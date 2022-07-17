/**
* @author : Ankit Singh
* @company : Cognizant
* @description : Test class for DataCategoryMappingService
*/
@isTest(SeeAllData=false)
public without sharing class DataCategoryPermissionSetMapDomainTest {
    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : set up data
    */
    @testSetup
    static void setupData() {
        DataCategoryPermissionSetMapping__mdt objMapping = [
            SELECT PermissionSetApiName__c, RegionAreaF__c
            FROM DataCategoryPermissionSetMapping__mdt LIMIT 1
        ];
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test DataCategoryPermissionSetMappingDomain method
    */
    @isTest
    static void testDataCategoryPermissionSetMappingDomain()
    {
        Test.startTest();
            List<DataCategoryPermissionSetMapping__mdt> lstmapping =  [
                    SELECT Id, PermissionSetApiName__c, RegionAreaF__c
                    FROM DataCategoryPermissionSetMapping__mdt
            ];
            System.assert(!lstmapping.isEmpty());
            DataCategoryPermissionSetMappingDomain.queryDataCategoryMapping();
        Test.stopTest();
    }
}