public class PTOCalculator {
	// PTOCalculator.calculatePTO(Date.valueOf('2014-10-03'));
	public static String calculatePTO(Date dtStart) {
		String response = '';
		String jsonPayload = makePayload(dtStart);
		Map<String, String> loginResults = login();
		if (loginResults.containsKey('SERVER_URL') && loginResults.containsKey('SESSION_ID')) {
			response = makeCallout(jsonPayload, loginResults);
		} else {
			response = loginResults.get('ERROR');
		}
		return response;
	}

	private static String convertDate(Date dt) {
		String strDT = DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyy-MM-dd');
		return strDT;
	}
	private static String makePayload(Date dtStart) {
		String strToday = convertDate(Date.today());
		String strStart = convertDate(dtStart);

		// Prepare the payload with dynamic values
		Map<String, Object> valueMap = new Map<String, Object>{
			'Input:dtStart' => new Map<String, String>{ 'value' => strStart },
			'Input:dtToday' => new Map<String, String>{ 'value' => strToday }
		};

		Map<String, Object> inputParams = new Map<String, Object>{ 'valueMap' => valueMap };

		Map<String, Object> additionalConfig = new Map<String, Object>{
			'numGenerations' => 1,
			'temperature' => 0,
			'frequencyPenalty' => 0.0,
			'presencePenalty' => 0.0,
			'additionalParameters' => new Map<String, Object>(),
			'applicationName' => 'PromptBuilderPreview'
		};

		Map<String, Object> payload = new Map<String, Object>{
			'isPreview' => false,
			'inputParams' => inputParams,
			'additionalConfig' => additionalConfig
		};

		// Convert the payload to JSON format
		String jsonPayload = JSON.serialize(payload);
		return jsonPayload;
	}
	private static String makeCallout(String jsonPayload, Map<String, String> loginResults) {
		String output;

		Http http = new Http();
		HttpRequest req = new HttpRequest();
		// req.setEndpoint('callout:RAG_Demo_NC/services/data/v62.0/einstein/prompt-templates/Calculate_PTO_Days/generations');
		req.setEndpoint(loginResults.get('SERVER_URL') + '/services/data/v62.0/einstein/prompt-templates/Calculate_PTO_Days/generations');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Authorization', 'Bearer ' + loginResults.get('SESSION_ID'));
		req.setTimeout(120000); // timeout in milliseconds
		req.setBody(jsonPayload);
		HttpResponse res = http.send(req);
		if (res.getStatusCode() == 201) {
			output = 'ERROR: Not able to parse.';
			String jsonResponse = res.getBody();
			Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
			List<Object> responseMessages = (List<Object>) jsonMap.get('responseMessages');
			if (!responseMessages.isEmpty()) {
				Map<String, Object> firstMessage = (Map<String, Object>) responseMessages[0];
				output = (String) firstMessage.get('content');
				output = output.unescapeHtml4();
			} else {
				output = 'ERROR: No response messages found.';
			}
		} else {
			output = 'Error: ' + res.getStatusCode() + ' - ' + res.getBody();
		}
		return output;
	}

	// PTOCalculator.login();
	private static Map<String, String> login() {
		HttpResponse res;
		String reqBody = '';
		Http http = new Http();
		Map<String, String> loginResults = new Map<String, String>();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://login.salesforce.com/services/Soap/c/62.0');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=utf-8');
		req.setHeader('SOAPAction', '""');
		req.setTimeout(120000); // timeout in milliseconds
		reqBody += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">';
		reqBody += '<soapenv:Body>';
		reqBody += '<urn:login>';
		reqBody += '<urn:username>' + 'storm.c7bec8596f03a1@salesforce.com' + '</urn:username>';
		reqBody += '<urn:password>' + 'sfdx1234' + '</urn:password>';
		reqBody += '</urn:login>';
		reqBody += '</soapenv:Body>';
		reqBody += '</soapenv:Envelope>';
		req.setBody(reqBody);
		res = http.send(req);
		if (res.getStatusCode() == 200) {
			String urn = 'urn:enterprise.soap.sforce.com';
			String soapenv = 'http://schemas.xmlsoap.org/soap/envelope/';

			loginResults.put('ERROR', 'ERROR: Not able to parse.');
			String xmlResponse = res.getBody();
			System.debug(xmlResponse);

			Dom.Document xmlDoc = new Dom.Document();
			xmlDoc.load(xmlResponse);
			Dom.XmlNode xmlEnvelope = xmlDoc.getRootElement();
			Dom.XmlNode xmlBody = xmlEnvelope.getChildElement('Body', soapenv);
			Dom.XmlNode xmlLoginResponse = xmlBody.getChildElement('loginResponse', urn);
			Dom.XmlNode xmlResultNode = xmlLoginResponse.getChildElement('result', urn);
			String serverUrl = xmlResultNode.getChildElement('serverUrl', urn)?.getText();
			String sessionId = xmlResultNode.getChildElement('sessionId', urn)?.getText();

			loginResults.put('SERVER_URL', serverUrl.substring(0, serverUrl.indexOf('/services')));
			loginResults.put('SESSION_ID', sessionId);
			loginResults.remove('ERROR');
		} else {
			loginResults.put('ERROR', 'Error: ' + res.getStatusCode() + ' - ' + res.getBody());
		}
		return loginResults;
	}
}
