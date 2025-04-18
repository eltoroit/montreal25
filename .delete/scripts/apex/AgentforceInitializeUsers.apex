AgentforceUserHelper helper = new AgentforceUserHelper();

helper.assignPermissions(
	// agent001@<ORG_ID>.ext => Human Resources
	helper.createUser(1, 'HumanResources Agent'),
	// PermisisonSet Names
	new List<String>{ 'AgentforceServiceAgentBase' },
	//  PermisisonSetGroup Names
	new List<String>{ 'AgentforceServiceAgentUserPsg' }
);
helper.assignPermissions(
	// agent002@<ORG_ID>.ext => Geography
	helper.createUser(2, 'Geography Agent'),
	// PermisisonSet Names
	new List<String>{ 'AgentforceServiceAgentBase' },
	//  PermisisonSetGroup Names
	new List<String>{ 'AgentforceServiceAgentUserPsg' }
);
// assignPermissions([SELECT Id FROM User WHERE Name = 'Platform Integration User'], new List<String>{ 'sfdc_chatbot_service_permset' }, new List<String>{});
insert helper.psas;

// throw new AuraException('DO NOT COMMIT');

