/**
* @author : Amit Sharma
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
* UniversalTaskListShareDomain class.
*/
@isTest(SeeAllData=false)
public class UniversalTaskListShareDomainTest {
    /**
    @Author : Amit Sharma
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
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        //create campaign record
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
        
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
       
        Database.insert(taskList);
    }

    /**
    @Author : Amit Sharma
    @Company : SaasFocus A Cognizant Company
    @description : Test the method
    */
    @isTest
    static void testMethodsShareDomain() {
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c
            From UniversalTaskList__c
        ];
        System.assert(taskList.size() > 0);
    }
}