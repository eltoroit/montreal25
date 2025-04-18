public with sharing class ETDH_ZipCodeLocationFormatter {
	public static String format(String zipCodeInfo, ETDH_ZipCodeLocationInformation.AgentRequest request, Property__c property) {
/* REMOVE THIS LINE
		// Create Prompt Input Parameter Variables
		Map<String, String> propertyId = new Map<String, String>{ 'id' => property.Id };
		Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
		addValue(inputParams, 'Input:ZipCode_Data', zipCodeInfo);
		addValue(inputParams, 'Input:Interest', request.interest);
		addValue(inputParams, 'Input:Property', propertyId);

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
			'ETDH_Analyze_ZipCode_information',
			promptGenerationsInput
		);

		// Consume response
		ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
		return ETAI_Helpers.extractHtml(response.text);
	}

	private static ConnectApi.WrappedValue addValue(Map<String, ConnectApi.WrappedValue> inputParams, String name, Object value) {
		ConnectApi.WrappedValue inputValue = new ConnectApi.WrappedValue();
		inputValue.value = value;
		inputParams.put(name, inputValue);
		return inputValue;
REMOVE THIS LINE */
		return 'APEX CODE HAS BEEN REMOVED FOR DEPLOYMENT! Modify code before execution, remove this line and the comments. [Apex class: ETDH_ZipCodeLocationFormatter]';
	}
}
