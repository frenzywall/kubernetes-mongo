#!/bin/bash

# Prompt the user for a username
read -p "Enter your username: " username

# Prompt the user for a password (input hidden)
read -sp "Enter your password: " password
echo

# Encode the username and password using base64
encoded_username=$(echo -n "$username" | base64)
encoded_password=$(echo -n "$password" | base64)

# Output the base64 encoded values
echo "Encoded username: $encoded_username"
echo "Encoded password: $encoded_password"

