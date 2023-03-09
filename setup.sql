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
    user_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE goals (
    user_id INT,
    goal_type ENUM('calories', 'protein', 'fat', 'sugar'), 
    target INT NOT NULL, -- in units per day
    PRIMARY KEY (user_id, goal_type),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE meals (
    meal_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    meal_name VARCHAR(200) NOT NULL,
    calories INT NOT NULL,
    protein INT,
    fat INT,
    sugar INT,
    PRIMARY KEY (meal_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE meal_log (
    user_id INT, 
    meal_id INT, 
    meal_date DATE, 
    -- meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
    meal_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, meal_id, meal_date),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
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
    num_ratings INT DEFAULT 0,
    avg_rating NUMERIC(3, 2),
    user_id INT, -- User who created the recipe
    PRIMARY KEY (recipe_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE ratings (
    user_id INT NOT NULL, -- User who rated the recipe
    recipe_id INT NOT NULL,
    rating INT NOT NULL,
    CHECK (rating >= 1 AND rating <= 5),
    PRIMARY KEY (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- INDEXES:
-- Index to make looking up recipe average ratings faster
CREATE INDEX idx_avg_rating ON recipes(avg_rating);
-- Index to make looking up user ratings faster
CREATE INDEX idx_rating ON ratings(rating);
