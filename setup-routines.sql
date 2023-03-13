-- CS 121 Winter 2023 Final Project

-- Routines for Meal Tracking app
-- Includes: functions: total_caloric_intake, get_average_ratings, 
--           procedure: update_avg_rating and
--           trigger:  ____

-- VIEWS
-- Create a materialized view of recipes with their average rating
DROP VIEW IF EXISTS recipe_ratings_view;

CREATE VIEW recipe_ratings_view AS
SELECT r.recipe_id AS recipe_id, r.recipe_name AS recipe_name, IFNULL(AVG(ra.rating), 0) AS average_rating
FROM recipes AS r
LEFT JOIN ratings AS ra ON r.recipe_id = ra.recipe_id
GROUP BY r.recipe_id
ORDER BY r.recipe_id;

-- FUNCTIONS
-- Computes the total caloric intake of a single user 
-- from begin date to end date, inclusive
DROP FUNCTION IF EXISTS total_caloric_intake;
DELIMITER !
CREATE FUNCTION total_caloric_intake (
     curr_username VARCHAR(20), -- username of user calling function
     begin_date DATE, -- beginning date of calorie intake count
     end_date DATE -- end date of calorie intake count
) RETURNS INT
BEGIN
     DECLARE total_calories INT;

     SELECT SUM(calories) INTO total_calories
     FROM meals
     WHERE username = curr_username AND 
           meal_date BETWEEN begin_date AND end_date;

     RETURN total_calories;
END!
DELIMITER ;

-- PROCEDURES
-- Add a new goal of a user
-- Either add an entirely new goal or update an existing goal to reflect the 
-- change
DROP PROCEDURE IF EXISTS add_goal;
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

-- Add a new ratings
-- If the rating exists, udpate the rating
-- Otherwise, create a new row in the table
DROP PROCEDURE IF EXISTS add_rating;
DELIMITER !
CREATE PROCEDURE add_rating (
     IN curr_username VARCHAR(20), 
     IN curr_recipe_id INT, 
     IN new_rating INT
)
BEGIN
     DECLARE v_rowcount INT DEFAULT 0;

     UPDATE ratings
     SET rating = new_rating
     WHERE username = curr_username AND recipe_id = curr_recipe_id;

     SET v_rowcount = ROW_COUNT();

     IF v_rowcount = 0 THEN
          INSERT INTO ratings (username, recipe_id, rating)
          VALUES (curr_username, curr_recipe_id, new_rating);
     END IF;
END !
DELIMITER ;


-- TRIGGERS

-- Logs user creation from users_info into users_change_log table
CREATE TRIGGER tr_insert_user
AFTER INSERT
ON users_info FOR EACH ROW
DELIMITER !
BEGIN
     INSERT INTO users_change_log (username, log_time, change_type)
     VALUES (NEW.username, NOW(), 'Created');
END!
DELIMITER ;

-- Logs user deletion from users_info into users_change_log table
CREATE TRIGGER tr_delete_user
BEFORE DELETE
ON users_info FOR EACH ROW
DELIMITER !
BEGIN
     INSERT INTO users_change_log (username, log_time, change_type)
     VALUES (OLD.username, NOW(), 'Deleted')
END!
DELIMITER ;
