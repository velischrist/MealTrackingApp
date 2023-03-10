-- CS 121 Winter 2023 Final Project
-- A DDL file for implementing basic password management in the application

-- File for Password Management section of Final Project
-- (Provided) This function generates a specified number of characters for 
-- using as a salt in passwords.
DROP FUNCTION IF EXISTS make_salt;
DELIMITER !
CREATE FUNCTION make_salt(num_chars INT) 
RETURNS VARCHAR(20) NOT DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20) DEFAULT '';
    -- Don't want to generate more than 20 characters of salt.
    SET num_chars = LEAST(20, num_chars);
    -- Generate the salt!  Characters used are ASCII code 32 (space)
    -- through 126 ('z').
    WHILE num_chars > 0 DO
        SET salt = CONCAT(salt, CHAR(32 + FLOOR(RAND() * 95)));
        SET num_chars = num_chars - 1;
    END WHILE;
    RETURN salt;
END !
DELIMITER ;

-- [Problem 1a]
-- Adds a new user to the user_info table, using the specified password (max
-- of 20 characters). Salts the password with a newly-generated salt value,
-- and then the salt and hash values are both stored in the table.
DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER !
CREATE PROCEDURE sp_add_user(new_username VARCHAR(20), password VARCHAR(20))
BEGIN
    DECLARE salt CHAR(8);
    SELECT make_salt(8) INTO salt;

    IF new_username = 'appadmin' THEN 
        INSERT INTO users_info 
            VALUES (new_username, salt, SHA2(CONCAT(salt, password), 256), 1);
    ELSE 
        INSERT INTO users_info
            VALUES (new_username, salt, SHA2(CONCAT(salt, password), 256), 0);
    END IF;
END !
DELIMITER ;

-- [Problem 1b]
-- Authenticates the specified username and password against the data
-- in the user_info table.  Returns 1 if the user appears in the table, and the
-- specified password hashes to the value for the user. Otherwise returns 0.
DROP FUNCTION IF EXISTS authenticate;
DELIMITER !
CREATE FUNCTION authenticate(username VARCHAR(20), password VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE password_hash BINARY(64);
    DECLARE salt CHAR(8);

    SELECT users_info.salt, users_info.password_hash INTO salt, password_hash
    FROM users_info 
    WHERE users_info.username = username;

    IF username IN (SELECT users_info.username FROM users_info) 
    AND SHA2(CONCAT(salt, password), 256) = password_hash THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END !
DELIMITER ;

-- [Problem 1c]
-- Add at least two users into your user_info table so that when we run this file,
-- we will have examples users in the database.
CALL sp_add_user('appadmin', 'sarah_veli_samir');
CALL sp_add_user('appclient', 'pistachio');

-- [Problem 1d]
-- Optional: Create a procedure sp_change_password to generate a new salt and 
-- change the given user's password to the given password 
-- (after salting and hashing)