package com.cookbook.controller;

import com.cookbook.dao.RecipeDAO;
import com.cookbook.model.Recipe;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/recipes")
public class RecipeServlet extends HttpServlet {

    private RecipeDAO recipeDAO = new RecipeDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Recipe> recipes = recipeDAO.getAllRecipes();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        objectMapper.writeValue(response.getWriter(), recipes);
    }
}