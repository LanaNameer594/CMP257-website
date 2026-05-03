DROP DATABASE IF EXISTS cookbook_app;
CREATE DATABASE cookbook_app;
USE cookbook_app;

CREATE TABLE recipes (
  recipe_id INT AUTO_INCREMENT PRIMARY KEY,
  source_index INT,
  recipe_name TEXT NOT NULL,
  prep_time TEXT,
  cook_time TEXT,
  total_time TEXT,
  servings TEXT,
  directions LONGTEXT,
  rating VARCHAR(50),
  source_url TEXT,
  cuisine_path TEXT,
  nutrition LONGTEXT,
  img_src TEXT
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(100) NOT NULL,
  lastname VARCHAR(100) NOT NULL,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE saved_recipes (
  saved_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  recipe_id INT,
  saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

CREATE TABLE ingredients (
  ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  CONSTRAINT unique_name_unit UNIQUE (name, unit)
);

CREATE TABLE shopping_list (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  ingredient_id INT,
  is_checked BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

CREATE TABLE recipe_ingredients (
  recipe_id INT,
  ingredient_id INT,
  quantity VARCHAR(100),
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '0', 

    'Energy Balls without Peanut Butter', 

    '20 mins', 

    NULL, 

    '2 hrs 20 mins', 

    '45', 

    'Burst oats into a coarse meal in the bowl of a food processor. Add pumpkin seeds, walnuts, and pecans; pulse 10 to 15 times, until chunks are desired size. Toss dates into the food processor and mix for 30 seconds. Pour rice syrup in slowly, with the processor running, until combined and starting to ball up. Transfer to a bowl and mix in chocolate chips, coconut, raisins, and sunflower seeds. Pull off dough in 25 gram sections and roll into balls. Place in a single layer on a cookie sheet; it\'s okay if they touch but make sure they are not stacked. Refrigerate for 2 to 24 hours before serving.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/283043/energy-balls-without-peanut-butter/', 

    '/Appetizers and Snacks/Snacks/Energy Ball Recipes/', 

    'Total Fat 4g 6%, Saturated Fat 1g 7%, Sodium 5mg 0%, Total Carbohydrate 11g 4%, Dietary Fiber 1g 4%, Total Sugars 8g, Protein 2g, Vitamin C 0mg 1%, Calcium 10mg 1%, Iron 1mg 4%, Potassium 98mg 2%', 

    'https://www.allrecipes.com/thmb/t_06YCdK084ZN3GE1HRR6AkTOws=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/8973676-cec2044ad2924ac791d201aaa991d793.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('rolled oats', 'g'),
('pumpkin seeds', 'g'),
('walnuts', 'g'),
('pecans', 'g'),
('pitted Medjool dates', 'pieces'),
('brown rice syrup', 'g'),
('mini chocolate chips', 'g'),
('shredded coconut', 'g'),
('raisins', 'g'),
('sunflower seeds', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='rolled oats' AND unit='g'), '90'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pumpkin seeds' AND unit='g'), '65'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='walnuts' AND unit='g'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pecans' AND unit='g'), '65'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pitted Medjool dates' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown rice syrup' AND unit='g'), '160'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='mini chocolate chips' AND unit='g'), '175'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded coconut' AND unit='g'), '45'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='raisins' AND unit='g'), '75'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sunflower seeds' AND unit='g'), '35');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '1', 

    'Pecan Pie Energy Bites', 

    '15 mins', 

    '10 mins', 

    '25 mins', 

    '12', 

    'Preheat the oven to 350 degrees F (175 degrees C). Line a baking sheet with parchment paper. Arrange a single layer of pecans on the prepared baking sheet. Top with rolled oats. Bake in the preheated oven until toasted, about 10 minutes. Allow to cool completely. Pulse pecans, oats, dates, cinnamon, salt, vanilla extract, and maple syrup in a food processor until nuts are ground to desired consistency. Shape mixture into twelve 2-inch tightly-packed balls. Refrigerate before serving.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/8381294/pecan-pie-energy-bites/', 

    '/Appetizers and Snacks/Snacks/Energy Ball Recipes/', 

    'Total Fat 7g 8%, Saturated Fat 1g 3%, Sodium 41mg 2%, Total Carbohydrate 15g 5%, Dietary Fiber 2g 7%, Protein 2g, Potassium 144mg 3%', 

    'https://www.allrecipes.com/thmb/BDw8F70K9G3J3feAHq7_UWq_gWQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Pecan-pie-energy-bites-chef-john-2000-d6fbb9081b7e4a89bd1bcfa587dbbece.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('pecans', 'g'),
('rolled oats', 'g'),
('pitted Medjool dates', 'pieces'),
('ground cinnamon', 'g'),
('salt', 'g'),
('vanilla extract', 'ml'),
('maple syrup', 'ml');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pecans' AND unit='g'), '100'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='rolled oats' AND unit='g'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pitted Medjool dates' AND unit='pieces'), '7'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cinnamon' AND unit='g'), '0.6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '1.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vanilla extract' AND unit='ml'), '1.25'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='maple syrup' AND unit='ml'), '15');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '2', 

    'Best Hot Sauce', 

    '10 mins', 

    '20 mins', 

    '30 mins', 

    '100', 

    'Place peppers, onion, dates, basil, parsley, tomato, bouillon powder, and garlic in the bowl of a food processor; pour in the oil. Pulse mixture until finely chopped, adding more oil if needed to thin; season with salt. Pour pepper mixture into a small saucepan; bring to a boil. Squeeze lemon juice into pepper mixture, reduce heat to low, and simmer for 15 minutes. Allow pepper mixture to cool; pour into a glass jar with a lid. Store pepper sauce in the refrigerator.', 

    '4.9', 

    'https://www.allrecipes.com/recipe/242153/best-hot-sauce/', 

    '/Side Dish/Sauces and Condiments/', 

    'Total Fat 1g 1%, Saturated Fat 0g 1%, Sodium 29mg 1%, Total Carbohydrate 1g 0%, Dietary Fiber 0g 0%, Total Sugars 0g, Protein 0g, Vitamin C 11mg 57%, Calcium 2mg 0%, Iron 0mg 1%, Potassium 21mg 0%', 

    'https://www.allrecipes.com/thmb/80wUYzFvbycfxxDSPtq83Vo3r1k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2513802-5c855a29fc3e4e14a9cf88a3e72fe63f.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('fresh hot chile peppers', 'pieces'),
('onion', 'pieces'),
('pitted Medjool dates', 'pieces'),
('fresh basil leaves', 'pieces'),
('fresh parsley', 'g'),
('roma tomatoes', 'piece'),
('beef bouillon powder', 'g'),
('garlic cloves', 'pieces'),
('vegetable oil', 'ml'),
('salt', 'g'),
('lemon juice', 'ml');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh hot chile peppers' AND unit='pieces'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pitted Medjool dates' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh basil leaves' AND unit='pieces'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh parsley' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='roma tomatoes' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='beef bouillon powder' AND unit='g'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic cloves' AND unit='pieces'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vegetable oil' AND unit='ml'), '120'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '5');
INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '3', 

    'Chef John\'s Chocolate Energy Bars', 

    '15 mins', 

    NULL, 

    '3 hrs', 

    '12', 

    'Place cashews, almonds, coconut, dates, cocoa, coconut oil, vanilla, cold coffee, cayenne and salt in the bowl of a food processor. Pulse on and off to start. Process about 1 minute; check to ensure mixture is sticky and moist enough to stick together. Add more coffee if needed. Continue to process until mixture becomes a chunky mass. Line a baking pan with plastic wrap. Scoop mixture into pan. Press down with a spatula until mixture is even. Place a layer of plastic wrap on the surface and smooth again with your hands. Refrigerate until cold and firm, 2 or 3 hours. Remove from the pan and unwrap. Cut into bars of your preferred size. Store in a zip top back in the refrigerator.', 

    '4.8', 

    'https://www.allrecipes.com/recipe/254452/chef-johns-chocolate-energy-bars/', 

    '/Appetizers and Snacks/Snacks/Granola Bar Recipes/', 

    'Total Fat 22g 28%, Saturated Fat 7g 36%, Sodium 230mg 10%, Total Carbohydrate 36g 13%, Dietary Fiber 7g 25%, Total Sugars 21g, Protein 8g, Vitamin C 0mg 1%, Calcium 59mg 5%, Iron 3mg 17%, Potassium 515mg 11%', 

    'https://www.allrecipes.com/thmb/IOoj42MMo8YNKWfqi3SjecjAwpE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/image-298-9ea0164f6701476d96dacf960f3e9aa9.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('pitted Medjool dates', 'pieces'),
('raw cashews', 'g'),
('almonds', 'g'),
('unsweetened cocoa powder', 'g'),
('coconut oil', 'ml'),
('shredded coconut', 'g'),
('vanilla extract', 'ml'),
('cold espresso', 'ml'),
('salt', 'g'),
('cayenne pepper', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pitted Medjool dates' AND unit='pieces'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='raw cashews' AND unit='g'), '260'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almonds' AND unit='g'), '140'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='unsweetened cocoa powder' AND unit='g'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='coconut oil' AND unit='ml'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded coconut' AND unit='g'), '45'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vanilla extract' AND unit='ml'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cold espresso' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cayenne pepper' AND unit='g'), '0.1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '4', 

    'Preserved Cherries', 

    NULL, 

    NULL, 

    NULL, 

    '16', 

    'Inspect 8 half-pint jars for cracks and rings for rust, discarding any defective ones. Immerse in simmering water for 10 minutes to sterilize. Wash new, unused lids and rings in warm soapy water. Fill sterilized jars with cherries up to the \"neck\" of the jar. Pour water into a large pan and bring to a boil. Add sugar and keep boiling until sugar dissolves. Pour hot simple syrup over cherries into the jars up to 1/8-inch from the top. Run a clean knife or thin spatula around the insides of the jars to remove any air bubbles. Wipe rims with a moist paper towel to remove any spills. Top with lids and tightly screw on rings. Place a rack in the bottom of a large stockpot and fill halfway with water. Bring to a boil and lower jars 2 inches apart into the boiling water using a holder. Pour in more boiling water to cover jars by at least 1 inch. Bring to a rolling boil, cover, and process for 20 minutes. Remove the jars from the stockpot and place onto a cloth-covered or wood surface, several inches apart. Let rest for 24 hours without moving the jars. Gently press the center of each lid with a finger to ensure the lid does not move up or down. Remove the rings for storage and store in a cool, dark area.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/265814/preserved-cherries/', 

    '/Side Dish/Sauces and Condiments/Canning and Preserving Recipes/Jams and Jellies Recipes/', 

    'Total Fat 1g 1%, Saturated Fat 0g 1%, Sodium 2mg 0%, Total Carbohydrate 19g 7%, Dietary Fiber 1g 5%, Total Sugars 18g, Protein 1g, Vitamin C 4mg 20%, Calcium 10mg 1%, Iron 0mg 1%, Potassium 128mg 3%', 

    'https://www.allrecipes.com/thmb/iDHeSS-JZu5UoTjOXeuPS_76mqE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5491038-preserved-cherries-AllrecipesPhoto-4x3-1-227bfd30ef37498185aeb911c11f8c06.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('fresh cherries', 'g'),
