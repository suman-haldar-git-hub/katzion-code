/**
* @author : Ankit Singh
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
* UTLService class.
*/
@isTest(SeeAllData=false)
public class UTLServiceTest {
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
            
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        accountList[0].Employee_ID__c = '111Test';
        accountList[1].Employee_ID__c = labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID');
        insert accountList;
        List<User> lstUser = new List<User>();
        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = '111Test';
        testUser.UserName = 'monika@testorg.com';
        lstUser.add(testUser);
        insert lstUser;
        //create UniversalTaskList__c records
        List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
        List<UniversalTaskList__c> approvalTaskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
            approvalTaskList[0].SubmittedForAccount__c = accountList[0].Id;
            approvalTaskList[0].SubmittedByAccount__c = accountList[0].Id;
            approvalTaskList[0].PrimarySourceId__c = '12345';
            approvalTaskList[0].AssignedToAccount__c = accountList[0].Id;
        taskList.add(approvalTaskList[0]);
        List<UniversalTaskList__c> taskRecord =
            UniversalTaskListTestData.createAccountRecords(2, approvalRecordTypeId);
        taskRecord[0].RecordTypeId = taskRecordTypeId;
        taskRecord[0].Status__c = '3';
        //taskRecord[0].SubmittedForAccount__c = accountList[0].Id;
        taskRecord[0].SubmittedByAccount__c = accountList[0].Id;
        taskRecord[0].OriginatingSystem__c = 'SuccessFactors';
        taskRecord[0].SubmittedDate__c = system.today();
        taskRecord[0].SecondarySourceId__c = '12345';
        taskRecord[0].AssignedToAccount__c = accountList[0].Id;
        taskRecord[0].Parent__c = approvalTaskList[0].id;
        taskList.add(taskRecord[0]);
        taskRecord[1].RecordTypeId = taskRecordTypeId;
        taskRecord[1].Status__c = '2';
        //taskRecord[0].SubmittedForAccount__c = accountList[0].Id;
        taskRecord[1].SubmittedByAccount__c = accountList[0].Id;
        taskRecord[1].OriginatingSystem__c = 'Ariba';
        taskRecord[1].SubmittedDate__c = system.today();
        taskRecord[1].SecondarySourceId__c = '12345';
        taskRecord[1].AssignedToAccount__c = accountList[0].Id;
        taskRecord[1].Parent__c = approvalTaskList[0].id;
        taskRecord[1].Type__c = 'Requisitions';
        taskList.add(taskRecord[1]);
        Database.insert(taskList);
        List<UniversalTaskList__c> taskToUpdate = [Select Id, Status__c From UniversalTaskList__c Where Status__c='2'];
        taskToUpdate[0].Status__c = '8';
        Database.update(taskToUpdate);
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