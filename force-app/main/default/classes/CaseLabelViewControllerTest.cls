/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * CaseLabelViewController and CaseLabelViewAdapter class.
*/
@isTest(SeeAllData=false)
private class CaseLabelViewControllerTest {
    /**
     * @author : Shubham Shukla 
     * @ccompany : Cognizant
     * @description : This method is used to setup test data
     * 
    */
	@testSetup
    static void dataSetup(){
        list<Label_Master__c> labelmasters = LabelMasterTestData.getLabelMasterData(2, true);
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
        caseTest[0].recordTypeId = 
        Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(
            'PS_Query_Case').getRecordTypeId();
        caseTest[0].ownerID = Label.Case_Owner_Id;
        caseTest[0].labels__c = 'Testing0,Testing1';
        insert caseTest;
    }
/**
     * @author : Shubham Shukla 
     * @ccompany : Cognizant
     * @description : This method is used to getlabels
     * 
    */
    @istest
    static void getlabels(){
        test.startTest();

        case objcase =[select id,labels__c from case limit 1];
        lightningResponse lgtResp = caseLabelViewerController.getCaseLabels(objcase.id);
        lightningResponse updResp = caseLabelViewerController.deleteCaseLabels(objcase.id,'Testing0');

        System.assertEquals(lgtResp.isError, false);
        System.assertEquals(updResp.isError, false);

        test.stopTest();
    }
    
}