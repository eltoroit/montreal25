public with sharing class ETDH_ZipCodeLocationInformation {
	@InvocableMethod(
		label='ETDH: Zipcode Location Information'
		description='Retrieves location information for the property ZipCode. You must provide either the Property ID or the Zip Code.'
	)
	public static List<AgentResult> getZipCodeInfo(List<AgentRequest> requests) {
		List<AgentResult> results = new List<AgentResult>();

		for (AgentRequest request : requests) {
			results.add(getZipCodeInfo(request));
		}
		return results;
	}

	private static AgentResult getZipCodeInfo(AgentRequest request) {
		AgentResult result = new AgentResult();

		try {
			result.error = null;
			Property__c property = [SELECT Id, Name, Address__c, City__c, State__c, Zip__c FROM Property__c WHERE Id = :request.propertyID];
			String zipCode = property.Zip__c;
			HttpRequest req = new HttpRequest();
			req.setEndpoint('callout:ETDH_ZipCode_Location_Information_NC/zip/' + zipCode);
			req.setMethod('GET');
			req.setTimeout(120000);

			try {
				Http http = new Http();
				HTTPResponse res = http.send(req);

				if (res.getStatusCode() == 200) {
					result.zipCodeInfo = formatZipCodeInfo(res.getBody(), request, property);
				} else {
					// Log the error and return null.  Important for debugging.
					result.error = ('Error: Zip Code API call failed with status code: ' + res.getStatusCode() + ', body: ' + res.getBody());
				}
			} catch (Exception e) {
				// Handle any exceptions (e.g., network errors, timeouts).
				result.error = ('Exception occurred during Zip Code API call: ' + e.getMessage());
			}
		} catch (Exception e) {
			System.debug(e.getMessage());
			result.error = 'An error has occurred' + e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber();
		}
		return result;
	}

	private static String formatZipCodeInfo(String zipCodeInfo, AgentRequest request, Property__c property) {
		// Create Prompt Input Parameter Variables
		ConnectApi.WrappedValue inputValue;
		Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();

		// Set each value
		inputValue = new ConnectApi.WrappedValue();
		inputValue.value = zipCodeInfo;
		inputParams.put('Input:ZipCode_Data', inputValue);

		inputValue = new ConnectApi.WrappedValue();
		inputValue.value = request.interest;
		inputParams.put('Input:Interest', inputValue);

		inputValue = new ConnectApi.WrappedValue();
		inputValue.value = new Map<String, String>{ 'id' => property.Id };
		inputParams.put('Input:Property', inputValue);

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
			'ETDH_Analyze_ZipCode_information2',
			promptGenerationsInput
		);

		// Consume response
		ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
		return ETDH_Helpers.extractHtml(response.text);
	}

	public class AgentRequest {
		@InvocableVariable(
			required=true
			description='What specific does the customer want to find in this zip code? Or does he want general information?'
		)
		public String interest;

		@InvocableVariable(
			required=true
			description='Property ID (18 characters record Id) for which we are trying to find the location information for.'
		)
		public String propertyID;
	}

	public class AgentResult {
		@InvocableVariable(required=false description='Location Information')
		public String zipCodeInfo;
		@InvocableVariable(required=false description='Error message')
		public String error;
	}
}
