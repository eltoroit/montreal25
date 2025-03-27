#!/bin/zsh

# NEW_USERNAME for metadata replacement
export NEW_USERNAME="test-c7r6syexyol8@example.com"
# Keep the target org here, to avoid accidentally deploying to a different org.
sf project deploy start --target-org "$NEW_USERNAME" --ignore-conflicts --verbose --json > "./etLogs/build.json"

# Check if there's anything to deploy
if jq -e '.result.status == "Nothing to deploy"' ./etLogs/build.json > /dev/null 2>&1; then
  print "\u001b[33m\u001b[1;30m*** *** NO CHANGES DETETED TO DEPLOY *** ***\u001b[0m"
else
  failures=$(jq '.result.details.componentFailures | length' ./etLogs/build.json)
  if [ "$failures" -gt 0 ]; then
    jq '.result.details.componentFailures[]' ./etLogs/build.json
    print "\u001b[43m\u001b[1;31m*** *** FAILED *** ***\u001b[0m"
  else
    successes=$(jq '.result.details.componentSuccesses | length' ./etLogs/build.json)
    if [ "$successes" -gt 0 ]; then
      jq -r '.result.files[] | "\(.state): \(.filePath)"' ./etLogs/build.json
      print "\u001b[42m\u001b[1;30m*** *** SUCCESS *** ***\u001b[0m"
    else
      # This case might indicate an unexpected scenario
      jq '.result.details.componentFailures[]' ./etLogs/build.json
      print "\u001b[43m\u001b[1;31m*** *** FAILED (or unexpected) *** ***\u001b[0m"
    fi
  fi
fi
date