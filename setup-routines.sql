-- CS 121 Winter 2023 Final Project

-- Routines for Meal Tracking app
-- Includes: functions total_caloric_intake, get_average_ratings, 
--           procedure update_avg_rating and
--           trigger ____

-- VIEWS
-- Create a view of recipes with their average rating

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
-- Add a new meal
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

-- Add a new goal of a user
-- Either add an entirely new goal or update an existing goal to reflect the 
-- change
DELIMITER !
CREATE PROCEDURE add_goal (
     IN old_username VARCHAR(20), 
     IN old_goal_type ENUM('calories', 'protein', 'fat', 'sugar'), 
     IN old_target INT
)
BEGIN
     DECLARE v_rowcount INT DEFAULT 0;

     UPDATE goals
     SET target = old_target
     WHERE username = old_username AND goal_type = old_goal_type;

     SET v_rowcount = ROW_COUNT();

     IF v_rowcount = 0 THEN
          INSERT INTO goals (username, goal_type, target)
          VALUES (old_username, old_goal_type, old_target);
     END IF;
END !
DELIMITER ;


-- TRIGGERS
-- Update the average rating of a recipe in the view when a there's a new rating
-- Uses the compute average rating function above