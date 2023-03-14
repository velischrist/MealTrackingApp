-- CS 121 Winter 2023 Final Project
-- Setup file for meal tracking app database

-- Enable general log via global query
SET global general_log = 1;

-- DROP TABLE commands:
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS meals;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS users_info;

-- This table holds information for authenticating users based on
-- a password.  Passwords are not stored plaintext so that they
-- cannot be used by people that shouldn't have them.
-- We have extended that table to include an is_admin role attribute for
-- admin users who have additional permissions (i.e., website managers). 
CREATE TABLE users_info (
    -- Usernames are up to 20 characters.
    username VARCHAR(20) PRIMARY KEY,

    -- Salt will be 8 characters all the time, so we can make this 8.
    salt CHAR(8) NOT NULL,

    -- We use SHA-2 with 256-bit hashes.  MySQL returns the hash
    -- value as a hexadecimal string, which means that each byte is
    -- represented as 2 characters.  Thus, 256 / 8 * 2 = 64.
    -- We can use BINARY or CHAR here; BINARY simply has a different
    -- definition for comparison/sorting than CHAR.
    password_hash BINARY(64) NOT NULL,

    -- Boolean for whether the user is an admin or not
    is_admin BOOLEAN NOT NULL
);

-- This table holds information on user creation and deletion
-- Whenever user_info table is changed upon insertion of deletion, 
-- new entry is added to this table
-- Logs the username, time of change, and change type
CREATE TABLE users_change_log (
    -- Log id
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Username of user being logged
    username VARCHAR(20) NOT NULL,
    
    -- Time of log
    log_time DATETIME NOT NULL,
    
    -- Type of change to users_info table
    -- 'Created' for user created, 'Deleted' for user deleted
    change_type CHAR(7) NOT NULL,
    CHECK (change_type IN ('Created','Deleted'))
);

-- This table stores information about goals users have set. 
-- A user can set goals of daily consumption for calories, protein, fat, 
-- and/or sugar. 
CREATE TABLE goals (
    username VARCHAR(20),

    -- Goal category: a goal represents a target daily consumption for a 
    -- specified macro
    goal_type ENUM('calories', 'protein', 'fat', 'sugar'), 

    -- target daily consumption:
    --     kcal/day for calories, 
    --     grams/day for the rest
    target INT NOT NULL, 

    -- Each user can have one goal for each category
    PRIMARY KEY (username, goal_type),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- This table holds information about the meals the users eat. Users
-- can log their meals to keep track of their daily consumption. 
-- Each meal is identified by a meal_id
-- A user needs to specify a name, date, type of meal, and macros
CREATE TABLE meals (
    meal_id INT AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL,
    meal_name VARCHAR(200) NOT NULL, 

    -- This holds the date the meal was consumed. 
    -- We want to allow the user to add a meal about yesterday's day in case
    -- the user forgot. To do this, the user specifies yesterday's day. 
    meal_date DATE NOT NULL, 

    -- For now we only support specific meal types. In the future, we might
    -- consider allowing the user to define new meal categories, but for now
    -- we believe this is more effective. 
    meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,

    calories INT NOT NULL, -- total calories in kcal
    protein INT, -- measured in grams
    fat INT, -- measured in grams
    sugar INT, -- measured in grams
    PRIMARY KEY (meal_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- This table holds information about recipes, such as name, instructions, 
-- cook time. 
-- Users and administators can upload recipes, which other people can view and
-- rate
CREATE TABLE recipes (
    recipe_id INT AUTO_INCREMENT, -- Uniqie identifies for recipes
    recipe_name VARCHAR(200) NOT NULL, 
    cuisine VARCHAR(100), -- e.g., Mexican, Indian
    course VARCHAR(100), -- e.g., Lunch, Breakfast, Dinner
    prep_time INT, -- prep time in minutes
    cook_time INT, -- cook time in minutes
    ingredients TEXT NOT NULL, -- List of ingredients

    -- Detailed instructions for how to prepare and cook the meal. This 
    -- attribute has a data type TEXT to allow users to describe their recipes
    -- in detail
    instructions TEXT NOT NULL,
    username VARCHAR(20), -- User who created the recipe
    PRIMARY KEY (recipe_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- This table holds information about the recipe ratings. 
-- Ratings are an integer from 1-5. 
-- Users can rate each recipe only once
CREATE TABLE ratings (
    username VARCHAR(20), -- User who rated the recipe
    recipe_id INT, -- The unique ID for the recipe

    -- Rating is an INT between 1 and 5.
    -- We have a CHECK constraint to implement this
    rating INT NOT NULL,
    CHECK (rating >= 1 AND rating <= 5),

    -- A user can rate each recipe once
    PRIMARY KEY (username, recipe_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- INDEXES:
-- Index to make looking up meal dates faster
-- This comes up handy when a user wants to find the meals they ate in a 
-- given date range (e.g., past week, 3 months ago). 
CREATE INDEX idx_meal_date ON meals(meal_date);
