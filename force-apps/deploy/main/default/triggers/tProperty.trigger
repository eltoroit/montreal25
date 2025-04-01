trigger tProperty on Property__c(after insert, after update) {
	switch on Trigger.operationType {
		when AFTER_INSERT, AFTER_UPDATE {
			ETDH_PropertyPriceHistory.updatePriceHistory(Trigger.new, Trigger.oldMap);
		}
	}
}
