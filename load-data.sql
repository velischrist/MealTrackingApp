-- CS 121 Winter 2023 Final Project
-- File to load the data for our dataset

SET GLOBAL local_infile = 1; 


LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/users.csv' INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/food_recipes.csv' INTO TABLE recipes
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(recipe_id, recipe_name, cuisine, course, @prep_time, @cook_time, ingredients, instructions)
SET prep_time = NULLIF(@prep_time, ''),
    cook_time = NULLIF(@cook_time, '');

LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/ratings.csv' INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Update the average rating now that we have data about the ratings
UPDATE recipes SET avg_rating = (
    SELECT AVG(rating) FROM ratings
    WHERE ratings.recipe_id = recipes.recipe_id
);

LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/goals.csv' INTO TABLE goals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/meals.csv' INTO TABLE meals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/meal_log.csv' INTO TABLE meal_log
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

