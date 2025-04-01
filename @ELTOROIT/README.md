# Zipcode location

- It will be simulated in a Heroku app because real APIs need to be registered and paid for.
- I will deploy a Deno app to Heroku.
- I already built it locally here: `@ELTOROIT/Neighborhood`
- Similar to this one: `~/Git Projects/current/Slack/0005_Html2MD/main.js`
- Use own buildpack for Heroku: `https://github.com/eltoroit/deno-buildpack`
- `deno run --allow-env --allow-net ./server.js`

# Scratch org configuration

- https://github.com/SF-BT/TZ_PartnerCommunity_Agentforce/blob/Integration/config/project-scratch-def.json

# Errors

- You've reached the maximum number of bots of this AgentType.
    - Do not deploy `bots/Copilot_for_Salesforce.bot`
- "This Object Name already exists or has been previously used. Please choose a different name."
    - Do not deploy `bots/Human_Resources_Agent.bot`

# Notes Agentforce

- `QueryResults` on `Property__History`: not found in the schema

```
{
  "additionalContext": [
    {
      "description": "Search results obtained from the query terms passed as input.",
      "id": null,
      "name": "searchResults",
      "schema": null,
      "type": "JSON",
      "value": "[]"
    },
    {
      "description": "A string that explains how the query was interpreted to retrieve the results.",
      "id": null,
      "name": "explanation",
      "schema": null,
      "type": "String",
      "value": "Property__History table or price change field not found in the schema."
    }
  ],
  "result": []
}
```

# Debugging

- Agentforce (default) (builder and regular modes) runs under "Platform Integration User" (Set debug logs on this user)

# Instrcutions

```
Properties can be identified by their Record Id (18 characters), Name, Address__c (for example 123 Main Street), or Zip__c (for example 024123) or other attributes. You may use action "QueryRecords" to find the property.
```
