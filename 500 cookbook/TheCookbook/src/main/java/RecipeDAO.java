
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecipeDAO {

	public List<Recipe> getAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();

        String sql = """
        	    SELECT 
        	        r.*,
        	        c.ingredients,
        	        i.image_path,
        	        NULL AS recipe_yield,
        	        r.total_time AS timing
        	    FROM recipes r
        	    LEFT JOIN curated_recipes c ON r.recipe_id = c.recipe_id
        	    LEFT JOIN recipe_images i ON r.recipe_id = i.recipe_id
        	    ORDER BY CAST(r.rating AS DECIMAL(3,1)) DESC
        	    LIMIT 50
        	""";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                recipes.add(mapRecipe(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return recipes;
    }

    public Recipe getRecipeById(int recipeId) {
    	String sql = """
    		    SELECT 
    		        r.*,
    		        c.ingredients,
    		        i.image_path,
    		        NULL AS recipe_yield,
    		        r.total_time AS timing
    		    FROM recipes r
    		    JOIN curated_recipes c ON r.recipe_id = c.recipe_id
    		    LEFT JOIN recipe_images i ON r.recipe_id = i.recipe_id
    		    WHERE r.recipe_id = ?
    		""";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recipeId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapRecipe(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Recipe> findBestMatches(String category, String recipeType, String ingredients) {
        // Treat default dropdown values "Any course" and "Any type" as empty
        if ("Any course".equalsIgnoreCase(category)) {
            category = "";
        }
        if ("Any type".equalsIgnoreCase(recipeType)) {
            recipeType = "";
        }

        List<Recipe> recipes = new ArrayList<>();
        String[] ingredientList = cleanIngredients(ingredients);

        StringBuilder sql = new StringBuilder();

        sql.append("""
        	    SELECT 
        	        r.*,
				    c.ingredients,
				    i.image_path,
				    NULL AS recipe_yield,
				    r.total_time AS timing,
        	        (
        	            0
        	""");

        if (hasValue(category)) {
            sql.append(" + CASE WHEN LOWER(r.cuisine_path) LIKE ? THEN 8 ELSE 0 END ");
        }

        if (hasValue(recipeType)) {
            sql.append(" + CASE WHEN LOWER(r.recipe_name) LIKE ? THEN 8 ELSE 0 END ");
            sql.append(" + CASE WHEN LOWER(r.cuisine_path) LIKE ? THEN 5 ELSE 0 END ");
        }

        for (int i = 0; i < ingredientList.length; i++) {
            sql.append(" + CASE WHEN LOWER(c.ingredients) LIKE ? THEN 5 ELSE 0 END ");
        }

        sql.append("""
                + COALESCE(r.rating, 0)
            ) AS match_score
            FROM recipes r
			LEFT JOIN curated_recipes c ON r.recipe_id = c.recipe_id
			LEFT JOIN recipe_images i ON r.recipe_id = i.recipe_id
            WHERE 1 = 1
        """);

        if (hasValue(category)) {
            sql.append(" AND LOWER(r.cuisine_path) LIKE ? ");
        }

        if (hasValue(recipeType)) {
            sql.append(" AND (LOWER(r.recipe_name) LIKE ? OR LOWER(r.cuisine_path) LIKE ?) ");
        }

        if (ingredientList.length > 0) {
            sql.append(" AND ( ");
            for (int i = 0; i < ingredientList.length; i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                sql.append(" LOWER(c.ingredients) LIKE ? ");
            }
            sql.append(" ) ");
        }

        sql.append(" ORDER BY match_score DESC, r.rating DESC LIMIT 50");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;

            String categoryValue = courseLikeValue(category);
            String typeValue = likeValue(recipeType);

            if (hasValue(category)) {
                stmt.setString(index++, categoryValue);
            }

            if (hasValue(recipeType)) {
                stmt.setString(index++, typeValue);
                stmt.setString(index++, typeValue);
            }

            for (String ingredient : ingredientList) {
                stmt.setString(index++, likeValue(ingredient));
            }

            if (hasValue(category)) {
                stmt.setString(index++, categoryValue);
            }

            if (hasValue(recipeType)) {
                stmt.setString(index++, typeValue);
                stmt.setString(index++, typeValue);
            }

            for (String ingredient : ingredientList) {
                stmt.setString(index++, likeValue(ingredient));
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recipes.add(mapRecipe(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Propagate the exception so it's not swallowed and an empty list isn't returned
            throw new RuntimeException("Error executing findBestMatches in RecipeDAO: " + e.getMessage(), e);
        }

        return recipes;
    }

    private boolean hasValue(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String[] cleanIngredients(String ingredients) {
        if (!hasValue(ingredients)) {
            return new String[0];
        }

        String[] rawItems = ingredients.split(",");
        List<String> cleaned = new ArrayList<>();

        for (String item : rawItems) {
            String value = item.trim().toLowerCase();

            if (!value.isEmpty()) {
                cleaned.add(value);
            }
        }

        return cleaned.toArray(new String[0]);
    }

    private String likeValue(String value) {
        if (!hasValue(value)) {
            return "%%";
        }

        return "%" + value.trim().toLowerCase() + "%";
    }

    private String courseLikeValue(String category) {
        if (!hasValue(category)) {
            return "%%";
        }

        String value = category.trim().toLowerCase();

        if (value.equals("dessert")) {
            return "%dessert%";
        }

        if (value.equals("appetizer")) {
            return "%appetizer%";
        }

        if (value.equals("main dish")) {
            return "%main dish%";
        }

        if (value.equals("side dish")) {
            return "%side dish%";
        }

        return "%" + value + "%";
    }

    private Recipe mapRecipe(ResultSet rs) throws SQLException {
        Recipe recipe = new Recipe();

        recipe.setRecipeId(rs.getInt("recipe_id"));
        recipe.setSourceIndex(rs.getInt("source_index"));
        recipe.setRecipeName(rs.getString("recipe_name"));
        recipe.setPrepTime(rs.getString("prep_time"));
        recipe.setCookTime(rs.getString("cook_time"));
        recipe.setTotalTime(rs.getString("total_time"));
        recipe.setServings(rs.getString("servings"));
        recipe.setRecipeYield(rs.getString("recipe_yield"));
        recipe.setIngredients(rs.getString("ingredients"));
        recipe.setDirections(rs.getString("directions"));
        recipe.setRating(rs.getDouble("rating"));
        recipe.setSourceUrl(rs.getString("source_url"));
        recipe.setCuisinePath(rs.getString("cuisine_path"));
        recipe.setNutrition(rs.getString("nutrition"));
        recipe.setTiming(rs.getString("timing"));

        String mappedImage = rs.getString("image_path");
        String originalImage = rs.getString("img_src");

        if (mappedImage != null && !mappedImage.isBlank()) {
            recipe.setImgSrc(mappedImage);
        } else if (originalImage != null && !originalImage.isBlank()) {
            recipe.setImgSrc(originalImage);
        } else {
            recipe.setImgSrc("images/placeholder.jpg");
        }

        return recipe;
    }
}