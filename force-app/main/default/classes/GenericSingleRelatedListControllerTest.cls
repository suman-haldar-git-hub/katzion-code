/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * GenericSingleRelatedListController class.
*/
@isTest(SeeAllData=false)
private class GenericSingleRelatedListControllerTest {
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used create setup data for testing.
    */
    @testSetup
    static void dataSetup(){
        ContactTestData.createContactRecords(1, null);
    }

	/**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of
     *  method.
    */
    @isTest
    static void positiveTest() {
        GenericSingleRelatedListController.param requestParam = new GenericSingleRelatedListController.param();
        requestParam.columns = 'Name,CreatedDate';
        requestParam.sObjectName = 'Contact';
        requestParam.relatedFieldAPI = 'AccountId';
        
        Test.startTest();
        lightningResponse resp = GenericSingleRelatedListController.getDataList(requestParam);
        Test.stopTest();
        System.assertEquals(resp.isError, false);
    }
}