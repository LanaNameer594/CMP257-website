USE cookbook_app;

DROP TABLE IF EXISTS curated_recipes;

CREATE TABLE curated_recipes AS
WITH categorized AS (
    SELECT
        recipe_id,
        recipe_name,
        rating,
        cuisine_path,
        ingredients,

        CASE
            WHEN LOWER(cuisine_path) LIKE '%main dish%' THEN 'main dish'
            WHEN LOWER(cuisine_path) LIKE '%side dish%' THEN 'side dish'
            WHEN LOWER(cuisine_path) LIKE '%appetizer%' THEN 'appetizer'
            WHEN LOWER(cuisine_path) LIKE '%dessert%' THEN 'dessert'
        END AS course,

     
        CASE
            WHEN LOWER(recipe_name) LIKE '%chicken%' OR LOWER(ingredients) LIKE '%chicken%' THEN 'chicken'
            WHEN LOWER(recipe_name) LIKE '%beef%' OR LOWER(ingredients) LIKE '%beef%' THEN 'beef'
            WHEN LOWER(recipe_name) LIKE '%fish%' OR LOWER(ingredients) LIKE '%fish%' THEN 'fish'
            WHEN LOWER(recipe_name) LIKE '%pasta%' OR LOWER(ingredients) LIKE '%pasta%' THEN 'pasta'
            WHEN LOWER(recipe_name) LIKE '%rice%' OR LOWER(ingredients) LIKE '%rice%' THEN 'rice'
            WHEN LOWER(recipe_name) LIKE '%potato%' OR LOWER(ingredients) LIKE '%potato%' THEN 'potato'
            WHEN LOWER(recipe_name) LIKE '%cheese%' OR LOWER(ingredients) LIKE '%cheese%' THEN 'cheese'
            WHEN LOWER(recipe_name) LIKE '%chocolate%' OR LOWER(ingredients) LIKE '%chocolate%' THEN 'chocolate'
            WHEN LOWER(recipe_name) LIKE '%apple%' OR LOWER(ingredients) LIKE '%apple%' THEN 'apple'
            ELSE CONCAT('other-', recipe_id)
        END AS ingredient_family,

       
        CASE
            WHEN LOWER(recipe_name) LIKE '%chicken%' OR LOWER(ingredients) LIKE '%chicken%' THEN 3
            WHEN LOWER(recipe_name) LIKE '%beef%' OR LOWER(ingredients) LIKE '%beef%' THEN 2
            ELSE 0
        END AS protein_priority

    FROM recipes
    WHERE rating >= 4.5
      AND ingredients IS NOT NULL

    
      AND LOWER(recipe_name) NOT LIKE '%pork%'
      AND LOWER(ingredients) NOT LIKE '%pork%'

      -- ❌ also remove fig-heavy bias
      AND LOWER(recipe_name) NOT LIKE '%fig%'
      AND LOWER(ingredients) NOT LIKE '%fig%'

      AND (
          LOWER(cuisine_path) LIKE '%main dish%'
          OR LOWER(cuisine_path) LIKE '%side dish%'
          OR LOWER(cuisine_path) LIKE '%appetizer%'
          OR LOWER(cuisine_path) LIKE '%dessert%'
      )
),


family_limited AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY course, ingredient_family
            ORDER BY (rating + protein_priority) DESC
        ) AS ingredient_family_rank
    FROM categorized
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY course
            ORDER BY (rating + protein_priority) DESC
        ) AS course_rank
    FROM family_limited
    WHERE ingredient_family_rank = 1
)

SELECT recipe_id
FROM ranked
WHERE course_rank <= 10;

SELECT r.recipe_id, r.recipe_name, r.rating, r.cuisine_path
FROM recipes r
JOIN curated_recipes c ON r.recipe_id = c.recipe_id
ORDER BY r.cuisine_path, r.rating DESC;