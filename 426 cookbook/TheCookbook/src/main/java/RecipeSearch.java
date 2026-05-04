import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/RecipeSearch")
public class RecipeSearch extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Safely grab all parameters
        String searchQuery = request.getParameter("q");
        String tagParam = request.getParameter("tag"); 
        String idParam = request.getParameter("id"); 

        // 2. Protect against null values
        if (searchQuery == null) searchQuery = "";
        if (tagParam == null) tagParam = "";
        
        // Ensure driver is loaded before attempting connection
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT r.recipe_id, r.recipe_name, img.image_path, r.directions, r.prep_time, r.nutrition, " +
                    "GROUP_CONCAT(TRIM(CONCAT_WS(' ', ri.quantity, i.unit, i.name)) SEPARATOR ', ') AS ingredient_list, " +
                    "GROUP_CONCAT(ri.ingredient_id SEPARATOR ',') AS ingredient_ids " +
                    "FROM recipes r " +
                    "LEFT JOIN recipe_images img ON r.recipe_id = img.recipe_id " +
                    "LEFT JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id " +
                    "LEFT JOIN ingredients i ON ri.ingredient_id = i.ingredient_id ";

            // 3. Build the WHERE clause dynamically
            if (idParam != null && !idParam.trim().isEmpty()) {
                sql += "WHERE r.recipe_id = ? ";
            } else {
                // Search by text query
                sql += "WHERE (r.recipe_name LIKE ? OR r.directions LIKE ? OR r.recipe_id IN ( " +
                       "    SELECT ri_sub.recipe_id FROM recipe_ingredients ri_sub " +
                       "    JOIN ingredients i_sub ON ri_sub.ingredient_id = i_sub.ingredient_id " +
                       "    WHERE i_sub.name LIKE ? " +
                       ")) ";
                       
                // If the user clicked a Tag (e.g., "Vegan"), force it to match the title or directions
                if (!tagParam.trim().isEmpty()) {
                    sql += " AND (r.recipe_name LIKE ? OR r.directions LIKE ?) ";
                }
            }
            
            sql += "GROUP BY r.recipe_id, r.recipe_name, img.image_path, r.directions, r.prep_time, r.nutrition";

            PreparedStatement st = conn.prepareStatement(sql);
            
            // 4. Inject parameters securely
            if (idParam != null && !idParam.trim().isEmpty()) {
                st.setInt(1, Integer.parseInt(idParam));
            } else {
                String searchPattern = "%" + searchQuery.trim() + "%";
                st.setString(1, searchPattern);
                st.setString(2, searchPattern);
                st.setString(3, searchPattern); 
                
                if (!tagParam.trim().isEmpty()) {
                    String tagPattern = "%" + tagParam.trim() + "%";
                    st.setString(4, tagPattern);
                    st.setString(5, tagPattern);
                }
            }

            ResultSet rs = st.executeQuery();
            StringBuilder json = new StringBuilder("[");

            while (rs.next()) {
                // Extract raw strings safely
                String rawName = rs.getString("recipe_name");
                String rawImg = rs.getString("image_path");
                String rawIngredients = rs.getString("ingredient_list");
                String rawIngredientIds = rs.getString("ingredient_ids");
                String rawDirections = rs.getString("directions");
                String rawPrep = rs.getString("prep_time");
                String rawNutrition = rs.getString("nutrition");

                // 5. Clean strings to PREVENT JSON syntax crashing
                String name = cleanForJson(rawName, "Unknown Recipe");
                String img = cleanForJson(rawImg, "");
                String ingredients = cleanForJson(rawIngredients, "No ingredients listed");
                String ingredientIds = cleanForJson(rawIngredientIds, "");
                String directions = cleanForJson(rawDirections, "No instructions provided.").replace("\\n", "<br>");
                String prepTime = cleanForJson(rawPrep, "Not specified");
                String nutrition = cleanForJson(rawNutrition, "Not specified");

                json.append("{")
                        .append("\"name\":\"").append(name).append("\",")
                        .append("\"image\":\"").append(img).append("\",")
                        .append("\"ingredients\":\"").append(ingredients).append("\",")
                        .append("\"ingredientIds\":\"").append(ingredientIds).append("\",")
                        .append("\"instructions\":\"").append(directions).append("\",")
                        .append("\"prepTime\":\"").append(prepTime).append("\",")
                        .append("\"nutrition\":\"").append(nutrition).append("\"")
                        .append("},");
            }

            // Remove the trailing comma so the JSON array is valid
            if (json.length() > 1) {
                json.setLength(json.length() - 1);
            }
            json.append("]");

            out.print(json.toString());
            rs.close();
            st.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("[]");
        }
    }

    /**
     * Helper method: Sanitizes text so manual JSON building doesn't cause server/browser crashes
     */
    private String cleanForJson(String input, String fallback) {
        if (input == null) return fallback;
        
        return input.replace("\\", "\\\\")   // Escape backslashes first
                    .replace("\"", "\\\"")   // Escape quotes
                    .replace("\b", "\\b")    // Escape backspace
                    .replace("\f", "\\f")    // Escape form feed
                    .replace("\n", "\\n")    // Escape new line
                    .replace("\r", "\\r")    // Escape carriage return
                    .replace("\t", "\\t");   // Escape tab spaces
    }
}