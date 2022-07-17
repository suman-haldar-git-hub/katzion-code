/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
LeaveManagementController class.
*/
@isTest(SeeAllData=false)
public class LeaveManagementControllerTest {
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
        
        List<Campaign> campaignList = CampaignTestData.create(1);
        campaignList[0].CampaignCode__c = labelToContentMap.get('LEAVECODEWEEKLY');
        insert campaignList;
        
        //Create Form Records
        List<Form__c> formData = FormTestData.getForm(2, false);
        formData[0].CaseCategory__c='Pay and the Basics';
        formData[0].ActionCentreIcon__c='test.svg';
        formData[0].FormTab__c=labelToContentMap.get('CASHOUTLEAVE');
        formData[0].DisplayOnDesktop__c=true;
        formData[0].DisplayOnMobile__c=true;
        formData[0].FormType__c=labelToContentMap.get('LEAVELABEL');
        formData[1].FormTab__c=labelToContentMap.get('PURCHASELEAVEHEADER');
        formData[1].FormType__c=labelToContentMap.get('LEAVELABEL');
        insert formData;
    }
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test LeaveManagementController method
    */
    @isTest
    static void testLeaveManagementController()
    {
        Test.startTest();
        List<Account> listOfAccount = [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c,
            (
                SELECT Id, From__c, ToDate__c, Status__c, LeaveDuration__c,SubmittedDate__c,
                UnitOfLeave__c, Category__c, SubmittedByAccount__c, AnnualLeaveBal__c,
                PersonalLeaveBal__c, PurchasedLeaveBal__c, LongServiceLeaveBal__c,
                RecordType.DeveloperName, CreatedDate, SubmittedByAccount__r.Name,
                AssignedToAccount__c, SubmittedByAccount__r.FirstName, RecordType.Name,
                SubmittedByAccount__r.Employee_ID__c, ActionURL__c, OwnerId, Duration__c,
                OriginatingSystem__c, Type__c
                From SubmittedByAccount__r
            )
            FROM Account
        ];
        System.assert(!listOfAccount.isEmpty());
        User userRecord = [SELECT Id,EmployeeID__c FROM User WHERE EmployeeID__c ='111Test'];
        System.runAs(userRecord) {
            LeaveManagementController.getLeaveWrapperData(true, true);
        }
        Test.stopTest();
    }
    /**
    @Author : Daksh
    @Company : SaasFocus A Cognizant Company
    @description : Test exception case
    */
    @isTest
    static void testCatchBlock(){
        Test.startTest();
        List<Account> listOfAccount = [
            SELECT Id, Name,
            (
                SELECT Id, From__c, ToDate__c, Status__c, LeaveDuration__c,SubmittedDate__c,
                UnitOfLeave__c, Category__c, SubmittedByAccount__c, AnnualLeaveBal__c,
                PersonalLeaveBal__c, PurchasedLeaveBal__c, LongServiceLeaveBal__c,
                RecordType.DeveloperName, CreatedDate, SubmittedByAccount__r.Name,
                AssignedToAccount__c, SubmittedByAccount__r.FirstName, RecordType.Name,
                SubmittedByAccount__r.Employee_ID__c, ActionURL__c, OwnerId, Duration__c,
                OriginatingSystem__c, Type__c
                From SubmittedByAccount__r
            )
            FROM Account
        ];
        System.assert(!listOfAccount.isEmpty());
        LeaveManagementController.getLeaveWrapperData(true,true);
        Test.stopTest();
    }
}