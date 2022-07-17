/**
* @author : Manohar dudi
* @company : Cognizant
* @description : 
*/
@isTest
public class UpdateCaseTransactionRecBatchTest {
    /**
    @Author : Manohar dudi
    @Company : Cognizant
    @description : create set up data
    */
    @isTest
    static void makeData(){
        User testUser = UserTestData.getUser('Big W Team', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        testUser.FederationIdentifier = 'testinguser@testorg.com.au';
        insert testUser;
        
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
        
        List<Case> caseTest = CaseTestData.getCaseData( accountTest[0].Id, 10, false);
        ID recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Case cs : caseTest)
        {
            cs.Category__c = 'Pay and the Basics';
            cs.Sub_Category__c = 'Leave Forms';
        }

        insert caseTest;
        System.assert(caseTest!=null);
        for(Case c : caseTest)
        {
            Test.setCreatedDate(c.Id, system.now().adddays(-30));
        }
        Test.startTest();
        UpdateCaseTransactionRecBatchSchedular obj = new UpdateCaseTransactionRecBatchSchedular();
        String sch = '0 0 0 1 APR ? 2022-2040';
        system.schedule('Order Summary Creation batch', sch, obj); 
        Test.stopTest();
    }
}