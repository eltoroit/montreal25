public with sharing class HRPTO_ListPTO {
	@InvocableMethod(label='HRPTO: View list of PTO Requests' description='This action shows the list of PTO request made by the employee.')
	public static List<AgentOutput> ListPTO(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				// Set default output
				output.success = false;
				output.ptoRequests = null;
				output.message = 'Pending...';

				// Find employee
				User employee = [SELECT ID, Username, Name, Email, StartDate__c, TimeZoneSidKey FROM User WHERE id = :input.employeeId];

				// Make callout to get list of PTO Requests
				HttpResponse resp = makeCallout(employee);
				if (resp.getStatusCode() == 200) {
					output.success = true;
					PTOList ptoList = (PTOList) JSON.deserialize(resp.getBody(), PTOList.class);
					// Agentforce action can take non-primitive types
					output.ptoRequests = ptoList;
					output.message = ptoList.Size + ' PTO active requests found';
				} else {
					output.message = resp.getBody().split('\n')[0];
				}
			} catch (Exception e) {
				output.message = 'Error: ' + e.getMessage();
			}

			// Add to the output list
			outputList.add(output);
		}
		return outputList;
	}

	private static HttpResponse makeCallout(User employee) {
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://agentforce-pto-5f6806bdc77f.herokuapp.com/findEvents?query=' + employee.Email);
		req.setMethod('GET');
		HttpResponse resp = http.send(req);

		System.debug('Status Code: ' + resp.getStatusCode());
		System.debug('Status: ' + resp.getStatus());
		System.debug('Body: ' + resp.getBody());
		return resp;
	}

	private class PTOList {
		private Integer Size { get; set; }
		private List<PTORequest> items { get; set; }
	}

	private class PTORequest {
		private String id { get; set; }
		private String summary { get; set; }
		private String description { get; set; }
		private DateTime startDTTM { get; set; }
		private DateTime endDTTM { get; set; }
		private String creator { get; set; }
		private List<String> attendees { get; set; }
		private String status { get; set; }
		private String timeZone { get; set; }
		private Decimal durationHours { get; set; }
		private Boolean isFullDay { get; set; }
	}

	public class AgentInput {
		@InvocableVariable(description='ID for the employee who is making the PTO request' required=true)
		public String employeeID;
	}

	public class AgentOutput {
		@InvocableVariable(description='List of PTO requests')
		public PTOList ptoRequests;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Messages for the agent')
		public String message;
	}
}
