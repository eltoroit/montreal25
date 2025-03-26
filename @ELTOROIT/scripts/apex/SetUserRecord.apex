// sfdx force:apex:execute -f ./@ELTOROIT/scripts/apex/SetUserRecord.apex

// Find me
User me = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

// Enable debug mode for the default scratch org user
me.UserPreferencesUserDebugModePref = true;
me.FirstName = 'Andres';
me.LastName = 'Perez';
me.StartDate__c = Date.valueOf('2024-10-03');
update me;
