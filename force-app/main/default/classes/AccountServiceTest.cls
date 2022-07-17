/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the test class of AccountService.
*/
@isTest(SeeAllData=false)
public class AccountServiceTest {
    /**
    * @author : Daksh
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        //create account records
        Id personAcctRecdTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        //create account records
        List<Account> accountList = 
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        insert accountList;
        
        User objUser = UserTestData.getUser('System Administrator', 'Test1');
        objUser.EmployeeID__c = 'Test0';
        objUser.UserName = 'amkumar@testorg.com';
        objUser.TaskNotification__c  = true;
        objUser.ReceiveTaskNotificationsFor__c = 'CATS';
      
        insert objUser ;
        
        //create campaign records
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;

    }
    /**
    * @author : Daksh
    * @company : Cognizant
    * @description : This will test for Other Employee.
    */
    @isTest static void getAccountIdForLineManagerTest(){
        Account acctRecord = [Select Id,Employee_ID__c,Employee_Class__c,AribaExternalId__c,
                               CATSExternalId__c
                              From Account 
                              Where Line_Manager__c = null];
        User objUserData = [Select Id,Email From User Where EmployeeID__c =: 'Test0' limit 1];
        Campaign objCampaign = [Select Id from Campaign where CampaignCode__c =: 'UTL NOTIF'];
        Test.startTest();
        System.assertEquals(acctRecord.Id,
            AccountService.getAccountIdForLineManager('Test0')[0].Id
        );
        AccountService.populateAribaExternalId(new List<Account>{acctRecord});
        acctRecord.IsTimeSheetSubmitter__c = true;
        update acctRecord;
        acctRecord.IsTimeSheetApprover__c = true;
        update acctRecord;
        Test.stopTest();
    }
}