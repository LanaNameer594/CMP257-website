USE cookbook_app;

DROP TABLE IF EXISTS curated_recipes;

CREATE TABLE curated_recipes AS
WITH recipe_with_ingredients AS (
    SELECT
        r.recipe_id,
        r.recipe_name,
        r.rating,
        r.cuisine_path,
        GROUP_CONCAT(i.name ORDER BY i.name SEPARATOR ', ') AS ingredients
    FROM recipes r
    LEFT JOIN recipe_ingredients ri
        ON r.recipe_id = ri.recipe_id
    LEFT JOIN ingredients i
        ON ri.ingredient_id = i.ingredient_id
    GROUP BY
        r.recipe_id,
        r.recipe_name,
        r.rating,
        r.cuisine_path
),

categorized AS (
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
            WHEN LOWER(recipe_name) LIKE '%dates%' OR LOWER(ingredients) LIKE '%dates%' THEN 'dates'
            WHEN LOWER(recipe_name) LIKE '%avocado%' OR LOWER(ingredients) LIKE '%avocado%' THEN 'avocado'
            WHEN LOWER(recipe_name) LIKE '%apricot%' OR LOWER(ingredients) LIKE '%apricot%' THEN 'apricot'
            WHEN LOWER(recipe_name) LIKE '%nectarines%' OR LOWER(ingredients) LIKE '%nectarines%' THEN 'nectarines'
            WHEN LOWER(recipe_name) LIKE '%pomegranate%' OR LOWER(ingredients) LIKE '%pomegranate%' THEN 'pomegranate'
            ELSE CONCAT('other-', recipe_id)
        END AS ingredient_family,

        CASE
            WHEN LOWER(recipe_name) LIKE '%chicken%' OR LOWER(ingredients) LIKE '%chicken%' THEN 3
            WHEN LOWER(recipe_name) LIKE '%beef%' OR LOWER(ingredients) LIKE '%beef%' THEN 2
            ELSE 0
        END AS protein_priority

    FROM recipe_with_ingredients
    WHERE CAST(rating AS DECIMAL(3,1)) >= 4.5
      AND ingredients IS NOT NULL
      AND LOWER(recipe_name) NOT LIKE '%pork%'
      AND LOWER(ingredients) NOT LIKE '%pork%'
      AND LOWER(recipe_name) NOT LIKE '%fig%'
      AND LOWER(ingredients) NOT LIKE '%fig%'
      AND (
          LOWER(cuisine_path) LIKE '%main dish%'
          OR LOWER(cuisine_path) LIKE '%side dish%'
          OR LOWER(cuisine_path) LIKE '%appetizer%'
          OR LOWER(cuisine_path) LIKE '%dessert%'
      )
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY course
            ORDER BY (CAST(rating AS DECIMAL(3,1)) + protein_priority) DESC
        ) AS course_rank
    FROM categorized
)

SELECT
    recipe_id,
    recipe_name,
    rating,
    cuisine_path,
    ingredients,
    course,
    ingredient_family
FROM ranked
WHERE course_rank <= 10;

SELECT *
FROM curated_recipes;

SELECT COUNT(*) FROM curated_recipes;