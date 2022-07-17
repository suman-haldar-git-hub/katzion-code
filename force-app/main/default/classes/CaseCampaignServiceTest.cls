/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the CaseCampaignService class
*/
@isTest(SeeAllData=false)
public class CaseCampaignServiceTest {
    
    /**
    * @author : Amit Sharma
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
            insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
            
         list<Campaign> listCam = CampaignTestData.create(2);
            listCam[0].CampaignCode__c = 'SALARY SACRIFICE NOTIF';
            listCam[1].CampaignCode__c = 'CASEPORTALNOTIF';
            insert listCam;
                    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c='Email');
        insert u;
        
         Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(2,transcationCaseId);
        cases[0].CaseApproved__c = 'Pending';
        cases[0].RequesterUser__c = u.id;
        cases[0].Category__c = 'Pay and the Basics';
        cases[0].Sub_Category__c  = 'Salary Sacrifice';
        cases[0].ContactId  = accountRecd.PersonContactId;
        cases[0].Origin = 'TeamHub';
        cases[0].Send_Notification__c = 'Send with comments';
        cases[0].TeamHubApplicationType__c = 'SalarySacrifice';
        cases[0].Page_View_Count__c = 2;
        insert cases[0];
        
        cases[1].RequesterUser__c = u.id;
        cases[1].Category__c = 'Benefits';
        cases[1].Sub_Category__c  = 'Payroll Payslips';
        cases[1].ContactId  = accountRecd.PersonContactId;
        cases[1].Origin = 'TeamHub';
        cases[1].Send_Notification__c = 'Send with comments';
        cases[1].TeamHubApplicationType__c = 'PeopleServices';
        cases[1].Page_View_Count__c = 3;
        insert cases[1];
    }
    
     /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute approved logic
    */
    @isTest
    static void testData(){
       
        list<Campaign> listCam = [
            Select Id,CampaignCode__c From Campaign 
            Where CampaignCode__c = 'SALARY SACRIFICE NOTIF'];
               
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c FROM Case 
                                           Where CaseApproved__c != null];
        System.assertEquals(lstCase.size() != null,true);
        
    }
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute rejected logic
    */
    @isTest
    static void testData1(){
       
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c FROM Case 
                                        Where CaseApproved__c != null];
                                    
        System.assertEquals(lstCase.size() != null,true);
        List<User> lstUser = [SELECT Id,Email FROM User];
                                    
        System.assertEquals(lstUser.size() != null,true);
        lstCase[0].OwnerId = lstUser[0].Id;
        lstCase[0].CaseApproved__c = 'Rejected';
        lstCase[0].Status = 'Closed';
        lstCase[0].Page_View_Count__c = 4;
        lstCase[0].Preferred_Email__c = 'test@abc.com';
        lstCase[0].CSR_Reporting__c = true;
        test.startTest();
        update lstCase[0];
        test.stopTest();
        
    }
}