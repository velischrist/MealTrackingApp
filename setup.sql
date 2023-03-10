-- CS 121 Winter 2023 Final Project
-- Setup file for meal tracking app database

-- DROP TABLE commands:
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS meals;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS users_info;

-- Provided (you may modify if you choose)
-- This table holds information for authenticating users based on
-- a password.  Passwords are not stored plaintext so that they
-- cannot be used by people that shouldn't have them.
-- You may extend that table to include an is_admin or role attribute if you 
-- have admin or other roles for users in your application 
-- (e.g. store managers, data managers, etc.)
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

CREATE TABLE goals (
    username VARCHAR(20),
    goal_type ENUM('calories', 'protein', 'fat', 'sugar'), 
    target INT NOT NULL, -- in units per day
    PRIMARY KEY (username, goal_type),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE meals (
    meal_id INT AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL,
    meal_name VARCHAR(200) NOT NULL,
    meal_date DATE NOT NULL, 
    meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
    calories INT NOT NULL,
    protein INT,
    fat INT,
    sugar INT,
    PRIMARY KEY (meal_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


CREATE TABLE recipes (
    recipe_id INT AUTO_INCREMENT,
    recipe_name VARCHAR(200) NOT NULL,
    cuisine VARCHAR(100),
    course VARCHAR(100),
    prep_time INT, -- prep time in minutes
    cook_time INT, -- cook time in minutes
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    username VARCHAR(20), -- User who created the recipe
    PRIMARY KEY (recipe_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE ratings (
    username VARCHAR(20), -- User who rated the recipe
    recipe_id INT,
    rating INT NOT NULL,
    CHECK (rating >= 1 AND rating <= 5),
    PRIMARY KEY (username, recipe_id),
    FOREIGN KEY (username) REFERENCES users_info(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- INDEXES:
-- Index to make looking up user ratings faster
CREATE INDEX idx_rating ON ratings(rating);