('water', 'ml'),
('white sugar', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh cherries' AND unit='g'), '907'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '946'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '150');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '5', 

    'Greek-Style Lemon Roasted Potatoes', 

    '15 mins', 

    '1 hrs', 

    '1 hrs 15 mins', 

    '6', 

    'Preheat the oven to 400 degrees F (200 degrees C). Put potato wedges in a large bowl. Drizzle with olive oil and lemon juice and toss to coat. Season with salt, oregano, and black pepper; toss again to coat. Spread potato wedges in a single layer in a 2-inch-deep pan. Pour chicken broth over potatoes. Roast potatoes in the preheated oven until tender and golden brown, about 1 hour.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/239180/greek-style-lemon-roasted-potatoes/', 

    '/Side Dish/Potato/Roasted Potato Recipes/', 

    'Total Fat 12g 16%, Saturated Fat 2g 9%, Sodium 789mg 34%, Total Carbohydrate 40g 15%, Dietary Fiber 5g 18%, Total Sugars 2g, Protein 5g, Vitamin C 45mg 225%, Calcium 33mg 3%, Iron 2mg 11%, Potassium 962mg 20%', 

    'https://www.allrecipes.com/thmb/TYElDgV7d-SD10L3P5g6ndaXjYE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1439519-8f20956405874765b71635a7873cdd60.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('potatoes', 'g'),
('olive oil', 'ml'),
('lemons', 'pieces'),
('salt', 'g'),
('dried oregano', 'g'),
('ground black pepper', 'g'),
('chicken broth', 'ml');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='potatoes' AND unit='g'), '1360'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='ml'), '80'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemons' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '12'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dried oregano' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chicken broth' AND unit='ml'), '710');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '6', 

    'Baked Salmon in Foil', 

    '20 mins', 

    '20 mins', 

    '40 mins', 

    '6', 

    'Preheat the oven to 375 degrees F (190 degrees C). Combine 1/2 cup olive oil, garlic, lemon juice, brown sugar, oregano, thyme, salt, and pepper in a bowl. Place a large piece of aluminum foil on a baking sheet and brush with 1 teaspoon olive oil. Place salmon, skin-side down, in the middle of the foil. Drizzle with olive oil mixture. Fold up the edges of the foil over salmon to create a packet, making sure to seal the edges. Bake in the preheated oven until fish flakes easily with a fork, 20 to 25 minutes. Garnish with fresh parsley and lemon slices.', 

    '4.5', 

    'https://www.allrecipes.com/recipe/263217/baked-salmon-in-foil/', 

    '/Main Dishes/Seafood Main Dishes/Salmon/Baked Salmon Recipes/', 

    'Total Fat 26g 34%, Saturated Fat 5g 23%, Cholesterol 96mg 32%, Sodium 131mg 6%, Total Carbohydrate 6g 2%, Dietary Fiber 1g 4%, Total Sugars 2g, Protein 42g, Vitamin C 24mg 121%, Calcium 109mg 8%, Iron 2mg 11%, Potassium 827mg 18%', 

    'https://www.allrecipes.com/thmb/WIcdWCX5NfrEnaAeAhVexbA2wM0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5221620-baked-salmon-in-foil-barbara-4x3-1-048821b4b44e4ce0ab61c0ca482999bd.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('olive oil', 'ml'),
('garlic cloves', 'pieces'),
('lemon juice', 'ml'),
('brown sugar', 'g'),
('dried oregano', 'g'),
('dried thyme', 'g'),
('salt', 'g'),
('ground black pepper', 'g'),
('salmon fillet', 'g'),
('fresh parsley', 'g'),
('lemons', 'pieces');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='ml'), '125'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic cloves' AND unit='pieces'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '37.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '12.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dried oregano' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dried thyme' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salmon fillet' AND unit='g'), '1360'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh parsley' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemons' AND unit='pieces'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '7', 

    'Scandinavian Pear Tart', 

    '25 mins', 

    '25 mins', 

    '3 hrs 50 mins', 

    '8', 

    'Preheat the oven to 425 degrees F (220 degrees C). Coat a 9-inch fluted tart pan with a removable bottom with cooking spray. Beat sugar and butter together in a small bowl until crumbly. Beat in flour and almonds. Press over the bottom and up the sides of the prepared tart pan. Beat cream cheese in another small bowl until smooth. Beat in sugar, egg, and vanilla extract. Spread over the cooled crust. Arrange pear slices over the cream cheese layer. Combine sugar, cardamom, and cinnamon in a small bowl. Sprinkle over the pears. Bake in the preheated oven for 10 minutes. Reduce oven temperature to 350 degrees F (175 degrees C). Continue baking until filling is set and an instant-read thermometer inserted into the center reads 160 degrees F (71 degrees C), 15 to 20 minutes. Cool tart on a wire rack for 1 hour. Refrigerate for at least 2 hours before slicing.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/276769/scandinavian-pear-tart/', 

    '/Desserts/Pies/Tarts/Fruit Tart Recipes/', 

    'Total Fat 17g 22%, Saturated Fat 9g 46%, Cholesterol 63mg 21%, Sodium 124mg 5%, Total Carbohydrate 38g 14%, Dietary Fiber 2g 6%, Total Sugars 26g, Protein 5g, Vitamin C 1mg 5%, Calcium 45mg 3%, Iron 1mg 7%, Potassium 137mg 3%', 

    'https://www.allrecipes.com/thmb/jAN3oDk35AlEvxawtyqAR0azl8k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/7282942-aa6d9a57b7f64863985903e48ed74f83.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('cooking spray', 'ml'),
('white sugar', 'g'),
('butter', 'g'),
('all-purpose flour', 'g'),
('almonds', 'g'),
('cream cheese', 'g'),
('eggs', 'pieces'),
('vanilla extract', 'ml'),
('pears', 'pieces'),
('ground cardamom', 'g'),
('ground cinnamon', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cooking spray' AND unit='ml'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '42'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '94'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almonds' AND unit='g'), '40'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cream cheese' AND unit='g'), '226'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vanilla extract' AND unit='ml'), '2.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pears' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cardamom' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cinnamon' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '8', 

    'Gorgonzola Pear Pasta', 

    '10 mins', 

    '15 mins', 

    '25 mins', 

    '2', 

    'Bring a large pot of lightly salted water to a rolling boil. Cook penne in the boiling water, stirring occasionally, until tender yet firm to the bite, about 11 minutes; drain. Return drained pasta to the pot; stir butter, Parmesan cheese, and Gorgonzola cheese into pasta and place over medium heat; cook until the cheese is completely melted. Pour cream into pasta mixture; stir. Remove from heat and fold in pear. Top with walnuts. Season with pepper and serve.', 

    '4.6', 

    'https://www.allrecipes.com/recipe/206356/gorgonzola-pear-pasta/', 

    '/Main Dishes/Pasta/', 

    'Total Fat 69g 88%, Saturated Fat 29g 146%, Cholesterol 147mg 49%, Sodium 712mg 31%, Total Carbohydrate 237g 86%, Dietary Fiber 28g 99%, Total Sugars 17g, Protein 74g, Vitamin C 5mg 26%, Calcium 389mg 30%, Iron 1mg 8%, Potassium 333mg 7%', 

    'https://www.allrecipes.com/thmb/oHJcVNwpTSwFVg_bJ32wQdVKXdQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/417586-bac5d533d4e040119a884043146e476c.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('penne pasta', 'g'),
('butter', 'g'),
('grated Parmesan cheese', 'g'),
('crumbled Gorgonzola cheese', 'g'),
('heavy whipping cream', 'ml'),
('pears', 'pieces'),
('walnuts', 'g'),
('ground black pepper', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='penne pasta' AND unit='g'), '255'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='grated Parmesan cheese' AND unit='g'), '50'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='crumbled Gorgonzola cheese' AND unit='g'), '42'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='heavy whipping cream' AND unit='ml'), '120'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pears' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='walnuts' AND unit='g'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '9', 

    'Plum Butter', 

    '10 mins', 

    '6 hrs 45 mins', 

    '18 hrs 55 mins', 

    '32', 

    'Place plums in a large stockpot and add enough water to cover the bottom of stockpot; cook over very low heat, stirring occasionally, until plums are broken down, about 2 hours. Remove stockpot from heat and cool for 2 hours. Return stockpot to stovetop over low heat; cook gently for 2 to 3 hours. Remove from heat and keep at room temperature, 8 hours to overnight. Cook plums over low heat, stirring occasionally, about 2 hours. Remove from heat and let stand at room temperature for 2 hours. Bring plums to a boil; add sugar, lower heat, and simmer until thickened, about 15 minutes. Sterilize jars and lids in boiling water for at least 5 minutes. Pack plum butter into hot jars, filling to within 1/4 inch of the top. Run a clean knife or thin spatula around the insides of the jars to remove any air bubbles. Wipe the rims of the jars with a moist paper towel to remove any food residue. Top with lids and screw on rings. Place a rack in the bottom of a large stockpot and fill halfway with water. Bring to a boil and lower jars into the boiling water using a holder. Leave a 2-inch space between the jars. Pour in more boiling water if necessary to bring the water level to at least 1 inch above the tops of the jars. Bring the water to a rolling boil, cover the pot, and process for 15 minutes. Remove the jars from the stockpot and place onto a cloth-covered or wood surface, several inches apart, until cool. Press the top of each lid with a finger, ensuring that the seal is tight (lid does not move up or down at all). Store in a cool, dark area.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/255523/plum-butter/', 

    '/Side Dish/Sauces and Condiments/Canning and Preserving Recipes/Fruit Butter Recipes/', 

    'Total Fat 0g 0%, Sodium 0mg 0%, Total Carbohydrate 14g 5%, Dietary Fiber 1g 3%, Total Sugars 13g, Protein 0g, Vitamin C 6mg 31%, Calcium 4mg 0%, Iron 0mg 1%, Potassium 101mg 2%', 

    'https://www.allrecipes.com/thmb/F367I96e_ETi64IVDNtGh3Z5BNo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/4540723-86e304d70526487cab5bf29a04bb019f.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES
