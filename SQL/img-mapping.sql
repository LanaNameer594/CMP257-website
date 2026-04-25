USE cookbook_app;

DROP TABLE IF EXISTS recipe_images;

CREATE TABLE recipe_images (
  recipe_id INT PRIMARY KEY,
  image_path VARCHAR(255) NOT NULL,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

INSERT INTO recipe_images (recipe_id, image_path) VALUES
(1069, 'recipe_images/1069.jpg'),
(1078, 'recipe_images/1078.jpg'),
(1088, 'recipe_images/1088.jpg'), 
(1090, 'recipe_images/1090.jpg'),
(200, 'recipe_images/200.jpg'),
(303, 'recipe_images/303.jpg'), 
(318, 'recipe_images/318.jpg'),
(410, 'recipe_images/410.jpg'),
(452, 'recipe_images/452.jpeg'), 
(467, 'recipe_images/467.jpg'),
(490, 'recipe_images/490.jpg'),
(508, 'recipe_images/508.jpg'), 
(521, 'recipe_images/521.jpg'),
(528, 'recipe_images/528.jpg'),
(566, 'recipe_images/566.jpg'), 
(575, 'recipe_images/575.jpg'),
(643, 'recipe_images/643.jpg'),
(661, 'recipe_images/661.jpg'), 
(667, 'recipe_images/667.jpg'),
(677, 'recipe_images/677.jpg'),
(705, 'recipe_images/705.jpg'), 
(708, 'recipe_images/708.jpg'),
(754, 'recipe_images/754.jpg'),
(797, 'recipe_images/797.jpg'), 
(817, 'recipe_images/817.jpg'),
(822, 'recipe_images/822.jpg'),
(832, 'recipe_images/832.jpg'), 
(844, 'recipe_images/844.jpg'),
(851, 'recipe_images/851.jpg'),
(859, 'recipe_images/859.jpg'), 
(871, 'recipe_images/871.jpg'),
(890, 'recipe_images/890.jpg'),
(904, 'recipe_images/904.jpg'), 
(907, 'recipe_images/907.jpg'),
(908, 'recipe_images/908.jpg'),
(914, 'recipe_images/914.jpg'), 
(915, 'recipe_images/915.jpg'),
(933, 'recipe_images/933.jpg'),
(939, 'recipe_images/939.jpg'), 
(966, 'recipe_images/966.jpg'),
(927, 'recipe_images/927.jpg'),
(886, 'recipe_images/886.jpg')
ON DUPLICATE KEY UPDATE
image_path = VALUES(image_path);

SELECT r.recipe_id, r.recipe_name, i.image_path
FROM recipes r
JOIN recipe_images i ON r.recipe_id = i.recipe_id
ORDER BY r.recipe_id;
