/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * AutoSaveCaseCommentsAdapter class.
*/
@isTest(SeeAllData=false)
public with sharing class CaseCommentDomainTest {

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of
     *  method.
    */
    @isTest
    static void positiveTest() {
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        List<Account> accounts = AccountTestData.createAccountRecords(1, null);
        insert accounts;
        List<Case> cases = CaseTestData.getCaseData(accounts[0].Id, 1, true);
        List<Case_Comment__c> caseComments = CaseCommentTestData.createAccountRecords(1, cases[0].Id);
        
        Test.startTest();
            CaseCommentDomain.upsertCaseComment(caseComments[0]);
            Case_Comment__c caseComment = CaseCommentDomain.queryCaseComments(caseComments[0].Id);
        Test.stopTest();

        System.assertEquals(caseComment.Id, caseComments[0].Id);
    }
}