('plums', 'g'),
('water', 'ml'),
('white sugar', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='plums' AND unit='g'), '2041'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '200');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '10', 

    'Prune Filling', 

    '10 mins', 

    NULL, 

    '10 mins', 

    '24', 

    'Chop pecans and prunes together in a blender or food processor, stir in the sugar, cinnamon, cloves and lime juice. Use as a filling for cookies or pastries.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/26216/prune-filling/', 

    '/Desserts/Fillings/Fruit Fillings/', 

    'Total Fat 3g 4%, Saturated Fat 0g 2%, Sodium 1mg 0%, Total Carbohydrate 7g 3%, Dietary Fiber 1g 4%, Total Sugars 6g, Protein 1g, Vitamin C 1mg 4%, Calcium 7mg 1%, Iron 0mg 1%, Potassium 62mg 1%', 

    'https://www.allrecipes.com/thmb/rLCRIG0I7zNR32oUvZZEM-k8IaY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5057331-66818de25d3c45749dca1964b39a5386.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('pecans', 'g'), 
('stewed prunes', 'g'), 
('white sugar', 'g'), 
('ground cinnamon', 'g'), 
('ground cloves', 'g'), 
('lime juice', 'mL');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pecans' AND unit='g'), '110'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='stewed prunes' AND unit='g'), '454'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '25'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cinnamon' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cloves' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lime juice' AND unit='mL'), '15');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '11', 

    'Middle Eastern Rice Pilaf with Pomegranate', 

    '10 mins', 

    '25 mins', 

    '35 mins', 

    '4', 

    'Heat oil in a saucepan over medium heat and cook onion until soft and translucent. Add rice and toast until fragrant, 2 to 3 minutes. Pour in hot vegetable broth and bring to a boil. Add saffron and allspice, reduce heat to medium-low, cover, and simmer until rice is tender and liquid has been absorbed, about 20 minutes. Toast pistachios in a skillet over medium heat until nuts start to turn golden brown and become fragrant, 5 to 10 minutes. Set aside. Stir butter into the cooked rice. Remove from heat and mix in pistachios and pomegranate seeds. Fluff with fork and season with salt and pepper.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/260447/middle-eastern-rice-pilaf-with-pomegranate/', 

    '/Side Dish/Rice Side Dish Recipes/Pilaf/', 

    'Total Fat 13g 17%, Saturated Fat 3g 16%, Cholesterol 8mg 3%, Sodium 351mg 15%, Total Carbohydrate 59g 21%, Dietary Fiber 3g 11%, Total Sugars 16g, Protein 7g, Vitamin C 9mg 44%, Calcium 49mg 4%, Iron 3mg 16%, Potassium 385mg 8%', 

    'https://www.allrecipes.com/thmb/J44EbA7hhMpvl8LUapjz88VROV0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6061946-ffd9570f960a467390f66b122febff29.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('olive oil', 'mL'), 
('onion', 'pieces'), 
('long-grain rice', 'g'), 
('vegetable broth', 'mL'), 
('saffron threads', 'g'), 
('ground allspice', 'g'), 
('unsalted pistachios', 'g'), 
('butter', 'g'), 
('pomegranate seeds', 'g'), 
('salt', 'g'), 
('ground black pepper', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='mL'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='long-grain rice' AND unit='g'), '185'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vegetable broth' AND unit='mL'), '530'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='saffron threads' AND unit='g'), '0.1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground allspice' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='unsalted pistachios' AND unit='g'), '28'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '14'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pomegranate seeds' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '12', 

    'Pomegranate Grenadine', 

    '5 mins', 

    '20 mins', 

    '55 mins', 

    '32', 

    'Combine 3 cups pomegranate juice and sugar together in a saucepan; heat to 244 degrees F (118 degrees C) or until a small amount of mixture dropped into cold water forms a firm ball. Remove saucepan from heat and cover with a lid; let cool until pan is cool enough to touch. Stir remaining 1 cup pomegranate juice into mixture. Refrigerate.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/237763/pomegranate-grenadine/', 

    '/Side Dish/Sauces and Condiments/Syrup Recipes/', 

    'Sodium 1mg 0%, Total Carbohydrate 11g 4%, Total Sugars 11g, Calcium 0mg 0%, Potassium 0mg 0%', 

    'https://www.allrecipes.com/thmb/n4zz7VM_jeYXB5-oRLMSRtUGdoo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1172032-ef4749c216f744e6a644f3aef3597a1e.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('pomegranate juice', 'mL'), 
('white sugar', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pomegranate juice' AND unit='mL'), '946'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '200');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '13', 

    'Holiday Pomegranate Mignonette', 

    '10 mins', 

    NULL, 

    '1 hrs 10 mins', 

    '4', 

    'Whisk vinegar, pomegranate juice, shallot, pepper, and white sugar together in a bowl until sugar dissolves. Add pomegranate seeds, cover the bowl with plastic wrap, and refrigerate until chilled, about 1 hour.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/236576/holiday-pomegranate-mignonette/', 

    '/Side Dish/Sauces and Condiments/Sauces/', 

    'Sodium 2mg 0%, Total Carbohydrate 4g 1%, Dietary Fiber 0g 0%, Total Sugars 2g, Protein 0g, Vitamin C 1mg 4%, Calcium 4mg 0%, Iron 0mg 1%, Potassium 40mg 1%', 

    'https://www.allrecipes.com/thmb/kFPiZkjgJ9Dtz8iOINCLwwZPJ60=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1670332-86a0fb143ab54ffbb760214f03850b72.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('champagne vinegar', 'mL'), 
('pomegranate juice', 'mL'), 
('shallot', 'piece'), 
('ground black pepper', 'g'), 
('white sugar', 'g'), 
('pomegranate seeds', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='champagne vinegar' AND unit='mL'), '45'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pomegranate juice' AND unit='mL'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shallot' AND unit='piece'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pomegranate seeds' AND unit='g'), '10');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '14', 

    'Roasted Persimmon-Burrata Focaccia', 

    '10 mins', 

    '40 mins', 

    '50 mins', 

    '2', 

    'Preheat the oven to 350 degrees F (175 degrees C). Line a baking sheet with parchment paper. Lay persimmon slices onto the prepared baking sheet. Drizzle with 2 teaspoons olive oil and sprinkle salt on top. Sprinkle 1/2 the rosemary leaves over the persimmon slices. Roast in the preheated oven for 20 minutes. Turn persimmon slices over and roast 10 minutes more. Remove baking sheet from the oven and increase temperature to 200 degrees C. Place focaccia on a baking sheet. Bake focaccia in the hot oven until warmed through, about 5 minutes. Remove from oven and top focaccia with roasted persimmon slices. Tear burrata cheese using your hands and lay evenly on the focaccia, avoiding the persimmon slices. Reserve about 1 tablespoon rosemary leaves and sprinkle the rest on top. Return focaccia to the hot oven and bake until warmed and burrata cheese has melted slightly, about 5 minutes. Top with reserved fresh rosemary leaves and drizzle remaining 2 teaspoons olive oil on top. Slice and serve hot.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/269164/roasted-persimmon-burrata-focaccia/', 

    '/Appetizers and Snacks/Cheese/', 

    'Total Fat 31g 40%, Saturated Fat 12g 62%, Cholesterol 45mg 15%, Sodium 2067mg 90%, Total Carbohydrate 118g 43%, Dietary Fiber 6g 23%, Total Sugars 2g, Protein 29g, Vitamin C 8mg 42%, Calcium 183mg 14%, Iron 7mg 39%, Potassium 294mg 6%', 

    'https://www.allrecipes.com/thmb/YY9YGFUcF4945PXRrfwGYTh2y4E=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5964553-e9f778e6294842b1864159e9e319d4c8.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('precooked 9-inch focaccia flatbread', 'piece'), 
('persimmon', 'piece'), 
('olive oil', 'mL'), 
('salt', 'g'), 
('fresh rosemary sprigs', 'piece'), 
('burrata cheese', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='precooked 9-inch focaccia flatbread' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='persimmon' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='mL'), '20'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh rosemary sprigs' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='burrata cheese' AND unit='g'), '115');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '15', 

    'Paleo Persimmon Pie', 

    '30 mins', 

    NULL, 

    '30 mins', 

    '8', 

    'Lightly grease an 8-inch pie pan with olive oil. Blend 3 cups pecans and dates in a food processor until finely ground, about 1 minute. Pour agave nectar over nut mixture and process until fully incorporated, about 30 seconds. Press nut mixture evenly into prepared pie pan. Peel and pit persimmons, then puree in food processor until smooth. Pour over crust and smooth out. Garnish with chopped pecans and cinnamon.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/228719/paleo-persimmon-pie/', 

    '/Desserts/Pies/No-Bake Pie Recipes/', 

    'Total Fat 31g 40%, Saturated Fat 3g 14%, Sodium 1mg 0%, Total Carbohydrate 36g 13%, Dietary Fiber 7g 24%, Total Sugars 22g, Protein 5g, Vitamin C 13mg 65%, Calcium 46mg 4%, Iron 2mg 10%, Potassium 371mg 8%', 

    'https://www.allrecipes.com/thmb/pjIE-wIHBsekrfdpIJdeniUVLis=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1569009-268177fbb6c3446bb32fbf9c3f1bfd76.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('olive oil', 'mL'), 
('pecans', 'g'), 
('pitted Medjool dates', 'pieces'), 
('agave nectar', 'mL'), 
('persimmon', 'piece'), 
('ground cinnamon', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='mL'), '2.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pecans' AND unit='g'), '330'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pitted Medjool dates' AND unit='pieces'), '20'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='agave nectar' AND unit='mL'), '85'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='persimmon' AND unit='piece'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cinnamon' AND unit='g'), '2');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '16', 

    'Fresh Fruit Tart with Mascarpone', 

    '30 mins', 

    '15 mins', 

    '45 mins', 

    '16', 

    'Preheat the oven to 350 degrees F (175 degrees C). Lightly grease 2 tart pans. Blend flour, butter, and sugar together in a bowl using an electric mixer until combined. Divide mixture evenly and press into the bottoms of the prepared tart pans. Bake in the preheated oven until golden brown, 12 to 15 minutes. Let cool completely. While crusts are cooling, beat cream cheese, mascarpone cheese, sugar, vanilla extract, nutmeg, and cinnamon together in a bowl using an electric mixer until light and fluffy. Spread mixture over cooled crusts. Arrange strawberries, blackberries, and kiwis on tart in desired design. Mix sugar and cornstarch together in a small saucepan. Pour in water and lemon juice. Cook over medium heat until clear and thick, about 2 minutes. Let glaze cool completely. Glaze the entire top of each tart gently using a pastry brush.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/273048/fresh-fruit-tart-with-mascarpone/', 

    '/Desserts/Pies/Tarts/Fruit Tart Recipes/', 

    'Total Fat 23g 30%, Saturated Fat 14g 70%, Cholesterol 63mg 21%, Sodium 132mg 6%, Total Carbohydrate 43g 16%, Dietary Fiber 2g 8%, Total Sugars 28g, Protein 4g, Vitamin C 28mg 141%, Calcium 51mg 4%, Iron 1mg 6%, Potassium 141mg 3%', 

    'https://www.allrecipes.com/thmb/UZyuCXyWRAGl8lXW-pJjjsnc2II=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/4520854-1c7bb16a86124f80bc7a17c9f16535e0.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('all-purpose flour', 'g'), 
