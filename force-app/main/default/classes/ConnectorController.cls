global class ConnectorController {
	
	/**
	 * The main search request to find a contact/account/whatever etc 
	 **/
    @RemoteAction global static Object findContact(String searchId, String searchValue, String mediaType, Map<String, String> userData) {
        system.debug('findContact: searchId - ' + searchId +', searchValue - ' + searchValue + ', mediaType - ' + mediaType);
        String newsearchFieldValue = searchValue;
 		try {
			if(searchId=='Account.Employee_ID__c' && searchValue.length() < 6){
				newsearchFieldValue = searchValue.leftPad(6).replace(' ', '0');
			}
			if(searchId=='Account.Employee_ID__c' && searchValue.length() == 7 && searchValue.startsWith('0') ){
				newsearchFieldValue = searchValue.substring(1, searchValue.length());
			}

		    String query = 'SELECT Id, Name, AccountId FROM Contact WHERE ' + searchId  + ' = \'' + newsearchFieldValue + '\'';
		    system.debug('query = ' + query);            
		    List<Contact> contacts = Database.query(query);
		    
		    if (!contacts.isEmpty()) {
				Integer numContacts = contacts.size();
				system.debug('contacts found=' + numContacts);
				
				if (numContacts > 1) {
					Contact c = contacts[0];
					c.Id = null; // indicator for multiple contacts
					return c;
				}
				else if (numContacts == 1) {
					return contacts[0];
				}
		    }
        }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
        
        try {
	        // throw in an account search if we've found nothing while we're here
	        if (searchId == 'Email') {
	        	searchId = 'PersonEmail'; // person account version
	        }
	        String searchKey ='';
			if(searchId.contains('.')) {
				searchKey = searchId.substringAfter('.');
			}
	        String query = 'SELECT Id, Name FROM Account WHERE ' + searchKey  + ' = \'' + newsearchFieldValue + '\'';
	        List<Account> accounts = Database.query(query);
	        
	        if (!accounts.isEmpty()) {
				Integer numAccounts = accounts.size();
				system.debug('accounts found=' + numAccounts);
				
				if (numAccounts > 1) {
					Account c = accounts[0];
					c.Id = null; // indicator for multiple accounts
					return c;
				}
				else if (numAccounts == 1) {
					return accounts[0];
				}
	        }
        }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
	    
        try {    
	        // and lead as well
	        String query = 'SELECT Id, Name FROM Lead WHERE ' + searchId  + ' = \'' + searchValue + '\'';
	        List<Lead> leads = Database.query(query);
	        
	        if (!leads.isEmpty()) {
				Integer numLeads = leads.size();
				system.debug('leads found=' + numLeads);
				
				if (numLeads > 1) {
					Lead c = leads[0];
					c.Id = null; // indicator for multiple leads
					return c;
				}
				else if (numLeads == 1) {
					return leads[0];
				}
	        }
	    }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
        
        return null;
    } 
    
    /**
     * Comes from the search contact/case screens
     **/
    @RemoteAction global static Object getContact(String contactId, String field) {
        system.debug('getContact: contactId - ' + contactId);
        if (field != null) {
        	field = ', ' + field;
        }
        else {
        	field = '';
        }
        
        try {
	        String query = 'SELECT Id, Name, AccountId' + field + ' FROM Contact WHERE Id= :contactId';
	        system.debug('query = ' + query);            
	        List<Contact> contacts = Database.query(query);
	        if (!contacts.isEmpty()) {
	        	return contacts[0];
	        }
        }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
        
        try {
	        String query = 'SELECT Id, Name' + field + ' FROM Account WHERE Id= :contactId';
	        system.debug('query = ' + query);            
	        List<Account> accounts = Database.query(query);
	        if (!accounts.isEmpty()) {
	        	return accounts[0];
	        }
	    }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
        
        try {
	        String query = 'SELECT Id, Name' + field + ' FROM Lead WHERE Id= :contactId';
	        system.debug('query = ' + query);            
	        List<Lead> leads = Database.query(query);
	        if (!leads.isEmpty()) {
	        	return leads[0];
	        }
	    }
        catch (QueryException e) {
        	system.debug('QueryException ' + e); 
        }
           
        return null;
    }  
    
    /**
     * Used by click to dial on a task to work out the contact id 
     **/
     @RemoteAction global static Task getContactByTask(String taskId) {
        system.debug('getContactByTask: taskId - ' + taskId);
        
        Task task = [SELECT WhoId, WhatId FROM Task WHERE Id= :taskId];
        system.debug('contact id = '  + task.WhoId);
        
        // see if this task has an associated case
        List<Case> cases = [SELECT CaseNumber FROM Case WHERE Id= :task.WhatId];
        
       	if (!cases.isEmpty()) {
       		// return the case number in the call object field
       		task.CallObject = cases[0].CaseNumber;
       	}
       	               
        return task;
    } 
    
    @RemoteAction global static Task createTask(String ixnId,
            String contactId, 
    		String whatId,
    		String subject,
    		Map<String, String> userData,
    		Map<String, String> taskMap) {
		system.debug('createTask: ' + contactId);
		  
		// check to see if this is an account and not a contact
		String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
		if (contactId != null) {
	        String prefix = contactId.substring(0, 3);
	        if (prefix == accountPrefix) {
	        	// see if the 'what' needs to be an account
	        	String casePrefix = Schema.SObjectType.Case.getKeyPrefix();
	        	if (whatId == null || whatId.substring(0, 3) != casePrefix) {
	        		whatId = contactId;
	        	}
	        	
	        	contactId = null;
	        }
		}
        
		Task task = new Task (
		  	Status = 'In Progress',
		  	Subject = subject,
		  	WhoId = contactId,
		  	WhatId = whatId,
		  	CallObject = ixnId
		);          
	      
	    if (taskMap != null) {
		    for (String sfdcField : taskMap.keySet()) {
		    	String val = taskMap.get(sfdcField);
	    		system.debug(sfdcField + ':' + val);
	    		try {
	    			task.put(sfdcField, val);
				}
				catch (Exception te){
					system.debug('is integer?');
					task.put(sfdcField, Integer.valueof(val));
				}
			}
	    }
		  
        insert task;
        system.debug('Task id = '  + task.Id);
        return task;
 	}
 	
	/**
 	 * Called if a task is created first -> contact found -> task updated
 	 */
 	@RemoteAction global static Task updateTaskDetails(ID taskId,
            String contactId,
            String whatId) {
		system.debug('updateTaskDetails: ' + contactId);
		
		Task[] tasks = null;
		Task task = null;
		
		if (taskId != null) {
			tasks = [SELECT Id, Description FROM Task WHERE Id= :taskId];
		}
		
		if (tasks == null || tasks.size() == 0) { // created yet?
			system.debug('updateTaskDetails: task does not exist');
			return null;
		}
		else {
			task = tasks[0];
		}
		
		// check to see if this is an account and not a contact
		String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
		if (contactId != null) {
	        String prefix = contactId.substring(0, 3);
	        if (prefix == accountPrefix) {
	        	// see if the 'what' needs to be an account
	        	String casePrefix = Schema.SObjectType.Case.getKeyPrefix();
	        	if (whatId == null || whatId.substring(0, 3) != casePrefix) {
	        		whatId = contactId;
	        	}
	        	
	        	contactId = null;
	        }
		}
		
		task.put('WhoId', contactId);
		task.put('WhatId', whatId); 
		update task;
        system.debug('Task id = '  + task.Id); 
        return task;
    }
	
	/**
     * Called when ixn attached data changes and task can update dynamically
     */
 	@RemoteAction global static Task updateTask(ID taskId, 
    		Map<String, String> userData,
    		Map<String, String> taskMap) {
		system.debug('updateTask: ' + taskId);
		Task[] tasks = null;
		Task task = null;
		
		if (taskId != null) {
			tasks = [SELECT Id, Description FROM Task WHERE Id= :taskId];
		}
		
		if (tasks == null || tasks.size() == 0) { // created yet?
			system.debug('updateTask: task does not exist');
			return null;
		}
		else {
			task = tasks[0];
		}
		
		if (taskMap != null) {
	        for (String sfdcField : taskMap.keySet()) { 
	        	String val = taskMap.get(sfdcField);
	    		system.debug(sfdcField + ':' + val);
	    		try {
		    		task.put(sfdcField, val);
				}
				catch (Exception te){
					system.debug('is integer?');
					task.put(sfdcField, Integer.valueof(val));
				}
			}
		}
		
        update task;
        system.debug('Task id = '  + task.Id); 
        return task;
 	}
 	
    @RemoteAction global static Task closeTask(String ixnId,
    		String contactId, 
            ID taskId, 
    		ID whatId,
 			String subject,
    		String comments, 
    		Map<String, String> userData,
    		String dispositionKVP,
    		Map<String, String> taskMap, 
    		Integer callDuration) {
		system.debug('closeTask: ' + taskId);
		Task[] tasks = null;
		Task task = null;
		
		if (taskId != null) {
			tasks = [SELECT Id, Description FROM Task WHERE Id= :taskId];
		}
		
		if (tasks == null || tasks.size() == 0) { // created yet?
			task = createTask(ixnId, contactId, whatId, subject, userData, taskMap); // task id is actually the contact id
			if (task == null) {
				system.debug('closeTask: task not created');
				return null;
			}
		}
		else {
			task = tasks[0];
		}
		
        String disposition = '';
        if (userData != null && userData.containsKey(dispositionKVP)) {
        	disposition = userData.get(dispositionKVP);
        }
        
        task.CallDisposition = disposition;
        task.CallDurationInSeconds = callDuration;
        task.Status = 'Completed';
        task.Subject = subject;
        
        if (comments != '') {
        	if (task.Description == null) {
        		task.Description = '';
        	}
        	
        	task.Description += '\n' + comments;
        }
        
        for (String sfdcField : taskMap.keySet()) {
        	String val = taskMap.get(sfdcField);
    		system.debug(sfdcField + ':' + val);
    		try {
	    			task.put(sfdcField, val);
			}
			catch (Exception te){
				system.debug('is integer?');
				task.put(sfdcField, Integer.valueof(val));
			}
		}
           
        update task;
        system.debug('Task id = '  + task.Id);
        return task;
 	}
 	
    @RemoteAction global static Case findCase(String caseNumber) {
        system.debug('findCase: ' + caseNumber);
        List<Case> cases = [SELECT CaseNumber, ContactId FROM Case WHERE CaseNumber= :caseNumber];
        
       	if (!cases.isEmpty()) {
        	return cases[0];
       	}
       	                            
        return null; 
    }
    
    @RemoteAction global static Case createCase(String contactId, String accountId, String mediaType, String subject, Map<String, String> userData, Map<String, String> caseMap) {        
        system.debug('createCase: ' + subject);
		Case c = null;
		
		try {      
			// check to see if this is an account and not a contact
			String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
			if (contactId != null) {
		        String prefix = contactId.substring(0, 3);
		        if (prefix == accountPrefix) {
		        	accountId = contactId;
		        	contactId = null;
		        }
			}
	        
	        c = new Case (
	        	ContactId = contactId,
	        	AccountId = accountId,
	        	Subject = subject,
	        	Priority = 'Medium',
	        	Origin = mediaType       	
	        );
			if (test.isRunningTest()) {
				c.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Transaction').getRecordTypeId();
			}
	        if (caseMap != null) {
		        for (String sfdcField : caseMap.keySet()) { 
		        	String val = caseMap.get(sfdcField);
		    		system.debug(sfdcField + ':' + val);
		    		try {
			    		c.put(sfdcField, val);
					}
					catch (Exception te){
						system.debug('is integer?');
						c.put(sfdcField, Integer.valueof(val));
					}
		        }
			}
		
            insert c;
            c = [select id, CaseNumber from Case where id=:c.id];
        }
        catch (Exception e) {
        	system.debug('Exception ' + e); 
        	return null; 
        }
        
        system.debug('Case id = '  + c.Id);
        return c;
    }
    
    /**
 	 * Called if a case is created first -> contact found -> case updated
 	 */
 	@RemoteAction global static Case updateCaseDetails(ID caseId,
            String contactId,
            String accountId) {
		system.debug('updateCaseDetails: ' + contactId);
		
		Case[] cases = null;
		Case caseObj = null;
		
		if (caseId != null) {
			cases = [SELECT Id, Description FROM Case WHERE Id= :caseId];
		}
		
		if (cases == null || cases.size() == 0) { // created yet?
			system.debug('updateCaseDetails: case does not exist');
			return null;
		}
		else {
			caseObj = cases[0];
		}
		
		caseObj.put('ContactId', contactId);
		caseObj.put('AccountId', accountId);
		
		update caseObj;
        system.debug('Case id = '  + caseObj.Id); 
        return caseObj;
    }
    
    /**
     * Called when ixn attached data changes and case can update dynamically
     */
 	@RemoteAction global static Case updateCase(ID caseId, 
    		Map<String, String> userData,
    		Map<String, String> caseMap) {
		system.debug('updateCase: ' + caseId);
		Case[] cases = null;
		Case caseObj = null;
		
		if (caseId != null) {
			cases = [SELECT Id FROM Case WHERE Id= :caseId];
		}
		
		if (cases == null || cases.size() == 0) { // created yet?
			system.debug('updateCase: case does not exist');
			return null; 
		}
		else {
			caseObj = cases[0];
		}
		
		if (caseMap != null) {
	        for (String sfdcField : caseMap.keySet()) { 
	        	String val = caseMap.get(sfdcField);
	    		system.debug(sfdcField + ':' + val);
	    		try {
		    		caseObj.put(sfdcField, val);
				}
				catch (Exception te){
					system.debug('is integer?');
					caseObj.put(sfdcField, Integer.valueof(val));
				}
			}
		}
		
        update caseObj;
        system.debug('Case id = '  + caseObj.Id); 
        return caseObj;
 	}
    
    /**
     * Look for a specific case(s)
     */
    @RemoteAction global static Case[] getCases(String query) {
		system.debug('getCases: ' + query);
		Case[] cases = Database.query(query);
		
		if (cases == null || cases.size() == 0) { // created yet?
			system.debug('getCases: no cases present');
			return null;
		}
		
        return cases;
    }
    
    //The method below is for the support of activating Mark Done and Call Result from Salesforce to Genesys WDE
    @AuraEnabled
    public static Sobject getRecord(Id recordId, String fieldsToShow) {
        String objectName = recordId.getSobjectType().getDescribe().getName();
        String soql = 'Select ' + fieldsToShow + '  from ' + objectName + ' where Id = :recordId';
        return Database.query(soql);
    }
    
    /**
     * Check to see if the is a person/account version of SFDC
     */
    @RemoteAction global static Boolean IsPersonAccountEnabled()
	{
		return Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount');
	}
}