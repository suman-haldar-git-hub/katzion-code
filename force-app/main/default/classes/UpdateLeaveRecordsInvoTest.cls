/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the test class of UpdateLeaveRecordsInvocable
*/
@isTest(SeeAllData=false)
public with sharing class UpdateLeaveRecordsInvoTest {
    /**
* @author : Daksh
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test0';
        insert testUser;
        User testUser2 = UserTestData.getUser('System Administrator', 'Test2');
        testUser2.EmployeeID__c = '';
        testUser2.LineManager__c = 'Test1';
        testUser2.UserName = 'test2inguser@testorg.com';
        insert testUser2;
        System.runAs(testUser) {
            //create account records
            Id personAcctRecdTypeId = 
                Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
                getRecordTypeId();
            List<Account> accountList = 
                AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
            accountList[0].Employee_ID__c = 'Test0';
            accountList[0].Line_Manager__c = 'Test1';
            accountList[1].Employee_ID__c = 'Test1';
            accountList[1].Line_Manager__c = 'Test0';
            insert accountList;
            //create leave records
            Id annualLeaveRecdTypeId = 
                Schema.SObjectType.Leave__c.getRecordTypeInfosByDeveloperName().get('AnnualLeave').
                getRecordTypeId();
            List<Leave__c> leaveList = LeaveTestData.createLeaveRecds(200, annualLeaveRecdTypeId);
            for(Integer i=0 ; i<200 ; i++){
                if(math.mod(i, 2) == 0){
                    leaveList[i].SubmittedBy__c = accountList[0].Id;
                }
                else{
                    leaveList[i].SubmittedBy__c = accountList[1].Id;
                }
            }
            insert leaveList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test updateSubmByUserAndApvUser method.
*/
    @isTest static void updateSubmByUserAndApvUserTest(){
        List<Leave__c> leaveList = [
            Select Id,SubmittedBy__c,SubmittedByUser__c,ApproverUser__c
            From Leave__c Limit 1
        ];
        List<Account> acctList = [
            Select Id,Employee_ID__c,Line_Manager__c
            From Account 
            Where Employee_ID__c ='Test0' 
            OR Employee_ID__c = 'Test1'
        ];
        List<User> userList = [
            Select Id,EmployeeID__c 
            From User 
            Where EmployeeID__c ='Test0'
            OR EmployeeID__c = 'Test1'
        ];
        System.assertNotEquals(userList[0].EmployeeID__c, null);
        System.runAs(userList[0]) {
            Test.startTest();
            UpdateLeaveRecordsInvocable.updateSubmByUserAndApvUser(leaveList);
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test updateSubmByUserAndApvUser method.
*/
    @isTest static void testCatchBlock(){
        List<Leave__c> leaveList = [
            Select Id
            From Leave__c
        ];
        List<Account> acctList = [
            Select Id,Employee_ID__c,Line_Manager__c
            From Account 
            Where Employee_ID__c ='Test0' 
            OR Employee_ID__c = 'Test1'
        ];
        List<User> userList = [
            Select Id,EmployeeID__c 
            From User 
            Where EmployeeID__c ='Test0'
            OR EmployeeID__c = 'Test1'
        ];
        System.assertNotEquals(userList[0].EmployeeID__c, null);
        System.runAs(userList[0]) {
            Test.startTest();
            UpdateLeaveRecordsInvocable.updateSubmByUserAndApvUser(leaveList);
            Test.stopTest();
        }
    }
}