('butter', 'g'), 
('white sugar', 'g'), 
('cream cheese', 'g'), 
('mascarpone cheese', 'g'), 
('vanilla extract', 'mL'), 
('ground nutmeg', 'g'), 
('ground cinnamon', 'g'), 
('strawberries', 'g'), 
('blackberries', 'g'), 
('kiwis', 'g'), 
('cornstarch', 'g'), 
('water', 'mL'), 
('lemon juice', 'mL');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '250'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '250'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cream cheese' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='mascarpone cheese' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vanilla extract' AND unit='mL'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground nutmeg' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cinnamon' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='strawberries' AND unit='g'), '300'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='blackberries' AND unit='g'), '150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='kiwis' AND unit='g'), '230'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cornstarch' AND unit='g'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='mL'), '120'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='mL'), '15');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '17', 

    'Simple Strawberry Salsa', 

    '15 mins', 

    NULL, 

    '45 mins', 

    '10', 

    'Stir lemon juice and sugar together in a bowl to dissolve the sugar; add strawberries, pineapple, kiwis, and orange pieces and stir to coat in the lemon juice mixture. Cover bowl with plastic wrap and refrigerate at least 30 minutes.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/238427/simple-strawberry-salsa/', 

    '/Appetizers and Snacks/Dips and Spreads Recipes/Fruit Dip/', 

    'Total Fat 0g 0%, Sodium 1mg 0%, Total Carbohydrate 11g 4%, Dietary Fiber 2g 6%, Total Sugars 8g, Protein 1g, Vitamin C 42mg 211%, Calcium 20mg 2%, Iron 0mg 1%, Potassium 154mg 3%', 

    'https://www.allrecipes.com/thmb/y63gYRYjghFbC1if0TEbAYfm09Y=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2220499-b93fbb5c1e3e4865b6662a7caae4e160.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('lemon juice', 'mL'), 
('white sugar', 'g'), 
('strawberries', 'g'), 
('crushed pineapple', 'g'), 
('kiwis', 'g'), 
('naval orange', 'piece');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='mL'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='strawberries' AND unit='g'), '150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='crushed pineapple' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='kiwis' AND unit='g'), '230'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='naval orange' AND unit='piece'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '18', 

    'Tart Tropical Parfait', 

    '5 mins', 

    NULL, 

    '5 mins', 

    '1', 

    'Spoon 1/3 cup yogurt into a 6- to 8-ounce parfait glass or jar. Top yogurt with 1/2 of the kiwi, 1/2 of the macadamia nuts, 1/2 of the agave. Repeat layers with the remaining yogurt, kiwi, nuts, and agave. Top parfait with mint.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/285020/tart-tropical-parfait/', 

    '/Desserts/Specialty Dessert Recipes/Parfait Recipes/', 

    'Total Fat 13g 17%, Saturated Fat 2g 11%, Cholesterol 9mg 3%, Sodium 74mg 3%, Total Carbohydrate 37g 13%, Dietary Fiber 4g 16%, Total Sugars 28g, Protein 15g, Vitamin C 83mg 413%, Calcium 46mg 4%, Iron 1mg 5%, Potassium 339mg 7%', 

    'https://www.allrecipes.com/thmb/RsFsSIETjBv5YlmZoZQbnMlLBT4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/9314803-c93055df2b164632a81c231ca4a35882.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('low-fat vanilla Greek yogurt', 'g'), 
('kiwis', 'g'), 
('macadamia nuts', 'g'), 
('agave nectar', 'mL'), 
('fresh mint', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='low-fat vanilla Greek yogurt' AND unit='g'), '150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='kiwis' AND unit='g'), '90'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='macadamia nuts' AND unit='g'), '18'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='agave nectar' AND unit='mL'), '7'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh mint' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '19', 

    'Sweet and Kickin\' Mango-Habanero Hot Sauce', 

    '25 mins', 

    '20 mins', 

    '45 mins', 

    '128', 

    'Heat olive oil in a skillet over medium heat. Add onion; cook and stir until translucent, about 5 minutes. Combine the onion, mangoes, peach, honey, habanero peppers, and mustard in a food processor. Process until smooth; mix in salt, paprika, white pepper, cumin, and allspice. Add brown sugar; continue to process until well combined. Pour mango-habanero mixture into a large saucepan. Bring to a boil. Add white vinegar and apple cider vinegar, stirring frequently until thoroughly combined. Boil until thickened, 10 to 12 minutes. Pour sauce into jars or containers.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/261294/sweet-and-kickin-mango-habanero-hot-sauce/', 

    '/Side Dish/Sauces and Condiments/Sauces/Wing Sauce Recipes/', 

    'Total Fat 0g 0%, Sodium 142mg 6%, Total Carbohydrate 3g 1%, Dietary Fiber 0g 1%, Total Sugars 2g, Protein 0g, Vitamin C 3mg 16%, Calcium 3mg 0%, Iron 0mg 1%, Potassium 23mg 0%', 

    'https://www.allrecipes.com/thmb/XVfX0pUDHAOYeuqSWrT5cYF3RrY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6613614-b8b8d68a5af34ca19443b10e9a243e02.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('olive oil', 'mL'), 
('onion', 'pieces'), 
('mangoes', 'piece'), 
('fresh peach', 'piece'), 
('honey', 'mL'), 
('habanero peppers', 'piece'), 
('yellow mustard', 'mL'), 
('salt', 'g'), 
('paprika', 'g'), 
('ground white pepper', 'g'), 
('ground cumin', 'g'), 
('ground allspice', 'g'), 
('brown sugar', 'g'), 
('white vinegar', 'mL'), 
('apple cider vinegar', 'mL');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='mL'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='mangoes' AND unit='piece'), '7'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh peach' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='honey' AND unit='mL'), '115'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='habanero peppers' AND unit='piece'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='yellow mustard' AND unit='mL'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '45'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='paprika' AND unit='g'), '18'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground white pepper' AND unit='g'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground cumin' AND unit='g'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground allspice' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '50'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white vinegar' AND unit='mL'), '355'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apple cider vinegar' AND unit='mL'), '120');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '20', 

    'Blackened Salmon Tacos with Chunky Mango Avocado Salsa', 

    '40 mins', 

    '9 mins', 

    '49 mins', 

    '6', 

    'Combine mangoes, avocado, orange bell pepper, and jalapeno in a large bowl to make salsa. Add lime juice, cilantro, and salt; mix to combine. Cover with plastic wrap and refrigerate. Sprinkle seafood rub, chili powder, salt, and black pepper over 1 side of each salmon steak; rub in with your fingers until evenly distributed. Coat the bottom of a large skillet with olive oil and heat over medium-high heat. Add salmon skin-side down and cook until skin is crisp, 4 to 5 minutes. Flip salmon and carefully peel off skin. Season top with seafood rub, chili powder, salt and black pepper. Continue cooking until lightly browned on the second side and salmon flakes easily with a fork, 4 to 5 minutes. Slice each salmon fillet lengthwise to create 6 portions. Lightly oil another skillet over medium heat. Pan-fry corn tortillas, one at a time, until heated through and pliable, about 30 seconds per side. Place 1 portion of salmon on each tortilla. Top with salsa. Squeeze a wedge of lime on top.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/246845/blackened-salmon-tacos-with-chunky-mango-avocado-salsa/', 

    '/Main Dishes/Taco Recipes/', 

    'Total Fat 14g 18%, Saturated Fat 2g 12%, Cholesterol 19mg 6%, Sodium 342mg 15%, Total Carbohydrate 36g 13%, Dietary Fiber 7g 26%, Total Sugars 13g, Protein 10g, Vitamin C 82mg 410%, Calcium 62mg 5%, Iron 1mg 7%, Potassium 565mg 12%', 

    'https://www.allrecipes.com/thmb/9KX9Pu4XDnNGdqpNpfjZhXpUBUo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/4539795-a4dccc6bbb5049ea9c1a7725df8d1a08.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('mangoes', 'piece'), 
('avocado', 'piece'), 
('orange bell pepper', 'piece'), 
('jalapeno pepper', 'piece'), 
('lime juice', 'ml'), 
('chopped fresh cilantro', 'g'), 
('salt', 'g'), 
('sweet and spicy seafood rub', 'g'), 
('chili powder', 'g'), 
('ground black pepper', 'g'), 
('salmon fillet', 'g'), 
('olive oil', 'ml'), 
('corn tortillas', 'piece'), 
('lemons', 'pieces');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='mangoes' AND unit='piece'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='orange bell pepper' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='jalapeno pepper' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lime juice' AND unit='ml'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chopped fresh cilantro' AND unit='g'), '8'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sweet and spicy seafood rub' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chili powder' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salmon fillet' AND unit='g'), '220'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='ml'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='corn tortillas' AND unit='piece'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemons' AND unit='pieces'), '3');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '21', 

    'Jerk Chicken Egg Rolls with Mango-Habanero Sauce', 

    '45 mins', 

    '40 mins', 

    '1 hrs 25 mins', 

    '18', 

    'For the habanero sauce: Combine mango with 3/4 cup water, rice vinegar, garlic, and salt in a small saucepan. Add most of the brown sugar, reserving 1 teaspoon. Bring to a boil, then reduce heat to medium-low; cook for 5 minutes. Add habanero peppers and simmer for 2 minutes. Mix 2 tablespoon water with cornstarch; stir slurry into the saucepan. Cook over medium-high until thick, 3 to 5 minutes. Leave mixture chunky or blend for a smoother texture. For the filling: Heat 1 tablespoon oil in a large saucepan over medium-high heat. Add chicken thighs and sauté until browned, 5 to 7 minutes; sprinkle jerk seasoning over chicken. Add shallot and garlic; cook and stir until shallot begins to soften, about 3 minutes. Reduce heat to medium; add cabbage, carrots, and reserved sugar. Cook until cabbage is translucent but still a little crunchy, 3 to 5 minutes. Taste for seasoning. Let mixture cool. Heat remaining vegetable oil in a pan over medium-high heat. Fry plantains until they start to brown, about 5 minutes. Transfer plantains onto a paper towel and let cool. Separate and place egg roll wrappers onto your work surface. Mix egg with water for egg wash. Lay out one wrapper with a corner pointed toward you. Use a slotted spoon to add some of the chicken and cabbage mixtures across the center. Sprinkle plantain bits on top. Use your finger or a pastry brush to lightly moisten edges of wonton wrappers with egg wash. Fold one corner of the wrapper over filling onto the opposite corner to form a triangle. Press edges together to seal. Fill and fold remaining egg rolls. Heat oil in a large saucepan over medium-high heat. Fry egg rolls in batches in hot oil, turning occasionally, until golden brown, about 5 minutes. Remove and drain on paper towels or a rack. Serve with mango-habanero sauce.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/269709/jerk-chicken-egg-rolls-with-mango-habanero-sauce/', 

    '/Appetizers and Snacks/Wraps and Rolls/Egg Roll Recipes/', 

    'Total Fat 8g 11%, Saturated Fat 2g 9%, Cholesterol 35mg 12%, Sodium 294mg 13%, Total Carbohydrate 35g 13%, Dietary Fiber 3g 12%, Total Sugars 14g, Protein 11g, Vitamin C 32mg 159%, Calcium 59mg 5%, Iron 2mg 11%, Potassium 385mg 8%', 

    'https://www.allrecipes.com/thmb/rFKfI-wu25jgpM4qfLOH_w9DOg8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/4560211-2ff36c9ec4df4b6089cd34763fb3af70.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('mangoes', 'piece'), 
