Generate a markdown document that has the same format as the previously generated document. Include all the details and being very verbose describe the solution using Salesforce Agentforce. Provide at least 20 different uttenace samples. The "Agentforce Topic" section has the information that I can use to build the agent, do not use JSON, just keep it as a bullet list. Do not add words like [cite: ##].
Use this use case [UC-EXT-005-02]

===

I have this technical design for a project, and this list of use cases. I will ask you some questions...

===
Generate a markdown document that seems similar to the one below. Including all the details and being very verbose describe the solution using Salesforce Agentforce. Provide at least 20 different uttenace samples. The "Agentforce Topic" section has the information that I can use to build the agent, do not use JSON, just keep it as a bullet list.
Use this use case [UC-INT-001-02]

```
**UC-INT-001: UseCase Name**
**Identifier:** <UC-INT-001>
**Purpose:**
- Use case description

**Preconditions:**
- List of preconditions

**Basic Flow:**
- Flow Steps

**Alternative Flows:**
- Alternative paths explained

**Error Flows:**
- Identify possible errors

**Sample Utterances:**
- List of possible utterances for Agentforce

**Agentforce Topic:**
- Provide the summary of the topic
- Provide the topic description
- Provide the topic role
- Provide the instructions
```

===

I will provide you one use case, then you will give me a list of about 20 things the Agentforce agent should do. Avoid duplicate (or very similar) items even if the list has to be shorter

The list should have a title indicating the use case name, each list item should be in this format: #. **<Title>**: Description

I want to see the list in markdown format (I want to see the code, not a rendered list). There should be no empty lines between the list items.

After that ask for the next use case.

Ready?

===

Please provide this information for Cambridge, Massachusetts, is 02139

1.  **Extract Location Information**: Accurately extract the property address or location from the user's utterance.
2.  **Call Walk Score API**: Use the API Integration Layer to call the Walk Score API and retrieve the walk score, transit score, and bike score.
3.  **Call Neighborhood Information API**: Use the API Integration Layer to call an API to retrieve neighborhood information (e.g., demographics, crime rate, schools).
4.  **Call Commute Time API**: Use the API Integration Layer to call an API to retrieve commute times to specified locations (e.g., downtown, major employers).
5.  **Call Amenities API**: Use the API Integration Layer to call an API to retrieve information about nearby amenities (e.g., grocery stores, restaurants, parks).
6.  **Call Location Analytics API**: Use the API Integration Layer to call an API to retrieve location analytics (e.g., market trends, property values).

Use a Json format
