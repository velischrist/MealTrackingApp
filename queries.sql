-- CS 121 Winter 2023 Final Project
-- SQL queries for the meal tracking app database

-- View all the dates for which the user did not meet their daily calories goal
SELECT meal_date
FROM meals JOIN goals ON meals.username = goals.username
WHERE meals.username = 'lacey_valenta' -- replace with the desired username
AND SUM(calories) > goals.target
GROUP BY meal_date;

-- Display the number of each rating that recipes for Mexican cuisine received
-- ordered by the rating
SELECT rating, COUNT(*)
FROM ratings JOIN recipes ON ratings.recipe_id = recipes.recipe_id
WHERE cuisine = 'Mexican'
GROUP BY rating 
ORDER BY rating;

-- Display the average rating for each cuisine 
SELECT cuisine, AVG(rating)
FROM recipes JOIN ratins ON ratings.recipe_id = recipes.recipe_id
GROUP BY cuisine;

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

