/**
* @author : Ankit Singh
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
* UniversalTaskListTriggerHandler class.
*/
@isTest(SeeAllData=false)
public class UniversalTaskListTriggerHandlerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id personAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
            
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
               
        //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        insert accountList;
        //create UniversalTaskList__c records
        List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
        List<UniversalTaskList__c> approvalTaskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
            approvalTaskList[0].SubmittedForAccount__c = accountList[0].Id;
            approvalTaskList[0].SubmittedByAccount__c = accountList[0].Id;
            approvalTaskList[0].AssignedToAccount__c = accountList[0].Id;
        taskList.add(approvalTaskList[0]);
        List<UniversalTaskList__c> taskRecord =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskRecord[0].RecordTypeId = taskRecordTypeId;
        taskRecord[0].Status__c = '3';
        taskRecord[0].SubmittedForAccount__c = accountList[0].Id;
        taskRecord[0].SubmittedByAccount__c = accountList[0].Id;
        taskRecord[0].AssignedToAccount__c = accountList[0].Id;
        taskList.add(taskRecord[0]);
        Database.insert(taskList);
        Database.update(taskList);
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testAllMethods() {
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c
            From UniversalTaskList__c
        ];
        System.assert(taskList.size() > 0);
    }
}