#!/bin/bash
ORG_ID=$(jq -r '.user.orgId' ./etReplacements/user.json)

# Agent #1 => agent001<ORG_ID>.ext => Human Resources
AGENT_USERNAME="agent001@${ORG_ID}.ext"
echo ${AGENT_USERNAME} > ./etReplacements/AGENT_HUMAN_RESOURCES_USERNAME.txt

# Agent #2 => agent002<ORG_ID>.ext => Geography
AGENT_USERNAME="agent002@${ORG_ID}.ext"
echo ${AGENT_USERNAME} > ./etReplacements/AGENT_GEOGRAPHY_USERNAME.txt
