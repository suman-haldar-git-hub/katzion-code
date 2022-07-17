/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * MultiselectLookUpController class.
*/
@isTest(SeeAllData=false)
public class MultiselectLookUpControllerTest {
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
     * GetResults method.
    */
    @isTest
    static void testGetResults() {
        TestUtility.createPSQueryCase();
        MultiselectLookUpController.ReqeustParam requestParam = new MultiselectLookUpController.ReqeustParam();
        requestParam.objectName = 'Case';
        requestParam.fieldName = 'Sub_Category__c';
        requestParam.value = 'WOW';
        requestParam.selectedRecId = new List<String>();
        
        Test.startTest();
        List<MultiselectLookUpController.SObJectResult> sObjectResultList=  MultiselectLookUpController.getResults(JSON.serialize(requestParam));
        Test.stopTest();
        System.assertEquals(sObjectResultList != null, true);
    }
}