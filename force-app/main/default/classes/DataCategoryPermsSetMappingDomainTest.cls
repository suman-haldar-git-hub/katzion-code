/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the DataCategoryPermissionSetMappingDomain class 
*/
@isTest(SeeAllData=false)
public without sharing class DataCategoryPermsSetMappingDomainTest {
    /**
@Author : Daksh
@Company : Cognizant
@description : Test all method
*/
    @isTest
    static void testAllmethods() {
        Test.startTest();
        System.assertNotEquals(DataCategoryPermissionSetMappingDomain.queryDataCategoryMapping(),null);
        System.assertNotEquals(DataCategoryPermissionSetMappingDomain.queryDataCategoryNameMapping(),null);
        Test.stopTest();
    }
}