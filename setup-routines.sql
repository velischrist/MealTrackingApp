-- CS 121 Winter 2023 Final Project

-- Routines for Meal Tracking app
-- Includes: functions total_caloric_intake, get_average_ratings, 
--           procedure update_avg_rating and
--           trigger ____

-- FUNCTIONS
-- Computes the total caloric intake of a single user from begin date to end date, inclusive
DELIMITER !
CREATE FUNCTION total_caloric_intake (
     user_id INT -- id of user calling function
     begin_date DATE -- beginning date of calorie intake count
     end_date DATE -- end date of calorie intake count
) RETURNS INT
BEGIN
     DECLARE calorie_count;

     SELECT COUNT(calories) INTO calorie_count
     FROM meal_log
     WHERE meal_log.user_id = user_id AND meal_log.date >= begin_date AND meal_log.date <= end_date;

     RETURN calorie_count;
END!
DELIMITER ;

-- Computes average rating for a recipe
DELIMITER !
CREATE FUNCTION get_average_rating (
     recipe_id     INT
) RETURNS NUMERIC(3,2)
BEGIN
     DECLARE avg_rating;

     SELECT AVG(rating) INTO avg_rating
     FROM ratings
     WHERE ratings.recipe_id = recipe_id;

     RETURN avg_rating;
END!
DELIMITER ;

-- PROCEDURES
-- Updates average rating whenever a new rating is added to a recipe
-- Also updates the number of ratings
DELIMITER !
CREATE PROCEDURE update_avg_rating (
     IN recipe_id INT, IN rating INT
)
BEGIN
     -- Update the average rating and number of ratings for the recipe
     UPDATE recipes SET avg_rating = (avg_rating * num_ratings + rating) / (num_ratings + 1),
                        num_ratings = num_ratings + 1
     WHERE recipes.recipe_id = recipe_id;
END!
DELIMITER ;



-- TRIGGERS
