@isTest
private class g_WorkspaceConnectorController_Test {

    
 static testMethod void findCaseFromNumber_Test()
 {
   //Cloud Sherpas Code
   //Custom Settings
   Case_Record_Types__c caseRec = new Case_Record_Types__c();
   caseRec.Transaction_Case__c = '0122800000094iF';
   caseRec.ER_Case__c = '012280000008xsX';
   caseRec.Query_Case__c = '012280000008xsS';
   insert caseRec;
   //End of Cloud Sherpas Code
  
    String test_subject = '123test321test';
    //error leg
    Case result = g_WorkspaceConnectorController.findCaseFromNumber('1');
    System.assert(result == null);
     
    //Create Case test data
    Case test_case = new Case(Subject = test_subject);
    insert test_case;
    Case myCase = [SELECT CaseNumber FROM Case WHERE Subject = :test_subject];  
    result = g_WorkspaceConnectorController.findCaseFromNumber(myCase.CaseNumber);
        System.assert(result!=null);
 }
    

static testMethod void findObjectFromANI_Test() {
        Object result = g_WorkspaceConnectorController.findObjectFromANI('5555');
        System.assert(result == 'not found');
        
    /* From Salesforce documentation: Adding SOSL Queries to Unit Tests
    To ensure that test methods always behave in a predictable way, any Salesforce Object Search Language (SOSL) query that is 
    added to an Apex test method returns an empty set of search results when the test method executes.
    Need to use setFixedSearchResults to set the results.       
    */    
        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '5555'];
        Id [] fixedSearchResultsACC= new Id[1];
        fixedSearchResultsACC[0] = newACC.Id;
        Test.setFixedSearchResults(fixedSearchResultsACC);
        result = g_WorkspaceConnectorController.findObjectFromANI('5555');
        System.assert(result!=null);
        
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        insert con1;
        Contact myContact = [SELECT Id FROM Contact WHERE Email = 'john.doer@somewhere.com'];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = myContact.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        result = g_WorkspaceConnectorController.findObjectFromANI('4444');       
        System.assert(result!=null);  
        
    	//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) Start
        //Create Lead test data
        /*Lead lead = new Lead(FirstName = 'John', LastName = 'Doer', Phone = '2424', Company = 'ABC');
        insert lead;
        Lead myLead = [SELECT Id FROM Lead WHERE Phone = '2424'];
        Id [] fixedSearchResultsLead= new Id[1];
        fixedSearchResultsLead[0] = myLead.Id;
        Test.setFixedSearchResults(fixedSearchResultsLead);
        result = g_WorkspaceConnectorController.findObjectFromANI('2424');       
        System.assert(result!=null); */
    	//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) End
}

    
static testMethod void findContactFromANI_Test() {
        Object id;

        //Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        //insert acc;
        //Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '5555'];
        
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333');
        //con1.AccountId = newACC.Id;
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Doer', Phone = '4444');
        //con2.AccountId = newACC.Id;
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromANI('4444');
        System.assert(id == 'not found');
        
        insert con1;
        String test_phone = '4444';
        Id [] fixedSearchResults = new Id[1];
        Contact myCon = [SELECT Id FROM Contact WHERE Phone = :test_phone];
        fixedSearchResults[0] = myCon.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        System.debug('*** Id = '+myCon.Id);
           
        id = g_WorkspaceConnectorController.findContactFromANI('4444');
        System.assert(id != null && id!='not found' && id != 'multiple found');
        System.debug('*** single match');
        
        //insert con2;
        //id = WorkspaceConnectorController.findContactFromANI('4444');
        //System.assert(id == 'multiple found');
        //System.debug('*** multiple match');
}  


static testMethod void findContactFromEmailAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromEmailAddress('john.doer@somewhere.com');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromEmailAddress('john.doer@somewhere.com');
        System.assert(id != null);        
}


static testMethod void findContactFromChatAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromChatAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromChatAddress('John Doer');
        System.assert(id != null);        
}

    static testMethod void findContactFromWorkItemAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromWorkItemAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromWorkItemAddress('John Doer');
        System.assert(id != null);        
}
    
    static testMethod void findContactFromOpenMediaAddress_Test() {
        Object id;
                
        //Create Contact test data
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        
        //error leg
        id = g_WorkspaceConnectorController.findContactFromOpenMediaAddress('John Doer');
        System.assert(id == null);
        
        insert con1;
        id = g_WorkspaceConnectorController.findContactFromOpenMediaAddress('John Doer');
        System.assert(id != null);        
}    

