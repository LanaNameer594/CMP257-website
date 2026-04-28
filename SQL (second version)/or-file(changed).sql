USE cookbook_app;

DROP TABLE IF EXISTS curated_recipes;

CREATE TABLE curated_recipes AS
SELECT
    r.recipe_id,
    r.recipe_name,
    r.rating,
    r.cuisine_path,
    GROUP_CONCAT(i.name ORDER BY i.name SEPARATOR ', ') AS ingredients,

    CASE
        WHEN LOWER(r.cuisine_path) LIKE '%main dish%' THEN 'main dish'
        WHEN LOWER(r.cuisine_path) LIKE '%side dish%' THEN 'side dish'
        WHEN LOWER(r.cuisine_path) LIKE '%appetizer%' THEN 'appetizer'
        WHEN LOWER(r.cuisine_path) LIKE '%dessert%' THEN 'dessert'
        ELSE 'other'
    END AS course,

    CASE
        WHEN LOWER(r.recipe_name) LIKE '%chicken%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%chicken%' THEN 'chicken'
        WHEN LOWER(r.recipe_name) LIKE '%beef%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%beef%' THEN 'beef'
        WHEN LOWER(r.recipe_name) LIKE '%fish%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%fish%' THEN 'fish'
        WHEN LOWER(r.recipe_name) LIKE '%pasta%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%pasta%' THEN 'pasta'
        WHEN LOWER(r.recipe_name) LIKE '%rice%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%rice%' THEN 'rice'
        WHEN LOWER(r.recipe_name) LIKE '%potato%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%potato%' THEN 'potato'
        WHEN LOWER(r.recipe_name) LIKE '%cheese%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%cheese%' THEN 'cheese'
        WHEN LOWER(r.recipe_name) LIKE '%chocolate%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%chocolate%' THEN 'chocolate'
        WHEN LOWER(r.recipe_name) LIKE '%apple%' OR GROUP_CONCAT(LOWER(i.name) SEPARATOR ', ') LIKE '%apple%' THEN 'apple'
        ELSE CONCAT('other-', r.recipe_id)
    END AS ingredient_family

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
ORDER BY r.recipe_id;

SELECT *
FROM curated_recipes
ORDER BY recipe_id;

