/*
These tests will only check the SOQL query can be built properly and executed.
There will be no results because Property__History only gets populated afeter a commit
To check for data, we would have to do @SeeAllData
*/
@isTest
private class ETDH_PropertyHistory_Test {
	@testSetup
	static void setupTestData() {
		// Create test property
		Property__c prop = new Property__c();
		prop.Name = 'Test Property';
		prop.Price__c = 1000000;
		insert prop;

		// Update the property to create history records
		prop.Name = 'Updated Property Name';
		update prop;

		// Update again with different value
		prop.Price__c = 1500000;
		update prop;
	}

	@isTest
	static void testGetHistoryNoFilter() {
		// Prepare test request
		ETDH_PropertyHistory.AgentRequest request = new ETDH_PropertyHistory.AgentRequest();
		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// Verify results
		System.assertEquals(1, results.size(), 'Should return one result');
		System.assertEquals(null, results[0].error, 'Error should be null for successful execution');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field != \'Created\') ) FROM Property__c WHERE (ID IN (SELECT ParentId FROM Property__History WHERE (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
	}

	@isTest
	static void testGetHistoryWithHistoryFilter() {
		// Prepare test request with history filter
		ETDH_PropertyHistory.AgentRequest request = new ETDH_PropertyHistory.AgentRequest();
		request.SOQL_WHERE_History = 'Field = \'Name\'';
		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// Verify results
		System.assertEquals(1, results.size(), 'Should return one result');
		System.assertEquals(null, results[0].error, 'Error should be null for successful execution');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field = \'Name\') AND (Field != \'Created\') ) FROM Property__c WHERE (ID IN (SELECT ParentId FROM Property__History WHERE (Field = \'Name\') AND (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
	}

	@isTest
	static void testGetHistoryWithPropertyFilter() {
		// Get a property Id to use in filter
		Property__c prop = [SELECT Id FROM Property__c LIMIT 1];

		// Prepare test request with property filter
		ETDH_PropertyHistory.AgentRequest request = new ETDH_PropertyHistory.AgentRequest();
		request.SOQL_WHERE_Property = 'Id = \'' + prop.Id + '\'';
		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// Verify results
		System.assertEquals(1, results.size(), 'Should return one result');
		System.assertEquals(null, results[0].error, 'Error should be null for successful execution');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field != \'Created\') ) FROM Property__c WHERE (Id = \'' +
				prop.Id +
				'\') AND (ID IN (SELECT ParentId FROM Property__History WHERE (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
	}

	@isTest
	static void testGetHistoryWithBothFilters() {
		// Get a property Id to use in filter
		Property__c prop = [SELECT Id FROM Property__c LIMIT 1];

		// Prepare test request with both filters
		ETDH_PropertyHistory.AgentRequest request = new ETDH_PropertyHistory.AgentRequest();
		request.SOQL_WHERE_History = 'Field = \'Name\'';
		request.SOQL_WHERE_Property = 'Id = \'' + prop.Id + '\'';
		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// Verify results
		System.assertEquals(1, results.size(), 'Should return one result');
		System.assertEquals(null, results[0].error, 'Error should be null for successful execution');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field = \'Name\') AND (Field != \'Created\') ) FROM Property__c WHERE (Id = \'' +
				prop.Id +
				'\') AND (ID IN (SELECT ParentId FROM Property__History WHERE (Field = \'Name\') AND (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
	}

	@isTest
	static void testGetHistoryWithError() {
		// Prepare test request with invalid SOQL
		ETDH_PropertyHistory.AgentRequest request = new ETDH_PropertyHistory.AgentRequest();
		request.SOQL_WHERE_History = 'InvalidField = \'Something\''; // This should cause an error
		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// Verify results
		System.assertEquals(1, results.size(), 'Should return one result');
		System.assertEquals(null, results[0].properties, 'Properties should be null for error case');
		System.assertNotEquals(null, results[0].error, 'Error should not be null for failed execution');
		System.assert(results[0].error.startsWith('An error has occurred'), 'Error message should start with expected text');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (InvalidField = \'Something\') AND (Field != \'Created\') ) FROM Property__c WHERE (ID IN (SELECT ParentId FROM Property__History WHERE (InvalidField = \'Something\') AND (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
	}

	@isTest
	static void testMultipleRequests() {
		// Prepare multiple test requests
		ETDH_PropertyHistory.AgentRequest request1 = new ETDH_PropertyHistory.AgentRequest();
		ETDH_PropertyHistory.AgentRequest request2 = new ETDH_PropertyHistory.AgentRequest();
		request2.SOQL_WHERE_History = 'Field = \'Name\'';

		List<ETDH_PropertyHistory.AgentRequest> requests = new List<ETDH_PropertyHistory.AgentRequest>{ request1, request2 };

		// Execute the method
		Test.startTest();
		List<ETDH_PropertyHistory.AgentResult> results = ETDH_PropertyHistory.getHistory(requests);
		Test.stopTest();

		// // Verify results
		System.assertEquals(2, results.size(), 'Should return two results');
		System.assertEquals(null, results[0].error, 'Error should be null for first request');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field != \'Created\') ) FROM Property__c WHERE (ID IN (SELECT ParentId FROM Property__History WHERE (Field != \'Created\') ))',
			results[0].SOQL,
			'SOQL Query not the expected one'
		);
		System.assertEquals(null, results[1].error, 'Error should be null for second request');
		System.assertEquals(
			'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories WHERE (Field = \'Name\') AND (Field != \'Created\') ) FROM Property__c WHERE (ID IN (SELECT ParentId FROM Property__History WHERE (Field = \'Name\') AND (Field != \'Created\') ))',
			results[1].SOQL,
			'SOQL Query not the expected one'
		);
	}
}
