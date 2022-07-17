/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
WalkThroughTooltipController class.
*/
@isTest(SeeAllData=false)
public class WalkThroughTooltipControllerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
             labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
        List<User> lstUser = new List<User>();
        User lineManagerUser = UserTestData.getUser('System Administrator', 'Test2');
        lineManagerUser.EmployeeID__c = 'Test111';
        lineManagerUser.UserName = 'testinguserAnkit@testorg.com';
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
        insert acctList;
    }
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test LeaveManagementController method
    */
    @isTest
    static void testWalkThroughTooltipController()
    {
        Test.startTest();
        List<Account> listOfAccount = [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c
            FROM Account
        ];
        System.assert(!listOfAccount.isEmpty());
        User userRecord = [SELECT Id,EmployeeID__c FROM User WHERE EmployeeID__c ='111Test'];
        System.runAs(userRecord) {
            WalkThroughTooltipController.updateWalkMeDetailOfUser('Splash');
            WalkThroughTooltipController.updateWalkMeDetailOfUser('udsds');
        }
        Test.stopTest();
    }
}