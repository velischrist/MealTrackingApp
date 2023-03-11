-- CS 121 Winter 2023 Final Project
-- File to load the data in our database

-- The source for the recipe data is specified in the README file
-- The source for the users data was a web app that automatically generates
-- fake users (link in README)
-- For the rest of the tables, we generated our own data using the scripts 
-- in generate_data.ipynb
-- CSV files from which we are loading the data are in the folder 'data'

SET GLOBAL local_infile = 1; 

-- Add users using the procedure from password management
CALL sp_add_user('lacey_valenta', 'YDy+u-e~');
CALL sp_add_user('wendell_cervantez','eVY3Y$A.y{e6');
CALL sp_add_user('tabansi_cagle','Udu)AMuXYj');
CALL sp_add_user('maureen_yeates','yza9UZUTUg');
CALL sp_add_user('marvelle_massa','y&y%EqurajU');
CALL sp_add_user('becse_massa','UrAqE7U^y_y/');
CALL sp_add_user('esteban_hoag','YNEBA{A`uX');
CALL sp_add_user('chad_nalls','yVUpU6Ate2a@');
CALL sp_add_user('yuri_hon','eGaNY*ejU3y');
CALL sp_add_user('dade_gastelum','E}u-e7y&uhE');
CALL sp_add_user('wickham_driggers','Y3EBa5y');
CALL sp_add_user('nadav_mcmullin','amau6Y~');
CALL sp_add_user('lann_kugler','u#Y#aGa3');
CALL sp_add_user('severin_hintz','AZy/u[E]');
CALL sp_add_user('ulima_fernandes','uve*E`AXEbA~');
CALL sp_add_user('parry_izquierdo','Y!ANaLy@e#aL');
CALL sp_add_user('frank_hon','u=UXe&A*');
CALL sp_add_user('kesia_libby','AtY9ePaP');
CALL sp_add_user('crisiant_wingfield','A=YnULa5Y-un');
CALL sp_add_user('savanna_maddy','E-USapU');

LOAD DATA LOCAL INFILE 'data/food_recipes.csv' INTO TABLE recipes
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(recipe_id, recipe_name, cuisine, course, @prep_time, @cook_time, ingredients, instructions)
SET prep_time = NULLIF(@prep_time, ''),
    cook_time = NULLIF(@cook_time, '');

LOAD DATA LOCAL INFILE 'data/ratings.csv' INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/goals.csv' INTO TABLE goals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/meals.csv' INTO TABLE meals
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;