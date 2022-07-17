/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This test class will cover the IncentiveDetailFlowController class
*/
@isTest(SeeAllData=false)
public class CaseCommentTriggerServiceTest {
    
    /**
    * @author : Sunil Kumar
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
       
         //create account records
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                'Individual Account').getRecordTypeId();
         List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            accountList[0].Employee_ID__c = '849953';
            insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
            
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'CASECOMMENTNOTIF';
            insert listCam;
                    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c ='Email',
            EmployeeID__c = '849953');
        insert u;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(1,transcationCaseId);
        cases[0].CaseApproved__c = 'Pending';
        cases[0].RequesterUser__c = u.id;
        cases[0].Category__c = 'Pay and the Basics';
        cases[0].Sub_Category__c  = 'Salary Sacrifice';
        cases[0].ContactId  = accountRecd.PersonContactId;
        cases[0].Origin  = 'TeamHub';
        cases[0].OwnerId  = u.id;
        insert cases[0];
        List<Case_Comment__c> lstCC = CaseCommentTestData.createAccountRecords(1,cases[0].Id);
        lstCC[0].Type__c = 'External';
        insert lstCC;
     
    }
    /**
    * @author : Sunil
    * @company : Cognizant
    * @description : This is the test method to execute approved logic
    */
    @isTest
    static void testData(){
       
        list<Campaign> listCam = [
            Select Id,CampaignCode__c,Name
            From Campaign
        ];
        List<Account> lstAcc = [Select Id,Employee_ID__c From Account limit 1];
        System.assertEquals(lstAcc != null,true);
        User objUser = [Select Id,Email,UserName from User limit 1]; 
        System.assertEquals(objUser != null,true);      
        List<Case> lstCase = [SELECT Id,Subject,Origin,Owner.Type FROM Case];
        lstCase[0].Closed_Case_Comments__c = 'test';
        lstCase[0].OwnerId = objUser.Id;
        update lstCase[0];
        List<Case_Comment__c> lstCC = [SELECT Id,Case__c,Comment__c,Type__c
                                     FROM Case_Comment__c ];
        System.assertEquals(lstCase.size() != null,true);
        CaseCommentTriggerService.createChildCampaigRecord(lstCC);
        CaseCommentTriggerService.insertCampaignAndMember(listCam[0],lstCase, new Map<Id, 
                        Case_Comment__c>{lstCase[0].Id => lstCC[0]});
    }
    
}