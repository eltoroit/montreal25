#!/bin/zsh

local agent_name=$1
local agent_yaml=$2
local username_file=$3

# Log the start of the process
echo "Starting creation for agent: $agent_name"

# Check if the YAML file and username file exist
if [[ ! -f "$agent_yaml" ]]; then
    echo "Error: YAML file '$agent_yaml' not found."
    return 1
fi

if [[ ! -f "$username_file" ]]; then
    echo "Error: Username file '$username_file' not found."
    return 1
fi

# Replace agent user
echo "Replacing agent user for $agent_name..."
./@ELTOROIT/agentforce/replaceAgentUser.sh "$agent_yaml" "$username_file"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to replace user for agent: $agent_name."
    return 1
fi

# Create agent
echo "Creating agent: $agent_name..."
./@ELTOROIT/agentforce/deployAgentHelper.sh "$agent_name" "$agent_yaml"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create agent: $agent_name."
    return 1
fi

# Log successful completion
echo "Successfully created agent: $agent_name"
