/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * AutoSaveCaseCommentsAdapter class.
*/
@isTest(SeeAllData=false)
public with sharing class AutoSaveCaseCommentsControllerTest {
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used create setup data for testing.
    */
    @testSetup
    static void dataSetup(){
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        List<Account> accounts = AccountTestData.createAccountRecords(1, null);
        insert accounts;
        List<Case> cases = CaseTestData.getCaseData(accounts[0].Id, 1, true);
        List<Case_Comment__c> caseComments = CaseCommentTestData.createAccountRecords(1, cases[0].Id);
        insert caseComments;
    }

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of
     *  method.
    */
    @isTest
    static void positiveTest() {
        
        Case_Comment__c caseComment = [SELECT Id, Case__c, Feed_Item_Id__c from Case_Comment__c Limit 1];
        
        Test.startTest();
            lightningResponse resp = AutoSaveCaseCommentsController.getData(caseComment.Id);
            lightningResponse respSave = AutoSaveCaseCommentsController.saveData(caseComment.Id, caseComment.Case__c, 'Test Comment','Internal','Test');
        	AutoSaveCaseCommentsController.deleteChatter(caseComment.Id, caseComment.Feed_Item_Id__c);
        Test.stopTest();

        System.assertEquals(resp.isError, false, 'Success');
        System.assertEquals(respSave.isError, false, 'Success');
    }
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover negative scenarios of
     *  method.
    */
    @isTest
    static void negativeTest() {
        Test.startTest();
            lightningResponse resp = AutoSaveCaseCommentsController.getData('INVALID_ID');
            lightningResponse respSave = AutoSaveCaseCommentsController.saveData('INVALID_ID', 'INVALID_ID', 'Test Comment','Internal','Test');       	
        Test.stopTest();

        System.assertEquals(resp.isError, true, 'Success');
        System.assertEquals(respSave.isError, true,'Success' );
    }
}