import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/saved-recipes")
public class SaveRecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            SavedRecipeRequest savedRequest =
                    mapper.readValue(request.getInputStream(), SavedRecipeRequest.class);

            int userId = savedRequest.getUserId();
            int recipeId = savedRequest.getRecipeId();

            if (userId <= 0) {
                userId = 1; // temporary guest user until login is implemented
            }

            if (recipeId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid recipe ID.\"}");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {

                String checkSql =
                        "SELECT saved_id FROM saved_recipes WHERE user_id = ? AND recipe_id = ?";

                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, userId);
                    checkStmt.setInt(2, recipeId);

                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next()) {
                            response.getWriter().write(
                                    "{\"status\":\"exists\",\"message\":\"Recipe already saved.\"}"
                            );
                            return;
                        }
                    }
                }

                String insertSql =
                        "INSERT INTO saved_recipes (user_id, recipe_id) VALUES (?, ?)";

                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, recipeId);
                    insertStmt.executeUpdate();
                }

                response.getWriter().write(
                        "{\"status\":\"success\",\"message\":\"Recipe saved successfully.\"}"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"status\":\"error\",\"message\":\"Could not save recipe.\"}"
            );
        }
    }
}