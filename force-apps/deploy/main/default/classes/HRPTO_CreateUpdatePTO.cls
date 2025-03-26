public with sharing class HRPTO_CreateUpdatePTO {
	@InvocableMethod(
		label='HRPTO: Create or Update a PTO request'
		description='This action creates or updates a PTO request. The ptoID is required when updating a request. The ptoID is not required when creating a new request. PTO requests can be done in whole days or fractions if requesting less than a day. When requesting less than a day, the start time is required'
	)
	public static List<AgentOutput> CreateUpdatePTO(List<AgentInput> inputList) {
		List<AgentOutput> outputList = new List<AgentOutput>();
		for (AgentInput input : inputList) {
			AgentOutput output = new AgentOutput();

			try {
				output.success = false;
				output.message = 'Pending...';
				output.ptoIDs = new List<String>();
				User employee = [SELECT ID, Username, Name, Email, StartDate__c, TimeZoneSidKey FROM User WHERE id = :input.employeeId];
				HttpResponse resp = makeCallout(input, employee);
				if (resp.getStatusCode() == 200) {
					List<Object> bodyPTOs = (List<Object>) JSON.deserializeUntyped(resp.getBody());
					for (Object bodyPTO : bodyPTOs) {
						Map<String, Object> mapBodyPTO = (Map<String, Object>) bodyPTO;
						String ptoId = (String) mapBodyPTO.get('id');
						output.ptoIDs.add(ptoId);
					}
					output.success = true;
					output.message = (input.ptoID != null ? 'Updated' : 'Created') + ' ' + output.ptoIDs.size() + ' PTO requests';
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

	public class AgentInput {
		private DateTime ptoStartDTTM, ptoEndDTTM;

		@InvocableVariable(description='ID for the PTO request. Required only when updating a PTO request')
		public String ptoID;

		@InvocableVariable(description='ID for the employee who is making the PTO request' required=true)
		public String employeeID;

		@InvocableVariable(description='Number of PTO days the employee is entitled to' required=true)
		public Decimal ptoEntitled;

		@InvocableVariable(description='Number of PTO days being requested' required=true)
		public Decimal ptoDays;

		@InvocableVariable(description='Date for the first day of the PTO' required=true)
		public Date ptoStartDate;

		@InvocableVariable(description='Start time for the PTO request. Required if asking for less than a day')
		public Time ptoStartTime;

		@InvocableVariable(description='End time for the PTO request. Required if asking for less than a day')
		public Time ptoEndTime;
	}

	public class AgentOutput {
		@InvocableVariable(description='IDs for the PTO request')
		public List<String> ptoIDs;

		@InvocableVariable(description='Indicates if the request was successful or not')
		public Boolean success;

		@InvocableVariable(description='Messages for the agent')
		public String message;
	}

	private class CalloutSchema {
		private User employee;
		private AgentInput ptoRequest;
	}

	private static HttpResponse makeCallout(AgentInput ptoRequest, User employee) {
		// Make callout body
		CalloutSchema body = new CalloutSchema();
		body.employee = employee;
		body.ptoRequest = ptoRequest;
		if (body.ptoRequest.ptoStartTime != null) {
			body.ptoRequest.ptoStartDTTM = makeDateTime(body.ptoRequest.ptoStartDate, body.ptoRequest.ptoStartTime, employee.TimeZoneSidKey);
		}
		if (body.ptoRequest.ptoEndTime != null) {
			body.ptoRequest.ptoEndDTTM = makeDateTime(body.ptoRequest.ptoStartDate, body.ptoRequest.ptoEndTime, employee.TimeZoneSidKey);
		}
		String jsonBody = JSON.serialize(body);

		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://agentforce-pto-5f6806bdc77f.herokuapp.com/requestPTO');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setBody(jsonBody);
		HttpResponse resp = http.send(req);

		System.debug('Status Code: ' + resp.getStatusCode());
		System.debug('Status: ' + resp.getStatus());
		System.debug('Body: ' + resp.getBody());
		return resp;
	}

	private static Datetime makeDateTime(Date myDate, Time myTime, String employeeTimeZone) {
		System.debug('myDate: ' + myDate);
		System.debug('myTime: ' + myTime);

		// This is "11 AM" (JSON.deserialize('"11:00:00"', Time.class)) for agent (running user), not for employee
		Datetime dttmAgent = Datetime.newInstanceGmt(myDate, myTime);
		System.debug('dttmAgent: ' + dttmAgent);
		System.debug(dttmAgent.formatLong());

		// Get Timezones
		TimeZone tzAgent = UserInfo.getTimeZone();
		Integer msOffsetAgent = tzAgent.getOffset(dttmAgent);
		System.debug('tzAgent: ' + tzAgent);
		System.debug('msOffsetAgent: ' + msOffsetAgent);

		TimeZone tzemployee = timeZone.getTimeZone(employeeTimeZone);
		Integer msOffsetEmployee = tzemployee.getOffset(dttmAgent);
		System.debug('tzemployee: ' + tzemployee);
		System.debug('msOffsetEmployee: ' + msOffsetEmployee);

		// Convert the time
		Integer Difference = msOffsetAgent - msOffsetEmployee;
		System.debug('Difference (hours): ' + (Difference / (1000 * 60 * 60)));
		Long msNewDTTM = dttmAgent.getTime() + Difference;
		Datetime newDTTM = Datetime.newInstance(msNewDTTM);
		System.debug(newDTTM.formatLong());

		return newDTTM;
	}
}