('water', 'ml'), 
('seasoned rice vinegar', 'ml'), 
('garlic cloves', 'pieces'), 
('salt', 'g'), 
('brown sugar', 'g'), 
('habanero peppers', 'piece'), 
('cornstarch', 'g'), 
('vegetable oil', 'ml'), 
('chicken thighs', 'g'), 
('jerk seasoning', 'g'), 
('shallot', 'piece'), 
('shredded cabbage', 'g'), 
('shredded carrots', 'g'), 
('plantains', 'piece'), 
('egg roll wrappers', 'piece'), 
('eggs', 'pieces');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='mangoes' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '210'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='seasoned rice vinegar' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic cloves' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '105'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='habanero peppers' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cornstarch' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vegetable oil' AND unit='ml'), '500'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chicken thighs' AND unit='g'), '450'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='jerk seasoning' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shallot' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded cabbage' AND unit='g'), '200'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded carrots' AND unit='g'), '100'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='plantains' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='egg roll wrappers' AND unit='piece'), '18'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '22', 

    'Baked Ham with Sweet Glaze', 

    '20 mins', 

    '2 hrs 30 mins', 

    '3 hrs', 

    '20', 

    'Preheat oven to 400 degrees F (200 degrees C). Place ham on a rack set in a roasting pan, and carefully pour about 1/2 inch of boiling water into the pan beneath the ham. Bake the ham in the preheated oven for 2 hours, or until a meat thermometer inserted into the thickest part of the meat (do not touch the bone) reads at least 140 degrees F (60 degrees C.) Reduce oven heat to 350 degrees F (175 degrees C.) In a bowl, mix together the brown sugar, flour, dry mustard, honey, and lemon juice as needed to make a thick, smooth paste. Brush the ham generously with glaze. Skewer 1 pineapple chunk and 1 maraschino cherry per toothpick, and insert the decorated picks all over the ham. Return the ham to the oven, and roast for 15 minutes. Baste the ham, fruit and all, with glaze and juices that have collected in the bottom of the pan, return to the oven, and roast for an additional 15 minutes. Let the ham rest for at least 10 minutes before slicing.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/214000/baked-ham-with-sweet-glaze/', 

    '/Main Dishes/Pork/Ham/Whole/', 

    'Total Fat 33g 42%, Saturated Fat 12g 60%, Cholesterol 218mg 73%, Sodium 146mg 6%, Total Carbohydrate 24g 9%, Dietary Fiber 0g 1%, Total Sugars 18g, Protein 66g, Vitamin C 3mg 17%, Calcium 46mg 4%, Iron 3mg 15%, Potassium 920mg 20%', 

    'https://www.allrecipes.com/thmb/kQ9m3oV1heKRJ0k47iovhDOFwOM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/739061-2d502b30f28b4ee39031bc51f32ae0fa.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('fully-cooked bone-in ham', 'g'), 
('water', 'ml'), 
('brown sugar', 'g'), 
('all-purpose flour', 'g'), 
('dry mustard powder', 'g'), 
('honey', 'mL'), 
('lemon juice', 'ml'), 
('pineapple chunks', 'g'), 
('maraschino cherries', 'g'), 
('toothpicks', 'piece');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fully-cooked bone-in ham' AND unit='g'), '4535'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '946'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '200'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '16'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dry mustard powder' AND unit='g'), '12'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='honey' AND unit='mL'), '85'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pineapple chunks' AND unit='g'), '565'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='maraschino cherries' AND unit='g'), '280'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='toothpicks' AND unit='piece'), '24');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '23', 

    'Watermelon Fish Snack for Kids', 

    '5 mins', 

    NULL, 

    '5 mins', 

    '1', 

    'Place watermelon triangle on a plate with the pointed side facing to the left. Place 1 blueberry into the triangle for the fish eye. Place the other 4 blueberries above the fish\'s mouth as if they are bubbles coming up. Cut off a tiny curved sliver of papaya for the mouth. Flip the papaya triangle over and place at the end of the fish as the tail fin.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/271094/watermelon-fish-snack-for-kids/', 

    '/Everyday Cooking/Vegan/Desserts/', 

    'Total Fat 0g 0%, Saturated Fat 0g 1%, Sodium 5mg 0%, Total Carbohydrate 16g 6%, Dietary Fiber 3g 10%, Total Sugars 10g, Protein 1g, Vitamin C 91mg 457%, Calcium 36mg 3%, Iron 0mg 1%, Potassium 394mg 8%', 

    'https://www.allrecipes.com/thmb/pWdkn0S6ZFZGmTs71z_OUKQlfvo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6443776-1369ff68018640deace2a4862fd93413.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('watermelon', 'g'), 
('blueberries', 'g'), 
('papaya', 'piece');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='watermelon' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='blueberries' AND unit='g'), '7'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='papaya' AND unit='piece'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '24', 

    'Black Bean Avocado Salsa', 

    '15 mins', 

    NULL, 

    '2 hrs 15 mins', 

    '10', 

    'Mix black beans, corn, tomatoes, red bell pepper, jalapeno pepper, cilantro, red onion, lime juice, vinegar, salt, and black pepper in a bowl; fold avocado into the mixture. Cover bowl with plastic wrap, putting it right on top of salsa; chill at least 2 hours.', 

    '4.9', 

    'https://www.allrecipes.com/recipe/229020/black-bean-avocado-salsa/', 

    '/Appetizers and Snacks/Dips and Spreads Recipes/Salsa Recipes/Corn Salsa Recipes/', 

    'Total Fat 6g 8%, Saturated Fat 1g 5%, Sodium 493mg 21%, Total Carbohydrate 19g 7%, Dietary Fiber 7g 25%, Total Sugars 3g, Protein 5g, Vitamin C 21mg 106%, Calcium 28mg 2%, Iron 1mg 8%, Potassium 471mg 10%', 

    'https://www.allrecipes.com/thmb/Y7XOlshxEjuG4iADMcXbpCey0QA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5889297-5575d9e6a70a402ca4e2b19ef34d0131.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('black beans', 'g'), 
('whole kernel sweet corn', 'g'), 
('roma tomatoes', 'piece'), 
('red bell pepper', 'piece'), 
('jalapeno pepper', 'piece'), 
('chopped fresh cilantro', 'g'), 
('onion', 'pieces'), 
('lime juice', 'ml'), 
('red wine vinegar', 'ml'), 
('salt', 'g'), 
('ground black pepper', 'g'), 
('avocado', 'piece');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='black beans' AND unit='g'), '425'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='whole kernel sweet corn' AND unit='g'), '310'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='roma tomatoes' AND unit='piece'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='red bell pepper' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='jalapeno pepper' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chopped fresh cilantro' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '0.25'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lime juice' AND unit='ml'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='red wine vinegar' AND unit='ml'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '2');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '25', 

    'Mexican Pizza I', 

    '17 mins', 

    '30 mins', 

    '50 mins', 

    '4', 

    'Heat the refried beans. In a large skillet, brown the ground beef. Stir in the seasoning packet. Preheat oven to 350 degrees F (175 degrees C). Place a small amount of vegetable oil in a large skillet. Let the oil heat, then place one corn tortilla in the skillet. After 15 seconds, flip the tortilla over and let it fry another 15 seconds. Repeat this process with the remaining tortillas, letting them drain on paper towels once they have been heated. When the tortillas have drained, arrange them on a cookie sheet. Spread a thin layer of beans on the tortillas, followed by a layer of beef, and cheese. Bake the tortillas in the preheated oven for 20 to 30 minutes. Slice the tortillas into wedges and arrange them on plates or a serving platter and garnish them with the sour cream, tomatoes, green onions, chiles, avocado, and olives.', 

    '4.5', 

    'https://www.allrecipes.com/recipe/17368/mexican-pizza-i/', 

    '/Appetizers and Snacks/Beans and Peas/', 

    'Total Fat 48g 62%, Saturated Fat 23g 114%, Cholesterol 150mg 50%, Sodium 1542mg 67%, Total Carbohydrate 42g 15%, Dietary Fiber 10g 37%, Total Sugars 4g, Protein 42g, Vitamin C 24mg 122%, Calcium 534mg 41%, Iron 5mg 29%, Potassium 866mg 18%', 

    'https://www.allrecipes.com/thmb/R4yPfeiSCjcjQ0dvg6c2LW5afpU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/image-432-46cd995a1c7f4955b2ca27d54d9ae63d.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('refried beans', 'g'), 
