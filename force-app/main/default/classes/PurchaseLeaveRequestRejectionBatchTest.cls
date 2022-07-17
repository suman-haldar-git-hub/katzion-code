/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* PurchaseLeaveRequestRejectionBatch class.
*/
@isTest(SeeAllData=false)
public class PurchaseLeaveRequestRejectionBatchTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
        List<User> lstUser = new List<User>();
        User lineManagerUser = UserTestData.getUser('System Administrator', 'Test2');
        lineManagerUser.EmployeeID__c = 'Test111';
        lineManagerUser.UserName = 'testinguserAnkit@testorg.com';
        lineManagerUser.LeaveNotificationChannel__c = 'TeamHub;';
        lstUser.add(lineManagerUser);
        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = '111Test';
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
        acctList[0].Employee_Class__c = labelToContentMap.get('EMPLOYEEGROUPFULLTIME');
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = '111Test';
        acctList[0].Line_Manager__c = 'Test111';
        acctList[0].Country__c = 'Australia';
        acctList[0].BaseHours__c = 1;
        insert acctList;

        Id purchaseLeaveReqRecdTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
        //create purchase leave records
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, purchaseLeaveReqRecdTypeId);
        taskList[0].Status__c = 'Submitted';
        taskList[0].Category__c = '0610';
        taskList[0].Type__c = 'Leave';
        taskList[0].SystemRejected__c = false;
        insert taskList;
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test PurchaseLeaveRequestRejectionBatch method
    */
    @isTest
    static void testPurchaseLeaveRequestRejectionSchedule()
    {
        List<UniversalTaskList__c> listOfLeaves = [
                SELECT Id, Status__c, RecordType.Name, SystemRejected__c
                FROM UniversalTaskList__c
        ];
        PurchaseLeaveRequestRejectionBatch batchObj = new PurchaseLeaveRequestRejectionBatch();
        Database.executeBatch(batchObj);
        System.assert(!listOfLeaves.isEmpty());
        Test.startTest();
            String jobID = System.schedule(
                    'PurchaseLeaveRequestRejectionScheduledClass',
                    '0 0 22 30 5 ? *',
                    new PurchaseLeaveRequestRejectionBatch()
            );
        Test.stopTest();
    }
}