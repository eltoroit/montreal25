public with sharing class HRPTO_TemplateAction {
	@InvocableMethod(label='HRPTO: Template' description='This action is a template')
	public static List<AgentOutput> TemplateAction(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				output.name = null;
				output.success = false;
				output.message = 'Pending...';

				// After a succesful operation
				output.name = 'TEST';
				output.success = true;
				output.message = 'Operation succesful';
			} catch (Exception e) {
				output.message = 'Error: ' + e.getMessage();
			}

			// Add to the output list
			outputList.add(output);
		}
		return outputList;
	}

	public class AgentInput {
		@InvocableVariable(description='Employee\'s email address' required=true)
		public String emailAddress;
	}

	public class AgentOutput {
		@InvocableVariable(description='XXXX')
		public String name;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Messages for the agent')
		public String message;
	}
}
