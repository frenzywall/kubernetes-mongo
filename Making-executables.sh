#!/bin/bash

# Function to make files executable
make_executable() {
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            chmod +x "$file"
            echo "$file has been made executable."
        else
            echo "$file does not exist or is not a regular file."
        fi
    done
}

# Prompt user to enter file paths
echo "Enter the paths of the files you want to make executable, separated by spaces:"
read -r file_paths

# Convert the input into an array of file paths
IFS=' ' read -r -a files_array <<< "$file_paths"

# Call the function to make the files executable
make_executable "${files_array[@]}"

