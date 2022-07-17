/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the following classes:- 
1. SyncUserFromAccountScheduled  
2. SyncUserFromAccountBatch.
*/
@isTest(SeeAllData=false)
public with sharing class SyncUserFromAccountScheduledTest {
    /**
* @author : Daksh
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test0';
        testUser.Area__c = 'NewTown';
        testUser.Department__c = 'IT';
        testUser.JobTitle__c = 'Project Manager';
        testUser.Location__c = 'Australia';
        testUser.Region__c = 'South Australia';
        insert testUser;
        System.runAs(testUser){
            //creating account recods
            List<Account> acctList = AccountTestData.createAccountRecords(200, '');
            insert acctList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void areaDeptNameIsDiffTest(){
        User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown2';
        acctList[0].OpsSupport__c = 'IT';
        acctList[0].Position__c = 'Project Manager';
        acctList[0].Location_Name__c = 'Australia';
        acctList[0].Region__c = 'South Australia';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].Area_Dept_Name__c, '');
        System.assertEquals(acctList[0].Area_Dept_Name__c, 'NewTown2');
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void opsSupportIsDiffTest(){
         User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown';
        acctList[0].OpsSupport__c = 'IT Support';
        acctList[0].Position__c = 'Project Manager';
        acctList[0].Location_Name__c = 'Australia';
        acctList[0].Region__c = 'South Australia';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].OpsSupport__c, '');
        System.assertEquals(acctList[0].OpsSupport__c, 'IT Support');
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void positionIsDiffTest(){
         User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown';
        acctList[0].OpsSupport__c = 'IT';
        acctList[0].Position__c = 'Developer';
        acctList[0].Location_Name__c = 'Australia';
        acctList[0].Region__c = 'South Australia';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].Position__c, '');
        System.assertEquals(acctList[0].Position__c, 'Developer');
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void locationIsDiffTest(){
         User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown';
        acctList[0].OpsSupport__c = 'IT';
        acctList[0].Position__c = 'Project Manager';
        acctList[0].Location_Name__c = 'New Zealand';
        acctList[0].Region__c = 'South Australia';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].Location_Name__c, '');
        System.assertEquals(acctList[0].Location_Name__c, 'New Zealand');
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void regionIsDiffTest(){
         User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown';
        acctList[0].OpsSupport__c = 'IT';
        acctList[0].Position__c = 'Project Manager';
        acctList[0].Location_Name__c = 'Australia';
        acctList[0].Region__c = 'Auckland';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].Region__c, '');
        System.assertEquals(acctList[0].Region__c, 'Auckland');
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test execute methods.
*/
    @isTest static void allIsSameTest(){
        User userRecd = [
            SELECT Id, Area__c, Department__c, JobTitle__c, Location__c,Region__c
            FROM User
            Where EmployeeID__c = 'Test0' Limit 1
        ];
        List<Account> acctList = [
            Select Area_Dept_Name__c,OpsSupport__c,Position__c,Location_Name__c,Region__c 
            From Account
        ];
        acctList[0].Area_Dept_Name__c = 'NewTown';
        acctList[0].OpsSupport__c = 'IT';
        acctList[0].Position__c = 'Project Manager';
        acctList[0].Location_Name__c = 'Australia';
        acctList[0].Region__c = 'South Australia';
        update acctList;
        Test.startTest();
        String jobID = System.schedule('TestScheduledClass', '0 0 0 15 3 ? *', new SyncUserFromAccountScheduled());
        System.assertNotEquals(acctList[0].Area_Dept_Name__c, '');
        System.assertEquals(acctList[0].Area_Dept_Name__c, 'NewTown');
        Test.stopTest();
    }
}