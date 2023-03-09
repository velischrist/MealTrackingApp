-- CS 121 Winter 2023 Final Project
-- SQL queries for the meal tracking app database

-- Compute the total caloric intake of user 10 on date 03/07/23
SELECT SUM(calories)
FROM meals NATURAL JOIN meal_log 
WHERE user_id = 10 AND meal_date = "2023-03-07";

-- Display the number of each rating that recipes for Mexican cuisine received
-- ordered by the rating
SELECT rating, COUNT(*)
FROM ratings JOIN recipes ON ratings.recipe_id = recipes.recipe_id
WHERE cuisine = 'Mexican'
GROUP BY rating 
ORDER BY rating;

-- Select a list of recipes and their rating as rated by the user named Chad
SELECT recipe_name, rating
FROM recipes JOIN ratings ON ratings.recipe_id = recipes.recipe_id
WHERE ratings.user_id = (SELECT user_id FROM users WHERE first_name = 'Chad');

-- Update the average rating and number of ratings for the recipe
-- Giving recipe with recipe_id = 139 a 5 star rating 
UPDATE recipes SET avg_rating = 
    (avg_rating * num_ratings + 5) / (num_ratings + 1),
    num_ratings = num_ratings + 1
WHERE recipes.recipe_id = 139;

