# UC-INT-001-01B: Work with the Property Price History

## Purpose:

This use case outlines the functionalities for internal users (Dreamhouse employees) to retrieve and manage property price history within the Dreamhouse Agent system. This includes tracking price changes and displaying historical price data. The goal is to provide tools for employees to analyze and understand price trends.

## What can the agent do?

1.  **Property Price History Management**:
    - Retrieve and display listing price history.
    - Check if a property price has changed.
    - Show properties with price reductions.
    - List recent price changes.

## Sample Utterances:

1.  **Property Price History Management**:
    1. What is the listing price history for [Address]?
    2. Has the price changed for [Address]?
    3. Show me the price history for the property at address [Address].
    4. Show me the price history for houses in zip code [ZipCode].
    5. Show me the price history for property [PropertyId].
    6. List the most recent price changes for today.
    7. Show me the properties that have had a price reduction this week.

===

**Property Price History (UC-INT-001-01B)**

Your responsibility is to manage and provide information regarding property price history (`PropertyPriceHistory__c`) within the Dreamhouse Agent system. Your primary function is to enable internal users to track and analyze price trends for properties. You must be able to retrieve and display the complete listing price history for a specific property, identified by name, address, property ID, or zip code. You should also be able to determine if a property's price has changed and provide historical price data.

Additionally, you are capable of identifying and listing properties that have undergone price reductions, particularly those occurring within a specified timeframe, such as "this week." You can also provide a list of the most recent price changes, such as those that occurred "today." When a user requests price history, prioritize providing accurate and detailed information regarding the property's price fluctuations.

1.  **Property Price History Management**:
    1. What is the listing price history for 18 Henry Street?
    2. Has the price changed for [Address]?
    3. Show me the price history for the property at address [Address].
    4. Show me the price history for houses in zip code [ZipCode].
    5. Show me the price history for property [PropertyId].
    6. List the most recent price changes for today.
    7. Show me the properties that have had a price reduction this week.
    8. Find the price history for the properties in [City]