static testMethod void createCase_Test() {
   //Cloud Sherpas Code
   //Custom Settings
   Case_Record_Types__c caseRec = new Case_Record_Types__c();
   caseRec.Transaction_Case__c = '0122800000094iF';
   caseRec.ER_Case__c = '012280000008xsX';
   caseRec.Query_Case__c = '012280000008xsS';
   insert caseRec;
   //End of Cloud Sherpas Code

        Map<String,String> fieldsMap = new Map<String,String>();
        //create map  
        fieldsMap.put('IXN Type','Phone');
        fieldsMap.put('Media Type','');
        fieldsMap.put('DATE','June1');
        fieldsMap.put('sfdc Object Id','');
        
        // Lookup without criteria and no custom fields
        String result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null);
        
                
        fieldsMap.put('fieldName','Account.Employee_ID__c');
        fieldsMap.put('fieldValue','654321');

        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Employee_ID__c = '654321',Phone='4444'); 
        insert acc;
        //Create Contact test data. 
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Employee_ID__c = '654321'];
        Contact con = new Contact(FirstName = 'test', LastName = 'Account', MobilePhone = '3333',Email = 'test.account@somewhere.com');
        con.AccountId = newACC.Id;  //account id
        insert con;        

        fieldsMap.put('IXN Type','Email');
        fieldsMap.put('LOOKUP','test.account@somewhere.com');
        result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null);

        fieldsMap.put('IXN Type','Chat');
        fieldsMap.put('LOOKUP','testAccount');
        result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null); 
        
        fieldsMap.put('IXN Type','InteractionWorkItem');
        fieldsMap.put('LOOKUP','testAccount');
        result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null); 
        
        fieldsMap.put('IXN Type','OpenMedia');
        fieldsMap.put('LOOKUP','testAccount');
        result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null); 
        
        //Case created under Contact using ID
        Contact newCon = [SELECT Id FROM Contact WHERE MobilePhone = '3333'];
        String ID = newCon.Id;
        System.Debug('sfdc Object Id = '+ID);
        fieldsMap.put('sfdc Object Id',ID);
        fieldsMap.put('SFDC1field','Description');
        fieldsMap.put('SFDC1value','Test1');
        fieldsMap.put('SFDC2field','Description');
        fieldsMap.put('SFDC2value','Test2');
        fieldsMap.put('SFDC3field','Description');
        fieldsMap.put('SFDC3value','Test3');
        fieldsMap.put('SFDC4field','Description');
        fieldsMap.put('SFDC4value','Test4');
        fieldsMap.put('SFDC5field','Description');
        fieldsMap.put('SFDC5value','Test5');    
        result = g_WorkspaceConnectorController.createCase(fieldsMap);
        System.assert(result != null);
  
}
    
