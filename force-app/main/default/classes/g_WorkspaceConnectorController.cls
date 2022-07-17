global class g_WorkspaceConnectorController {


    @RemoteAction
    global static Case findCaseFromNumber(String num)
    {
        system.debug('[WSC] findCaseFromNumber using  ' + num);       
        try {
           List<Case> cases = [SELECT CaseNumber, ContactId FROM Case WHERE CaseNumber= :num];            
           if(!cases.isEmpty()) {
               // return the first case found (should only be one)                            
               for (Case c : cases) {
                   return c;
               } 
           }
        } catch(QueryException e){
            return null; 
        }
        return null; 
    }
 
   

    @RemoteAction
    global static Object findObjectFromANI(String ANI)
    {
        system.debug('*** findObjectFromANIfor '+ANI); 

        //DGC: Start This function customized to support PersonAccount Salesforce org mode
        Boolean personAccountsEnabled = Schema.sObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        if (personAccountsEnabled) {
            system.debug('*** findObjectFromANI: PersonAccounts is enabled');   
        }
        //DGC: End      

        Integer listSize = 0; 
        //List<SObject> objList;
        SObject obj_found = null;     
        try{
            
            List<List<SObject>> aobjects = [FIND :ANI IN PHONE FIELDS RETURNING Account];
            if (!aobjects.isEmpty()){
              List<Account> accounts = ((List<Account>)aobjects[0]);
              listSize = accounts.size();
              system.debug('*** accounts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize != 0){
                  for (List<SObject> objList : aobjects)
                      for (SObject aobj : objList){
                        obj_found = aobj;
                        system.debug('*** findObjectFromANI account = '+ obj_found.Id);
                  } 
              }
            }                
                
            //DGC: Start - If PersonAccount is enabled and we have a match, do not search Contact and Lead because both Account and Contact 
            // will likely have hits on the same reference.
            if (personAccountsEnabled && obj_found != null) {
                return obj_found;
            }
            //DGC: End   

            List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            if (!cobjects.isEmpty()){
              List<Contact> contacts= ((List<Contact>)cobjects[0]);
              listSize = contacts.size();
              system.debug('*** contacts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 1 && obj_found != null){
                    return 'multiple found';
              }
              if(listSize != 0){
                  for (List<SObject> objList : cobjects)
                      for (SObject cobj : objList){
                        obj_found = cobj;
                        system.debug('*** findObjectFromANI contact = '+ obj_found.Id);
                      } 
                  }
            }  
                                   
			//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) Start
            /*List<List<SObject>> lobjects = [FIND :ANI IN PHONE FIELDS RETURNING Lead];
            if (!lobjects.isEmpty()){
              List<Lead> leads= ((List<Lead>)lobjects[0]);
              listSize = leads.size();
              system.debug('*** leads listSize = ' + listSize);              
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 1 && obj_found != null){
                    return 'multiple found';
              }
              if(listSize != 0){                            
                  for (List<SObject> objList : lobjects)
                      for (SObject lobj: objList){
                        obj_found = lobj;
                        system.debug('*** findObjectFromANI lead= '+obj_found.Id);
                      } 
              }
            }*/
            //Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) End
            if(obj_found != null)              
                return obj_found; 
            return 'not found';

        }
        catch(QueryException e){
            return 'not found'; 
        }        
    }
    
    
    @RemoteAction
    global static Object findContactFromANI(String ANI)
    {
        system.debug('*** findContactFromANI '+ANI);       
        try{                                  
            List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            Integer listSize = cobjects.size();
            system.debug('*** listSize = ' + listSize);
            if(listSize > 1){
                    return 'multiple found'; //not expected
            }
            if (!cobjects.isEmpty()){
              List<Contact> contacts = ((List<Contact>)cobjects[0]);
              listSize = contacts.size();
              system.debug('*** contacts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 0){
                  return 'not found';
              }
              for (List<SObject> objList : cobjects)
                  for (SObject cobj : objList){
                    system.debug('*** findContactFromANI contact = '+ cobj.Id);
                    return cobj;
                  } 
            }                
            return null; 

        }
        catch(QueryException e){
            return null; 
        }        
    }

    @RemoteAction
    global static Object findContactFromEmailAddress(String address)
    {
        system.debug('*** findObjectFromEmailAddress' + address);       
        try {
            List<Contact> objects = [select name from contact where email= :address ];
            Integer listSize = objects.size();
            if(listSize == 1){            
            //if (!objects.isEmpty()) {
                  for (Contact obj : objects) {
                    system.debug('*** findContactFromEmailAddress contact = '+ obj.Name);
                    return obj;
                  } 
            }                
            return null; 
        }
        catch(QueryException e){
            return null; 
        }        
    }
    
    @RemoteAction
    global static Object findContactFromChatAddress(String theName)
    {
        system.debug('*** findObjectFromChatAddress' + theName);       
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
            //if (!objects.isEmpty()) {
                  for (Contact obj : objects) {
                    system.debug('*** findObjectFromChatAddresscontact = '+ obj.Name);
                    return obj;
                  } 
            }                
            return null; 
        }
        catch(QueryException e){
            return null; 
        }        
    }

        
    @RemoteAction
    global static Object findContactFromWorkItemAddress(String theName)
    {
        system.debug('*** findContactFromWorkItemAddress' + theName);       
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
            //if (!objects.isEmpty()) {
                  for (Contact obj : objects) {
                    system.debug('*** findContactFromWorkItemAddress = '+ obj.Name);
                    return obj;
                  } 
            }                
            return null; 
        }
        catch(QueryException e){
            return null; 
        }        
    }    


    @RemoteAction
    global static Object findContactFromOpenMediaAddress(String theName)
    {
        system.debug('*** findContactFromOpenMediaAddress' + theName);       
        try {
            List<Contact> objects = [select name from contact where name= :theName];
            Integer listSize = objects.size();
            if(listSize == 1){
            //if (!objects.isEmpty()) {
                  for (Contact obj : objects) {
                    system.debug('*** findContactFromOpenMediaAddress = '+ obj.Name);
                    return obj;
                  } 
            }                
            return null; 
        }
        catch(QueryException e){
            return null; 
        }        
    }
 
 
 @RemoteAction global static String createActivity(Map<String,String> activityMap){
        system.debug('*** createActivity' );
        String result = 'not found';
                        
        String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix(); 
        String casePrefix = Schema.SObjectType.Case.getKeyPrefix(); 

        system.debug('*** duration = ' + activityMap.get('Call Duration'));
        String callType = activityMap.get('IXN Type');
        String mediaType = activityMap.get('Media Type');
        String d = activityMap.get('DATE');
        system.debug('*** d   '+ d);
        if(d == '0001-01-01 00:00:00')
            d = '';
        String subject = callType + ' ' + mediaType + ' ' + d; 
        String objectToUse = '';
        String duration = activityMap.get('Call Duration');
        Integer durationInSecs = Integer.valueOf(duration);
                
        DateTime startDate=null;
        try{
            startDate = (activityMap.get('StartDate')=='' && activityMap.get('StartDate')==null) ? null : dateTime.valueOf(activityMap.get('StartDate'));
        }catch(Exception e) {
            system.debug(e); 
        }
        system.debug('*** start date = ' + startDate);

        DateTime endDate=null;
        try{
            endDate = (activityMap.get('EndDate')=='' && activityMap.get('EndDate')==null) ? null : dateTime.valueOf(activityMap.get('EndDate'));
        }catch(Exception e) {
            system.debug(e);
        }
        
        system.debug('*** end date = ' + endDate); 
        
        if(activityMap.get('sfdc Object Id')!= ''){
                system.debug('*** createActivity sfdc Object Id = ' + activityMap.get('sfdc Object Id'));
                objectToUse = activityMap.get('sfdc Object Id');
        }
        else {
            //do a search
            String field_value = activityMap.get('fieldValue');
            String field_name = activityMap.get('fieldName');
            Object searchObj = g_WorkspaceConnectorController.findObject(field_name,field_value);
            if(searchObj != null){
                SObject sobj = (SObject) searchObj;
                objectToUse = sobj.Id;
            }
        }       
        system.debug('*** createActivity for object ' + objectToUse);      
        
        String prefix = '';
        if(objectToUse != '')
            prefix = objectToUse.substring(0, 3);
        system.debug('*** prefix = '+prefix);
          

        Task t = new Task (
          Type = 'Call',
          Status = 'Completed',
          Subject = subject,
          CallDurationInSeconds = durationInSecs,            
          //PJB Start__c = startDate,  //If we want to use the start of the interaction
          //PJB End__c = endDate,  //If we want to use the end of the interaction
          Description = activityMap.get('Comments'),
          CallDisposition = activityMap.get('Disposition'),
          CallObject = activityMap.get('GenesysId')
        );          
        
        if(prefix == accountPrefix || prefix == casePrefix){
          system.debug('*** create task for account or case');
          t.put('WhatId',objectToUse);
        }
        else{
          t.put('WhoId',objectToUse);
        }
              
        if(prefix == contactPrefix)
        {
          Contact contact= [SELECT AccountId, Id FROM Contact WHERE Id= :objectToUse];
          system.debug('*** create task for contact');
          t.put('WhatId', contact.AccountId); 
        }
        else if(prefix == casePrefix)
        {
          Case caseObj = [SELECT ContactId FROM Case WHERE Id= :objectToUse];
          system.debug('*** create task for case');
          t.put('WhoId', caseObj.ContactId); 
        }
             
             // CAM: used by Case instead              
        /*String mySFDCfield = '';
        String mySFDCvalue = '';
        if (activityMap.get('SFDC1field') != '' && (activityMap.get('SFDC1field') != null) && activityMap.get('SFDC1value') != '' && activityMap.get('SFDC1value') != null)
        {
            mySFDCfield = activityMap.get('SFDC1field');
            mySFDCvalue = activityMap.get('SFDC1value');
            system.debug('*** mySFDCfield1 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC2field') != '' && (activityMap.get('SFDC2field') != null) && activityMap.get('SFDC2value') != '' && activityMap.get('SFDC2value') != null)
        {
            mySFDCfield = activityMap.get('SFDC2field');
            mySFDCvalue = activityMap.get('SFDC2value');
            system.debug('*** mySFDCfield2 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC3field') != '' && (activityMap.get('SFDC3field') != null) && activityMap.get('SFDC3value') != '' && activityMap.get('SFDC3value') != null)
        {
            mySFDCfield = activityMap.get('SFDC3field');
            mySFDCvalue = activityMap.get('SFDC3value');
            system.debug('*** mySFDCfield3 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC4field') != '' && (activityMap.get('SFDC4field') != null) && activityMap.get('SFDC4value') != '' && activityMap.get('SFDC4value') != null)
        {
            mySFDCfield = activityMap.get('SFDC4field');
            mySFDCvalue = activityMap.get('SFDC4value');
            system.debug('*** mySFDCfield4 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        }
        if (activityMap.get('SFDC5field') != '' && (activityMap.get('SFDC5field') != null) && activityMap.get('SFDC5value') != '' && activityMap.get('SFDC5value') != null)
        {
            mySFDCfield = activityMap.get('SFDC5field');
            mySFDCvalue = activityMap.get('SFDC5value');
            system.debug('*** mySFDCfield5 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            t.put(mySFDCfield,mySFDCvalue);
        } */          
            
        try{                        
                insert t;
        }
        catch(QueryException e){
                 return result; 
        }
        system.debug('*** Task id = '  +t.Id);
        result = t.Id;
        return result;
     }
 
    @RemoteAction      
    global static String createCase(Map<String,String> caseMap)
    {        
        system.debug('*** createCase');
        String result = 'case not created';
        String ixnType = caseMap.get('IXN Type');
        //String subject = ixnType + ' ' + caseMap.get('DATE'); 
        String objectToUse = caseMap.get('sfdc Object Id');
       	String genesysId = caseMap.get('GenesysId');
       	String customerID = caseMap.get('CustomerID');
       	String subject = caseMap.get('Subject');
       	String categoryS = caseMap.get('Category');
                
        String callType = caseMap.get('IXN Type');
        String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String prefix = null;
        
        if (objectToUse != null && objectToUse != '') {
        	prefix = objectToUse.substring(0, 3);
        }
        
        if (ixnType == 'Chat') {
        	ixnType = 'Live Chat';
        }
        
        if (ixnType == 'Voice') {
        	ixnType = 'Phone';
        }
           
        Case c = new Case (
            //Subject = subject,   //DGC: Subject not wanted by customer 
            Priority = 'Medium',
            Origin = ixnType,
            Status = 'In Progress',
            Genesys_Id__c = genesysId,
            Web_Employee_Id__c = customerID,
            Subject = subject,
            Category__c = categoryS
        );
        
        if (prefix == accountPrefix) { 
          system.debug('*** create case for account');
          c.put('AccountId', objectToUse);
        }
        else if (prefix == contactPrefix) {
          Contact contact= [SELECT AccountId, Id FROM Contact WHERE Id= :objectToUse];
          system.debug('*** create case for contact');
          c.put('AccountId', contact.AccountId); 
        }
               
        String mySFDCfield = '';
        String mySFDCvalue = '';
        if (caseMap.get('SFDC1field') != '' && (caseMap.get('SFDC1field') != null) && caseMap.get('SFDC1value') != '' && caseMap.get('SFDC1value') != null)
        {
            mySFDCfield = caseMap.get('SFDC1field');
            mySFDCvalue = caseMap.get('SFDC1value');
            system.debug('*** mySFDCfield1 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            c.put(mySFDCfield,mySFDCvalue);
        }
        
        if (caseMap.get('SFDC2field') != '' && (caseMap.get('SFDC2field') != null) && caseMap.get('SFDC2value') != '' && caseMap.get('SFDC2value') != null)
        {
            mySFDCfield = caseMap.get('SFDC2field');
            mySFDCvalue = caseMap.get('SFDC2value');
            system.debug('*** mySFDCfield2 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            c.put(mySFDCfield,mySFDCvalue);
        }
        
        if (caseMap.get('SFDC3field') != '' && (caseMap.get('SFDC3field') != null) && caseMap.get('SFDC3value') != '' && caseMap.get('SFDC3value') != null)
        {
            mySFDCfield = caseMap.get('SFDC3field');
            mySFDCvalue = caseMap.get('SFDC3value');
            system.debug('*** mySFDCfield3 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            c.put(mySFDCfield,mySFDCvalue);
        }
        
        if (caseMap.get('SFDC4field') != '' && (caseMap.get('SFDC4field') != null) && caseMap.get('SFDC4value') != '' && caseMap.get('SFDC4value') != null)
        {
            mySFDCfield = caseMap.get('SFDC4field');
            mySFDCvalue = caseMap.get('SFDC4value');
            system.debug('*** mySFDCfield4 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            c.put(mySFDCfield,mySFDCvalue);
        }
        
        if (caseMap.get('SFDC5field') != '' && (caseMap.get('SFDC5field') != null) && caseMap.get('SFDC5value') != '' && caseMap.get('SFDC5value') != null)
        {
            mySFDCfield = caseMap.get('SFDC5field');
            mySFDCvalue = caseMap.get('SFDC5value');
            system.debug('*** mySFDCfield5 ' + mySFDCfield + ' -- ' + mySFDCvalue);
            c.put(mySFDCfield,mySFDCvalue);
        }
        
        try{                        
            insert c;
        }
        catch(QueryException e){
            return result; 
        }
        system.debug('*** Case id = '  +c.Id);
        return c.Id;
    }  
      
    @RemoteAction      
    global static String addAttachment(String objectId, String descriptionText, String nameText, String mimeType, Blob attachmentBody, String attachmentId)
    {        
        system.debug('*** addAttachment to '+objectId);
        try{           
 
                if(attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    
                    String newBody = '';
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    
                    String newAttachmentBody = EncodingUtil.base64Encode(attachmentBody);                    
                    
                    newBody += newAttachmentBody;
                    
                    att.Body = EncodingUtil.base64Decode(newBody);
                    //att.Body = Blob.valueOf(newBody);                    
                    
                    if(attachmentId == null) {
                        system.debug('*** First time through');
                        att.Name = nameText;
                        att.parentId = objectId;
                    }
                    upsert att;
                    return att.Id;
                } else {
                    return 'error';
                }
        }
        catch(QueryException e){
            system.debug('*** addAttachment error ' + e);
            return 'error';
        }
    }
    
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }


   @RemoteAction
    global static Object findObject(String searchFieldName, String searchFieldValue){
        //DGC: Start - note this function is customized
        system.debug('*** findObject: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue);
        Boolean personAccountsEnabled = Schema.sObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        if (personAccountsEnabled) {
            system.debug('*** findObject: PersonAccounts is enabled');   
        }
        //DGC: End      
        Object result = null;
        if(searchFieldName == '' || searchFieldValue == '')
            return result;
        String query;
        //Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) Start
        String newsearchFieldValue = searchFieldValue;
        if(searchFieldName=='Account.Employee_ID__c' && searchFieldValue.length() < 6){
            //String newsearchFieldValue = String.format('%06d', searchFieldValue);
            newsearchFieldValue = searchFieldValue.leftPad(6).replace(' ', '0');
        }
        if(searchFieldName=='Account.Employee_ID__c' && searchFieldValue.length() == 7 && searchFieldValue.startsWith('0') ){
            newsearchFieldValue = searchFieldValue.substring(1, searchFieldValue.length());
        }
        //Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) End
        try{
			//Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) Start
           //query = 'SELECT Id, Name, Phone FROM Account WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
           query = 'SELECT Id, Name, Phone FROM Account WHERE ' + searchFieldName  + ' = \'' + newsearchFieldValue + '\'';
           //Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) End
           system.debug('*** Account query = ' + query);            
           List<Account> accounts = Database.query(query);
            if (!accounts.isEmpty()){
                Integer listSize = accounts.size();
                if(listSize > 1){
                    return result;
                }
                for (Account a : accounts){
                    system.debug('***  Id = ' + a.Id);
                    system.debug('***  Name = '+ a.Name);
                    system.debug('*** Phone = '+ a.Phone);
                    result = a;
                }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e);
        }
        
        //DGC: Start - If PersonAccount is enabled and we have a match, do not search Contact and Lead because both Account and Contact 
        // will likely have hits on the reference.
        if (personAccountsEnabled && result != null) {
            return result;
        }
        //DGC: End
        
        //check contact
        try{
            //Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) Start
            //query = 'SELECT Id, Name, Phone FROM Contact WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
            query = 'SELECT Id, Name, Phone FROM Contact WHERE ' + searchFieldName  + ' = \'' + newsearchFieldValue + '\'';
            //Append Leading 0 for employee Id less than 6 digits 05/09/2017 (agarg2@woolworths.com.au) End
            system.debug('*** Contact query = ' + query);            
            List<Contact> contacts = Database.query(query);
            if (!contacts.isEmpty()){
                    Integer listSize = contacts.size();
                    if(listSize > 1){
                        return result;
                    }
                    for (Contact c: contacts ){
                        system.debug('***  Id = ' + c.Id);
                        system.debug('***  Name = '+ c.Name);
                        system.debug('*** Phone = '+ c.Phone);
                        if(result == null){
                            result = c;
                        }
                        else{
                            //multiple found so return null
                            return null;
                        }
                    }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e); 
        }
        
        //check lead
        //Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) Start
        /*try{
            query = 'SELECT Id, Name, Phone FROM Lead WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
            system.debug('*** Contact query = ' + query);            
            List<Lead> leads = Database.query(query);
            if (!leads.isEmpty()){
                    Integer listSize = leads.size();
                    if(listSize > 1){
                        return result;
                    }
                    for (Lead l: leads ){
                        system.debug('***  Id = ' + l.Id);
                        system.debug('***  Name = '+ l.Name);
                        system.debug('*** Phone = '+ l.Phone);
                        if(result == null){
                            result = l;
                        }
                        else{
                            //multiple found so return null
                            return null;
                        }
                    }
            }
        }
        catch(QueryException e){
            system.debug('*** QueryException ' + e); 
        }*/
        System.debug('result:['+result+']');
        //Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) End
        
        return result;
    }    
  
    @RemoteAction
    global static String testConnection()
    {   
        return 'Active';
    }
     

}