/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the MyTeamSlabDomain class 
*/
@isTest(SeeAllData=false)
public without sharing class MyTeamSlabDomainTest {
    /**
@Author : Daksh
@Company : Cognizant
@description : Test queryMyTeamSlab method
*/
    @isTest
    static void queryMyTeamSlabTest() {
        Test.startTest();
        System.assertNotEquals(MyTeamSlabDomain.queryMyTeamSlab(2),null);
        Test.stopTest();
    }
}