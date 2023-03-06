import csv
import random

num_users = 200 # Number of users
num_recipes = 6742 # Number of recipes

# Define the data to be written to the CSV file
rating_data = [['user_id', 'recipe_id', 'rating']]

users = range(1, num_users + 1)
for recipe_id in range(1, num_recipes+1):
    sample_users = random.sample(users, 10)
    for user_id in sample_users:
        rating = random.randint(1, 5)
        rating_data.append([user_id, recipe_id, rating])

# Specify the name of the CSV file
filename = '/Users/velis.christ/Documents/Caltech/Winter2023/CS121/FinalProject/ratings.csv'

# Open the CSV file for writing
with open(filename, 'w', newline='') as csvfile:

    # Create a CSV writer object
    csvwriter = csv.writer(csvfile)

    # Write the data to the CSV file
    csvwriter.writerows(rating_data)

print(f"CSV file '{filename}' created successfully.")
