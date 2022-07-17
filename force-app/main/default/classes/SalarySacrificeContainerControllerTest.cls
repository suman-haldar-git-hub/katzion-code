/**
@Author : Praveen Tiwari
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover SalarySacrificeContainerController class.
*/
@isTest(SeeAllData=false)
public class SalarySacrificeContainerControllerTest {
    @testSetup
    static void setupData(){
        //Create User
        // User usr = new User();
        // usr = UserTestData.getUser('Team Member', 'Test1');
        // usr.EmployeeId__c = 'Test123';
        // insert usr;
        //Create Account
        Id personAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[0].Employee_ID__c = 'Test123';
        accountList[0].Employee_Class__c = 'F';
        accountList[1].Employee_ID__c = 'UTL_SYS';
        accountList[1].Employee_Class__c = 'F';
        accountList[1].Line_Manager__c = 'Test123';
        insert accountList;
        Id transactionRecdTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().
            get('Transaction').getRecordTypeId();
        //Create Custom Settings
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();
        caseRecTypeCS.Transaction_Case__c = String.valueOf(transactionRecdTypeId);
        caseRecTypeCS.ER_Case__c = String.valueOf(transactionRecdTypeId);
        caseRecTypeCS.WOW_NZ_ER_Case__c = String.valueOf(transactionRecdTypeId);
        caseRecTypeCS.Query_Case__c = String.valueOf(transactionRecdTypeId);
        insert caseRecTypeCS;
        //Create Case
        List<Case> caseLst = CaseTestData.getCaseData(accountList[0].Id, 1, false);
        caseLst[0].RecordTypeId = transactionRecdTypeId;
        caseLst[0].CaseApproved__c = 'Pending';
        caseLst[0].Category__c = 'Pay and the Basics';
        caseLst[0].Sub_Category__c = 'Salary Sacrifice';
        caseLst[0].TypeofDevice__c = 'Tablet';
        insert caseLst;
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(caseLst[0].Id, yesterday);
        //Create Form records
        List<Form__c> formList = FormTestData.getForm(3, False);
        formList[0].FormTab__c = 'MyDevice';
        formList[0].DisplayOnDesktop__c = true;
        formList[0].FormType__c = 'ActionCentre';
        formList[1].FormTab__c = 'MyIncentive';
        formList[1].FormType__c = 'SalarySacrifice';
        formList[1].FormTab__c = 'MyDevice';
        formList[1].StartDate__c = System.today()+10;
        formList[1].EndDate__c = System.today()+20;
        formList[1].DisplayOnDesktop__c = true;
        formList[2].FormType__c = 'SalarySacrifice';
        formList[2].FormTab__c = 'Purchase Leave';
        formList[2].DisplayOnDesktop__c = true;
        insert formList;
    }
    @isTest
    static void testMethod1(){
        //Create User
        User usr = new User();
        usr = UserTestData.getUser('Team Member', 'Test1');
        usr.EmployeeId__c = 'Test123';
        insert usr;
        //User usr = [Select Id From User Where EmployeeId__c = 'Test123' LIMIT 1];
        System.runAs(usr){
            test.startTest();
                LightningResponse resp = SalarySacrificeContainerController.getFormDataOnLoad(true, false);
            test.stopTest();
            System.assertEquals(false, String.isBlank(resp.payLoad));
        }
    }
    @isTest
    static void testMyDeviceEligibility(){
        //User usr = [Select Id From User Where EmployeeId__c = 'Test123' LIMIT 1];
        //Create User
        User usr = new User();
        usr = UserTestData.getUser('System Administrator', 'Test12');
        usr.EmployeeId__c = 'Test1234';
        insert usr;
        System.runAs(usr){
            List<Form__c> formLst = [Select Id, StartDate__c, EndDate__c, FormTab__c, FormType__c
                                 From Form__c
                                Where FormType__c = 'SalarySacrifice'];
            formLst[0].MaximumDeviceEligibility__c = 2;
            update formLst;
            
            test.startTest();
                LightningResponse resp = SalarySacrificeContainerController.getFormDataOnLoad(true, false);
            test.stopTest();
            System.assertEquals(true, String.isBlank(resp.payLoad));
        }
    }
}