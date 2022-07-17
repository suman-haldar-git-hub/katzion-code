/*
    Author:             Jerome To
    Created Date:       JUNE 23, 2015 
    Brief:              Case Trigger Handler Test Class
    Description:        Case Trigger Handler Test Class

    Visualforce Page:   N/A
    Test Class:         N/A
    Apex Class:         CaseTriggerHandler.cls   
    Version Control:    v1.0

    @Revision History:  AUGUST 08, 2015     -   Added test cases for synching of Account and Contact on Case

    @Test Coverage:     100%    -   AUGUST 08, 2015
*/


@isTest
private class CaseTriggerHandlerTest {
    
    // Set up account and Case records for the test class
    @testSetup static void setup() {
        // instantiate Custom Setting
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;

        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(3,transcationCaseId);

        for(Case c : cases)
        {
            c.Effort_To_Date__c = 1.50;
        }

        insert cases;


        // create perosn accounts
        List<Account> accts = TestUtility.createPersonAccount(2);
        insert accts;

        // create query cases
        List<Case> queryCases = TestUtility.createQueryCases(2, Id.valueOf(caseRec.Query_Case__c));
        insert queryCases;
    }
    // tets updateTotalTime method
    @isTest static void updateTotalTimeTest() {
        // instantiate Custom Setting
        // Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        // insert caseRec;

        Case_Record_Types__c caseRec = [SELECT Id, Transaction_Case__c, ER_Case__c, Query_Case__c, WOW_NZ_ER_Case__c FROM Case_Record_Types__c LIMIT 1];

        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> ebaCases = [SELECT Id,Subject,Total_Time__c,Effort_To_Date__c FROM Case WHERE RecordTypeId =:caseRec.Transaction_Case__c];

        Case ebaCase = ebaCases.get(0);
        
        Test.startTest();

        System.assertEquals(1.50, ebaCases.get(0).Total_Time__c);
        System.assertEquals(null, ebaCases.get(0).Effort_To_Date__c);

        // update the case's effort time
        ebaCase.Effort_To_Date__c = 1.50;
        update ebaCase;

        Case updatedCase = [SELECT Id,Subject,Total_Time__c,Effort_To_Date__c FROM Case WHERE Id =:ebaCase.Id];
        System.assertEquals(3.40, updatedCase.Total_Time__c);
        System.assertEquals(null, updatedCase.Effort_To_Date__c);

        // validation for invalid input on effort time
        updatedCase.Effort_To_Date__c = 1.6;
        try{
            update updatedCase;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Invalid Time Input');
            System.assertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }

    // test for account and contact synching
    @isTest static void updateContactNameTest() {
        
        // instantiate Custom Setting
        // Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        // insert caseRec;   

        Case_Record_Types__c caseRec = [SELECT Id, Transaction_Case__c, ER_Case__c, Query_Case__c, WOW_NZ_ER_Case__c FROM Case_Record_Types__c LIMIT 1];
        Id queryCaseId= Id.valueOf(caseRec.Query_Case__c); 
        List<Case> queryCases = [SELECT Id,Subject,ContactId,AccountId 
                               FROM Case 
                               WHERE RecordTypeId =:queryCaseId];
		
        Case queryCase = queryCases.get(0);
        
        Test.startTest();
        System.assertEquals(2, queryCases.size());
        System.assertEquals(null, queryCase.ContactId);

        List<Account> personAccounts = [Select id, IsPersonAccount from Account where IsPersonAccount = true];       

        Account acct = personAccounts.get(0);
        Contact con = [Select Id from Contact where AccountId =: acct.id];
        queryCase.AccountId = acct.Id;
        queryCase.Account_Verified_N_A__c = TRUE;
        update queryCase;

        Case updatedCase = [SELECT Id,Subject,ContactId,AccountId FROM Case WHERE Id =:queryCase.Id];
        System.assertEquals(con.Id, updatedCase.ContactId);

        // has changes in AccountId
        Account acct2 = personAccounts.get(1);
        Contact con2 = [Select Id from Contact where AccountId =: acct2.id];
        updatedCase.AccountId = acct2.Id;
        update updatedCase;

        Case updatedCase2 = [SELECT Id,Subject,ContactId,AccountId FROM Case WHERE Id =:updatedCase.Id];
        System.assertEquals(con2.Id, updatedCase2.ContactId);

        // has changes in ContactId
        updatedCase2.ContactId = con.Id;
        update updatedCase2;

        Case updatedCase3 = [SELECT Id,Subject,ContactId,AccountId FROM Case WHERE Id =:updatedCase2.Id];
        System.assertEquals(acct.Id, updatedCase3.AccountId);
        


        Test.stopTest();
    }


	@isTest static void updateCasePriority() {
		Test.startTest();
		// Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        // insert caseRec;   // This will allow you to create 4 record type cases
        
        Case_Record_Types__c caseRec = [SELECT Id, Transaction_Case__c, ER_Case__c, Query_Case__c, WOW_NZ_ER_Case__c FROM Case_Record_Types__c LIMIT 1];
        Id queryCaseId= Id.valueOf(caseRec.Query_Case__c);  // getting the ID for the Record Type
        
        system.debug('********** Start **********' );
        //create person account
        List<Account> accts = TestUtility.createPersonAccount(1);
        insert accts;
        
        ID AccountID;
        for (Account act : accts) {
        	AccountID = act.id;
        }
        system.debug('************ Account ID is - ' + AccountID);
        
        // create query cases
        List<Case> queryCases = TestUtility.createQueryCases(2, Id.valueOf(caseRec.Query_Case__c));
        insert queryCases;
        
        List<Case> lstqueryCases = [SELECT Id,Subject,ContactId,AccountId, priority, Category__c, Sub_Category__c 
                               		FROM Case 
                               		WHERE RecordTypeId =:caseRec.Query_Case__c limit 5];
        
        for( Case cs : lstqueryCases) {
        	system.debug('************ Case ID is - ' + cs.id);
        	cs.AccountId = AccountID;
        	cs.Sub_Category__c = 'Duplicates';
        }
        update lstqueryCases;
        
        system.assertEquals(lstqueryCases[0].AccountId, accountId);
        
        for( Case cs : lstqueryCases) {
        	cs.Sub_Category__c = null;
        }
        update lstqueryCases;
        
        for( Case cs : lstqueryCases) {
        	cs.Sub_Category__c = 'Duplicate';
        }
        update lstqueryCases;
        
        // Creating a Case from scratch
        
        list<Case> lstNewCase = new list<Case>();
        Case cstempCase = new Case();
        cstempCase.Subject = 'TEST_CASE_101';
        cstempCase.AccountId = AccountID;
        cstempCase.Sub_Category__c = 'Duplicate';
        cstempCase.RecordTypeId = caseRec.Query_Case__c;
        cstempCase.Category__c = 'Pay and the Basics';
        //
        Case cstempCase1 = new Case();
        cstempCase1.Subject = 'TEST_CASE_101';
        cstempCase1.AccountId = AccountID;
        cstempCase1.Sub_Category__c = null;
        cstempCase1.RecordTypeId = caseRec.Query_Case__c;
        cstempCase1.Category__c = 'Pay and the Basics';
        //
        Case cstempCase2 = new Case();
        cstempCase2.Subject = 'TEST_CASE_101';
        cstempCase2.AccountId = AccountID;
        cstempCase2.Sub_Category__c = 'Duplicates';
        cstempCase2.RecordTypeId = caseRec.Query_Case__c;
        cstempCase2.Category__c = 'Pay and the Basics';
        cstempCase2.priority = 'Low';
        
        //
        Case cstempCase3 = new Case();
        cstempCase3.Subject = 'TEST_CASE_101';
        cstempCase3.AccountId = AccountID;
        cstempCase3.Sub_Category__c = 'Pay';
        cstempCase3.RecordTypeId = caseRec.Query_Case__c;
        cstempCase3.Category__c = 'Pay and the Basics';
        
        //
        Case cstempCase4 = new Case();
        cstempCase4.Subject = 'TEST_CASE_101';
        cstempCase4.AccountId = AccountID;
        cstempCase4.Sub_Category__c = 'Deskbanks or Adhoc';
        cstempCase4.RecordTypeId = caseRec.Query_Case__c;
        cstempCase4.Category__c = 'Pay and the Basics';
        
        lstNewCase.add(cstempCase);
        lstNewCase.add(cstempCase1);
        lstNewCase.add(cstempCase2);
        lstNewCase.add(cstempCase3);
        lstNewCase.add(cstempCase4);
        insert lstNewCase;
        //
        
         
        system.debug('********** END **********' );
        
        Test.stopTest();
	}
    
    @isTest static void updateCaseTest() {
        User loggedInUser = UserTestData.getUser('Team Member', 'Test1');
        loggedInUser.EmployeeID__c = '123456';
        insert loggedInUser;
        User newOwner = UserTestData.getUser('Team Member', 'Test2');
        loggedInUser.EmployeeID__c = '1234567';
        insert newOwner;
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123456';
        insert accountTest;
        List<Case> caseTest = CaseTestData.getCaseData(accountTest[0].Id,1,false);
        caseTest[0].recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        caseTest[0].ownerId = loggedInUser.Id;
        caseTest[0].RequesterUser__c = loggedInUser.Id;
        caseTest[0].Origin = 'TeamHub';
        insert caseTest;
        Test.startTest();
        caseTest[0].ownerId = newOwner.Id;
        update caseTest;
        Test.stopTest();
        Case queriedCase = [SELECT Id, OwnerId FROM Case WHERE Id=:caseTest];
        system.assertEquals(queriedCase.OwnerId, newOwner.Id);
    }
    
}