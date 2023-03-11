-- CS 121 Winter 2023 Final Project
-- SQL queries for the meal tracking app database

-- Displays the total calories consumed on each date.
-- (INCLUDED IN THE RELATIONAL ALGEBRA)
SELECT meal_date, sum(calories) as total_calories
FROM meals JOIN goals ON meals.username = goals.username
WHERE meals.username = 'lacey_valenta' -- replace with the desired username
GROUP BY meal_date;

-- Displays the average rating for each cuisine.
-- (INCLUDED IN THE RELATIONAL ALGEBRA)
SELECT cuisine, AVG(rating) AS average_rating
FROM recipes JOIN ratings ON ratings.recipe_id = recipes.recipe_id
GROUP BY cuisine;

-- Displays the names of recipes and their ratings as 
-- rated by a particular user.
-- (INCLUDED IN THE RELATIONAL ALGEBRA)
SELECT recipe_name, rating
FROM recipes JOIN ratings ON ratings.recipe_id = recipes.recipe_id
WHERE ratings.username = 'lacey_valenta';

-- Displays the number of each rating received by all 
-- recipes for a particular cuisine. Ordered in 
-- descending order by rating.
SELECT rating, COUNT(*) AS recipe_count
FROM ratings JOIN recipes ON ratings.recipe_id = recipes.recipe_id
WHERE cuisine = 'Mexican'
GROUP BY rating 
ORDER BY rating DESC;
SELECT username FROM users_info;

-- Displays all meals consumed by the particular 
-- user on the given date. 
SELECT meal_type, meal_name 
FROM meals 
WHERE username = 'lacey_valenta' AND meal_date = '2023-03-11';

-- Displays all dates for which the particular 
-- user logged a meal. 
SELECT meal_date 
FROM meals 
WHERE username='lacey_valenta';

-- Removes a particular user from the users_info table.
DELETE FROM users_info WHERE username = 'lacey_valenta';

-- Removes a particular recipe from the recipes table.
DELETE FROM recipes WHERE recipe_id = 1;

-- Removes a particular rating, identified by a specific 
-- recipe_id of the recipe and the username of the reviewer. 
DELETE FROM ratings WHERE recipe_id = 1 AND username ='lacey_valenta';

-- Calls the add_goal procedure which adds a new nutritional 
-- goal for a particular user. 
CALL add_goal('lacey_valenta', protein, 60);

-- Adds a new meal to the meal log for a particular user. 
INSERT INTO meals(meal_date, meal_type, username, 
    meal_name, calories, protein, fat, sugar) 
VALUES ('2023-03-11', 'breakfast', 'lacey_valenta', 'pancakes', 
    600, 8, 3, 5);

-- Adds a new recipe to the recipes table. 
INSERT INTO recipes(username, recipe_name, cuisine, course, ingredients,
    instructions, prep_time, cook_time) 
    VALUES ('lacey_valenta', 'tacos', 'mexican', 'dinner', 'test_ingredients',
    'test_instructions', 30, 60);

-- Calls the add_rating procedure which allows 
-- a particular user to add a new rating for a recipe.
CALL add_rating('lacey_valenta', 1, 5);

-- Displays all recipes and their average ratings from the 
-- recipe_ratings_view. 
SELECT recipe_name, average_rating FROM recipe_ratings_view;

-- Calls the authenticate function which authenticates
-- a given username and password combination and also 
-- checks for admin privileges. 
SELECT authenticate('lacey_valenta', 'YDy+u-e~');

