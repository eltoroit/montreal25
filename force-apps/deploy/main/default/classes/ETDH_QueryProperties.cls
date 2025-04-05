public with sharing class ETDH_QueryProperties {
	@InvocableMethod(label='ETDH: Query Property and related records' description='Retrieves property and related information')
	public static List<AgentResult> queryProperties(List<AgentRequest> requests) {
		List<AgentResult> results = new List<AgentResult>();

		for (AgentRequest request : requests) {
			results.add(queryProperties(request));
		}
		return results;
	}

	private static AgentResult queryProperties(AgentRequest request) {
		AgentResult result = new AgentResult();

		try {
			result.error = null;
			String queryJson = createSOQL(request);
			Map<String, Object> query = (Map<String, Object>) JSON.deserializeUntyped(queryJson);
			if (query.containsKey('error')) {
				result.error = queryJson;
			} else {
				String SOQL = (String) query.get('query');
				ETAI_Helpers.debugStringInChunks('ETDH_QueryProperties.queryProperties(): SOQL', SOQL, 100);
				result.records = Database.query(SOQL);
			}
		} catch (Exception e) {
			ETAI_Helpers.debugStringInChunks('ETDH_QueryProperties.queryProperties(): Exception', JSON.serialize(e.getMessage()), 100);
			result.error = 'An error has occurred' + e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber();
		}
		return result;
	}

	public class AgentRequest {
		@InvocableVariable(
			required=true
			description='The question or request from the user\'s input. Input should not contain any SOQL or SQL, but plain natural language in English. Do not generate SQL or SOQL.'
		)
		public String query;
		@InvocableVariable(required=true description='Salesforce object type, such as Account, Lead, Contact, or custom object')
		public String sObjectName;
	}

	public class AgentResult {
		@InvocableVariable(required=false description='A list of matching Salesforce CRM records with details about each record.')
		public List<SObject> records;
		@InvocableVariable(required=false description='Error message')
		public String error;
	}

	private static String createSOQL(AgentRequest request) {
		// Create Prompt Input Parameter Variables
		Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
		ETAI_Helpers.addValue(inputParams, 'Input:Question', request.query);
		ETAI_Helpers.addValue(inputParams, 'Input:ObjectName', request.sObjectName);
		ETAI_Helpers.addValue(inputParams, 'Input:ObjectSchema', ETAI_Helpers.getSObjectMetadata(request.sObjectName));
		ETAI_Helpers.addValue(
			inputParams,
			'Input:AdditionalInstructions',
			'- Properties can be identified by their Record Id (18 characters), Name (for example 123 Main Street), Address__c (for example 123 Main Street), Zip__c (five digits, for example 02123) or other attributes (bedrooms, bathrooms, ...).'
		);

		// Set the prompt service
		ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
		promptGenerationsInput.inputParams = inputParams;
		promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
		promptGenerationsInput.additionalConfig.numGenerations = 1;
		promptGenerationsInput.additionalConfig.enablePiiMasking = true;
		promptGenerationsInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';
		promptGenerationsInput.isPreview = false;

		// Call the prompt service to generate messages for the prompt template
		ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
			'ETDH_Generate_SOQL',
			promptGenerationsInput
		);

		// Consume response
		ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
		ETAI_Helpers.debugStringInChunks('ETDH_QueryProperties.createSOQL(): generationsOutput', JSON.serialize(response), 100);
		return ETAI_Helpers.extractJson(response.text);
	}
}
