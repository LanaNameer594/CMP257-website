import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddToShoppingListServlet")
public class AddToShoppingListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Retrieve user from the session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id"); // Ensure this matches your login attribute

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"User not logged in\"}");
            out.flush();
            return;
        }

        // Get the ingredient ID from the request
        String ingredientIdParam = request.getParameter("ingredient_id");
        if (ingredientIdParam == null || ingredientIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing ingredient ID\"}");
            out.flush();
            return;
        }

        try {
            int ingredientId = Integer.parseInt(ingredientIdParam);

            try (Connection conn = DBConnection.getConnection()) {
                
                // 1. Fetch the name and unit from the ingredients table
                String ingName = "";
                String ingUnit = "";
                String selectQuery = "SELECT name, unit FROM ingredients WHERE ingredient_id = ?";
                
                try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                    selectStmt.setInt(1, ingredientId);
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            ingName = rs.getString("name");
                            ingUnit = rs.getString("unit");
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                            out.write("{\"error\": \"Ingredient not found in database.\"}");
                            out.flush();
                            return;
                        }
                    }
                }

                // 2. Insert the ingredient into the shopping list
                String insertQuery = "INSERT INTO shopping_list (user_id, ingredient_id, is_checked) VALUES (?, ?, FALSE)";
                
                try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, ingredientId);

                    int affectedRows = insertStmt.executeUpdate();

                    if (affectedRows > 0) {
                        // 3. Return the name and unit in the JSON response
                        // Escaping double quotes just in case the name has them
                        ingName = ingName.replace("\"", "\\\""); 
                        ingUnit = ingUnit.replace("\"", "\\\"");
                        
                        out.write("{\"success\": true, \"message\": \"Item added to shopping list!\", \"name\": \"" + ingName + "\", \"unit\": \"" + ingUnit + "\"}");
                    } else {
                        out.write("{\"success\": false, \"message\": \"Could not add item.\"}");
                    }
                    out.flush();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"" + e.toString().replace("\"", "\\\"") + "\"}");
            out.flush();
        }
    }
}