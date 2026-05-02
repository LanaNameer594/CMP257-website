package com.cookbook.dao;

import com.cookbook.model.Recipe;
import com.cookbook.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SavedRecipeDAO {

    public boolean saveRecipe(int userId, int recipeId) {
        String sql = "INSERT INTO saved_recipes (user_id, recipe_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, recipeId);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Recipe> getSavedRecipes(int userId) {
        List<Recipe> recipes = new ArrayList<>();

        String sql = """
            SELECT r.*
            FROM saved_recipes sr
            JOIN recipes r ON sr.recipe_id = r.recipe_id
            WHERE sr.user_id = ?
            ORDER BY sr.saved_at DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
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
                recipe.setImgSrc(rs.getString("img_src"));

                recipes.add(recipe);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return recipes;
    }
}