('ground beef', 'g'), 
('taco seasoning mix', 'g'), 
('vegetable oil', 'ml'), 
('corn tortillas', 'piece'), 
('shredded Cheddar cheese', 'g'), 
('sour cream', 'g'), 
('roma tomatoes', 'piece'), 
('green onion', 'pieces'), 
('diced green chiles', 'g'), 
('avocado', 'piece'), 
('black olives', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='refried beans' AND unit='g'), '454'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground beef' AND unit='g'), '454'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='taco seasoning mix' AND unit='g'), '35'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vegetable oil' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='corn tortillas' AND unit='piece'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded Cheddar cheese' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sour cream' AND unit='g'), '120'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='roma tomatoes' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='green onion' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='diced green chiles' AND unit='g'), '113'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='black olives' AND unit='g'), '15');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '26', 

    'Avocado Toast with Egg', 

    '5 mins', 

    '5 mins', 

    '10 mins', 

    '2', 

    'Melt butter in a skillet over medium-low heat. Crack eggs into the skillet side by side and cook until eggs are white on the bottom layer and firm enough to flip, 2 to 3 minutes. Flip eggs, trying not to crack the yolk, and cook until egg reaches desired doneness, 2 to 5 minutes more. Meanwhile, toast bread slices to desired doneness, 3 to 5 minutes. Mash avocado in a bowl; stir in lemon juice, cayenne pepper, and sea salt. Spread avocado mixture onto toast. Top with fried egg and season with sea salt and pepper.', 

    '4.9', 

    'https://www.allrecipes.com/recipe/265304/avocado-toast-with-egg/', 

    '/Main Dishes/Sandwich Recipes/', 

    'Total Fat 23g 29%, Saturated Fat 5g 26%, Cholesterol 191mg 64%, Sodium 361mg 16%, Total Carbohydrate 21g 8%, Dietary Fiber 9g 31%, Total Sugars 3g, Protein 12g, Vitamin C 12mg 58%, Calcium 69mg 5%, Iron 4mg 23%, Potassium 628mg 13%', 

    'https://www.allrecipes.com/thmb/7-Tno2yJIb9B01pj87eGbAlC1Vo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6274187-98cf86c35b0d4f0bb69dad283ac7a8db.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('butter', 'g'), 
('eggs', 'pieces'), 
('multigrain bread', 'piece'), 
('avocado', 'piece'), 
('lemon juice', 'ml'), 
('cayenne pepper', 'g'), 
('salt', 'g'), 
('ground black pepper', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='multigrain bread' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cayenne pepper' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '27', 

    'Meyer Lemon Avocado Toast', 

    '10 mins', 

    '3 mins', 

    '13 mins', 

    '2', 

    'Toast bread slices to desired doneness, 3 to 5 minutes. Mash avocado in a bowl; stir in cilantro, Meyer lemon juice, Meyer lemon zest, cayenne pepper, and sea salt. Spread avocado mixture onto toast and top with chia seeds.', 

    '4.8', 

    'https://www.allrecipes.com/recipe/257457/meyer-lemon-avocado-toast/', 

    '/Main Dishes/Sandwich Recipes/', 

    'Total Fat 1g 2%, Saturated Fat 0g 1%, Sodium 271mg 12%, Total Carbohydrate 12g 4%, Dietary Fiber 2g 8%, Total Sugars 2g, Protein 4g, Vitamin C 3mg 13%, Calcium 31mg 2%, Iron 3mg 14%, Potassium 82mg 2%', 

    'https://www.allrecipes.com/thmb/W7qxZ1EaZNXan2kpORUQXBg6x8g=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/4487253-e6669e70d4114beb857b6aeac7814444.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('multigrain bread', 'piece'), 
('avocado', 'piece'), 
('chopped fresh cilantro', 'g'), 
('lemon juice', 'ml'), 
('lemon zest', 'g'), 
('cayenne pepper', 'g'), 
('salt', 'g'), 
('chia seeds', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='multigrain bread' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chopped fresh cilantro' AND unit='g'), '8'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon zest' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cayenne pepper' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chia seeds' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '28', 

    'Mexican Botana Platter', 

    '40 mins', 

    '40 mins', 

    '1 hrs 20 mins', 

    '12', 

    'Preheat oven to 350 degrees F (175 degrees C). Rub beef and chicken with fajita seasoning and 2 teaspoons garlic powder. Cut beef and chicken into 1-inch strips. Warm refried beans over medium-low heat. Stir salt, lemon pepper, and 1/2 teaspoon garlic powder into mashed avocados. Heat corn oil in a deep skillet; cut tortillas into 4 triangular pieces each and fry until crisp. In the same skillet, cook beef, chicken, bell pepper, and onion for 7 minutes; stir in cilantro. Layer tortilla pieces in a large baking dish. Spread beans over tortillas, sprinkle with cheese, and top with meat mixture. Bake until bubbly, about 20 minutes. Top with dollops of sour cream and guacamole, then sprinkle with tomatoes and jalapenos.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/86322/mexican-botana-platter/', 

    '/Mexican/Main Dishes/Fajita Recipes/Chicken/', 

    'Total Fat 40g 51%, Saturated Fat 16g 80%, Cholesterol 120mg 40%, Sodium 958mg 42%, Total Carbohydrate 42g 15%, Dietary Fiber 11g 39%, Total Sugars 3g, Protein 40g, Vitamin C 23mg 116%, Calcium 326mg 25%, Iron 3mg 19%, Potassium 1008mg 21%', 

    'https://www.allrecipes.com/thmb/lyqST07dlkdfnnYmq1oI-8dTVqQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/7223980-3fdf6560768d429885fa4c4b4a60676a.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('beef skirt steak', 'g'), 
('chicken thighs', 'g'), 
('fajita seasoning', 'g'), 
('garlic powder', 'g'), 
('refried beans', 'g'), 
('avocado', 'piece'), 
('vegetable oil', 'ml'), 
('corn tortillas', 'piece'), 
('green bell pepper', 'piece'), 
('onion', 'pieces'), 
('chopped fresh cilantro', 'g'), 
('shredded American cheese', 'g'), 
('sour cream', 'g'), 
('roma tomatoes', 'piece'), 
('pickled jalapeno peppers', 'piece');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='beef skirt steak' AND unit='g'), '907'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chicken thighs' AND unit='g'), '907'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fajita seasoning' AND unit='g'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic powder' AND unit='g'), '8'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='refried beans' AND unit='g'), '450'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='avocado' AND unit='piece'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vegetable oil' AND unit='ml'), '235'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='corn tortillas' AND unit='piece'), '24'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='green bell pepper' AND unit='piece'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chopped fresh cilantro' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='shredded American cheese' AND unit='g'), '454'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sour cream' AND unit='g'), '340'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='roma tomatoes' AND unit='piece'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='pickled jalapeno peppers' AND unit='piece'), '4');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '29', 

    'Apricot Brown Sugar Ham', 

    NULL, 

    '2 hrs', 

    '2 hrs', 

    '15', 

    'Preheat the oven to 275 degrees F (135 degrees C). Place the ham cut side down onto a sheet of aluminum foil. Mix together the brown sugar, apricot jam, and mustard powder in a small bowl. Brush onto the ham using a pastry or barbeque brush. Reserve any leftover glaze. Enclose the foil around the ham and place on a rimmed baking sheet. Roast for 2 hours in the preheated oven, or if your ham is a different size, figure 14 minutes per pound. Apply the remaining glaze 20 minutes before the ham is done.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/102159/apricot-brown-sugar-ham/', 

    '/Main Dishes/Pork/Ham/Whole/', 

    'Total Fat 56g 72%, Saturated Fat 20g 101%, Cholesterol 170mg 57%, Sodium 3895mg 169%, Total Carbohydrate 14g 5%, Total Sugars 13g, Protein 56g, Vitamin C 106mg 532%, Calcium 31mg 2%, Iron 2mg 13%, Potassium 958mg 20%', 

    'https://www.allrecipes.com/thmb/SLu9E2obOFpbL_sDncDXBCIiQsE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1x1-PASSANO_ALR0922_Faves_Ham_5343-3c7cb8cd6f8f4179905af16dda147058.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('fully-cooked spiral cut ham', 'g'), 
('brown sugar', 'g'), 
('apricot jam', 'g'), 
('dry mustard powder', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fully-cooked spiral cut ham' AND unit='g'), '4535'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '135'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot jam' AND unit='g'), '110'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dry mustard powder' AND unit='g'), '4');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '30', 

    'Simple Apricot-Glazed Meatloaf', 

    '10 mins', 

    '1 hrs', 

    '1 hrs 15 mins', 

    '6', 

    'Preheat the oven to 350 degrees F (175 degrees C). Combine ground beef, bread crumbs, onion, egg, garlic, apricot preserves, kosher salt, and pepper in a large mixing bowl; mix well until thoroughly combined. Transfer to a 9x5-inch loaf pan. Bake in the preheated oven for 45 minutes. Meanwhile, make the glaze: Mix ketchup, apricot preserves, brown sugar, hot sauce, Worcestershire sauce, and cider vinegar together in a medium bowl. Remove meatloaf from the oven and pour glaze over top. Continue cooking until no longer pink in the center, about 15 minutes longer. An instant-read thermometer inserted into the center should read at least 160 degrees F (70 degrees C). Let rest 5 minutes before serving.', 

    '4.7', 

    'https://www.allrecipes.com/recipe/281342/simple-apricot-glazed-meatloaf/', 

    '/Main Dishes/Meatloaf Recipes/Beef Meatloaf Recipes/', 

    'Total Fat 20g 25%, Saturated Fat 7g 37%, Cholesterol 101mg 34%, Sodium 1782mg 77%, Total Carbohydrate 55g 20%, Dietary Fiber 1g 5%, Total Sugars 34g, Protein 23g, Vitamin C 14mg 70%, Calcium 78mg 6%, Iron 4mg 21%, Potassium 529mg 11%', 

    'https://www.allrecipes.com/thmb/bqcwvKxOgdCDkwsh7WoNcTdx-G4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/8547739-6d6f3ba9798c4045ad2d0cda25dec5f7.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('ground beef', 'g'), ('bread crumbs', 'g'), ('onion', 'pieces'), ('eggs', 'pieces'), ('garlic cloves', 'pieces'), 
('apricot preserves', 'g'), ('salt', 'g'), ('ground black pepper', 'g'), 
('ketchup', 'ml'), ('brown sugar', 'g'), ('hot sauce', 'ml'), ('Worcestershire sauce', 'ml'), ('apple cider vinegar', 'ml');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground beef' AND unit='g'), '680'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='bread crumbs' AND unit='g'), '100'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic cloves' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot preserves' AND unit='g'), '60 g'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '18 g'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '3 g'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ketchup' AND unit='ml'), '120 ml'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '25 g'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='hot sauce' AND unit='ml'), '5 ml'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='Worcestershire sauce' AND unit='ml'), '15 ml'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apple cider vinegar' AND unit='ml'), '15 ml');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '31', 

    'Apricot Cheesecake', 

    '40 mins', 

    '1 hrs 8 mins', 

    '8 hrs 48 mins', 

    '12', 

    'Preheat oven to 350 degrees F (175 degrees C). Line a 9-inch springform pan with parchment paper. Combine almond flour, brown sugar, and almonds in a bowl. Add melted butter; stir until mixture resembles wet sand. Press into pan. Combine apricots and water in a saucepan; simmer until soft, drain, and mash. Add amaretto and 1 tsp sugar. Beat cream cheese, 3/4 cup sugar, 1/2 cup sour cream, cornstarch, and 1 1/2 tsp vanilla extract. Add eggs one at a time. Fold in 2 tbsp apricot pulp. Pour over crust and bake for 45 minutes. Beat 1 1/2 cups sour cream, 3 tbsp sugar, and 1 tsp vanilla for topping. Spread over cheesecake and bake 8 minutes more. Cool and refrigerate for 6-8 hours. Top with remaining pulp.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/239539/apricot-cheesecake/', 

    '/Desserts/Cakes/Cheesecake Recipes/', 

    'Total Fat 38g 49%, Saturated Fat 20g 98%, Cholesterol 130mg 43%, Sodium 221mg 10%, Total Carbohydrate 40g 15%, Dietary Fiber 3g 10%, Total Sugars 31g, Protein 11g, Vitamin C 1mg 3%, Calcium 113mg 9%, Iron 2mg 8%, Potassium 369mg 8%', 

    'https://www.allrecipes.com/thmb/hGknfmqfD_tIsLQCy7lzth81vsk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5198951-df02f6ceb62b42beb38701cf7464fa6c.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('almond flour', 'g'), ('brown sugar', 'g'), ('almonds', 'g'), ('butter', 'g'), 
