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

            // Connect to database and insert the ingredient to the shopping list
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO shopping_list (user_id, ingredient_id, is_checked) VALUES (?, ?, FALSE)"
                 )) {

                stmt.setInt(1, userId);
                stmt.setInt(2, ingredientId);

                int affectedRows = stmt.executeUpdate();

                if (affectedRows > 0) {
                    out.write("{\"success\": true, \"message\": \"Item added to shopping list!\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"Could not add item.\"}");
                }
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"" + e.toString().replace("\"", "\\\"") + "\"}");
            out.flush();
        }
    }
}