USE cookbook_app;

DROP TABLE IF EXISTS curated_recipes;

CREATE TABLE curated_recipes AS
WITH categorized AS (
    SELECT
        r.recipe_id,
        r.recipe_name,
        r.rating,
        r.cuisine_path,

        CASE
            WHEN LOWER(r.cuisine_path) LIKE '%main dish%' THEN 'main dish'
            WHEN LOWER(r.cuisine_path) LIKE '%side dish%' THEN 'side dish'
            WHEN LOWER(r.cuisine_path) LIKE '%appetizer%' THEN 'appetizer'
            WHEN LOWER(r.cuisine_path) LIKE '%dessert%' THEN 'dessert'
        END AS course,

     
        CASE
            WHEN LOWER(r.recipe_name) LIKE '%chicken%' OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%chicken%') THEN 'chicken'
            WHEN LOWER(r.recipe_name) LIKE '%beef%'    OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%beef%')    THEN 'beef'
            WHEN LOWER(r.recipe_name) LIKE '%fish%'    OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%fish%')    THEN 'fish'
            WHEN LOWER(r.recipe_name) LIKE '%pasta%'   OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%pasta%')   THEN 'pasta'
            WHEN LOWER(r.recipe_name) LIKE '%rice%'    OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%rice%')    THEN 'rice'
            WHEN LOWER(r.recipe_name) LIKE '%potato%'  OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%potato%')  THEN 'potato'
            WHEN LOWER(r.recipe_name) LIKE '%cheese%'  OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%cheese%')  THEN 'cheese'
            WHEN LOWER(r.recipe_name) LIKE '%chocolate%' OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%chocolate%') THEN 'chocolate'
            WHEN LOWER(r.recipe_name) LIKE '%apple%'   OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%apple%')   THEN 'apple'
            ELSE CONCAT('other-', r.recipe_id)
        END AS ingredient_family,

       
        CASE
            WHEN LOWER(r.recipe_name) LIKE '%chicken%' OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%chicken%') THEN 3
            WHEN LOWER(r.recipe_name) LIKE '%beef%'    OR EXISTS (SELECT 1 FROM recipe_ingredients ir JOIN ingredients i ON ir.ingredient_id = i.ingredient_id WHERE ir.recipe_id = r.recipe_id AND i.name LIKE '%beef%')    THEN 2
            ELSE 0
        END AS protein_priority

    FROM recipes r
    WHERE r.rating >= 4.5
      AND NOT EXISTS (
          SELECT 1 FROM recipe_ingredients ir 
          JOIN ingredients i ON ir.ingredient_id = i.ingredient_id
          WHERE ir.recipe_id = r.recipe_id 
          AND (i.name LIKE '%pork%' OR i.name LIKE '%fig%')
      )
      AND LOWER(r.recipe_name) NOT LIKE '%pork%'
      AND LOWER(r.recipe_name) NOT LIKE '%fig%'
      AND (
          LOWER(r.cuisine_path) LIKE '%main dish%'
          OR LOWER(r.cuisine_path) LIKE '%side dish%'
          OR LOWER(r.cuisine_path) LIKE '%appetizer%'
          OR LOWER(r.cuisine_path) LIKE '%dessert%'
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