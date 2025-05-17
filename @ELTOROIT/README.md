# Unlocked Package

```
sf package create --target-dev-hub etdcoDevHub --name dreamhouse_ELTOROit --package-type Unlocked --path force-apps/dreamhouse_ELTOROit --no-namespace  --description "Dreamhouse app plus additional metadata required for Agentforce Workshop"

sf package version create --target-dev-hub etdcoDevHub --package dreamhouse_ELTOROit --wait 600 --installation-key-bypass --code-coverage

sf package version promote --target-dev-hub etdcoDevHub --package "dreamhouse_ELTOROit@0.1.1-1"
```