static testMethod void createActivity_Test() {
        //DGC: Added additional tests
        String ID = '';
        Map<String,String> fieldsMap = new Map<String,String>();
        //create map
        fieldsMap.put('Genesys Call Type','Inbound');
        fieldsMap.put('LOOKUP','4444');
        fieldsMap.put('Call Duration','35');
        fieldsMap.put('DATE','June1');
        fieldsMap.put('Comments','');
        fieldsMap.put('ANI','4444');
        fieldsMap.put('IXN Type','Phone');
        fieldsMap.put('Media Type','');
        fieldsMap.put('sfdc Object Id',ID);

        //Activity created as orphan
        String noIDResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(noIDResult != null);
    
        //Create Account test data
        Account acc = new Account(Name = 'testAccount',Phone = '7654321', Employee_ID__c = '654321'); 
        insert acc;
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Phone = '7654321'];
        //Create Contact test data
        Contact con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333',Email = 'john.doer@somewhere.com');
        con.AccountId = newACC.Id;  //account id
        insert con;
        
        //Activity created under Contact using search (ANI)
        String contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);

        //Activity created under Contact using search
        fieldsMap.put('fieldName','Account.Employee_ID__c');
        fieldsMap.put('fieldValue','654321');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);
        
        fieldsMap.put('IXN Type','Email');
        fieldsMap.put('LOOKUP','john.doer@somewhere.com');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);

        fieldsMap.put('IXN Type','Chat');
        fieldsMap.put('LOOKUP','John Doer');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null); 
        
        fieldsMap.put('IXN Type','OpenMedia');
        fieldsMap.put('LOOKUP','John Doer');
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);        
    
        //Activity created under Contact using ID
        Contact newCon = [SELECT Id FROM Contact WHERE Phone = '4444'];
        ID = newCon.Id;
        System.Debug('sfdc Object Id = '+ID);
        fieldsMap.put('sfdc Object Id',ID);
        fieldsMap.put('SFDC1field','Description');
        fieldsMap.put('SFDC1value','Test1');
        fieldsMap.put('SFDC2field','Description');
        fieldsMap.put('SFDC2value','Test2');
        fieldsMap.put('SFDC3field','Description');
        fieldsMap.put('SFDC3value','Test3');
        fieldsMap.put('SFDC4field','Description');
        fieldsMap.put('SFDC4value','Test4');
        fieldsMap.put('SFDC5field','Description');
        fieldsMap.put('SFDC5value','Test5');    
        contactResult = g_WorkspaceConnectorController.createActivity(fieldsMap);
        System.assert(contactResult != null);
} 

static testMethod void addAttachment_Test(){
    Task t = new Task (
          Type = 'Call',
          Status = 'Completed',
          Subject = 'Testttt',
          Priority = 'Normal',
          ActivityDate = System.today()
        );
        insert t;
        Task myTask = [SELECT Id FROM Task WHERE Subject = 'Testttt'];
        String blobString= 'This is a string';
        Blob b = Blob.valueOf(blobString);
        String result = g_WorkspaceConnectorController.addAttachment(myTask.Id,'Test Description','TestName1','txt',b,null);
    System.assert(result != 'error');
}

static testMethod void testConnection_Test(){
    Object result = g_WorkspaceConnectorController.testConnection();
    System.assert(result != null);
}

static testMethod void findObject_Test() {
        //DGC: Start  Added additional checks in this test case
        
        //Create Account test data.  Phone is duplicate on purpose
        Account acc = new Account(Name = 'testAccount',Employee_ID__c = '654321',Phone='4444'); 
        insert acc;
        acc = new Account(Name = 'testAccount2',Employee_ID__c = '654322',Phone='4444'); 
        insert acc;

        //Create Contact test data. 
        Account newACC = [SELECT Id, Name, Phone FROM Account WHERE Employee_ID__c = '654321'];
        Contact con = new Contact(FirstName = 'test', LastName = 'Account', MobilePhone = '3333',Email = 'test.account@somewhere.com');
        con.AccountId = newACC.Id;  //account id
        insert con;                
        
    	//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) Start
        //Create Lead test data
        //Lead newLead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Acme Sprockets');
        //insert newLead;        
		//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) End
		
        // Empty search crtieria
        Object result = g_WorkspaceConnectorController.findObject('','');
        System.assert(result == null);

        // Object not found
        result = g_WorkspaceConnectorController.findObject('Phone','5');
        System.assert(result == null);

        // Account found
        result = g_WorkspaceConnectorController.findObject('Account.Employee_ID__c','654321');
        System.assert(result != null);   
                
        // Multiple found
        result = g_WorkspaceConnectorController.findObject('Phone','4444');
        System.assert(result == null);          

        // Find in Contact
        result = g_WorkspaceConnectorController.findObject('MobilePhone','3333');
        System.assert(result != null); 

    	//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) Start
        // Find in Lead
        //result = g_WorkspaceConnectorController.findObject('Company','Acme Sprockets');
        //System.assert(result != null); 
    	//Comment Lead serach code to fix case not popped issue as recommended by Cameron Rich from Genesys 28/08/2017 (agarg2@woolworths.com.au) End
        //DGC: end
        
        
    /* From Salesforce documentation: Adding SOSL Queries to Unit Tests
    To ensure that test methods always behave in a predictable way, any Salesforce Object Search Language (SOSL) query that is 
    added to an Apex test method returns an empty set of search results when the test method executes.
    Need to use setFixedSearchResults to set the results.       
    */  
}

}