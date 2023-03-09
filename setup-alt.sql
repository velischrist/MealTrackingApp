-- CS 121 Winter 2023 Final Project
-- Setup file for meal tracking app database

-- DROP TABLE commands:
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS meal_log;
DROP TABLE IF EXISTS meals;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS users;

-- CREATE TABLE commands:
CREATE TABLE users (
    username VARCHAR(20),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    PRIMARY KEY (username)
);

CREATE TABLE goals (
    username VARCHAR(20),
    goal_type ENUM('calories', 'protein', 'fat', 'sugar'), 
    target INT NOT NULL, -- in units per day
    PRIMARY KEY (username, goal_type),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE meals (
    meal_id INT AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL,
    meal_name VARCHAR(200) NOT NULL,
    calories INT NOT NULL,
    protein INT,
    fat INT,
    sugar INT,
    PRIMARY KEY (meal_id),
    FOREIGN KEY (username) REFERENCES users(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE meal_log (
    username VARCHAR(20), 
    meal_id INT, 
    meal_date DATE, 
    -- meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
    meal_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, meal_id, meal_date),
    FOREIGN KEY (username) REFERENCES users(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (meal_id) REFERENCES meals(meal_id)
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
    FOREIGN KEY (username) REFERENCES users(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE ratings (
    username VARCHAR(20) NOT NULL, -- User who rated the recipe
    recipe_id INT NOT NULL,
    rating INT NOT NULL,
    CHECK (rating >= 1 AND rating <= 5),
    PRIMARY KEY (username, recipe_id),
    FOREIGN KEY (username) REFERENCES users(username)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- INDEXES:
-- Index to make looking up user ratings faster
CREATE INDEX idx_rating ON ratings(rating);