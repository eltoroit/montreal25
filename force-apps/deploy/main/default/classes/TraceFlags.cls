public class TraceFlags {
	public class CustomException extends Exception {}

	// TraceFlags.createTrace();
	public static void createTrace() {
		String userId = UserInfo.getUserId(); // Get the current user ID
		String debugLevelId = getDebugLevelId('FINEST');

		HttpResponse res = TraceFlags.makeCallout(
			'sobjects/TraceFlag',
			'POST',
			new Map<String, Object>{
				'TracedEntityId' => userId,
				'DebugLevelId' => debugLevelId,
				'StartDate' => Datetime.now(),
				'ExpirationDate' => +Datetime.now().addHours(24),
				'LogType' => 'USER_DEBUG'
			}
		);

		if (res.getStatusCode() == 201) {
			System.debug('TraceFlag created successfully: ' + res.getBody());
		} else {
			throw new CustomException('Failed to create TraceFlag: ' + res.getStatusCode() + ' ' + res.getBody());
		}
	}

	// TraceFlags.deleteTrace();
	public static void deleteTrace() {
		String userId = UserInfo.getUserId(); // Get the current user ID
		String debugLevelId = getDebugLevelId('FINEST');

		HttpResponse res = TraceFlags.makeCallout(
			'sobjects/TraceFlag',
			'POST',
			new Map<String, Object>{
				'TracedEntityId' => userId,
				'DebugLevelId' => debugLevelId,
				'StartDate' => Datetime.now(),
				'ExpirationDate' => +Datetime.now().addHours(24),
				'LogType' => 'USER_DEBUG'
			}
		);

		if (res.getStatusCode() == 201) {
			System.debug('TraceFlag created successfully: ' + res.getBody());
		} else {
			throw new CustomException('Failed to create TraceFlag: ' + res.getStatusCode() + ' ' + res.getBody());
		}
	}

	// TraceFlags.getDebugLevelId('FINEST');
	public static String getDebugLevelId(String developerName) {
		HttpResponse res = TraceFlags.makeCallout('/query/?q=SELECT+Id+FROM+DebugLevel+WHERE+DeveloperName+=+\'' + developerName + '\'', 'GET', null);

		if (res.getStatusCode() == 200) {
			System.debug('TraceFlag created successfully: ' + res.getBody());
		} else {
			throw new CustomException('Failed to create TraceFlag: ' + res.getStatusCode() + ' ' + res.getBody());
		}

		return '7dlQL000000cwZFYAY';
	}

	private static HttpResponse makeCallout(String toolingEndpoint, String method, Map<String, Object> requestBody) {
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/v60.0/tooling/' + toolingEndpoint);
		req.setMethod(method);
		req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		if (method == 'PATCH' || method == 'POST' || method == 'PUT') {
			req.setHeader('Content-Type', 'application/json');
			req.setBody(JSON.serialize(requestBody));
		}
		HttpResponse res = http.send(req);
		System.debug('Status Code: ' + res.getStatusCode());
		System.debug('Status: ' + res.getStatus());
		System.debug('Body: ' + res.getBody());
		return res;
	}
}
