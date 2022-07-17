/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
LeaveService class.
*/
@isTest(SeeAllData=false)
public class LeaveServiceTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        //Create User
        User usr = new User();
        usr = UserTestData.getUser('Team Member', 'Test1');
        usr.EmployeeId__c = 'Test123';
        insert usr;
    }
    
    /**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : Test LeaveService method
*/
    @isTest
    static void testLeaveService()
    {    
        User usr = [SELECT Id FROM USER WHERE EmployeeId__c = 'Test123' LIMIT 1];
        //Create Account
        Id personAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        Id recordTypeIdApproval = Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByName()
            .get('Task').getRecordTypeId();
        
        List<Account> acctList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        acctList[0].Employee_ID__c = 'test67';
        acctList[0].Employee_Class__c = 'F';
        acctList[1].Employee_ID__c = 'UTL_SYS';
        acctList[1].Employee_Class__c = 'F';
        acctList[1].Region__c = 'Test';
        acctList[1].BaseHours__c = 40;
        acctList[1].Employee_Class__c = labelToContentMap.get('EMPLOYEEGROUPFULLTIME');
        acctList[1].TerminationDate__c = null;
        acctList[1].Employee_ID__c = 'Test123';
        acctList[1].Line_Manager__c = 'test67';
        acctList[1].AnnualLeaveBalance__c = 150;
        acctList[1].LongServiceLeaveBalance__c = 0;
        acctList[1].PersonalLeaveBalance__c = 90;
        acctList[1].PurchasedLeaveBalance__c = 12;
        acctList[1].PaymentFrequency__c = 'Monthly';
        insert acctList;
        //create campaign record
        list<Campaign> listCam = CampaignTestData.create(1);
        listCam[0].CampaignCode__c = 'UTL NOTIF';
        insert listCam;
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(5, recordTypeIdApproval);
        taskList[0].Type__c = labelToContentMap.get('LEAVELABEL');
        taskList[0].RecordTypeId = recordTypeIdApproval;
        taskList[0].OriginatingSystem__c = 'TeamHub';
        taskList[0].SystemOfAction__c = 'TeamHub';
        taskList[0].DeepLink__c = labelToContentMap.get('APPLYLEAVESUCCESSFACTORS');
        taskList[0].Status__c = labelToContentMap.get('TASKSTATUSINPROGRESS');
        taskList[0].DueDate__c = ((Date.today()).toStartofWeek()).addDays(7);
        taskList[0].ReceivedDate__c = Date.today();
        taskList[0].Category__c = '0610';
        taskList[0].Duration__c = 1;
        taskList[0].SubmittedByAccount__c = acctList[1].Id;
        taskList[0].OwnerId = usr.Id;
        insert taskList;
        
        //create campaign records
        List<Campaign> campListRecord = CampaignTestData.create(1);
        campListRecord[0].CampaignCode__c = 'LEAVE NOTIF';
        insert campListRecord;
        
        Test.startTest();
        List<Campaign> campList = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        List<Account> listOfAccount = [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c FROM Account
        ];
        List<UniversalTaskList__c> utlList = [Select Id, ToDate__c From UniversalTaskList__c];
        System.assert(!listOfAccount.isEmpty());
        User userRecord = [SELECT Id,EmployeeID__c FROM User WHERE EmployeeID__c ='Test123'];
        Datetime dateOb = Date.today().addDays(-20);
        System.runAs(userRecord) {
            Account acc = LeaveService.getCurrentLeaves();
            LeaveService.getCurrentLeaves();
            LeaveService.decidePurchaseLeaveVisibility(acc);
            LeaveService.getPicklistValues(labelToContentMap.get('ACCOUNT'),labelToContentMap.get('PAYMENTFREQUENCYFIELDAPINAME'));
            LeaveService.getNudgeData('listOfAccount[0].id');
            LeaveService.checkLWPInLastTwoMonth(utlList[0], dateOb);
        }
        Test.stopTest();
    }
}