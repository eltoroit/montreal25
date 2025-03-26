public with sharing class HRPTO_EntitlementsPTO {
	@InvocableMethod(
		label='HRPTO: Entitlements PTO'
		description='This action finds the PTO entitlements for the employee based on the employment start date'
	)
	public static List<AgentOutput> EntitlementsPTO(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				output.success = false;
				output.errorMessage = 'Validating...';
				output.ptoEntitlement = null;

				output.ptoEntitlement = PTOCalculator.calculatePTO(input.employmentStartDate);
				output.success = true;
				output.errorMessage = null;
			} catch (Exception e) {
				output.errorMessage = 'Error: ' + e.getMessage();
			}

			// Add to the output list
			outputList.add(output);
		}
		return outputList;
	}

	public class AgentInput {
		@InvocableVariable(description='Date the employee started working for the company' required=true)
		public Date employmentStartDate;
	}

	public class AgentOutput {
		@InvocableVariable(description='Text describing the PTO entitlements for this user')
		public String ptoEntitlement;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Captures any error messages')
		public String errorMessage;
	}
}
