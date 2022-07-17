/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* CreateCommunicationAudienceService class.
*/
@isTest(SeeAllData=false)
public class CreateCommunicationAudienceServiceTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test FeatureControlDomain method
    */
    @isTest
    static void testCreateCommunicationAudienceService()
    {
        Set<String> setOfValue = new Set<String>{'Test1','Test2'};
        Set<String> valueSet = new Set<String>();
        System.assertEquals(
            CreateCommunicationAudienceService.createCollectionData('Test1;Test2', valueSet, null),
            setOfValue
        );
        System.assertEquals(CreateCommunicationAudienceService.createCollectionData('Test1',
            'includes',null),'includes');
        List<Object_Field__c> obj= ObjectFieldTestData.createObjectFieldRecds('DistributionList__c','OpsSupport__c');
        PicklistFieldValueTestData.getPicklistFieldValueData(obj[0].Id,1,true);    
        CreateCommunicationAudienceService.createPicklistMap();    
            
    }
}