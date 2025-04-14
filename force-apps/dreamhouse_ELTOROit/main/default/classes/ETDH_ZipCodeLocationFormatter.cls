public with sharing class ETDH_ZipCodeLocationFormatter {
	public static String format(String zipCodeInfo, ETDH_ZipCodeLocationInformation.AgentRequest request, Property__c property) {
		// Create Prompt Input Parameter Variables
		Map<String, String> propertyId = new Map<String, String>{ 'id' => property.Id };
		Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
		ETAI_Helpers.addValue(inputParams, 'Input:ZipCode_Data', zipCodeInfo);
		ETAI_Helpers.addValue(inputParams, 'Input:Interest', request.interest);
		ETAI_Helpers.addValue(inputParams, 'Input:Property', propertyId);

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
}
