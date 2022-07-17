/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * MultiselectCaseFilesController class.
*/
@isTest(SeeAllData=false)
private class MultiselectCaseFilesControllerTest {

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This method is used to setup test data
     * 
    */
    @testSetup
    static void dataSetup(){
        TestUtility.crateCaseRecTypeCustomSettings();
    }

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * getFiles method.
    */
    @isTest
    static void testGetFiles() {
        // instantiate Custom Setting
        Case_Record_Types__c caseRec = [SELECT Transaction_Case__c FROM Case_Record_Types__c Limit 1];
        
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(3,transcationCaseId);
        insert cases;
        
        ContentDocumentLink contentDocLik = TestUtility.createTestDocument(cases[0].Id);
        
        List<Id> caseIds = new List<Id>();
        caseIds.add(cases[0].Id);

        Test.startTest();
        LightningResponse ltngResponse = MultiselectCaseFilesController.getFiles(caseIds, cases[1].Id);
        Test.stopTest();

        System.assertEquals(ltngResponse.isError, false);
    }


    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * getFiles method.
    */
    @isTest
    static void testSaveFiles() {
        // instantiate Custom Setting
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;

        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(3,transcationCaseId);
        insert cases;
        
        ContentDocumentLink contentDocLik = TestUtility.createTestDocument(cases[0].Id);
        
        List<Id> contentDocId = new List<Id>();
        contentDocId.add(contentDocLik.ContentDocumentId);

        Test.startTest();
            LightningResponse ltngResponse = MultiselectCaseFilesController.saveFiles(contentDocId, cases[1].Id);
        Test.stopTest();

        System.assertEquals(ltngResponse.isError, false);
    }
    
    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * getFiles method.
    */
    @isTest
    static void testSaveFilesException() {
        
        Test.startTest();
            LightningResponse ltngResponse = MultiselectCaseFilesController.saveFiles(null, null);
        Test.stopTest();

        System.assertEquals(ltngResponse.isError, true);
    }
    
    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * getFiles method.
    */
    @isTest
    static void testGetFilesException() {
        
        Test.startTest();
            LightningResponse ltngResponse = MultiselectCaseFilesController.GetFiles(null, null);
        Test.stopTest();

        System.assertEquals(ltngResponse.isError, true);
    }
}