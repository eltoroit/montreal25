public with sharing class HRPTO_DeletePTO {
	@InvocableMethod(label='HRPTO: Delete PTO Request' description='This action deletes the PTO request, agent must provide the ptoID for the request to be deleted')
	public static List<AgentOutput> DeletePTO(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				// Set default output
				output.success = false;
				output.message = 'Pending...';

				// Make callout to delete PTO Request
				HttpResponse resp = makeCallout(input);
				if (resp.getStatusCode() == 200) {
					output.success = true;
					output.message = 'Event deleted';
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

	private static HttpResponse makeCallout(AgentInput input) {
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://agentforce-pto-5f6806bdc77f.herokuapp.com/event?id=' + input.ptoID);
		req.setMethod('DELETE');
		HttpResponse resp = http.send(req);

		System.debug('Status Code: ' + resp.getStatusCode());
		System.debug('Status: ' + resp.getStatus());
		System.debug('Body: ' + resp.getBody());
		return resp;
	}

	public class AgentInput {
		@InvocableVariable(description='ID for the PTO Request to delete' required=true)
		public String ptoID;
	}

	public class AgentOutput {
		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Messages for the agent')
		public String message;
	}
}
