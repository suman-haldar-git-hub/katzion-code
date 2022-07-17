/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * MultiselectCaseLabelAdapter class.
*/
@isTest(SeeAllData=false)
private class MultiselectCaseLabelAdapterTest {

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This method is used to setup test data
     * 
    */
    @testSetup
    static void dataSetup(){
        CaseRecordTypesTestData.crateTestCustomSetting();
    }

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of
     * getCaseLabels method and updateCaseLabels method.
    */
    @isTest
    static void testGetLabelsAndUpdate() {
        List<Account> accounts = AccountTestData.createAccountRecords(1, null);
        Insert accounts;
        List<Case> cases = CaseTestData.getCaseData(accounts[0].Id, 1, True);
        List<String> caseLabels = new List<String>();
        caseLabels.add('Label 1');
        caseLabels.add('Label 2');

        test.startTest();
        lightningResponse updateResp = MultiselectCaseLabelAdapter.updateCaseLabels(cases[0].Id, caseLabels);
        lightningResponse getResp = MultiselectCaseLabelAdapter.getCaseLabels(cases[0].Id);

        System.assertEquals(updateResp.isError, false);
        System.assertEquals(getResp.payLoad.contains('Label 1'), true);
        test.stopTest();
    }
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover negative scenarios of
     * getCaseLabels method and updateCaseLabels method.
    */
    @isTest
    static void testGetLabelsAndUpdateNegative() {
        List<Account> accounts = AccountTestData.createAccountRecords(1, null);
        Insert accounts;
        List<Case> cases = CaseTestData.getCaseData(accounts[0].Id, 1, True);
        List<String> caseLabels = new List<String>();
        for(integer i = 0; i < 30; i++){
            caseLabels.add('Label ' + i);
        }

        test.startTest();
        lightningResponse updateResp = MultiselectCaseLabelAdapter.updateCaseLabels(cases[0].Id, caseLabels);
        System.assertEquals(updateResp.isError, true);
        test.stopTest();
    }
}