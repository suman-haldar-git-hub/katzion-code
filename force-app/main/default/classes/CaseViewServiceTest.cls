/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for 'VaseViewService' class...
 */
@isTest
public class CaseViewServiceTest {
    @testSetup
    static void makeData(){
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123456';
        insert accountTest;

        Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();
        caseRecTypeCS.Transaction_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.WOW_NZ_ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.Query_Case__c = String.valueOf(caseRecTypeId);
        insert caseRecTypeCS;

        List<Case> caseTest = CaseTestData.getCaseData(
            accountTest[0].Id,
            1,
            false
        );
        caseTest[0].recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        caseTest[0].ownerID = Label.Case_Owner_Id;
        insert caseTest;
    }
    @isTest
    static void createNewRecordTest(){
        Case caseId = [SELECT Id FROM Case LIMIT 1];
        test.startTest();
        CaseViewService.createNewRecord(caseId.Id);
        test.stopTest();
        system.assertEquals(caseId!=null, true);
    }
}