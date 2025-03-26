AgentforceUserHelper helper = new AgentforceUserHelper();
helper.assignPermissions(
	// agent001@<ORG_ID>.ext => Human Resources
	helper.getUser(1),
	// PermisisonSet Names
	new List<String>{ 'psAgent_HumanResources_Permissions' },
	//  PermisisonSetGroup Names
	new List<String>{}
);
helper.assignPermissions(
	// agent002@<ORG_ID>.ext => Geography
	helper.getUser(2),
	// PermisisonSet Names
	new List<String>{ 'psAgent_HumanResources_Permissions' },
	//  PermisisonSetGroup Names
	new List<String>{}
);
insert helper.psas;

// throw new AuraException('DO NOT COMMIT');

