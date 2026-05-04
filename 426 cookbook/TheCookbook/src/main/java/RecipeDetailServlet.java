
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/api/recipe")
public class RecipeDetailServlet extends HttpServlet {

    private RecipeDAO recipeDAO = new RecipeDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (idParam == null || idParam.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing recipe id\"}");
            return;
        }

        int recipeId = Integer.parseInt(idParam);
        Recipe recipe = recipeDAO.getRecipeById(recipeId);

        if (recipe == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\":\"Recipe not found\"}");
            return;
        }

        objectMapper.writeValue(response.getWriter(), recipe);
    }
}