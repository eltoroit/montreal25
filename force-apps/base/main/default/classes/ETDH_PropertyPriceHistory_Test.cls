@isTest
private class ETDH_PropertyPriceHistory_Test {
	@testSetup
	static void setupTestData() {
		// Create test property records
		List<Property__c> propertiesToCreate = new List<Property__c>();

		for (Integer i = 0; i < 3; i++) {
			Property__c prop = new Property__c(
				Name = 'Test Property ' + i,
				Price__c = 100000 + (i * 50000)
				// Add other required fields here
			);
			propertiesToCreate.add(prop);
		}

		insert propertiesToCreate;
	}

	@isTest
	static void testPriceHistoryCreation() {
		// Get properties created in setup
		List<Property__c> properties = [SELECT Id, Name, Price__c FROM Property__c];
		System.assertEquals(3, properties.size(), 'Setup should have created 3 properties');

		// Prepare property updates
		List<Property__c> propertiesToUpdate = new List<Property__c>();
		for (Property__c prop : properties) {
			prop.Price__c = prop.Price__c + 25000; // Increase each property price
			propertiesToUpdate.add(prop);
		}

		// Start test and update properties
		Test.startTest();
		update propertiesToUpdate;
		Test.stopTest();

		// Verify price history records were created
		List<PropertyPriceHistory__c> priceHistories = [
			SELECT Id, Property__c, OldPrice__c, NewPrice__c, DateChanged__c
			FROM PropertyPriceHistory__c
		];

		System.assertEquals(3, priceHistories.size(), 'Should have created 3 price history records');

		// Verify details of price history records
		Map<Id, Property__c> propMap = new Map<Id, Property__c>(properties);

		for (PropertyPriceHistory__c history : priceHistories) {
			Property__c relatedProperty = propMap.get(history.Property__c);
			System.assertNotEquals(null, relatedProperty, 'Price history should be linked to a property');
			System.assertEquals(relatedProperty.Price__c, history.NewPrice__c, 'New price should match updated property price');
			System.assertEquals(relatedProperty.Price__c - 25000, history.OldPrice__c, 'Old price should match original property price');
			System.assertNotEquals(null, history.DateChanged__c, 'Date changed should be populated');
		}
	}

	@isTest
	static void testNoChangeNoHistory() {
		// Get properties created in setup
		List<Property__c> properties = [SELECT Id, Name, Price__c FROM Property__c];

		// Update properties but don't change price
		List<Property__c> propertiesToUpdate = new List<Property__c>();
		for (Property__c prop : properties) {
			prop.Name = prop.Name + ' Updated'; // Change name only, not price
			propertiesToUpdate.add(prop);
		}

		// Start test and update properties
		Test.startTest();
		update propertiesToUpdate;
		Test.stopTest();

		// Verify no price history records were created
		List<PropertyPriceHistory__c> priceHistories = [SELECT Id FROM PropertyPriceHistory__c];
		System.assertEquals(0, priceHistories.size(), 'No price history records should be created when price is unchanged');
	}

	@isTest
	static void testMultiplePriceChanges() {
		// Get properties created in setup
		List<Property__c> properties = [SELECT Id, Name, Price__c FROM Property__c];
		Property__c testProperty = properties[0]; // Use the first property

		// First price update
		testProperty.Price__c = testProperty.Price__c + 10000;

		Test.startTest();
		update testProperty;

		// Get original price for verification
		Decimal originalPrice = testProperty.Price__c - 10000;

		// Second price update
		testProperty.Price__c = testProperty.Price__c + 5000;
		update testProperty;
		Test.stopTest();

		// Verify two price history records were created
		List<PropertyPriceHistory__c> priceHistories = [
			SELECT Id, Property__c, OldPrice__c, NewPrice__c, DateChanged__c
			FROM PropertyPriceHistory__c
			WHERE Property__c = :testProperty.Id
			ORDER BY DateChanged__c ASC
		];

		System.assertEquals(2, priceHistories.size(), 'Should have created 2 price history records for the property');

		// Verify first price history record
		System.assertEquals(originalPrice, priceHistories[0].OldPrice__c, 'First record old price should match original price');
		System.assertEquals(originalPrice + 10000, priceHistories[0].NewPrice__c, 'First record new price should match first update');

		// Verify second price history record
		System.assertEquals(originalPrice + 10000, priceHistories[1].OldPrice__c, 'Second record old price should match first update');
		System.assertEquals(originalPrice + 15000, priceHistories[1].NewPrice__c, 'Second record new price should match second update');
	}

	@isTest
	static void testBulkUpdate() {
		// Create 200 properties for bulk testing
		List<Property__c> bulkProperties = new List<Property__c>();
		for (Integer i = 0; i < 200; i++) {
			Property__c prop = new Property__c(
				Name = 'Bulk Property ' + i,
				Price__c = 200000 + (i * 1000)
				// Add other required fields here
			);
			bulkProperties.add(prop);
		}
		insert bulkProperties;

		// Update all property prices
		for (Property__c prop : bulkProperties) {
			prop.Price__c = prop.Price__c + 50000;
		}

		Test.startTest();
		update bulkProperties;
		Test.stopTest();

		// Verify price history records were created for all properties
		Integer historyCount = [SELECT COUNT() FROM PropertyPriceHistory__c WHERE Property__c IN :bulkProperties];
		System.assertEquals(200, historyCount, 'Should have created 200 price history records for bulk update');
	}
}
