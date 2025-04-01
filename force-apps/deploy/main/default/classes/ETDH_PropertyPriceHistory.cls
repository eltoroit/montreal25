public with sharing class ETDH_PropertyPriceHistory {
	@InvocableMethod(label='ETDH: Property Price History' description='Retrieve price history information for properties')
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
			Map<Id, List<PriceHistoryItem>> mapPriceHistory = new Map<Id, List<PriceHistoryItem>>();
			List<Property__c> properties = [SELECT Id, PriceHistory__c FROM Property__c WHERE ID IN :request.PropertyIDs];
			for (Property__c property : properties) {
				List<PriceHistoryItem> priceHistory = new List<PriceHistoryItem>();
				if (property.PriceHistory__c != null) {
					priceHistory = (List<PriceHistoryItem>) JSON.deserialize(property.PriceHistory__c, List<PriceHistoryItem>.class);
				}
				mapPriceHistory.put(property.Id, priceHistory);
			}
			result.priceHistory = JSON.serialize(mapPriceHistory);
		} catch (Exception e) {
			System.debug(e.getMessage());
			result.error = 'An error has occurred' + e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber();
		}
		return result;
	}

	// Handles the changes to the property prices, invoked from before update trigger
	public static void updatePriceHistory(List<Property__c> newProperties, Map<Id, Property__c> oldProperties) {
		for (Property__c newProperty : newProperties) {
			Property__c oldProperty = oldProperties.get(newProperty.Id);
			if (newProperty.Price__c != oldProperty.Price__c) {
				// Parse old prices
				List<PriceHistoryItem> priceHistory = new List<PriceHistoryItem>();
				if (newProperty.PriceHistory__c != null) {
					priceHistory = (List<PriceHistoryItem>) JSON.deserialize(newProperty.PriceHistory__c, List<PriceHistoryItem>.class);
				}

				// Add new price to list
				PriceHistoryItem historyItem = new PriceHistoryItem();
				historyItem.dateChange = System.now();
				historyItem.oldPrice = oldProperty.Price__c;
				historyItem.newPrice = newProperty.Price__c;
				priceHistory.add(historyItem);

				// Stringify (JSON) price history
				newProperty.PriceHistory__c = JSON.serialize(priceHistory);
			}
		}
	}

	public class AgentRequest {
		@InvocableVariable(required=true description='List of Property IDs to get the price history for')
		public List<ID> PropertyIDs;
	}

	public class AgentResult {
		@InvocableVariable(required=false description='JSON object with the list of price changes for each property')
		public String priceHistory;
		@InvocableVariable(required=false description='Error message')
		public String error;
	}

	public class PriceHistoryItem {
		public DateTime dateChange;
		public Decimal oldPrice;
		public Decimal newPrice;
	}
}
