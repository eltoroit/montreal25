#!/bin/zsh

# Check if input arguments are provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <yamlFile> <usernameFile>"
  exit 1
fi

# Assign input arguments to variables
yamlFile=$1
usernameFile=$2

# Validate that both files exist
for file in "$yamlFile" "$usernameFile"; do
  if [[ ! -f $file ]]; then
    echo "Error: File '$file' not found."
    exit 1
  fi
done

# Validate that the placeholder exists in the YAML file
if ! grep -q '<REPLACE_USER_HERE>' "$yamlFile"; then
  echo "Error: Placeholder '<REPLACE_USER_HERE>' not found in '$yamlFile'."
  exit 1
fi

# Read the username and escape any special characters for sed
username=$(<"$usernameFile")
escapedUsername=$(printf '%s' "$username" | sed 's/[\/&]/\\&/g')

# Perform the replacement based on the OS
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS uses a different sed syntax
  sed -i '' "s/<REPLACE_USER_HERE>/$escapedUsername/g" "$yamlFile"
else
  # Linux uses standard sed syntax
  sed -i "s/<REPLACE_USER_HERE>/$escapedUsername/g" "$yamlFile"
fi

# Check if the replacement was successful
if [[ $? -eq 0 ]]; then
  echo "Replacement complete. '<REPLACE_USER_HERE>' has been replaced with '$username' in $yamlFile."
else
  echo "Error: Failed to perform replacement."
  exit 1
fi
