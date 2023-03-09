-- total calories eaten by user number 10 on 03/08/23
SELECT SUM(calories)
FROM meals NATURAL JOIN meal_log 
WHERE user_id = 10 AND meal_date = "2023-03-08";

-- Display how many of each rating level recipes for Mexican cuisine received 
SELECT rating, count(*)
FROM ratings NATURAL JOIN recipes
WHERE cuisine = 'Mexican'
GROUP BY rating ORDER BY rating;

-- list of recipes and their rating as rated by the user named Chad
SELECT recipe_name, rating
FROM recipes NATURAL JOIN ratings 
WHERE user_id = (SELECT user_id FROM users WHERE first_name = 'Chad');


-- Update the average rating and number of ratings for the recipe
-- Giving recipe with recipe_id = 139 a 5 star rating 
UPDATE recipes SET avg_rating = 
    (avg_rating * num_ratings + 5) / (num_ratings + 1),
    num_ratings = num_ratings + 1
WHERE recipes.recipe_id = 139;

