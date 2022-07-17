/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* FeatureControlDomain class.
*/
@isTest(SeeAllData=false)
public class FeatureControlDomainTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test FeatureControlDomain method
    */
    @isTest
    static void testFeatureControlDomain()
    {
        FeatureControl__mdt obj = new FeatureControl__mdt();
        obj = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLALLOWEDPROFILE')
        );
        FeatureControlDomain.getFeatureControlRecord(
                new Set<String>{labelToContentMap.get('FEATURECONTROLALLOWEDPROFILE')}
        );
        FeatureControlDomain.getFeatureControlWithWalkthroughRecord();
        System.assertEquals(obj.EnableUTLBatches__c, false);
        FeatureControlDomain.getFeatureControlRecordByDN(new Set<String>{'SalarySacrifice','Leave'});
        FeatureControlDomain.getFeatureControlRecordByDN('SalarySacrifice');
    }
}