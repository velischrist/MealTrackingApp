-- CS 121 Winter 2023 Final Project

CREATE USER 'appadmin'@'localhost' IDENTIFIED BY 'adminpw';
CREATE USER 'appclient'@'localhost' IDENTIFIED BY 'clientpw';

GRANT ALL PRIVILEGES ON mealtrackerdb.* TO 'appadmin'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.meals TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.recipe TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.ratings TO 'appclient'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealtrackerdb.goals TO 'appclient'@'localhost';

FLUSH PRIVILEGES;
