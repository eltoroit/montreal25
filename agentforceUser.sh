#!/bin/bash
echo "HELLO"
date
ORG_ID=$(jq -r '.user.orgId' ./etLogs/_user.json)

# Agent #1
AGENT_USERNAME="agent001@${ORG_ID}.ext"
echo ${AGENT_USERNAME} > ./etReplacements/AGENT_FIRST_USERNAME.txt

# Agent #2
AGENT_USERNAME="agent002@${ORG_ID}.ext"
echo ${AGENT_USERNAME} > ./etReplacements/AGENT_HR_USERNAME.txt