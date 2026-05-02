package com.cookbook.model;

public class SavedRecipeRequest {
    private int userId;
    private int recipeId;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }
}