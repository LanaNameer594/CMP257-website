USE cookbook_app;

DROP TABLE IF EXISTS recipe_images;

CREATE TABLE recipe_images (
  recipe_id INT PRIMARY KEY,
  image_path VARCHAR(255) NOT NULL,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

INSERT INTO recipe_images (recipe_id, image_path) VALUES
(0, 'recipe_images/1069.jpg'),
(1, 'recipe_images/1078.jpg'),
(2, 'recipe_images/1088.jpg'), 
(3, 'recipe_images/1090.jpg'),
(4, 'recipe_images/200.jpg'),
(5, 'recipe_images/303.jpg'), 
(6, 'recipe_images/318.jpg'),
(7, 'recipe_images/410.jpg'),
(8, 'recipe_images/452.jpeg'), 
(9, 'recipe_images/467.jpg'),
(10, 'recipe_images/490.jpg'),
(11, 'recipe_images/508.jpg'), 
(12, 'recipe_images/521.jpg'),
(13, 'recipe_images/528.jpg'),
(14, 'recipe_images/566.jpg'), 
(15, 'recipe_images/575.jpg'),
(16, 'recipe_images/643.jpg'),
(17, 'recipe_images/661.jpg'), 
(18, 'recipe_images/667.jpg'),
(19, 'recipe_images/677.jpg'),
(20, 'recipe_images/705.jpg'), 
(21, 'recipe_images/708.jpg'),
(22, 'recipe_images/754.jpg'),
(23, 'recipe_images/797.jpg'), 
(24, 'recipe_images/817.jpg'),
(25, 'recipe_images/822.jpg'),
(26, 'recipe_images/832.jpg'), 
(27, 'recipe_images/844.jpg'),
(28, 'recipe_images/851.jpg'),
(29, 'recipe_images/859.jpg'), 
(30, 'recipe_images/871.jpg'),
(31, 'recipe_images/890.jpg'),
(32, 'recipe_images/904.jpg'), 
(33, 'recipe_images/907.jpg'),
(34, 'recipe_images/908.jpg'),
(35, 'recipe_images/914.jpg'), 
(36, 'recipe_images/915.jpg'),
(37, 'recipe_images/933.jpg'),
(38, 'recipe_images/939.jpg'), 
(39, 'recipe_images/966.jpg'),
(40, 'recipe_images/927.jpg'),
(41, 'recipe_images/886.jpg')
ON DUPLICATE KEY UPDATE
image_path = VALUES(image_path);

SELECT r.recipe_id, r.recipe_name, i.image_path
FROM recipes r
JOIN recipe_images i ON r.recipe_id = i.recipe_id
ORDER BY r.recipe_id;
