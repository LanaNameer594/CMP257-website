package com.cookbook.controller;

import com.cookbook.dao.SavedRecipeDAO;
import com.cookbook.model.SavedRecipeRequest;
import com.cookbook.model.Recipe;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/saved-recipes")
public class SavedRecipeServlet extends HttpServlet {

    private SavedRecipeDAO savedRecipeDAO = new SavedRecipeDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SavedRecipeRequest savedRequest =
                objectMapper.readValue(request.getReader(), SavedRecipeRequest.class);

        boolean success = savedRecipeDAO.saveRecipe(
                savedRequest.getUserId(),
                savedRequest.getRecipeId()
        );

        response.setContentType("application/json");

        if (success) {
            response.getWriter().write("{\"message\":\"Recipe saved successfully\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Could not save recipe\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));

        List<Recipe> recipes = savedRecipeDAO.getSavedRecipes(userId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        objectMapper.writeValue(response.getWriter(), recipes);
    }
}