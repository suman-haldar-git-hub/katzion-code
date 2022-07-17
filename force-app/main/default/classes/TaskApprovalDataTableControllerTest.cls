/**
* @author : Daksh Madan
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
TaskApprovalDataTableController class.
*/
@isTest(SeeAllData=false)
public class TaskApprovalDataTableControllerTest {
    /**
    @Author : Daksh Madan
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        //create campaign records
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;
        List<Account> accounts=ActionCentreTestData.getAccounts(1,true);
        //create UniversalTaskList__c records
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
            taskList[0].RecordTypeId = approvalRecordTypeId;
            taskList[0].Status__c = 'requested';
            taskList[0].Title__c = 'Title';
            taskList[0].OriginatingSystem__c = 'TeamHub';
            taskList[0].DueDate__c = System.now().addDays(-3);
            taskList[0].Type__c='UTL';
            taskList[0].Category__c='CONTRACT';   
            taskList[0].SubmittedByAccount__c=accounts[0].Id;
            taskList[0].SubmittedForAccount__c=accounts[0].Id;        
        insert taskList;
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
        List<UniversalTaskList__c> taskList2 =
            UniversalTaskListTestData.createAccountRecords(1, taskRecordTypeId);
        taskList2[0].RecordTypeId = taskRecordTypeId;
        taskList2[0].Status__c = '-5';
        taskList2[0].Title__c = 'Title';
        taskList2[0].OriginatingSystem__c = 'TeamHub';
        taskList2[0].DueDate__c = System.now().addDays(-3);
        taskList2[0].Type__c='UTL';
        taskList2[0].Category__c='CONTRACT';
        taskList2[0].SubmittedByAccount__c=accounts[0].Id;
        taskList2[0].SubmittedForAccount__c=accounts[0].Id;
        insert taskList2;
    }
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : Test all method
*/
    @isTest
    static void testAllMethods() {
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c, Category__c,Type__c,
            SubmittedForAccount__r.Name,SubmittedByAccount__r.Name 
            From UniversalTaskList__c
        ];        
        LightningResponse resp=TaskApprovalDataTableController.completeTask(taskList[0].id);
        System.assert(resp.isError==false);
        TaskApprovalDataTableController.getDetailsForUtlLanding(taskList[0].id);        
    }
    

    /**
    * @author       Abhishek Setia
    * @description  Test method for TaskApprovalDataTableController.getTaskRecords
    */
    @isTest
    static void getTaskRecordsTest() {
        TaskApprovalDataTableController.RequestWrapper reqwrap=new TaskApprovalDataTableController.RequestWrapper();
        reqwrap.initialRows=10;
        reqwrap.filterType='My Task';
        reqwrap.columnSorting=' ORDER BY ReceivedDate__c ASC NULLS LAST ';
        reqwrap.keyword='Title';
        reqwrap.type='TeamHub,SuccessFactors,ServiceWOW,Ariba,Expense8,CATS,SAPPY,Concur';
        reqwrap.offset=0;
        TaskApprovalDataTableController.TaskWrapper tw=null;
        tw=TaskApprovalDataTableController.getTaskRecords(JSON.serialize(reqwrap));
        System.assert(1==tw.taskList.size());
        reqwrap.filterType='My Approval';
        tw=TaskApprovalDataTableController.getTaskRecords(JSON.serialize(reqwrap));
        System.assert(1==tw.taskList.size());
    }
    
}