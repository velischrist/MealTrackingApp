-- CS 121 Winter 2023 Final Project
-- File to load the data in our database

-- Admin user (website administrator)
DROP USER 'appadmin'@'localhost';
CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'adminpw';

-- Client user (users using the app)
DROP USER 'appclient'@'localhost';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'clientpw';

-- Granting permissions
GRANT ALL PRIVILEGES ON mealtracker.* TO 'appadmin'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.meals TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.recipes TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.ratings TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.goals TO 'appclient'@'localhost';

FLUSH PRIVILEGES;

