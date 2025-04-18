// Execute Anonymous code to retrieve Contact metadata in JSON format
Map<String, Object> jsonOutput = new Map<String, Object>();

// Get the describe result for the Contact object
// Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Contact;
Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
Schema.DescribeSObjectResult describeResult = globalDescribe.get('Property__c').getDescribe();

// Add general object metadata
Map<String, Object> objectMetadata = new Map<String, Object>{
	// 'keyPrefix' => describeResult.getKeyPrefix(),
	// 'isCustom' => describeResult.isCustom(),
	// 'isCreateable' => describeResult.isCreateable(),
	// 'isUpdateable' => describeResult.isUpdateable(),
	// 'isDeletable' => describeResult.isDeletable(),
	// 'isQueryable' => describeResult.isQueryable(),
	// 'isAccessible' => describeResult.isAccessible()
	'apiName' => describeResult.getName(),
	'label' => describeResult.getLabel(),
	'labelPlural' => describeResult.getLabelPlural()
};
jsonOutput.put('objectMetadata', objectMetadata);

// Get all fields from the Contact object
Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
List<Map<String, Object>> fieldsList = new List<Map<String, Object>>();

// Process field information
for (String fieldName : fieldMap.keySet()) {
	Schema.DescribeFieldResult field = fieldMap.get(fieldName).getDescribe();

	Map<String, Object> fieldInfo = new Map<String, Object>{
		// 'length' => field.getLength(),
		// 'precision' => field.getPrecision(),
		// 'scale' => field.getScale(),
		// 'isCustom' => field.isCustom(),
		// 'isRequired' => !field.isNillable(), // isNillable() returns true when NOT required
		// 'isCreateable' => field.isCreateable(),
		// 'isUpdateable' => field.isUpdateable(),
		// 'isAccessible' => field.isAccessible(),
		// 'isExternalId' => field.isExternalId(),
		// 'isUnique' => field.isUnique(),
		// 'defaultValue' => field.getDefaultValue(),
		// 'helpText' => field.getInlineHelpText()
		'apiName' => field.getName(),
		'label' => field.getLabel(),
		'type' => String.valueOf(field.getType())
	};

	// // For picklist fields, include values
	// if (field.getType() == Schema.DisplayType.PICKLIST || field.getType() == Schema.DisplayType.MULTIPICKLIST) {
	// 	List<Map<String, Object>> picklistEntries = new List<Map<String, Object>>();

	// 	for (Schema.PicklistEntry ple : field.getPicklistValues()) {
	// 		picklistEntries.add(
	// 			new Map<String, Object>{
	// 				'label' => ple.getLabel(),
	// 				'value' => ple.getValue(),
	// 				'isActive' => ple.isActive(),
	// 				'isDefaultValue' => ple.isDefaultValue()
	// 			}
	// 		);
	// 	}

	// 	fieldInfo.put('picklistValues', picklistEntries);
	// }

	// For reference fields, include referenced objects
	if (field.getType() == Schema.DisplayType.REFERENCE) {
		List<String> references = new List<String>();
		for (Schema.SObjectType reference : field.getReferenceTo()) {
			references.add(reference.getDescribe().getName());
		}
		fieldInfo.put('referenceTo', references);
		fieldInfo.put('relationshipName', field.getRelationshipName());
	}

	fieldsList.add(fieldInfo);
}
jsonOutput.put('fields', fieldsList);

// Get child relationships
List<Map<String, Object>> childRelationships = new List<Map<String, Object>>();
for (Schema.ChildRelationship cr : describeResult.getChildRelationships()) {
	if (cr.getRelationshipName() != null) {
		childRelationships.add(
			new Map<String, Object>{
				// 'isCascadeDelete' => cr.isCascadeDelete()
				'relationshipName' => cr.getRelationshipName(),
				'childObject' => cr.getChildSObject().getDescribe().getName(),
				'field' => cr.getField().getDescribe().getName()
			}
		);
	}
}
jsonOutput.put('childRelationships', childRelationships);

// // Get record types
// List<Map<String, Object>> recordTypes = new List<Map<String, Object>>();
// Map<Id, Schema.RecordTypeInfo> recordTypeInfos = describeResult.getRecordTypeInfosById();
// for (Id recordTypeId : recordTypeInfos.keySet()) {
// 	Schema.RecordTypeInfo rti = recordTypeInfos.get(recordTypeId);
// 	recordTypes.add(
// 		new Map<String, Object>{
// 			'id' => recordTypeId,
// 			'name' => rti.getName(),
// 			'developerName' => rti.getDeveloperName(),
// 			'isAvailable' => rti.isAvailable(),
// 			'isMaster' => rti.isMaster()
// 		}
// 	);
// }
// jsonOutput.put('recordTypes', recordTypes);

// Convert to JSON and output
String jsonString = JSON.serializePretty(jsonOutput);
System.debug(jsonString);

// To ensure the full JSON is visible in logs, split into smaller chunks if needed
Integer maxLogSize = 100000; // Smaller than actual log line limit to be safe
if (jsonString.length() > maxLogSize) {
	for (Integer i = 0; i < jsonString.length(); i += maxLogSize) {
		Integer endIndex = Math.min(i + maxLogSize, jsonString.length());
		System.debug('JSON PART ' + ((i / maxLogSize) + 1) + ': ' + jsonString.substring(i, endIndex));
	}
}
