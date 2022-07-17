/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
MyTeamService class.
*/
@isTest(SeeAllData=false)
public without sharing class MyTeamServiceTest {
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
        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = '123456';
        acctList[0].Line_Manager__c = '1234567';
        insert acctList;
        
        Id annualLeaveRecdTypeId = 
                Schema.SObjectType.Leave__c.getRecordTypeInfosByDeveloperName().get('AnnualLeave').
                getRecordTypeId();
        List<Leave__c> leaveList = LeaveTestData.createLeaveRecds(20, annualLeaveRecdTypeId);
        for(Integer i=0 ; i<20 ; i++){
            leaveList[i].SubmittedBy__c = acctList[0].id;
        }
        insert leaveList;
    }

    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test MyTeamService method
    */
    @isTest
    static void testMyTeamService() {
        List<Leave__c> listLeave = new List<Leave__c>();
        listLeave = [SELECT Id, SubmittedBy__c,SubmittedBy__r.Line_Manager__c,SubmittedBy__r.Employee_ID__c FROM Leave__c];
        System.assert(!listLeave.isEmpty());
        MyTeamService.getEmployeeIdHavingNudgeForCurrentWeek(listLeave);
    }
}