('dried apricots', 'g'), ('water', 'ml'), ('amaretto liqueur', 'ml'), ('white sugar', 'g'), 
('cream cheese', 'g'), ('sour cream', 'g'), ('cornstarch', 'g'), ('vanilla extract', 'ml'), ('eggs', 'pieces');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almond flour' AND unit='g'), '130'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '40'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almonds' AND unit='g'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='dried apricots' AND unit='g'), '200'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '250'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='amaretto liqueur' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '190'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cream cheese' AND unit='g'), '680'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sour cream' AND unit='g'), '480'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cornstarch' AND unit='g'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='vanilla extract' AND unit='ml'), '12'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '3');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '32', 

    'Apricot Brandy and Peach Schnapps Pound Cake', 

    '40 mins', 

    '1 hrs 15 mins', 

    '1 hrs 55 mins', 

    '12', 

    'Butter and flour one tube pan. Preheat oven to 325 degrees F (165 degrees C). Cream butter and sugar for 5 minutes. Add eggs one at a time. Sift flour, soda, and salt; add to creamed mixture alternately with sour cream and brandy. Bake 1 hour 15 minutes. For syrup: boil sugar, peach schnapps, water, and zest for 1 minute. Poke holes in cake bottom and pour syrup in. For glaze: boil preserves, brandy, and zest for 1 minute; drizzle over cake and top with almonds. Serve with peaches and blueberries tossed in citrus juice, peach schnapps, and simple syrup.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/13699/apricot-brandy-and-peach-schnapps-pound-cake/', 

    '/Desserts/Cakes/Pound Cake Recipes/', 

    'Total Fat 25g 32%, Saturated Fat 13g 67%, Cholesterol 142mg 47%, Sodium 289mg 13%, Total Carbohydrate 114g 42%, Dietary Fiber 2g 6%, Total Sugars 83g, Protein 9g, Vitamin C 3mg 16%, Calcium 66mg 5%, Iron 2mg 13%, Potassium 167mg 4%', 

    'https://www.allrecipes.com/thmb/SnGGcWkq7Wwm_uHe5oBJ9PwkWL4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5877385-6097ec811d1943cc94a40eb98e036d5f.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('white sugar', 'g'), ('butter', 'g'), ('eggs', 'pieces'), ('all-purpose flour', 'g'), 
('baking soda', 'g'), ('salt', 'g'), ('sour cream', 'g'), ('apricot brandy', 'ml'), 
('lemon zest', 'g'), ('peach schnapps', 'ml'), ('water', 'ml'), ('apricot preserves', 'g'), 
('almonds', 'g'), ('fresh peach', 'piece'), ('lemon juice', 'ml'), ('blueberries', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '900'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '225'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '6'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '375'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='baking soda' AND unit='g'), '1.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='sour cream' AND unit='g'), '240'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot brandy' AND unit='ml'), '180'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon zest' AND unit='g'), '12'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='peach schnapps' AND unit='ml'), '240'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '475'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot preserves' AND unit='g'), '325'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almonds' AND unit='g'), '50'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh peach' AND unit='piece'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '120'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='blueberries' AND unit='g'), '150');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '33', 

    'Spicy Air Fryer Pork Chops with Apricot Glaze', 

    '15 mins', 

    '15 mins', 

    '3 hrs', 

    '4', 

    'Combine water, salt, and sugar in a bowl and stir until dissolved. Add pork chops, cover, and refrigerate for 2 to 4 hours. Remove chops, discard brine, and pat dry. Combine chili powder, onion powder, salt, and white pepper. Coat chops with rub and let stand for 30 minutes. Meanwhile, combine apricot spread, hoisin sauce, ginger, garlic, chili-garlic sauce, and lime juice in a microwave-safe bowl. Microwave on high for 3 minutes, stirring halfway. Preheat air fryer to 400 degrees F (200 degrees C). Spray chops with cooking spray and air-fry in a single layer for 8 minutes, turning halfway. Brush with glaze and air-fry 2-3 minutes more until internal temperature reaches 145 degrees F (63 degrees C). Garnish with parsley.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/285573/spicy-air-fryer-pork-chops-with-apricot-glaze/', 

    '/Main Dishes/Pork/Pork Chop Recipes/', 

    'Total Fat 6g 7%, Saturated Fat 2g 9%, Cholesterol 41mg 14%, Sodium 3517mg 153%, Total Carbohydrate 40g 15%, Dietary Fiber 1g 4%, Total Sugars 27g, Protein 17g, Vitamin C 10mg 49%, Calcium 48mg 4%, Iron 1mg 6%, Potassium 309mg 7%', 

    'https://www.allrecipes.com/thmb/HlfwiiXjZb13qYNaI_MYNWoo5Q4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/9399833-7332c084d1c94b31ad3883d0a91edd83.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('water', 'ml'), ('salt', 'g'), ('white sugar', 'g'), ('bone-in pork chops', 'pc'), 
('chili powder', 'g'), ('onion powder', 'g'), ('ground white pepper', 'g'), 
('apricot preserves', 'g'), ('hoisin sauce', 'g'), ('grated fresh ginger', 'g'), 
('garlic cloves', 'pieces'), ('chili-garlic sauce', 'g'), ('lime juice', 'ml'), ('fresh parsley', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='water' AND unit='ml'), '946'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '36'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '25'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='bone-in pork chops' AND unit='pc'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chili powder' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion powder' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground white pepper' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot preserves' AND unit='g'), '150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='hoisin sauce' AND unit='g'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='grated fresh ginger' AND unit='g'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='garlic cloves' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chili-garlic sauce' AND unit='g'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lime juice' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh parsley' AND unit='g'), '2');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '34', 

    'Boozy Apricot Jam', 

    '30 mins', 

    '5 mins', 

    '8 hrs 35 mins', 

    '144', 

    'Inspect 9 half-pint jars for defects. Finely chop apricots (need 5 cups prepared). Transfer to a large saucepan, stir in pectin, and bring to a full rolling boil. Add sugar, return to a full boil, and boil for exactly 1 minute, stirring constantly. Skim foam, remove from heat, and stir in apricot brandy. Pack into hot jars leaving 1/4 inch headspace. Remove air bubbles and wipe rims. Process in a boiling water bath for 10 minutes. Let rest for 24 hours before checking seals and storing.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/264865/boozy-apricot-jam/', 

    '/Side Dish/Sauces and Condiments/Canning and Preserving Recipes/Jams and Jellies Recipes/', 

    'Sodium 0mg 0%, Total Carbohydrate 11g 4%, Dietary Fiber 0g 1%, Total Sugars 11g, Protein 0g, Vitamin C 1mg 6%, Calcium 2mg 0%, Potassium 29mg 1%', 

    'https://www.allrecipes.com/thmb/W4R-FlL7ze11Wg0h5Fsxf2Qvt6w=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5403766-cea33cc7c12f48558dc0c428501955b0.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('apricots', 'g'), 
('fruit pectin', 'g'), 
('white sugar', 'g'), 
('apricot brandy', 'ml');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricots' AND unit='g'), '1585'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fruit pectin' AND unit='g'), '50'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '1400'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricot brandy' AND unit='ml'), '80');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '35', 

    'Chef John\'s Nectarine Salsa', 

    '20 mins', 

    NULL, 

    '50 mins', 

    '6', 

    'Combine nectarines, bell pepper, onions, jalapeno pepper, and cilantro in a bowl. Stir in lime juice, olive oil, salt, and cayenne pepper. Cover bowl with plastic wrap. Refrigerate to let flavors develop, 30 minutes to 1 hour. Before serving, stir in black pepper. Add a pinch more salt, if needed.', 

    '4.8', 

    'https://www.allrecipes.com/recipe/244391/chef-johns-nectarine-salsa/', 

    '/Appetizers and Snacks/Dips and Spreads Recipes/Salsa Recipes/Peach Salsa Recipes/', 

    'Total Fat 2g 2%, Saturated Fat 0g 1%, Sodium 195mg 8%, Total Carbohydrate 5g 2%, Dietary Fiber 1g 3%, Total Sugars 3g, Protein 1g, Vitamin C 20mg 98%, Calcium 6mg 0%, Iron 0mg 1%, Potassium 98mg 2%', 

    'https://www.allrecipes.com/thmb/Vkhx-ClzT3oTl5FZ8WZjfFeYfVM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5482571-b522b102290d4e38a5bc7df9d9d11982.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('nectarines', 'pieces'), 
('red bell pepper', 'piece'), 
('onion', 'pieces'), 
('jalapeno pepper', 'piece'), 
('chopped fresh cilantro', 'g'), 
('lime juice', 'ml'), 
('olive oil', 'ml'), 
('salt', 'g'), 
('cayenne pepper', 'g'), 
('ground black pepper', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='nectarines' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='red bell pepper' AND unit='piece'), '0.75'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='onion' AND unit='pieces'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='jalapeno pepper' AND unit='piece'), '30'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='chopped fresh cilantro' AND unit='g'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lime juice' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='ml'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cayenne pepper' AND unit='g'), '0.5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='ground black pepper' AND unit='g'), '0.5');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '36', 

    'Easy Grilled Nectarines', 

    '5 mins', 

    '5 mins', 

    '10 mins', 

    '4', 

    'Brush each nectarine half with melted butter and sprinkle with brown sugar. Preheat the grill on medium heat. Place nectarines into an aluminum grill dish or directly onto the grill. Grill until lightly browned, turning occasionally, 3 to 5 minutes.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/263769/easy-grilled-nectarines/', 

    '/Desserts/', 

    'Total Fat 6g 8%, Saturated Fat 4g 19%, Cholesterol 15mg 5%, Sodium 5mg 0%, Total Carbohydrate 28g 10%, Dietary Fiber 2g 8%, Total Sugars 24g, Protein 2g, Vitamin C 7mg 37%, Calcium 21mg 2%, Iron 1mg 3%, Potassium 293mg 6%', 

    'https://www.allrecipes.com/thmb/sZ_mvu_RFHGck0ZrHgAnzB_MlaY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6897825-a50b9b70bde6401885bef6aab1a42ffe.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('nectarines', 'pieces'), 
