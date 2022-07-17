/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the SubmitterAndApproverReminderBatch
*/
@isTest(SeeAllData=false)
public class SubmitterAndApproverReminderBatchTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
* @author : Amit Sharma
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup
    static void setupData(){
        //SubmitterAndApproverReminderBatch.scheduleDay = labelToContentMap.get('BATCHSUBMITTERDAY');
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
         User objUser = UserTestData.getUser('System Administrator', 'Test1');  
         objUser.EmployeeId__c = 'Test007';
         objUser.ReceiveTaskNotificationsFor__c = 'CATS';
         objUser.TaskNotification__c = true;
         objUser.TaskNotificationChannel__c = 'Email';
         insert objUser;
        //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountList[0].Employee_Id__c = 'Test007';
        accountList[0].Area_Dept_Name__c = 'CEO Support;Corporate- Public Affair';
        accountList[0].Brand__c = 'Corporate';
        accountList[0].Group__c = 'Support Functions';
        accountList[0].OpsSupport__c = 'CEO Support;Corporate Strategy';
        accountList[0].Country__c = 'Australia';
        accountList[0].IsLineManager__c = 'No';
        accountList[0].HasDOA__c = 'No';
        accountList[0].IsTimeSheetSubmitter__c = true;
        accountList[0].Active__c = 'Y';
        insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
        System.assert(accountRecd != null);
        
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
    }
    
     @isTest
    static void testBatch(){
        User u = [Select id,ReceiveTaskNotificationsFor__c,EmployeeId__c,TaskNotification__c,
        TaskNotificationChannel__c 
         FROM user where EmployeeId__c = 'Test007' LIMIT 1];
        System.runAs(u){
        List<Account> accountList = [
            Select id,PersonContactId,Area_Dept_Name__c,Brand__c,
            CareerLevel__c,Employee_Class__c,Employee_Type__c,Employee_ID__c,
            Group__c,Location_Name__c,Region__c,OpsSupport__c
            From Account
        ];
        System.assert(accountList != null);
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        
        Test.startTest();
        SubmitterAndApproverReminderBatch objBatchClass = new SubmitterAndApproverReminderBatch();
        Database.executeBatch(objBatchClass);
        
        SubmitterAndApproverReminderBatch sh1 = new SubmitterAndApproverReminderBatch();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
        }
    }
}