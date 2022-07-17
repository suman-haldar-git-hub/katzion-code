/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the CommunityContentInfoDomain class 
*/
@isTest(SeeAllData=false)
public class CommunityContentInfoDomainTest {
    /**
@Author : Daksh
@Company : Cognizant
@description : Test queryCommunityContentInfo method
*/
    @isTest
    static void queryCommunityContentInfoTest() {
        Test.startTest();
        System.assertNotEquals(CommunityContentInfoDomain.queryCommunityContentInfo(),null);
        Test.stopTest();
    }
}