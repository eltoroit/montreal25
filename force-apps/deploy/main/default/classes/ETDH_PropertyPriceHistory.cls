public with sharing class ETDH_PropertyPriceHistory {
	@InvocableMethod(label='ETDH: Property Price History' description='Retrieve price history information for a property')
	public static List<AgentResult> getHistory(List<AgentRequest> requests) {
		List<AgentResult> results = new List<AgentResult>();

		for (AgentRequest request : requests) {
			results.add(getHistory(request));
		}
		return results;
	}

	private static AgentResult getHistory(AgentRequest request) {
		AgentResult result = new AgentResult();
 
		try {
			result.error = null;
			result.priceChanges = [
				SELECT Id, (SELECT Id, DateChanged__c, OldPrice__c, NewPrice__c FROM PropertyPricesHistory__r ORDER BY DateChanged__c DESC)
				FROM Property__c
				WHERE ID = :request.PropertyID
			]
			.PropertyPricesHistory__r;
		} catch (Exception e) {
			System.debug(e.getMessage());
			result.error = 'An error has occurred' + e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber();
		}
		return result;
	}

	// Handles the changes to the property prices, invoked from before update trigger
	public static void updatePriceHistory(List<Property__c> newProperties, Map<Id, Property__c> oldProperties) {
		List<PropertyPriceHistory__c> phs = new List<PropertyPriceHistory__c>();
		for (Property__c newProperty : newProperties) {
			Property__c oldProperty = new Property__c();
			if (oldProperties != null) {
				oldProperty = oldProperties.get(newProperty.Id);
			}
			if (newProperty.Price__c != oldProperty.Price__c) {
				PropertyPriceHistory__c ph = new PropertyPriceHistory__c();
				ph.Property__c = newProperty.Id;
				ph.OldPrice__c = oldProperty.Price__c;
				ph.NewPrice__c = newProperty.Price__c;
				ph.DateChanged__c = System.now();
				phs.add(ph);
			}
		}

		if (phs.size() > 0) {
			insert phs;
		}
	}

	public class AgentRequest {
		@InvocableVariable(required=true description='Property ID of th eproperty to get the price history for')
		public ID PropertyID;
	}

	public class AgentResult {
		@InvocableVariable(required=false description='List of price changes')
		public List<PropertyPriceHistory__c> priceChanges;
		@InvocableVariable(required=false description='Error message')
		public String error;
	}
}
