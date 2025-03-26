public without sharing class HRPTO_FindEmployee {
	@InvocableMethod(
		label='HRPTO: Find Employee'
		description='This action receives the employee\'s email address and validates the user exits. The action can receive an OTP_OVERRIDE in whcih case no further action is taken. If no OTP is received then it generates an OTP (one-time password) and sends a copy via email to the employee (OTP_Employee) and one back to the agent (OTP_Agent). The agent must provide the employee email address'
	)
	public static List<AgentOutput> FindEmploye(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				output.success = false;
				output.message = 'Validating...';
				output.employeeID = null;
				output.name = null;
				output.startDate = null;
				output.OTP_Agent = null;
				output.isValidOTP = false;
				output.timeZone = null;
				List<User> users = [
					SELECT ID, Username, Name, Email, StartDate__c, TimeZoneSidKey
					FROM User
					WHERE Email = :input.emailAddress
				];
				if (users.size() == 1) {
					User employee = users[0];
					output.success = true;
					output.message = 'Employee found...';
					output.employeeID = employee.Id;
					output.name = employee.Name;
					output.startDate = employee.StartDate__c;
					output.OTP_Agent = String.valueOf(Integer.valueOf(Math.round(Math.random() * 899 + 100))); // Generates a random integer between 100 and 999
					if (input.OTP_OVERRIDE != null) {
						output.isValidOTP = true;
						output.message = 'OTP is valid';
					} else {
						output.message = 'Ask user to confirm the OTP';
					}
					output.timeZone = employee.TimeZoneSidKey;
				} else {
					output.message = 'Error: Expecting to find One and Only One user. Found: ' + users.size() + '';
				}
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

		@InvocableVariable(description='OTP Override to skip sending email' required=false)
		public String OTP_OVERRIDE;
	}

	public class AgentOutput {
		@InvocableVariable(description='ID for the employee')
		public String employeeID;

		@InvocableVariable(description='Employee name')
		public String name;

		@InvocableVariable(description='Employment start date')
		public Date startDate;

		@InvocableVariable(description='OTP_Agent (One-time password for agent)')
		public String OTP_Agent;

		@InvocableVariable(description='Indicates if the OTP is valid')
		public Boolean isValidOTP;

		@InvocableVariable(description='timezone for the employee')
		public String timeZone;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Messages for the agent')
		public String message;
	}
}
