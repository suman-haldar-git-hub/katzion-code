/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
PurchaseLeaveVisibilityService class.
*/
@isTest(SeeAllData=false)
public without sharing class PurchaseLeaveVisibilityServiceTest {
     private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Praveen Tiwari
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
    
    @isTest
    static void testMethod1(){
        User usr = [Select Id From User Where EmployeeId__c = 'Test123' LIMIT 1];
        
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
        
        System.runAs(usr){
            Account acc = LeaveService.getCurrentLeaves();
            test.startTest();
            	Map<String, String> m1 = PurchaseLeaveVisibilityService.decidePurchaseLeaveVisibility(acc);
            test.stopTest();
            System.assertEquals('1 Week', m1.get('Eligible'));
        }
    }
}