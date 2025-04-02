trigger tProperty on Property__c(after insert, after update) {
	switch on Trigger.operationType {
		when AFTER_INSERT {
			// I only want the price changes in that table, not the initial value.
			// ETDH_PropertyPriceHistory.updatePriceHistory(Trigger.new, Trigger.oldMap);
		}
		when AFTER_UPDATE {
			ETDH_PropertyPriceHistory.updatePriceHistory(Trigger.new, Trigger.oldMap);
		}
	}
}