trigger tProperty on Property__c(before update) {
	switch on Trigger.operationType {
		when BEFORE_UPDATE {
			ETDH_PropertyPriceHistory.updatePriceHistory(Trigger.new, Trigger.oldMap);
		}
	}
}
