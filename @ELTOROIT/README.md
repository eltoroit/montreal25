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
