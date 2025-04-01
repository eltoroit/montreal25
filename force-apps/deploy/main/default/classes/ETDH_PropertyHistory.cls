public with sharing class ETDH_PropertyHistory {
	@InvocableMethod(label='ETDH: Property History' description='Retrieve history information for properties')
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
			// SELECT Id, (SELECT ID FROM Histories WHERE ....) FROM Property__c WHERE ....
			// WHERE History
			String WHERE_History = '';
			if (request.SOQL_WHERE_History != null) {
				WHERE_History += 'WHERE (' + request.SOQL_WHERE_History + ') AND ';
			} else {
				WHERE_History += 'WHERE ';
			}
			WHERE_History += '(Field != \'Created\') ';

			// WHERE Property
			String WHERE_Property = '';
			if (request.SOQL_WHERE_Property != null) {
				WHERE_Property += 'WHERE (' + request.SOQL_WHERE_Property + ') AND ';
			} else {
				WHERE_Property += 'WHERE ';
			}
			WHERE_Property += '(ID IN (SELECT ParentId FROM Property__History ' + WHERE_History + '))';

			String soql =
				'SELECT Id, (SELECT Id, ParentId, Field, DataType, OldValue, NewValue FROM Histories ' +
				WHERE_History +
				') FROM Property__c ' +
				WHERE_Property;

			System.debug(soql);
			result.SOQL = soql;
			result.properties = Database.query(soql);
		} catch (Exception e) {
			System.debug(e.getMessage());
			result.error = 'An error has occurred' + e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber();
		}
		return result;
	}

	public class AgentRequest {
		@InvocableVariable(required=false description='Criteria used to build the SOQL query, this is specifically to filter the history records')
		public String SOQL_WHERE_History;
		@InvocableVariable(required=false description='Criteria used to build the SOQL query, this is specifically to filter the property records')
		public String SOQL_WHERE_Property;
	}

	public class AgentResult {
		@InvocableVariable(required=false description='SOQL Query uses to find data')
		public String SOQL;
		@InvocableVariable(required=false description='Property with list of changes')
		public List<Property__c> properties;
		@InvocableVariable(required=false description='Error message')
		public String error;
	}
}