('butter', 'g'), 
('brown sugar', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='nectarines' AND unit='pieces'), '4'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '28'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='brown sugar' AND unit='g'), '50');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '37', 

    'Nectarine Bars', 

    '20 mins', 

    '55 mins', 

    '1 hrs 45 mins', 

    '12', 

    'Preheat oven to 350 degrees F (175 degrees C). Combine flour and 1/2 cup sugar in a 9x13-inch pan; cut in butter until crumbly. Press into an even layer. Bake until slightly browned, about 25 minutes. Puree 1/3 of the nectarine slices in a blender; stir in cornstarch. Beat eggs until light; gradually beat in 1 cup sugar. Stir in nectarine mixture and pour over hot crust. Bake until almost set, about 30 minutes. Let cool completely before cutting. Top with remaining nectarine slices.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/258417/nectarine-bars/', 

    '/Desserts/Cookies/Bar Cookie Recipes/', 

    'Total Fat 9g 11%, Saturated Fat 5g 26%, Cholesterol 48mg 16%, Sodium 65mg 3%, Total Carbohydrate 45g 16%, Dietary Fiber 1g 4%, Total Sugars 28g, Protein 4g, Vitamin C 2mg 9%, Calcium 12mg 1%, Iron 1mg 7%, Potassium 103mg 2%', 

    'https://www.allrecipes.com/thmb/ExSAQ107x7hgdgeh-t--PToVtiA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/8421032-51fb0ba1f37a46d7956d46594bad26f9.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('all-purpose flour', 'g'), 
('white sugar', 'g'), 
('butter', 'g'), 
('nectarines', 'pieces'), 
('cornstarch', 'g'), 
('eggs', 'pieces');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '250'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '300'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '115'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='nectarines' AND unit='pieces'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='cornstarch' AND unit='g'), '8'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '2');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '38', 

    'Fresh Nectarine Cake with Blackberries', 

    '20 mins', 

    '45 mins', 

    '1 hrs 10 mins', 

    '8', 

    'Preheat the oven to 350 degrees F (175 degrees C). Grease a 9-inch springform pan. Beat butter in a large bowl until creamy. Add sugar and salt gradually and mix well. Add eggs one at a time, beating well after each. Combine flour and baking powder, sift, and quickly beat into the batter on low speed. Thin with milk if needed. Pour batter into pan. Arrange nectarines and blackberries on top in a decorative pattern. Bake until a toothpick comes out clean, about 45 minutes. Dust with confectioners\' sugar and cool on a wire rack for 5 minutes. Invert carefully onto a serving plate and let cool completely.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/263853/fresh-nectarine-cake-with-blackberries/', 

    '/Desserts/Cakes/', 

    'Total Fat 13g 17%, Saturated Fat 8g 39%, Cholesterol 72mg 24%, Sodium 114mg 5%, Total Carbohydrate 39g 14%, Dietary Fiber 3g 9%, Total Sugars 19g, Protein 5g, Vitamin C 7mg 36%, Calcium 67mg 5%, Iron 2mg 9%, Potassium 184mg 4%', 

    'https://www.allrecipes.com/thmb/_vXcgp6tLPtA9z-nwgJcU979ouI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/5317700-9e40560acd12435e8f7077594d215815.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('butter', 'g'), 
('eggs', 'pieces'), 
('white sugar', 'g'), 
('salt', 'g'), 
('all-purpose flour', 'g'), 
('baking powder', 'g'), 
('milk', 'ml'), 
('nectarines', 'pieces'), 
('blackberries', 'g'), 
('confectioners\' sugar', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '113'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='eggs' AND unit='pieces'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '100'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='all-purpose flour' AND unit='g'), '190'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='baking powder' AND unit='g'), '5'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='milk' AND unit='ml'), '15'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='nectarines' AND unit='pieces'), '3'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='blackberries' AND unit='g'), '170'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='confectioners\' sugar' AND unit='g'), '8');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '39', 

    'Coconut Oil Popcorn', 

    '5 mins', 

    '5 mins', 

    '10 mins', 

    '2', 

    'Place popcorn and oil in a 3-quart pot over medium heat and cover with a lid. Shake the pot constantly as popcorn pops. When popping slows to a few seconds in-between pops (about 3 to 5 minutes), remove from heat and pour into a large bowl. Season with sea salt.', 

    '4.9', 

    'https://www.allrecipes.com/recipe/241449/coconut-oil-popcorn/', 

    '/Appetizers and Snacks/Snacks/Popcorn Recipes/', 

    'Total Fat 15g 19%, Saturated Fat 13g 63%, Sodium 161mg 7%, Total Carbohydrate 19g 7%, Dietary Fiber 4g 13%, Total Sugars 0g, Protein 3g, Calcium 3mg 0%, Iron 3mg 14%, Potassium 74mg 2%', 

    'https://www.allrecipes.com/thmb/SJSbFVjT_x3KEA29mmX_VHd5_uQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/3598265-58680f01b1c541af8721b76c7b40b1cf.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('coconut oil', 'ml'), 
('unpopped popcorn kernels', 'g'), 
('salt', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='coconut oil' AND unit='ml'), '28'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='unpopped popcorn kernels' AND unit='g'), '56'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='salt' AND unit='g'), '1');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '40', 

    'Grilled Honey-Nectarine Ricotta Toast', 

    '10 mins', 

    '10 mins', 

    '25 mins', 

    '2', 

    'Preheat an outdoor grill for medium-high heat and lightly oil grate. Drizzle 1 teaspoon olive oil onto a small plate. Place nectarine wedges on the plate and cover all sides with oil. Brush both sides of bread with 2 tablespoons olive oil. Place nectarines onto the hot grate and grill 1 to 2 minutes per side; remove to a plate. When nectarine wedges have cooled slightly, cut each wedge in 1/2 lengthwise so you now have 16 slices. Place bread slices onto the hot grate and cook until toasted, about 1 minute per side. Spread ricotta cheese onto each slice of toast. Arrange 8 nectarine slices onto each toast and top with almonds. Sprinkle with mint and drizzle with honey. Cut each toast in half and serve.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/275175/grilled-honey-nectarine-ricotta-toast/', 

    '/Main Dishes/Sandwich Recipes/Cheese/', 

    'Total Fat 21g 27%, Saturated Fat 4g 20%, Cholesterol 9mg 3%, Sodium 200mg 9%, Total Carbohydrate 32g 12%, Dietary Fiber 3g 9%, Total Sugars 14g, Protein 7g, Vitamin C 5mg 25%, Calcium 114mg 9%, Iron 1mg 7%, Potassium 271mg 6%', 

    'https://www.allrecipes.com/thmb/vK_jBo_mfLADTskNAsFtJNQqk04=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/6906566-dbdbf45fb41a4fe4b6cb0da3f7207a89.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('olive oil', 'ml'), 
('nectarines', 'pieces'), 
('crusty bread', 'pc'), 
('whole-milk ricotta cheese', 'g'), 
('almonds', 'g'), 
('fresh mint', 'g'), 
('honey', 'mL');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='olive oil' AND unit='ml'), '35'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='nectarines' AND unit='pieces'), '1'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='crusty bread' AND unit='pc'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='whole-milk ricotta cheese' AND unit='g'), '60'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='almonds' AND unit='g'), '10'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fresh mint' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='honey' AND unit='mL'), '14');

INSERT INTO recipes (source_index, recipe_name, prep_time, cook_time, total_time, servings, directions, rating, source_url, cuisine_path, nutrition, img_src)

VALUES (

    '41', 

    'Homemade Apricot Jam', 

    '10 mins', 

    '10 mins', 

    '1 day 20 mins', 

    '56', 

    'Stir apricots, lemon juice, and sugar together in a large pot over medium heat; add butter to reduce foaming. Bring to a rolling boil, stirring constantly. Quickly stir in pectin; return to a full boil for 1 minute. Remove from heat and skim foam. Pack into hot, sterilized jars leaving 1/4 inch headspace. Remove air bubbles and wipe rims. Top with lids and screw on rings. Process in a boiling water bath for 5 minutes. Let rest on a wood or cloth surface for 24 hours. Check seals and store in a cool, dark area.', 

    '5.0', 

    'https://www.allrecipes.com/recipe/223063/homemade-apricot-jam/', 

    '/Side Dish/Sauces and Condiments/Canning and Preserving Recipes/Jams and Jellies Recipes/', 

    'Total Fat 0g 0%, Cholesterol 0mg 0%, Sodium 1mg 0%, Total Carbohydrate 23g 8%, Dietary Fiber 0g 1%, Total Sugars 22g, Protein 0g, Vitamin C 3mg 14%, Calcium 3mg 0%, Iron 0mg 1%, Potassium 55mg 1%', 

    'https://www.allrecipes.com/thmb/dDGLeRtrIG6cUN8RV1GkZSSRjpI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/1215260-f892c32097944ba799a15b91620827a3.jpg'

);

SET @last_id = LAST_INSERT_ID();

INSERT IGNORE INTO ingredients (name, unit) VALUES 
('apricots', 'g'), 
('lemon juice', 'ml'), 
('white sugar', 'g'), 
('butter', 'g'), 
('fruit pectin', 'g');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES 
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='apricots' AND unit='g'), '1135'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='lemon juice' AND unit='ml'), '80'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='white sugar' AND unit='g'), '1150'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='butter' AND unit='g'), '2'),
(@last_id, (SELECT ingredient_id FROM ingredients WHERE name='fruit pectin' AND unit='g'), '50');

SELECT COUNT(*)  FROM ingredients;
SELECT * FROM ingredients;


INSERT INTO users (user_id, firstname, lastname, username, password_hash, email) VALUES 
(1, 'Isabella', 'Rossi', 'chef_isabella', 'pasta123', 'isabella@thecookbook.com'),
(2, 'Dan', 'Smith', 'baker_dan', 'bread456', 'dan@thecookbook.com'),
(3, 'Gary', 'Miller', 'grillmaster99', 'steak789', 'grillmaster@thecookbook.com'),
(4, 'Admin', 'User', 'admin', 'admin123', 'admin@thecookbook.com');

SELECT * FROM users;
SELECT * 
FROM saved_recipes
ORDER BY saved_at DESC;