// Get global describe
Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
Integer globalDescribeCount = globalDescribe.size();

// Lists to store our results
List<Map<String, Object>> searchableObjects = new List<Map<String, Object>>();
List<String> objectNames = new List<String>();
Map<String, Map<String, Object>> objectDetailsByName = new Map<String, Map<String, Object>>();

// Process each SObject
for (String sObjectName : globalDescribe.keySet()) {
	Schema.DescribeSObjectResult describeResult = globalDescribe.get(sObjectName).getDescribe();

	// Check if the object is searchable
	if (describeResult.isSearchable()) {
		// Create a map to store all object details
		Map<String, Object> objectDetails = new Map<String, Object>{
			'name' => describeResult.getName(),
			'label' => describeResult.getLabel(),
			'pluralLabel' => describeResult.getLabelPlural(),
			'keyPrefix' => describeResult.getKeyPrefix(),
			'isAccessible' => describeResult.isAccessible(),
			'isCreateable' => describeResult.isCreateable(),
			'isCustom' => describeResult.isCustom(),
			'isCustomSetting' => describeResult.isCustomSetting(),
			'isDeletable' => describeResult.isDeletable(),
			'isDeprecatedAndHidden' => describeResult.isDeprecatedAndHidden(),
			'isFeedEnabled' => describeResult.isFeedEnabled(),
			'isMergeable' => describeResult.isMergeable(),
			'isMruEnabled' => describeResult.isMruEnabled(),
			'isQueryable' => describeResult.isQueryable(),
			'isSearchable' => describeResult.isSearchable(),
			'isUndeletable' => describeResult.isUndeletable(),
			'isUpdateable' => describeResult.isUpdateable()
		};

		// Store the object name for sorting
		String name = describeResult.getName();
		objectNames.add(name);
		objectDetailsByName.put(name, objectDetails);
	}
}

// Sort the object names
objectNames.sort();

// Create the final sorted list
for (String name : objectNames) {
	searchableObjects.add(objectDetailsByName.get(name));
}

// Count of searchable objects
Integer searchableObjectCount = searchableObjects.size();

// Output the counts
System.debug('Total objects in globalDescribe: ' + globalDescribeCount);
System.debug('Total searchable objects: ' + searchableObjectCount);

// Convert to JSON and output
String jsonOutput = JSON.serializePretty(searchableObjects);
System.debug(jsonOutput);
