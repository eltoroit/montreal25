#!/bin/zsh
# =================================================================
# Agent Deployment Script
# A complete solution for deploying Salesforce agents with username replacement
# =================================================================

# ----- Configuration and Constants -----
RETRY_DELAY=10  # Seconds to wait between retries
MAX_RETRIES=10  # Maximum number of retries before giving up (set to -1 for infinite)
SETUP_URL="/lightning/setup/EinsteinCopilot/home"
USERNAME_PLACEHOLDER="<REPLACE_USER_HERE>"

# ----- Helper Functions -----

# Function to log messages with timestamp
log() {
  local level="$1"
  local message="$2"
  echo "$(date '+%Y-%m-%d %H:%M:%S') [AGENT DEPLOY] [$level] $message"
}

# Function to log errors and exit
error_exit() {
  log "ERROR" "$1"
  exit 1
}

# Function to validate file existence
validate_file() {
  local file="$1"
  local description="$2"
  if [[ ! -f "$file" ]]; then
    error_exit "$description '$file' not found."
  fi
}

# Function to replace username in YAML file
replace_user() {
  local yaml_file="$1"
  local username_file="$2"
  
  # Validate that the placeholder exists
  if ! grep -q "$USERNAME_PLACEHOLDER" "$yaml_file"; then
    error_exit "Placeholder '$USERNAME_PLACEHOLDER' not found in '$yaml_file'."
  fi

  # Read the username and escape any special characters for sed
  local username=$(<"$username_file")
  local escaped_username=$(printf '%s' "$username" | sed 's/[\/&]/\\&/g')

  log "INFO" "Replacing agent user with: $username"
  
  # Perform the replacement based on the OS
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS uses a different sed syntax
    sed -i '' "s/$USERNAME_PLACEHOLDER/$escaped_username/g" "$yaml_file"
  else
    # Linux uses standard sed syntax
    sed -i "s/$USERNAME_PLACEHOLDER/$escaped_username/g" "$yaml_file"
  fi

  # Check if the replacement was successful
  if [[ $? -ne 0 ]]; then
    error_exit "Failed to perform replacement in $yaml_file."
  fi
  
  log "INFO" "Replacement complete in $yaml_file."
}

# Function to create the agent (with API name sanitization)
create_agent() {
  local agent_name="$1"
  local yaml_file="$2"
  
  log "INFO" "Creating agent: $agent_name"
  
  # Create API-safe name by replacing spaces with underscores and removing special characters
  local agent_api_name=$(echo "$agent_name" | tr ' ' '_' | tr -cd 'a-zA-Z0-9_')
  
  # Execute the agent creation command
  sf agent create --spec "$yaml_file" --agent-name "$agent_name" --agent-api-name "$agent_api_name"
}

# Function to open Salesforce setup page
validate_org_ready() {
  log "INFO" "Opening Salesforce setup page. Ensure you see the '+ New Agent' button."
  sf org open --path "$SETUP_URL"
}

# Function to handle Git operations
handle_git() {
  local operation="$1"
  
  case "$operation" in
    "stage")
      log "INFO" "Staging changes in Git"
      git add . >/dev/null 2>&1
      ;;
    "restore")
      log "INFO" "Restoring Git state"
      git restore . >/dev/null 2>&1
      git clean -fd >/dev/null 2>&1
      ;;
    *)
      error_exit "Unknown Git operation: $operation"
      ;;
  esac
}

# Function to format time
format_time() {
  local seconds="$1"
  local minutes=$((seconds / 60))
  local remaining_seconds=$((seconds % 60))
  
  printf "%dm %ds" "$minutes" "$remaining_seconds"
}

# ----- Main Script -----

# Check if correct number of arguments are provided
if [ $# -ne 3 ]; then
  log "ERROR" "Incorrect number of arguments"
  echo "Usage: ./deployAgent.sh \"Agent Name\" \"Spec path\" \"Username file\""
  exit 1
fi

agent_name="$1"
agent_yaml="$2"
username_file="$3"

# Start deployment process
log "INFO" "Starting deployment for agent: $agent_name"
start_time=$(date +%s)

# Validate input files
validate_file "$agent_yaml" "YAML file"
validate_file "$username_file" "Username file"

# Stage changes in Git
handle_git "stage"

# Replace username in YAML file
replace_user "$agent_yaml" "$username_file"

# Create agent with retry mechanism
retry_count=0
first_attempt=true

while true; do
  if create_agent "$agent_name" "$agent_yaml"; then
    log "SUCCESS" "Agent '$agent_name' created successfully!"
    break
  fi
  
  # Check if maximum retries exceeded
  if [[ $MAX_RETRIES -ge 0 && $retry_count -ge $MAX_RETRIES ]]; then
    error_exit "Failed to create agent after $MAX_RETRIES attempts. Giving up."
  fi
  
  # Increment retry counter
  ((retry_count++))
  
  # On first failure, open the Salesforce setup page
  if $first_attempt; then
    validate_org_ready
    first_attempt=false
  fi
  
  # Calculate elapsed time
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  formatted_time=$(format_time $elapsed_time)
  
  log "WARN" "Creation failed. Retry $retry_count in $RETRY_DELAY seconds... (Elapsed: $formatted_time)"
  sleep $RETRY_DELAY
done

# Cleanup - restore Git state
handle_git "restore"

# Calculate and log total time
end_time=$(date +%s)
total_time=$((end_time - start_time))
formatted_total=$(format_time $total_time)

log "INFO" "Deployment of '$agent_name' completed in $formatted_total"