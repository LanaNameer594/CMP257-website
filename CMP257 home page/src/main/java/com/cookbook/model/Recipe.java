package com.cookbook.model;

public class Recipe {
    private int recipeId;
    private int sourceIndex;
    private String recipeName;
    private String prepTime;
    private String cookTime;
    private String totalTime;
    private String servings;
    private String recipeYield;
    private String ingredients;
    private String directions;
    private double rating;
    private String sourceUrl;
    private String cuisinePath;
    private String nutrition;
    private String timing;
    private String imgSrc;

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }

    public int getSourceIndex() { return sourceIndex; }
    public void setSourceIndex(int sourceIndex) { this.sourceIndex = sourceIndex; }

    public String getRecipeName() { return recipeName; }
    public void setRecipeName(String recipeName) { this.recipeName = recipeName; }

    public String getPrepTime() { return prepTime; }
    public void setPrepTime(String prepTime) { this.prepTime = prepTime; }

    public String getCookTime() { return cookTime; }
    public void setCookTime(String cookTime) { this.cookTime = cookTime; }

    public String getTotalTime() { return totalTime; }
    public void setTotalTime(String totalTime) { this.totalTime = totalTime; }

    public String getServings() { return servings; }
    public void setServings(String servings) { this.servings = servings; }

    public String getRecipeYield() { return recipeYield; }
    public void setRecipeYield(String recipeYield) { this.recipeYield = recipeYield; }

    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }

    public String getDirections() { return directions; }
    public void setDirections(String directions) { this.directions = directions; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getSourceUrl() { return sourceUrl; }
    public void setSourceUrl(String sourceUrl) { this.sourceUrl = sourceUrl; }

    public String getCuisinePath() { return cuisinePath; }
    public void setCuisinePath(String cuisinePath) { this.cuisinePath = cuisinePath; }

    public String getNutrition() { return nutrition; }
    public void setNutrition(String nutrition) { this.nutrition = nutrition; }

    public String getTiming() { return timing; }
    public void setTiming(String timing) { this.timing = timing; }

    public String getImgSrc() { return imgSrc; }
    public void setImgSrc(String imgSrc) { this.imgSrc = imgSrc; }
}