import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/recipes/match")
public class RecipeMatchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String category = request.getParameter("category");
        String type = request.getParameter("type");

        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString().trim(); 

        List<String> ingredients = new ArrayList<>();
        if (requestBody.startsWith("[") && requestBody.endsWith("]")) {
            String content = requestBody.substring(1, requestBody.length() - 1).trim();
            if (!content.isEmpty()) {
                String[] items = content.split(",");
                for (String item : items) {
                    ingredients.add(item.replace("\"", "").trim().toLowerCase());
                }
            }
        }

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Cleaned up the main SELECT statement (removed DISTINCT, removed main JOINs)
            StringBuilder sql = new StringBuilder(
                "SELECT r.recipe_id, r.recipe_name, img.image_path, r.total_time, r.rating, r.servings " +
                "FROM recipes r " +
                "LEFT JOIN recipe_images img ON r.recipe_id = img.recipe_id " +
                "WHERE 1=1 "
            );
            
            List<String> parameters = new ArrayList<>();

            if (category != null && !category.trim().isEmpty()) {
                sql.append("AND r.cuisine_path LIKE ? ");
                parameters.add("%" + category + "%");
            }
            
            if (type != null && !type.trim().isEmpty()) {
                sql.append("AND r.cuisine_path LIKE ? ");
                parameters.add("%" + type + "%");
            }

            // 2. The Magic Ingredient Filter (AND logic + partial matches)
            if (!ingredients.isEmpty()) {
                for (String ingredient : ingredients) {
                    sql.append("AND EXISTS (")
                       .append("  SELECT 1 FROM recipe_ingredients ri ")
                       .append("  JOIN ingredients i ON ri.ingredient_id = i.ingredient_id ")
                       .append("  WHERE ri.recipe_id = r.recipe_id AND LOWER(i.name) LIKE ?")
                       .append(") ");
                    
                    // The % signs allow "chicken" to match "chicken breast"
                    parameters.add("%" + ingredient + "%"); 
                }
            }
            
            sql.append("ORDER BY RAND() LIMIT 15");

            try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                
                for (int i = 0; i < parameters.size(); i++) {
                    stmt.setString(i + 1, parameters.get(i));
                }
                
                try (ResultSet rs = stmt.executeQuery()) {
                    
                    StringBuilder jsonBuilder = new StringBuilder("[");
                    boolean first = true;
                    
                    while (rs.next()) {
                        if (!first) {
                            jsonBuilder.append(",");
                        }
                        
                        String imagePath = rs.getString("image_path");
                        if (imagePath == null || imagePath.trim().isEmpty()) {
                            imagePath = "images/placeholder.jpg"; 
                        }
                        
                        jsonBuilder.append("{")
                                  .append("\"recipeId\":").append(rs.getInt("recipe_id")).append(",")
                                  .append("\"recipeName\":\"").append(escapeJson(rs.getString("recipe_name"))).append("\",")
                                  .append("\"imgSrc\":\"").append(escapeJson(imagePath)).append("\",")
                                  .append("\"totalTime\":\"").append(escapeJson(rs.getString("total_time"))).append("\",")
                                  .append("\"rating\":\"").append(escapeJson(rs.getString("rating"))).append("\",")
                                  .append("\"servings\":\"").append(escapeJson(rs.getString("servings"))).append("\"")
                                  .append("}");
                        
                        first = false;
                    }
                    jsonBuilder.append("]");
                    
                    response.getWriter().write(jsonBuilder.toString());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "");
    }
}