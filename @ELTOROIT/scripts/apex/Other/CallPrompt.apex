public class AgentInput {
	@InvocableVariable(description='Canvas ID')
	public String canvasID;

	@InvocableVariable(required=true description='JSON string containing the list of events to display')
	public String eventsJSON;
}

AgentInput input = new AgentInput();
input.eventsJSON = '{"attributes":{"type":"Event","url":"/services/data/v62.0/sobjects/Event/00UKd00000R38ZqMAJ"},"Id":"00UKd00000R38ZqMAJ","OwnerId":"005Kd000005eoADIAY","Subject":"I need a break!","ActivityDate":"2025-01-17","Owner":{"attributes":{"type":"Name","url":"/services/data/v62.0/sobjects/User/005Kd000005eoADIAY"},"Id":"005Kd000005eoADIAY","Name":"Andres Perez"}},{"attributes":{"type":"Event","url":"/services/data/v62.0/sobjects/Event/00UKd00000R38ZvMAJ"},"Id":"00UKd00000R38ZvMAJ","OwnerId":"005Kd000005eoADIAY","Subject":"I need a longer break!","ActivityDate":"2025-01-18","Owner":{"attributes":{"type":"Name","url":"/services/data/v62.0/sobjects/User/005Kd000005eoADIAY"},"Id":"005Kd000005eoADIAY","Name":"Andres Perez"}}]';

// Get the canvas content
String canvasContent;
ConnectApi.WrappedValue wrappedValue = new ConnectApi.WrappedValue();
Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();

wrappedValue.value = input.eventsJSON;
inputParams.put('Input:calendarEvents', wrappedValue);

ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
executeTemplateInput.isPreview = false;
executeTemplateInput.inputParams = inputParams;
ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
	'Canvas_for_calendar_events',
	executeTemplateInput
);
// System.debug(generationsOutput);
canvasContent = generationsOutput.generations[0].text;
canvasContent = '# Title: ' + System.now().format() + '\n\n' + canvasContent;
// System.debug(canvasContent);
