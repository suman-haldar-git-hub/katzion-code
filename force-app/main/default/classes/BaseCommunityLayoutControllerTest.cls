/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the test class of BaseCommunityLayoutController and  BaseCommunityLayoutService
*/
@isTest(SeeAllData=false)
public class BaseCommunityLayoutControllerTest {
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
        testUser2.EmployeeID__c = 'Test1';
        testUser2.UserName = 'test2inguser@testorg.com';
        insert testUser2;
        System.runAs(testUser) {
            //create account records
            Id personAcctRecdTypeId =
                Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
                getRecordTypeId();
            //create account records
            List<Account> accountList =
                AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
            for(Account acctRecd : accountList){
                acctRecd.PersonBirthdate = System.today();
                acctRecd.Employee_Class__c = 'F';
            }
            insert accountList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test for Other Employee.
*/
    @isTest static void testOtherEmployee(){
        Account acctRecord = [Select Id,Employee_ID__c,Employee_Class__c
                              From Account
                              Where Employee_ID__c ='Test0'];
        acctRecord.Employee_Class__c = 'X';
        update acctRecord;
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test User without employee id.
*/
    @isTest static void testUserWithoutEmpId(){
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        userRecord.EmployeeID__c = '';
        update userRecord;
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            System.assertEquals(false, verNavRes.isError);
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test User Without Account.
*/
    @isTest static void testUserWithoutAcct(){
        Account acctRecord = [Select Id,Employee_ID__c,Employee_Class__c
                              From Account
                              Where Employee_ID__c ='Test0'];
        acctRecord.Employee_ID__c = 'Test9';
        update acctRecord;
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            System.assertEquals(false, verNavRes.isError);
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test for Salaried Employee.
*/
    @isTest static void testSalariedEmployee(){
        Account acctRecord = [Select Id,Employee_ID__c
                              From Account
                              Where Employee_ID__c ='Test0'];
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test for Corporate Employee without salaried direct report.
*/
    @isTest static void testCorporateEmpWithoutSalDirectReportUser(){
        Account acctRecord = [Select Id,Employee_ID__c,Employee_Class__c
                              From Account
                              Where Employee_ID__c ='Test0'];
        acctRecord.Employee_Class__c = 'O';
        update acctRecord;
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test for Corporate Employee with salaried direct report and Salaried Account.
*/
    @isTest static void testCorporateEmpWithSalDirectReportUserAndAcct(){
        Account corEmp = [Select Id,Employee_ID__c,Employee_Class__c
                          From Account
                          Where Employee_ID__c ='Test0'];
        corEmp.Employee_Class__c = 'O';
        update corEmp;
        Account salEmp = [Select Id,Employee_ID__c,Line_Manager__c
                          From Account
                          Where Employee_ID__c ='Test1'];
        salEmp.Line_Manager__c = corEmp.Employee_ID__c;
        update salEmp;
        User managerUser = [Select Id,EmployeeID__c,ManagerId
                            From User
                            Where EmployeeID__c ='Test0'];
        System.assert(managerUser != null);
        System.runAs(managerUser) {
            Test.startTest();
            LightningResponse verNavRes = BaseCommunityLayoutController.fetchRequiredDataOnLoad();
            BaseCommunityLayoutController.completeWalkMeDetailOfUser('Splash');
            BaseCommunityLayoutController.completeWalkMeDetailOfUser('abd');
            BaseCommunityLayoutService.checkSalariedOrContractorAcct(corEmp);
            Test.stopTest();
        }
    }

    @isTest
    static void testgetJWTToken(){        
        String token=BaseCommunityLayoutController.getJWTToken('DESKTOP');
        System.assert(token!=null);
    }
}