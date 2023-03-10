"""
TODO: Student name(s):
TODO: Student email(s):
TODO: High-level program overview

******************************************************************************
This is a template you may start with for your Final Project application.
You may choose to modify it, or you may start with the example function
stubs (most of which are incomplete).

Some sections are provided as recommended program breakdowns, but are optional
to keep, and you will probably want to extend them based on your application's
features.

TODO:
- Make a copy of app-template.py to a more appropriately named file. You can
  either use app.py or separate a client vs. admin interface with app_client.py,
  app_admin.py (you can factor out shared code in a third file, which is
  recommended based on submissions in 22wi).
- For full credit, remove any irrelevant comments, which are included in the
  template to help you get started. Replace this program overview with a
  brief overview of your application as well (including your name/partners name).
  This includes replacing everything in this *** section!
******************************************************************************
"""
# TODO: Make sure you have these installed with pip3 if needed
import sys  # to print error messages to sys.stderr
import mysql.connector
# To get error codes from the connector, useful for user-friendly
# error-handling
import mysql.connector.errorcode as errorcode

# Debugging flag to print errors when debugging that shouldn't be visible
# to an actual client. ***Set to False when done testing.***
DEBUG = True


# ----------------------------------------------------------------------
# SQL Utility Functions
# ----------------------------------------------------------------------
def get_conn():
    """"
    Returns a connected MySQL connector instance, if connection is successful.
    If unsuccessful, exits.
    """
    try:
        conn = mysql.connector.connect(
          host='localhost',
          user='appadmin',
          # Find port in MAMP or MySQssL Workbench GUI or with
          # SHOW VARIABLES WHERE variable_name LIKE 'port';
          port='8889',  # this may change!
          password='adminpw',
          database='mealtracker' # replace this with your database name
        )
        print('successfully connected')
        print('⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩')
        return conn
    except mysql.connector.Error as err:
        # Remember that this is specific to _database_ users, not
        # application users. So is probably irrelevant to a client in your
        # simulated program. Their user information would be in a users table
        # specific to your database; hence the DEBUG use.
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR and DEBUG:
            sys.stderr('Incorrect username or password when connecting to DB.')
        elif err.errno == errorcode.ER_BAD_DB_ERROR and DEBUG:
            sys.stderr('Database does not exist.')
        elif DEBUG:
            sys.stderr(err)
        else:
            # A fine catchall client-facing message.
            sys.stderr('An error occurred, please contact the administrator.')
        sys.exit(1)

# ----------------------------------------------------------------------
# Functions for Command-Line Options/Query Execution
# ----------------------------------------------------------------------
def return_to_menu_admin():
    ans = input('press ENTER to return to the menu or anything else to quit').lower()
    if ans == '':
        show_admin_options()
    else:
        quit_ui()


def view_users():
    print('viewing all users')
    print('*' * 50)
    cursor = conn.cursor()
    sql = 'SELECT username FROM users_info;'
    try:
        cursor.execute(sql)
        rows = cursor.fetchall()
        for idx, username in enumerate(rows):
            print(idx+1, username[0])
        print('*' * 50)
        print('there are total', len(rows), 'users in the app.')
        return_to_menu_admin()
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')
    
def remove_user():
    remove_id = input('enter the username to remove: ').lower()
    print('*' * 50)
    cursor = conn.cursor()
    sql = 'DELETE FROM users_info WHERE username = \'%s\';' % (remove_id, )
    try:
        cursor.execute(sql)
        if cursor.rowcount == 1:
            print('user %s successfully removed.' % remove_id)
        else:
            print('uh oh. user %s could not removed. (ㅠ﹏ㅠ) \nmake sure the user exists or try again.' % remove_id)
            print('*' * 50)
        return_to_menu_admin()
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')


def remove_recipe():
    remove_id = input('enter the recipe_id to remove: ').lower()
    print('*' * 50)
    cursor = conn.cursor()
    sql = 'DELETE FROM recipes WHERE recipe_id = %s;' % (remove_id, )
    try:
        cursor.execute(sql)
        if cursor.rowcount == 1:
            print('recipe #%s successfully removed.' % remove_id)
        else:
            print('uh oh. recipe #%s could not removed. (ㅠ﹏ㅠ) \nmake sure the recipe exists or try again.' % remove_id)
            print('*' * 50)
        return_to_menu_admin()

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')

