public with sharing class HRPTO_ValidateOTP {
	@InvocableMethod(
		label='HRPTO: Validate OTP (one-time password)'
		description='This action authenticates the employee by validating the OTP (one-time password) for the employee (OTP_Employee) against the OTP (one-time password) for the agent (OTP_Agent)'
	)
	public static List<AgentOutput> ValidateOTP(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				if (input.OTP_Agent == input.OTP_Employee) {
					output.success = true;
					output.isValidOTP = true;
					output.errorMessage = null;
				} else {
					output.success = false;
					output.isValidOTP = false;
					output.errorMessage = 'Error: OTP (one-time password) does not match expected value';
				}
			} catch (Exception e) {
				output.errorMessage = 'Error: ' + e.getMessage();
			}

			// Add to the output list
			outputList.add(output);
		}
		return outputList;
	}

	public class AgentInput {
		@InvocableVariable(
			required=true
			description='OTP_Agent is the OTP (one-time password) the agent received when the action "HRPTO: Send OTP to employee" was called'
		)
		public String OTP_Agent;

		@InvocableVariable(required=true description='OTP_Employee is the OTP (one-time password) the employee entered when requested')
		public String OTP_Employee;
	}

	public class AgentOutput {
		@InvocableVariable(description='Indicates if the OTP (one-time password) is valid')
		public Boolean isValidOTP;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Captures any error messages')
		public String errorMessage;
	}
}
