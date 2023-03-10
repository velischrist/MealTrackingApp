import random
import string

n_username = 20
n_email = 10
n_password = 10
num_users = 200

username_list = []
email_list = []
password_list = []
email_choice = ['@gmail.com', '@caltech.edu', '@yahoo.com', '@hotmail.com']

i = 0
while i < num_users:
     username = ''.join(random.choices(string.ascii_lowercase + string.ascii_letters, k = n_username))
     email = ''.join(random.choices(string.ascii_lowercase + string.ascii_letters, k = n_email)) + \
             ''.join(random.choice(email_choice))
     password = ''.join(random.choices(string.ascii_lowercase + string.ascii_letters, k = n_password))
     if username not in username_list and email not in email_list:
          username_list.append(username)
          email_list.append(email)
          password_list.append(password)
          i += 1

print(username_list)
print(email_list)
print(password_list)