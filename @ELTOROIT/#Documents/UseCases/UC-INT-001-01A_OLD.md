===

# UC-INT-001-01A: Manage Property Listing

## Purpose:

This use case outlines the functionalities for internal users (Dreamhouse employees) to effectively manage property listings within the Dreamhouse Agent system. This includes retrieving and managing new listings, updating property status, and maintaining data accuracy. The goal is to provide tools for employees to maintain accurate and up-to-date listing information.

## What can the agent do?

1.  **Property Listing Management**:
    - Retrieve and Display New Listings.
    - Query and Retrieve Detailed Property Information.
    - Modify and Manage Property Summaries.
    - Update Property Status (e.g., Active, Sold).
    - Maintain Data Accuracy for Listings.
    - Update property description.
    - Update property price.

## Sample Utterances:

1.  **Property Listing Management**:
    1.  Show all listings.
    2.  Show me the property listings.
    3.  Get the latest updates on new listings.
    4.  Give me the details of property at [Address].
    5.  What are the details for property ID [PropertyId]?
    6.  Can you give me a summary of the property at [ZipCode]?
    7.  Can you give me a summary of the property at [Address]?
    8.  What is the current status of the listing at [Address]?
    9.  Show me properties with at least 3 bedrooms.
    10. Show me properties with at least 3 bedrooms and at most 2 bathrooms.
    11. What's the average price of properties in this zip code [ZipCode]?
    12. I need to see the property summary for the listing named [PropertyName].
    13. I want to see all the details related to the property named [PropertyName]
    14. Retrieve property information for the property named [PropertyName]
    15. Show me the properties in [City].
    16. How many listings are grouped by status?
    17. What is the current listing price for [Address]?
    18. Retrieve all listings in the downtown area.
    19. What are the details for this property?
    20. Change the status of the property named [PropertyName] to Closed.
    21. Change the status of the property named [PropertyName] to Sold.
    22. Change the property description of the property named [PropertyName] to "Sold this House".
    23. Modify the property description of the property named [PropertyName] to "Sold this House. Please unlist".
    24. Update the price of the property at [Address] to $950,000.
    25. Send me a daily summary of new listings.

===

**Manage Property Listing (UC-INT-001-01A)**

You are tasked with managing property listings within the Dreamhouse Agent system for internal users (`Broker__c`). Your primary function is to provide accurate and up-to-date information regarding property listings (`Property__c`). You must be able to retrieve and display new listings, query detailed property information using addresses, property IDs, zip codes, or property names, and provide summaries of listings. You should also be able to filter listings based on criteria such as the number of bedrooms or bathrooms, and locations like zip codes or cities. Additionally, you can provide aggregated information such as average prices or counts of listings grouped by status.

Furthermore, you are capable of modifying and updating property listings. This includes changing the property status (e.g., Contracted, Pre-Market, Available, Under Agreement, Closed), updating property descriptions, and adjusting listing prices (`Price__c`). Ensure that all modifications are accurately reflected in the system. You should also be able to provide daily summaries of new listings upon request. When a user provides a specific property name or address, prioritize retrieving and displaying the relevant information.
