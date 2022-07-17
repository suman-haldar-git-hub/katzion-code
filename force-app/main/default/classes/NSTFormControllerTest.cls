/**
* @author : Amit Sharma
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
NSTFormController class.
*/
@isTest(SeeAllData=false)
public with sharing class NSTFormControllerTest {
    
    /*@Author : Amit Sharma
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        
        Account objAccount = new Account();
        objAccount.LastName = 'Test Account';
        objAccount.PersonBirthdate = System.today()-2000;
        objAccount.Employee_ID__c = userDetail.EmployeeID__c;
        
        insert objAccount;
        
        Schedule__c objSchedule = new Schedule__c();
        objSchedule.ScheduleDate__c = system.now();
        objSchedule.PayCode__c = '7891191';
        objSchedule.TeamMember__c = objAccount.id;
        
        insert objSchedule;
    }
      /**
    @Author : Amit Sharma
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testAllMethods() {
        Set<String> setDeveloperName = new Set<String>();
        setDeveloperName.add('NSTTHINGSTOKNOW1');
        setDeveloperName.add('NSTTHINGSTOKNOW2'); 
        List<CommunityContentInfo__mdt> lstCustomEmtadata = 
                                    CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName);
        System.assertNotEquals(CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName),null);
        NSTFormController.getContentFromMetadata();
        List<Schedule__c> lstSchedule = [Select Id, Name From Schedule__c limit 1];
        system.debug('lstSchedule=='+lstSchedule);
        System.assertNotEquals(lstSchedule,null);
        NSTFormController.getScheduleDataCurrentWeek();
    }
}