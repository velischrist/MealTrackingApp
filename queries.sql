-- CS 121 Winter 2023 Final Project
-- SQL queries for the meal tracking app database

-- Compute the total caloric intake of a user with the username 'lacey_valenta'
-- on date 03/07/23
SELECT SUM(calories)
FROM meals NATURAL JOIN meal_log 
WHERE username = 'lacey_valenta' AND meal_date = '2023-03-07';

-- Display the number of each rating that recipes for Mexican cuisine received
-- ordered by the rating
SELECT rating, COUNT(*)
FROM ratings JOIN recipes ON ratings.recipe_id = recipes.recipe_id
WHERE cuisine = 'Mexican'
GROUP BY rating 
ORDER BY rating;

-- Select a list of recipe names and their rating as rated by the user with
-- username 'lacey_valenta'
-- This query can be used for whichever user is logged into the app
SELECT recipe_name, rating
FROM recipes JOIN ratings ON ratings.recipe_id = recipes.recipe_id
WHERE ratings.username = 'lacey_valenta';

-- Update the average rating and number of ratings for the recipe
-- Giving recipe with recipe_id = 139 a 5 star rating 
UPDATE recipes SET avg_rating = 
    (avg_rating * num_ratings + 5) / (num_ratings + 1),
    num_ratings = num_ratings + 1
WHERE recipes.recipe_id = 139;

