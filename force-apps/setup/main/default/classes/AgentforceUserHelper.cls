public without sharing class AgentforceUserHelper {
	private Profile profile;
	public List<PermissionSetAssignment> psas = new List<PermissionSetAssignment>();
	public Map<String, Id> permSets = new Map<String, Id>();
	public Map<String, Id> permSetGroups = new Map<String, Id>();

	public AgentforceUserHelper() {
		profile = [SELECT Id FROM Profile WHERE Name = 'Einstein Agent User' LIMIT 1];
		for (PermissionSet permSet : [SELECT Id, Name FROM PermissionSet]) {
			permSets.put(permSet.Name, permSet.Id);
		}
		for (PermissionSetGroup permSetGroup : [SELECT Id, DeveloperName FROM PermissionSetGroup]) {
			permSetGroups.put(permSetGroup.DeveloperName, permSetGroup.Id);
		}
	}

	public User getUser(Integer agentNumber) {
		return [SELECT Id FROM User WHERE Username = :getUserName(agentNumber)];
	}

	public User createUser(Integer agentNumber, String agentName) {
		String username = getUserName(agentNumber);
		List<String> words = agentName.split(' ', 2); // {'word1', 'word2 word3 word4...'}
		User u = new User(
			Username = username,
			FirstName = words[0],
			LastName = words.size() > 1 ? words[1] : 'LAST_NAME_PLACEHOLDER',
			Email = 'noreply@salesforce.com',
			// UserLicense='Einstein Agent',
			ProfileId = profile.Id,
			EmailEncodingKey = 'UTF-8',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			Alias = 'Agent'
		);
		insert u;
		return u;
	}

	public void assignPermissions(User u, List<String> permSetNames, List<String> permSetGroupNames) {
		for (String permSetName : permSetNames) {
			Id permSetId = permSets.get(permSetName);
			if (permSetId != null) {
				psas.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = permSetId));
			} else {
				throw new AuraException('Permission Set not found: ' + permSetName);
			}
		}

		for (String permSetGroupName : permSetGroupNames) {
			Id permSetGroupId = permSetGroups.get(permSetGroupName);
			if (permSetGroupId != null) {
				psas.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetGroupId = permSetGroupId));
			} else {
				throw new AuraException('Permission Set Group not found: ' + permSetGroupName);
			}
		}
	}

	private String getUserName(Integer agentNumber) {
		return 'agent' + String.valueOf(agentNumber).leftPad(3, '0') + '@' + UserInfo.getOrganizationId() + '.ext';
	}
}
