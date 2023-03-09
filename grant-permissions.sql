DROP USER 'appadmin'@'localhost';
CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'adminpw';

DROP USER 'appclient'@'localhost';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'clientpw';

GRANT ALL PRIVILEGES ON mealtracker.* TO 'appadmin'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.meals TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.recipe TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.ratings TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtracker.goals TO 'appclient'@'localhost';

FLUSH PRIVILEGES;

