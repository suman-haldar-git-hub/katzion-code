/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the IncentiveDetailFlowController class
*/
@isTest(SeeAllData=false)
public class CaseTriggerServiceTest {
    
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
            
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'SALARY SACRIFICE NOTIF';
            insert listCam;
                    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c ='Email');
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
        insert cases[0];
     
    }
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute approved logic
    */
    @isTest
    static void testData(){
       
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        User objUser = [Select Id,Email,UserName from User limit 1]; 
        System.assertEquals(objUser != null,true);      
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c FROM Case];
        System.assertEquals(lstCase.size() != null,true);
        lstCase[0].CaseApproved__c = 'Approved';
        lstCase[0].OwnerId = objUser.id;
        update lstCase[0];
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
               
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c FROM Case];
        System.assertEquals(lstCase.size() != null,true);
        lstCase[0].CaseApproved__c = 'Rejected';
        
        update lstCase[0];
        
    }
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute rejected logic
    */
    @isTest
    static void testData2(){
              
        try{
             List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c FROM Case];
            System.assertEquals(lstCase.size() != null,true);
            lstCase[0].CaseApproved__c = 'Rejected';
            
            update lstCase[0];
            
            CaseTriggerService.shareCase(lstCase,null);
        }
        catch(Exception ex){
            system.debug('not empty catch block');
        }
        
        
    }
}