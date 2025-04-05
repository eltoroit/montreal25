// sf apex run --file '/Users/aperez/Git Projects/current/AgentForce/08.Montreal/@ELTOROIT/scripts/apex/prompts/ShowLocationInformation.apex' | grep "USER_DEBUG"

List<ETDH_ZipCodeLocationInformation.AgentRequest> requests = new List<ETDH_ZipCodeLocationInformation.AgentRequest>();
ETDH_ZipCodeLocationInformation.AgentRequest request = new ETDH_ZipCodeLocationInformation.AgentRequest();
Property__c property = [SELECT Id FROM Property__c LIMIT 1];
request.propertyID = property.Id;
request.interest = 'everything';
// request.interest = 'Schools';
// request.interest = 'General Information';
requests.add(request);
List<ETDH_ZipCodeLocationInformation.AgentResult> results = ETDH_ZipCodeLocationInformation.getZipCodeInfo(requests);
for (ETDH_ZipCodeLocationInformation.AgentResult result : results) {
	if (result.error != null) {
		System.debug('Error: ' + result.error);
	}
}
