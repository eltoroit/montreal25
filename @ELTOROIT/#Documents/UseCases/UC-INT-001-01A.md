# UC-INT-001-01A: Comprehensive Property Lifecycle Management

## Purpose:

This use case outlines the functionalities for internal users (Dreamhouse employees) to effectively manage the entire lifecycle of property listings within the Dreamhouse Agent system. This includes retrieving and managing new listings, tracking price changes, and managing property summaries. The goal is to provide a comprehensive suite of tools for employees to maintain accurate and up-to-date property information, ensuring efficient operations and better service delivery.

# What can the agent do?

1.  **Property Listing Management**:

    - Retrieve and Display New Listings.
    - Query and Retrieve Detailed Property Information.
    - Modify and Manage Property Summaries.
    - Update Property Status (e.g., Active, Sold).
    - Maintain Data Accuracy for Listings.

<!-- 2.  **Open House Scheduling**:

    - Arrange and Schedule Open House Events. -->

## Sample Utterances:

- **Property Listing Management**:

    - Main Tests

        1. Show all listings.
        2. Give me the details of property at 18 Henry Street.
        3. Can you give me a summary of the property at 02420?
        4. Can you give me a summary of the properties at 02420?
        5. Show me properties with at least 3 bedrooms and at most 2 bathrooms
        6. Show me the properties in Cambridge
        7. How many listings are the grouped by city?
        8. Change the status of property at 18 Henry Street to Sold.
            - [Expected] => "Sold" is not a valid option, the option is "Closed"
        9. Modify the property description of property at 18 Henry Street to "Sold this House. Please unlist".
        10. Update the price of property at 18 Henry Street to $950,000.
        11. What is the listing price history for 18 Henry Street?
        12. Find the properties in Cambridge and, for each property, show the price history
        13. Find the properties that have been changed today, for each property review the price history. Only show properties that have changed their price
        14. Show me the properties that have had a price change this week.

    - Other Utterances

        1.  Show me the property listings
        2.  Get the latest updates on new listings.
        3.  Can you give me a summary of the property at 02420?
        4.  Can you give me a summary of the property at 18 Henry Street?
        5.  What is the current status of listing at 18 Henry Street?
        6.  Show me properties with at least 3 bedrooms.
        7.  What's the average price of properties in this zip code 02420?
        8.  I need to see the property summary for listing at 18 Henry Street
        9.  I want to see all the details related to property at 18 Henry Street
        10. Retrieve property information for property at 18 Henry Street
        11. How many listings are the grouped by status?
        12. What is the current listing price for 18 Henry Street?
        13. Retrieve all listings in the downtown area.
        14. Change the status of property at 18 Henry Street to Closed.
        15. Change the property description of property at 18 Henry Street to "Sold this House".
        16. Modify the property description of property at 18 Henry Street to "Sold this House. Please unlist".
        17. Has the price changed for 18 Henry Street?
        18. Show me the price history for property at address 18 Henry Street
        19. Show me the price history for houses in zip code 02139

    - With Record Id

        1.  What are the details for property ID [PropertyId]?
        2.  Show me the price history for property [PropertyId]?
        3.  What are the details for this property?

    - Version 2.0

        1.  Send me a daily summary of new listings.

# Agentforce

## Topic: Property Management (UC-INT-001-01A)

You are the real state Dreamhouse Agent, designed to assist brokers (Dreamhouse employees) in managing the full lifecycle of real state property listings (houses and apartments). Your primary responsibility is to provide comprehensive tools for retrieving, updating, and maintaining accurate property (`Property__c`) information. When a user requests property listing information, retrieve and display the relevant details, including new listings, property summaries, price changes (`PropertyPriceHistory__c`), and current status. Allow users to modify property summaries, update listing prices, and change property statuses as needed. Ensure data accuracy by validating all updates.
