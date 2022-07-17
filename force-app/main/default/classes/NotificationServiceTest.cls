/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
NotificationService class.
*/
@isTest(SeeAllData=false)
public without sharing class NotificationServiceTest {
private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
   /**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        Id recordTypeIdTask = Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByName().get('Task').getRecordTypeId();
        List<User> lstUser = new List<User>();
        User lineManagerUser = UserTestData.getUser('System Administrator', 'Test2');
        lineManagerUser.EmployeeID__c = 'test67';
        lineManagerUser.UserName = 'testinguserAnkit@testorg.com';
        lstUser.add(lineManagerUser);
        
        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = 'Test56';
        testUser.UserName = 'ankit@testorg.com';
        lstUser.add(testUser);
        insert lstUser;
        
        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].Area_Dept_Name__c = 'Test';
        acctList[0].Location_Name__c = 'Test';
        acctList[0].IsLineManager__c = 'Yes';
        acctList[0].HasDOA__c = 'Yes';
        acctList[0].CareerLevel__c = 'Test';
        acctList[0].Region__c = 'Test';
        acctList[0].BaseHours__c = 40;
        acctList[0].Employee_Class__c = Label.EMPLOYEEGROUPFULLTIME;
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = 'test67';
        acctList[0].Line_Manager__c = 'test67';
        insert acctList;
        //create campaign record
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
        List<UniversalTaskList__c> taskList =
            	UniversalTaskListTestData.createAccountRecords(5, recordTypeIdTask);
        taskList[0].Type__c = 'Nudge';
        taskList[0].RecordTypeId = recordTypeIdTask;
        taskList[0].OriginatingSystem__c = 'TeamHub';
        taskList[0].SystemOfAction__c = 'SuccessFactors';
        taskList[0].DeepLink__c = labelToContentMap.get('APPLYLEAVESUCCESSFACTORS');
        taskList[0].Status__c = labelToContentMap.get('TASKSTATUSINPROGRESS');
        taskList[0].DueDate__c = ((Date.today()).toStartofWeek()).addDays(7);
        taskList[0].ReceivedDate__c = Date.today();
        taskList[0].SubmittedForAccount__c = acctList[0].Id;
        taskList[0].OwnerId = lstUser[0].Id;
        insert taskList;
    }
    
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test NotificationService method
    */
    @isTest
    static void testNotificationService(){
        List<Account> listOfAccount = [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c
            FROM Account 
        ];
        System.assert(!listOfAccount.isEmpty());
        set<string> setEmpId = new set<string>();
        setEmpId.add(listOfAccount[0].Employee_ID__c); 
        User userRecord = [SELECT Id,EmployeeID__c FROM User WHERE EmployeeID__c ='test67'];
        String accIdLMEmpId = listOfAccount[0].Id+'-:-'+
            					listOfAccount[0].Line_Manager__c+'-:-'+
            					userRecord.EmployeeID__c;
        System.runAs(userRecord) {
            Test.startTest();
            NotificationService.getNudgesTaskForCurrentWeek(setEmpId);
            NotificationService.createNudge(accIdLMEmpId,userRecord.id);
            NotificationService.createNudge('ABC-:-ABC-:-ABC',userRecord.id);
            Test.stopTest();
        }
    }
}