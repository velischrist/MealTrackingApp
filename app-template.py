"""
Student name(s): Velissarios Christodoulou, Samir Johnson, Sarah Yun
Student email(s): vcchrist@caltech.edu, sijohnso@caltech.edu, gyun@caltech.edu

The application allows to user to the log in to MealTracker™ 
using a username and password combination. After the user logs 
in as a 'client' or an 'admin,' the application displays either 
a client menu or an administrator menu. 

The administrator can perform the following: View all 
users, remove a user, remove a recipe, or remove a rating. Thus, the 
administrator is able to remove inappropriate users, recipes, or ratings 
to maintain the integrity of the MealTracker™ community. 

The client can perform the following: Add a new goal, view meal log, 
log a new meal, view recipes, add a recipe, or rate a recipe. When viewing
all meals from a given date, the user can also view the total caloric intake.
They can browse recipes sorted by ratings, contribute recipes of their own 
to share with MealTracker™ community members, and rate recipes as well. 

"""

import sys 
import mysql.connector
import mysql.connector.errorcode as errorcode

DEBUG = False


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
          port='8889', 
          password='adminpw',
          database='mealtracker'
        )
        print('successfully connected')
        print('⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩')
        return conn
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR and DEBUG:
            sys.stderr('Incorrect username or password when connecting to DB.')
        elif err.errno == errorcode.ER_BAD_DB_ERROR and DEBUG:
            sys.stderr('Database does not exist.')
        elif DEBUG:
            sys.stderr(err)
        else:
            sys.stderr('An error occurred, please contact the administrator.')
        sys.exit(1)

# ----------------------------------------------------------------------
# Functions for Command-Line Options/Query Execution
# ----------------------------------------------------------------------
def sql_conn_helper_with_success_msg(query, success_msg,
                    success_function, error_function, username):
    """
    Runs a given SQL query. If the query runs without error, a success
    message is printed and the success function is called with username 
    as input. Otherwise, a default error message is printed and the 
    error function is called with username as input.
    """
    cursor = conn.cursor()    
    try:
        cursor.execute(query)
        print(success_msg)
        if username:
            success_function(username)
        else:
            success_function()

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred.')
            if username:
                error_function(username)
            else:
                error_function()

def sql_conn_helper_with_return_values(query):
    """
    Runs a given SQL query. If the query runs without error, the 
    query results are returned. Otherwise, a default error 
    message is printed.
    """
    cursor = conn.cursor()    
    try:
        cursor.execute(query)
        return cursor.fetchall()

    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('An error occurred.')

def return_to_menu_admin():
    """
    Provides the user with the option of returning to the 
    admin menu or quitting. 
    """
    print('*' * 65)
    ans = input('press ENTER to return to the menu or anything else to quit').lower()
    if ans == '':
        show_admin_options()
    else:
        quit_ui()

def return_to_menu_client(username):
    """
    Provides the user with the option of returning to the 
    client menu or quitting. 
    """
    print('*' * 65)
    ans = input('press ENTER to return to the menu or anything else to quit').lower()
    if ans == '':
        show_client_options(username)
    else:
        quit_ui()

def view_users():
    """
    Displays a list of all users of MealTracker™ with a 
    total count of users. This list can only be viewed by the 
    administrator.
    """
    print('viewing all users')
    print('*' * 50)

    sql = 'SELECT username FROM users_info;'
    rows = sql_conn_helper_with_return_values(sql)
    for idx, username in enumerate(rows):
        print(idx+1, username[0])
    print('*' * 50)
    print('there are total', len(rows), 'users in the app.')
    return_to_menu_admin()


def view_meals_for_date(username, meal_date):
    """
    Given a username and date, this function returns all meals consumed
    by the user on the given date. Meals are displays with their 
    respective meal types (breakfast, lunch, dinner, or snack), 
    and the total caloric intake for the date is provided at the 
    end of the list. 
    """
    print('*' * 65)
    print('\033[1m' + '    ★ ˎˊ˗✩°｡⋆ displaying all meals for %s ⋆｡°✩˗ˏˋ ★' %meal_date + '\033[0m')
    print('*' * 65)
    cursor = conn.cursor()
    sql = 'SELECT meal_type, meal_name FROM meals WHERE username=\'%s\' AND meal_date = \'%s\';' % (username, meal_date, )
    try:
        cursor.execute(sql)
        rows = cursor.fetchall()
        for (meal_type, meal_name, ) in rows:
            print('\033[1m' + meal_type + '\033[0m')
            print(meal_name.replace('Recipe ',''))
            print('----------')
        sql2 = 'SELECT total_caloric_intake(\'%s\', \'%s\', \'%s\');' % (username, meal_date, meal_date, ) 
        cursor.execute(sql2)
        (total_calories, ) = cursor.fetchone()
        print('your total caloric intake for %s was\033[1m %s \033[0m' % (meal_date, total_calories) )
        return_to_menu_client(username)
    except mysql.connector.Error as err:
        if DEBUG:
            sys.stderr(err)
            sys.exit(1)
        else:
            sys.stderr('the inputs were invalid! please try again.')
            view_meals_for_date(username, meal_date)


