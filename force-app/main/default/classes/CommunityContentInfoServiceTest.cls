/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the CommunityContentInfoService class 
*/
@isTest(SeeAllData=false)
public class CommunityContentInfoServiceTest {
    /**
@Author : Daksh
@Company : Cognizant
@description : Test getMappingFromMetadeta method
*/
    @isTest
    static void getMappingFromMetadetaTest() {
        Test.startTest();
        System.assertEquals(false,CommunityContentInfoService.getMappingFromMetadeta().isEmpty());
        Test.stopTest();
    }
}