// sf apex run --file '/Users/aperez/Git Projects/current/AgentForce/08.Montreal/@ELTOROIT/scripts/apex/prompts/FindProperties.apex' | grep "USER_DEBUG"

List<ETDH_QueryProperties.AgentRequest> requests = new List<ETDH_QueryProperties.AgentRequest>();
ETDH_QueryProperties.AgentRequest request = new ETDH_QueryProperties.AgentRequest();
request.query = 'Show All Properties';
request.sObjectName = 'Property__c';
requests.add(request);
List<ETDH_QueryProperties.AgentResult> results = ETDH_QueryProperties.queryProperties(requests);
for (ETDH_QueryProperties.AgentResult result : results) {
	if (result.error != null) {
		System.debug('Error: ' + result.error);
	} else {
		ETDH_Helpers.debugStringInChunks('ExecAnon: Records', JSON.serialize(result.records), 100);
	}
}
