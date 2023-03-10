-- CS 121 Winter 2023 Final Project
-- File to load the data for our dataset
-- The sources for the data are specified in the README file
-- We also generated our own data using the scripts in generate_data.ipynb

SET GLOBAL local_infile = 1; 

-- Create a temporary table to hold the users data
CREATE TABLE temp (
    username VARCHAR(20),
    pswd VARCHAR(20) NOT NULL,
    PRIMARY KEY(username)
);

-- Load the CSV file data into the temporary table
LOAD DATA LOCAL INFILE 'data/users.csv' INTO TABLE temp
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Loop through the rows of the temporary table, 
-- calling the procedure sp_add_user for each user
DECLARE @username VARCHAR(20);
DECLARE @pswd VARCHAR(20);
DECLARE cursor_name CURSOR FOR
SELECT username, pswd FROM temp;
OPEN cursor_name;
FETCH NEXT FROM cursor_name INTO @username, @pswd;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_add_user(@username, @pswd);
    FETCH NEXT FROM cursor_name INTO @username, @pswd;
END;
CLOSE cursor_name;
DEALLOCATE cursor_name;

-- Drop the temporary table
DROP TABLE temp;


LOAD DATA LOCAL INFILE 'data/users.csv' INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/food_recipes.csv' INTO TABLE recipes
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(recipe_id, recipe_name, cuisine, course, @prep_time, @cook_time, ingredients, instructions)
SET prep_time = NULLIF(@prep_time, ''),
    cook_time = NULLIF(@cook_time, '');

LOAD DATA LOCAL INFILE 'data/ratings.csv' INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Update the average rating now that we have data about the ratings
UPDATE recipes SET avg_rating = (
    SELECT AVG(rating) FROM ratings
    WHERE ratings.recipe_id = recipes.recipe_id
);

LOAD DATA LOCAL INFILE 'data/goals.csv' INTO TABLE goals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/meals.csv' INTO TABLE meals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/meal_log.csv' INTO TABLE meal_log
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

