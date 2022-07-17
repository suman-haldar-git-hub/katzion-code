/**
 * @author : Shubham Shukla
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for 'labelmasterDomain' class...
 */
@isTest(SeeAllData=false)
private class LabelMasterDomainTest {
    /**
     * @author : Shubham Shukla 
     * @ccompany : Cognizant
     * @description : This method is used to setup test data
     * 
    */
	@testSetup
    static void makeData(){
        list<Label_Master__c> labelmasters = LabelMasterTestData.getLabelMasterData(2, true);
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
        List<String> labels = new List<String>{'Red','Red'};
        list<Label_Master__c> labelMasters= LabelMasterDomain.getLabelMaster(labels);
        System.assertEquals(labelMasters != null,true);

        test.stopTest();
    }
}