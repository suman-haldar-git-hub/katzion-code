/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* FeatureControlService class.
*/
@isTest(SeeAllData=false)
public class FeatureControlServiceTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test FeatureControlService method
    */
    @isTest
    static void testFeatureControlService()
    {
        Map<String, FeatureControl__mdt> mapData = FeatureControlService.getFeatureControlRecord(
                new Set<String>{labelToContentMap.get('FEATURECONTROLALLOWEDPROFILE')}
        );
        Map<String, Map<Integer, Walkthrough__mdt>> walkthroughMap = 
            FeatureControlService.getWalkthroughRecord();
        System.assertNotEquals(mapData, null);        
    }
}