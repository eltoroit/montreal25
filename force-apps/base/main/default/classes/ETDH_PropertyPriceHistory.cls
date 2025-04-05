public with sharing class ETDH_PropertyPriceHistory {
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
}
