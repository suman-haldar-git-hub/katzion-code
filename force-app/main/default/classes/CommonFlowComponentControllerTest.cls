/**
@Author : Praveen Tiwari
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover CommonFlowComponentController class.
*/
@isTest(SeeAllData=false)
public class CommonFlowComponentControllerTest {
    @testSetup
    static void setUpData(){
        //Create User
        List<User> userList = new List<User>();
        User usr = new User();
        usr = UserTestData.getUser('System Administrator', 'Test1');
        usr.EmployeeId__c = 'Test123';
        insert usr;
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
        List<Case> caseLst = CaseTestData.getCaseData(accountList[0].Id, 4, false);
        caseLst[0].RecordTypeId = transactionRecdTypeId;
        caseLst[0].CaseApproved__c = 'Pending';
        caseLst[0].Category__c = 'Pay and the Basics';
        caseLst[0].Sub_Category__c = 'Salary Sacrifice';
        caseLst[0].TypeofDevice__c = 'Tablet';
        caseLst[1].Category__c = 'Pay and the Basics';
        caseLst[1].Sub_Category__c = 'Superannuation Processing';
        caseLst[1].Subject = 'MyIncentive Info AVC Nominations Full Year';
        caseLst[2].Category__c = 'Pay and the Basics';
        caseLst[2].Sub_Category__c = 'Superannuation Processing';
        caseLst[2].Subject = 'MyIncentive Info AVC Nominations Full Year';
        caseLst[3].Sub_Category__c = 'Leaves';
        caseLst[3].TypeofDevice__c = 'Tablet';
        caseLst[3].Category__c = 'Pay and the Basics';
        insert caseLst;
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(caseLst[0].Id, yesterday);
        //Create Form records
        List<Form__c> formList = FormTestData.getForm(2, False);
        formList[0].FormTab__c = 'MyDevice';
        formList[0].MaximumDeviceEligibility__c = 2;
        formList[1].FormTab__c = 'MyIncentive';
        insert formList;
    }
    @isTest
    static void testMethod1(){
        User usr = [Select Id From User Where EmployeeId__c = 'Test123' LIMIT 1];
        Account acc = [Select Id, (Select Id From Cases) From Account Where Employee_Id__c = 'Test123' LIMIT 1];
        Account adminAcc = [Select Id From Account Where Employee_Id__c = 'UTL_SYS' LIMIT 1];
        List<Case> caseLst = [Select Id From Case
            Where Category__c = 'Pay and the Basics'
            AND Sub_Category__c = 'Superannuation Processing'
            AND Subject = 'MyIncentive Info AVC Nominations Full Year'
            AND AccountId = :acc.Id
            AND CreatedDate <= :System.Now()];
        caseLst[0].AccountId = adminAcc.Id;
        caseLst[1].parentId = caseLst[0].Id;
        caseLst[1].TypeofDevice__c = 'Mobile Phone';
        update caseLst;
        System.runAs(usr){
            test.startTest();
                LightningResponse resp = CommonFlowComponentController.getDataForDeviceFlow();
                LightningResponse resp2 = CommonFlowComponentController.getDataFormyIncentiveFlow();
                LightningResponse resp3 = CommonFlowComponentController.getCaseRecordDetail(caseLst[0].Id);
            test.stopTest();
            System.assertEquals(false, String.isBlank(resp.payLoad));
            System.assertEquals(false, String.isBlank(resp2.payLoad));
            System.assertEquals(false, String.isBlank(resp3.payLoad));
        }
    }
    @isTest
    static void testMethod2(){
        User usr = [Select Id From User Where EmployeeId__c = 'Test123' LIMIT 1];
        List<Case> caseLst = [Select Id From Case
            Where Category__c = 'Pay and the Basics'
            AND Sub_Category__c = 'Leaves'];
        System.runAs(usr){
            test.startTest();
            	LightningResponse resp = CommonFlowComponentController.getDataFormyIncentiveFlow();
                LightningResponse resp2 = CommonFlowComponentController.getDataForDeviceFlow();
            	LightningResponse resp3 = CommonFlowComponentController.getCaseRecordDetail(caseLst[0].Id);
            test.stopTest();
            System.assertEquals(false, String.isBlank(resp.payLoad));
            System.assertEquals(false, String.isBlank(resp2.payLoad));
        }
    }
    
    @isTest
    static void getFormRecordDetailTest(){
        List<Form__c> forms = FormTestData.getForm(1, true);
        forms[0].CaseCategory__c = 'Pay & Basics';
        insert forms;
        Test.startTest();
        Form__c objForm = CommonFlowComponentController.getFormRecordDetail(forms[0].Id);
        Test.stopTest();
        system.assertEquals(objForm.CaseCategory__c,'Pay & Basics');
    }

}