# MealTrackingApp
An app for tracking daily meals, setting goals, and finding/rating recipes.

The app includes:
- SQL database of users, goals, meals, recipes, and ratings
- Python interface for the app

Dataset for recipes: https://www.kaggle.com/datasets/sarthak71/food-recipes

The CSV files we use for loading the data are included in this repository 
in the folder 'data'. 

First, enter into a MySQL command-line interface, create a new database, and
select it. To load the data and run the python app, execute the following 
commands:

mysql> source setup.sql;

mysql> source setup-passwords.sql;

mysql> source load-data.sql;

mysql> source setup-routines.sql;

mysql> source grant-permissions.sql;

mysql> source queries.sql;

mysql> quit;

$ python3 app.py

You will be prompted to login by entering a username and password.

To login as an admin:
- username: appadmin
- password: sarah_veli_samir

To loing as a client (user), you can enter the credentials for any user in our
database. An example is given below:
- username: lacey_valenta
- password: YDy+u-e~

You should now be logged in to either the admin or client app. 

Simply select an action from the dropdwon menu by typing in the letter that
corresponds to your desired action. 