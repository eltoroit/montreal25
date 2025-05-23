public with sharing class TrialExpirationController {
	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getExpirationDaysLeft() {
		Map<String, Object> data = new Map<String, Object>();

		Organization org = [SELECT TrialExpirationDate FROM Organization];
		DateTime expDate = org.TrialExpirationDate;
		data.put('expDate', expDate);
		data.put('orgExpires', expDate != null);
		if (expDate != null) {
			data.put('daysLeft', Date.today().daysBetween(date.valueof(expDate)) - 1);
		}

		return data;
	}
}
