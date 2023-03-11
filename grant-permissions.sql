-- CS 121 Winter 2023 Final Project
-- File to load the data in our database

-- Admin user (website administrator)
DROP USER 'appadmin'@'localhost';
CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'adminpw';

-- Client user (users using the app)
DROP USER 'appclient'@'localhost';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'clientpw';

-- Granting permissions
-- The admin has all permissions to all tables
GRANT ALL PRIVILEGES ON mealtrackerdb.* TO 'appadmin'@'localhost';

-- The user has permissions to all tables except the users_info table for 
-- privacy issues. 
-- These privileges would allow a user to delete a recipe created by another
-- user (and other actions which should not be allowed), but our goal is to 
-- handle such cases by creating procedures and calling them in the client 
-- app interface. 
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.meals TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.recipes TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.ratings TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.goals TO 'appclient'@'localhost';

FLUSH PRIVILEGES;