def view_meal_log(username):
    """
    Displays the meal log of a user. First, the user is given a list of 
    dates for which meals have been logged. After the user selects a date
    from this list, all logged meals for the selected date are displayed. 
    """
    print('*' * 50)
    
    sql = 'SELECT meal_date FROM meals WHERE username=\'%s\';' % (username, )
    rows = sql_conn_helper_with_return_values(sql)

    meal_dates = set([meal_date for (meal_date, ) in rows])
    print('you have %s dates logged in your meal log: ' % len(meal_dates))
    for (idx, meal_date) in enumerate(meal_dates):
        print(idx+1, '-------', meal_date.strftime('%Y-%m-%d'))
    if len(meal_dates) > 0:
        selected = int(input('enter a number to select a date: '))
        if (selected-1) in range(len(rows)):
            view_meals_for_date(username, rows[selected-1][0])
    else:
        print('you have no meals logged! log new meals to view them here.')

    

def remove_user():
    """
    Allows the administrator to remove a user.
    """
    remove_id = input('enter the username to remove: ').lower()
    print('*' * 50)
    sql = 'DELETE FROM users_info WHERE username = \'%s\';' % (remove_id, )
    sql_conn_helper_with_success_msg(sql, 'user %s successfully removed. ' % remove_id, 
                    return_to_menu_admin, remove_user, "")


def remove_recipe():
    """
    Allows the administrator to remove a recipe.
    """
    remove_id = input('enter the recipe_id to remove: ').lower()
    print('*' * 50)
    sql = 'DELETE FROM recipes WHERE recipe_id = %s;' % (remove_id, )
    sql_conn_helper_with_success_msg(sql, 'recipe #%s successfully removed.' % remove_id, 
                    return_to_menu_admin, remove_recipe, "")

def remove_rating():
    """
    Allows the administrator to remove a rating.
    """
    recipe_id = input('enter the recipe_id for the recipe to remove a rating for: ').lower()
    username = input('enter the username of the user who submitted the recipe: ').lower()
    print('*' * 50)
    sql = 'DELETE FROM ratings WHERE recipe_id = %s AND username = \'%s\';' % (recipe_id, username, )
    sql_conn_helper_with_success_msg(sql, 'rating successfully removed', 
                    return_to_menu_admin, remove_recipe, "")

def add_goal(username):
    """
    Allows the user to add a new goal. Goals are daily targets for calories, 
    protein, fat, or sugar. 
    """
    type_dict = {'1': 'calories', '2': 'protein', '3': 'fat', '4': 'sugar'}
    print('goal types: 1) calories, 2) protein, 3) fat, 4) sugar')
    goal_type= input('make a selection: ').lower()
    if goal_type not in type_dict:
        print('goal type selection not valid. try again!')
        add_goal(username)
    target = input('enter the daily target for your goal:').lower()
    print('*' * 50)
    sql = 'CALL add_goal(\'%s\', \'%s\', %s);' % (username, type_dict[goal_type], target, )
    sql_conn_helper_with_success_msg(sql, 'goal successfuly added', 
                    return_to_menu_client, add_goal, username)
    



def add_meal(username):
    """
    Allows the user to add log a new meal to their meal log. Users must 
    provide a meal type (breakfast, lunch, dinner, snack), meal name, 
    the date the meal was eaten on, and macro information. 
    """
    type_dict = {'1': 'breakfast', '2': 'lunch', '3': 'dinner', '4': 'snack'}
    
    print('meal types: 1) breakfast, 2) lunch, 3) dinner, 4) snack')
    meal_type_input = input('what type of meal did u eat: ').lower()
    
    if meal_type_input not in type_dict:
        print('goal type selection not valid. try again!')
        add_meal(username)
    else:
        meal_type = type_dict[meal_type_input]
    
    meal_date = input('date (YYYY-mm-dd): ')
    meal_name = input('meal name:')
    calories = input('calories (kcal):')
    protein = input('protein (g):')
    fat = input('fat (g):')
    sugar = input('sugar (g):')
    print('*' * 50)

    sql = 'INSERT INTO meals(meal_date, meal_type, username, meal_name, calories, protein, fat, sugar) VALUES (\'%s\', \'%s\', \'%s\', \'%s\', %s, %s, %s, %s);' % (meal_date, meal_type, username, meal_name, calories, protein, fat, sugar)
    sql_conn_helper_with_success_msg(sql, 'meal succesfully logged!', 
                    return_to_menu_client, add_meal, username)