def remove_rating():
    recipe_id = input('enter the recipe_id for the recipe to remove a rating for: ').lower()
    username = input('enter the username of the user who submitted the recipe: ').lower()
    print('*' * 50)
    cursor = conn.cursor()
    sql = 'DELETE FROM ratings WHERE recipe_id = %s AND username = \'%s\';' % (recipe_id, username, )
    try:
        cursor.execute(sql)
        if cursor.rowcount == 1:
            print('rating successfully removed.')
        else:
            print('uh oh. rating could not removed. (ㅠ﹏ㅠ) \nmake sure the rating exists or try again.')
            print('*' * 50)
        return_to_menu_admin()

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')

def add_goal():
    goal_type = input('select a goal type: a) calories, b) protein, c) fat, d) sugar').lower()
    type_dict = {1: 'calories', 2: 'protein', 3: 'fat', 4: 'sugar'}
    if goal_type not in type_dict:
        print('goal type selection not valid. try again!')
    target = input('enter the daily target for your goal:').lower()
    print('*' * 50)
    cursor = conn.cursor()
    sql = 'INSERT INTO goals(user_id, goal_type, target) VALUES (%s, %s, %s);' % (user_id, type_dict[goal_type], target)
    try:
        cursor.execute(sql)
        return_to_menu_admin()

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')


# ----------------------------------------------------------------------
# Command-Line Functionality
# ----------------------------------------------------------------------
def show_client_options():
    """
    Displays options specific for admins, such as adding new data <x>,
    modifying <x> based on a given id, removing <x>, etc.
    """

    print('welcome to the MealTracker™ ( ˘▽˘)っ♨')
    print('⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩')
    print('hi babe, you are logged in as ~ client ~!')
    print('  (a) - add a new goal')
    print('  (b) - view my meal log')
    print('  (c) - add a new meal')
    print('  (d) - view recipes')
    print('  (e) - add a recipe')
    print('  (f) - rate a recipe')
    print('  (q) - quit')
    ans = input('enter an option: ').lower()
    print(ans)
    if ans == 'q':
        quit_ui()
    elif ans == 'a':
        add_goal()
    elif ans =='b':
        view_meal_log()
    elif ans =='c':
        add_meal()
    elif ans =='d':
        view_recipes()
    elif ans == 'e':
        add_recipe()
    elif ans == 'f':
        add_rating()
    else:
        print('your input is not valid. try again!')
        show_client_options()
        


def show_admin_options():
    """
    Displays options specific for admins, such as adding new data <x>,
    modifying <x> based on a given id, removing <x>, etc.
    """

    print('welcome to the MealTracker™ ( ˘▽˘)っ♨')
    print('⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩')
    print('hi babe, you are logged in as ~ admin ~!')
    print('  (a) - view all users')
    print('  (b) - remove a user')
    print('  (c) - remove a recipe')
    print('  (d) - remove a rating')
    print('  (q) - quit')

    ans = input('enter an option: ').lower()
    print(ans)
    if ans == 'q':
        quit_ui()
    elif ans == 'a':
        view_users()
    elif ans =='b':
        remove_user()
    elif ans =='c':
        remove_recipe()
    elif ans == 'd':
        remove_rating()
    else:
        print('your input is not valid. try again!')
        show_admin_options()
        

def log_in(username, password):
    # returns a boolean tuple of (is_authenticated, is_admin)
    is_admin = False
    cursor = conn.cursor()
    sql = 'SELECT authenticate(\'%s\', \'%s\');' % (username, password, )

    try:
        cursor.execute(sql)
        ret = cursor.fetchone()
        if ret[0]:
            sql2 = 'SELECT is_admin FROM users_info WHERE username = \'%s\';' % (username, )
            cursor.execute(sql2)
            is_admin = cursor.fetchone()[0]
            return (True, is_admin)
        else:
            return (False, is_admin)

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred, give something useful for clients...')

def quit_ui():
    """
    Quits the program, printing a good bye message to the user.
    """
    print('Good bye!')
    exit()


def main():
    """
    Main function for starting things up.
    """
    username = input('username: ')
    password = input('password: ')
    is_authenticated, is_admin = log_in(username, password)
    print(is_authenticated, is_admin)
    if not is_authenticated:
        print('incorrect username and/or password. try again!')
        main()
    else:
        if is_admin:
            show_admin_options()
        else:
            show_client_options()


if __name__ == '__main__':
    # This conn is a global object that other functions can access.
    # You'll need to use cursor = conn.cursor() each time you are
    # about to execute a query with cursor.execute(<sqlquery>)
    conn = get_conn()
    main()
