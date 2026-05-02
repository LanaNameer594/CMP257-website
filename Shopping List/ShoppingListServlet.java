import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/ShoppingListServlet")
public class ShoppingListServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Updated parameter name to match the checkbox input name in recipe.js
        String[] selectedIngredients = request.getParameterValues("shopping_ingredients");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Retrieve the user ID from the session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in\"}");
            return;
        }

        if (selectedIngredients != null) {
            try (Connection conn = DBConnection.getConnection()) {
                
                // Updated SQL to match your database table schema
                String sql = "INSERT INTO shopping_list (user_id, ingredient_id, is_checked) VALUES (?, ?, FALSE)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    
                    for (String ingredientIdStr : selectedIngredients) {
                        try {
                            int ingredientId = Integer.parseInt(ingredientIdStr);

                            stmt.setInt(1, userId);
                            stmt.setInt(2, ingredientId);
                            
                            stmt.executeUpdate(); // Add to database
                        } catch (NumberFormatException e) {
                            // Skip invalid format
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
                return;
            }
        }
        
        // Return JSON success status
        response.getWriter().write("{\"status\": \"success\"}");
    }
}