def add_recipe(username):
    """
    Allows a user to add a new recipe. The user must provide a
    recipe name, cuisine, course, prep time, cook time, ingredients, 
    and instructions for the recipe.
    """
    recipe_name = input('recipe name:')
    cuisine = input('cuisine:')
    course = input('course:')
    prep_time = input('prep time in minutes:')
    cook_time = input('cook time in minutes:')
    ingredients = input('ingredients:')
    instructions = input('instructions:')
    print('*' * 50)
    sql = 'INSERT INTO recipes(username, recipe_name, cuisine, course, ingredients, \
        instructions, prep_time, cook_time) \
        VALUES (\'%s\', \'%s\', \'%s\', \'%s\',\'%s\', \'%s\',%s, %s);' \
        % (username, recipe_name, cuisine, course, ingredients, instructions, prep_time, cook_time, )
    
    sql_conn_helper_with_success_msg(sql, 'recipe succesfully logged!', 
                    return_to_menu_client, add_recipe, username)

def add_rating(username):
    """
    Allows the user to add a rating for a given recipe using 
    the recipe_id. Ratings must be an integer value ranging from 
    1-5. 
    """
    recipe_id = input('recipe id:')
    rating = int(input('rating (1-5):'))
    if not (1 <= rating <= 5):
        print('rating not valid. try again!')
        add_rating(username)
    print('*' * 50)
    sql = 'CALL add_rating(\'%s\', %s, %s);' % (username, recipe_id, rating, )
    sql_conn_helper_with_success_msg(sql, 'recipe was successfully rated!', 
                    return_to_menu_client, add_rating, username)

def view_recipes(username): 
    """
    Displays recipes with their respective average ratings.
    """
    print('*' * 60)
    print('★ ˎˊ˗✩°｡⋆ displaying recipes ⋆｡°✩˗ˏˋ ★')
    cursor = conn.cursor()
    sql = 'SELECT recipe_name, average_rating FROM recipe_ratings_view;'
    rows = sql_conn_helper_with_return_values(sql)
    for idx, (recipe_name, average_rating, ) in enumerate(rows[:10]):
        print('*' * 60)
        print(idx+1, '--', '\033[1m' + recipe_name + '\033[0m')
        print('avg rating:', average_rating)
    return_to_menu_client(username)

# ----------------------------------------------------------------------
# Command-Line Functionality
# ----------------------------------------------------------------------
def show_client_options(username):
    """
    Displays options specific for clients, such as adding a new goal, 
    viewing their meal log, adding a new meal, viewing recipes, adding
    a recipe, or rating a recipe.
    """
    [first, last] = username.split('_')
    print('welcome to the MealTracker™ ( ˘▽˘)っ♨')
    print('⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩⁺˚⋆｡°✩₊⋆｡ °✩⋆｡ °✩')
    print('hi babe, you are logged in as ~ %s %s ~!' % (first, last))
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
        add_goal(username)
    elif ans =='b':
        view_meal_log(username)
    elif ans =='c':
        add_meal(username)
    elif ans =='d':
        view_recipes(username)
    elif ans == 'e':
        add_recipe(username)
    elif ans == 'f':
        add_rating(username)
    else:
        print('your input is not valid. try again!')
        show_client_options()
        


def show_admin_options():
    """
    Displays options specific for admins, such as 
    viewing all users, removing a user, removing a recipe, 
    or removing a rating. 
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
    """
    Authenticates a username and password combination. Returns a 
    a boolean tuple of (is_authenticated, is_admin). 
    """
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
            sys.stderr('the inputs were invalid! please try again.')

def quit_ui():
    """
    Quits the program, printing a good bye message to the user.
    """
    print('*＊✿❀　❀✿＊* ------------*＊✿❀　❀✿＊*')
    print('good bye! see u again soon ~mwah~ ʕ´•㉨•`ʔ')
    print('*＊✿❀　❀✿＊* ------------*＊✿❀　❀✿＊*')
    
    exit()


def main():
    """
    Main function for starting things up.
    """
    username = input('username: ')
    password = input('password: ')
    is_authenticated, is_admin = log_in(username, password)
    if not is_authenticated:
        print('incorrect username and/or password. try again! (๑•̀д•́๑)')
        main()
    else:
        if is_admin:
            show_admin_options()
        else:
            show_client_options(username)


if __name__ == '__main__':
    conn = get_conn()
    main()
