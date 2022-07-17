/**
* @author : Monika Bisht
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
TaskAndApprovalController class.
*/
@isTest(SeeAllData=false)
public class TaskAndApprovalControllerTest {
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        //create UniversalTaskList__c records
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
            taskList[0].Title__c = 'Title';
        insert taskList;
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
        List<UniversalTaskList__c> taskList2 =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskList2[0].RecordTypeId = taskRecordTypeId;
        taskList2[0].Status__c = '-5';
        taskList2[0].Title__c = 'Title';
        insert taskList2;
    }
    /**
@Author : Monika Bisht
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
            AssignedToAccount__r.Employee_ID__c
            From UniversalTaskList__c
        ];
        TaskAndApprovalController.getTask();
    }
}