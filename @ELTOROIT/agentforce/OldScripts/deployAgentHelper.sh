# ---
echo "Starting"
date
start_time=$(date +%s)  # Capture the start time in seconds

# ---
first_failure=true
echo "Check if agentName is provided"
if [ -z "$1" ]; then
  echo "Error: Please provide an agent name as an argument."
  echo "Usage: ./create.sh \"Your Agent Name\" \"Spec path\""
  exit 1
fi
agentName="$1"

echo "Check if spec is provided"
if [ -z "$2" ]; then
  # force-apps/tempAgents/tempAgent.yaml
  echo "Error: Please provide the spect path."
  echo "Usage: ./create.sh \"Your Agent Name\" \"Spec path\""
  exit 1
fi
specPath="$2"

# ---
echo "Stage all changes but do NOT commit"
git add .  

# ---
echo "Creating the temp agent"
createAgent() {
  agentNameAPI=$(echo "$agentName" | tr ' ' '_')
  # sf agent create --spec "$specPath" --agent-name "$agentName" --agent-api-name "$agentNameAPI" --preview
  sf agent create --spec "$specPath" --agent-name "$agentName" --agent-api-name "$agentNameAPI"
}

validateOrgReady() {
  echo "Make sure you do see the \"+ New Agent\" button"
  sf org open --path "/lightning/setup/EinsteinCopilot/home"
}

while ! createAgent; do
  if $first_failure; then
    validateOrgReady
    first_failure=false
  fi

  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))  # Calculate the elapsed time
  echo "Command failed. Retrying in 10 seconds... Elapsed time: $((elapsed_time / 60))m $((elapsed_time % 60))s"
  sleep 10
done

# ---
echo "Undo all changes done"
git restore .
git clean -fd

# ---
current_time=$(date +%s)  # Capture the current time
elapsed_time=$((current_time - start_time))  # Calculate the elapsed time
echo "Command succeeded! Elapsed time: $((elapsed_time / 60)) minutes $((elapsed_time % 60)) seconds"
