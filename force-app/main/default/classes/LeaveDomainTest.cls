/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
LeaveDomain class.
*/
@isTest(SeeAllData=false)
public class LeaveDomainTest {
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
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = 'Test111';
        acctList[0].Line_Manager__c = '111Test';
        insert acctList;

        Id annualLeaveRecdTypeId =
                Schema.SObjectType.Leave__c.getRecordTypeInfosByDeveloperName().get('AnnualLeave').
                getRecordTypeId();
        Id purchaseLeaveReqRecdTypeId = Schema.SObjectType.Leave__c.getRecordTypeInfosByName().get(
                labelToContentMap.get('RECORDTYPEPURCHASELEAVEREQUEST')).getRecordTypeId();
        List<Leave__c> leaveList = LeaveTestData.createLeaveRecds(20, annualLeaveRecdTypeId);
        for(Integer i=0 ; i<20 ; i++){
            leaveList[i].SubmittedBy__c = acctList[0].id;
            if(i == 3) {
                leaveList[i].RecordTypeId = purchaseLeaveReqRecdTypeId;
                leaveList[i].Status__c = labelToContentMap.get('APPROVED');
            }
        }
        insert leaveList;
    }

    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test LeaveDomain method
    */
    @isTest
    static void testLeaveDomain() {
        List<Leave__c> listLeave = new List<Leave__c>();
        listLeave = [SELECT Id, SubmittedBy__c,SubmittedBy__r.Line_Manager__c,RecordType.Name
            FROM Leave__c];
        System.assert(!listLeave.isEmpty());
        LeaveDomain.getMyLeaveRequests(listLeave[0].SubmittedBy__c);
        LeaveDomain.getMaxAnnualLeaveBalanceRecord('1234567');
        LeaveDomain.queryLeaveWithLineManager(3,'1234567');
        LeaveDomain.queryLeaveWithLineManagerUsingOffset(3,0,'1234567');
        LeaveDomain.getTotalCountOfLeave('1234567');
        LeaveDomain.queryLWPSubmittedBy(new Set<String>{'1234567'});
        LeaveDomain.queryLeaveForRecTypeAndCreatedDate(
            new LeaveRequestService.ExcessPurchaseWrapper()
        );
        for(Leave__c eachLeave : listLeave) {
            if(eachLeave.RecordType.Name ==
                        labelToContentMap.get('RECORDTYPEPURCHASELEAVEREQUEST')) {
                System.assertNotEquals(LeaveDomain.queryForPurchaseNotification(eachLeave.Id), null);
            }
        }
    }
}