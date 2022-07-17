/**
* @author : Ankit Singh
* @company : Cognizant
* @description : Test class for DataCategoryMappingService
*/
@isTest(SeeAllData=false)
public without sharing class DataCategoryMappingServiceTest {
    /**
* @author : Ankit Singh
* @company : Cognizant
* @description : set up data
*/
    @testSetup
    static void setupData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].Location_Name__c = 'Test';
        acctList[0].IsLineManager__c = 'Yes';
        acctList[0].HasDOA__c = 'Yes';
        acctList[0].CareerLevel__c = 'Test';
        acctList[0].CompanyCode__c = '1000';
        acctList[0].GroupCode__c = '1020000';
        acctList[0].BrandCode__c = '2002000';
        acctList[0].OpsSupport__c = 'Ops';
        insert acctList;
    }

    /**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : Test SyncUserFromAccountBatchService method
*/
    @isTest
    static void testSyncUserFromAccountBatchService()
    {
        Test.startTest();
        List<Account> lstAccount =  [
            SELECT Id, Area_Dept_Name__c,BrandCode__c,
            Employee_ID__c, Position__c,CompanyCode__c,GroupCode__c,
            Location_Name__c, Region__c, IsLineManager__c,
            HasDOA__c, CareerLevel__c,OpsSupport__c
            FROM Account
        ];
        System.assert(!lstAccount.isEmpty());
        List<DataCategoryPermissionSetMapping__mdt> lstmapping =  [
            SELECT Id, PermissionSetApiName__c
            FROM DataCategoryPermissionSetMapping__mdt LIMIT 1
        ];
        System.assert(!lstmapping.isEmpty());
        Map<String, DataCategoryPermissionSetMapping__mdt> regionAndAreaToPermissionSetApiMap =
            new Map<String, DataCategoryPermissionSetMapping__mdt>();
        regionAndAreaToPermissionSetApiMap.put(lstAccount[0].CompanyCode__c +'_'+
                                               lstAccount[0].GroupCode__c +'_'+
                                               lstAccount[0].BrandCode__c +'_'+
                                               lstAccount[0].OpsSupport__c, 
                                               lstmapping[0]);
        Map<String, sobject> mapOfSobjectNameToSobject = new Map<String, sobject>();
        Map<String, Map<String, Id>> permissionSetMapping = new Map<String, Map<String, Id>>();
        Map<String, Id> permssionSetNameToId = new Map<String, Id>();
        permssionSetNameToId.put('Label', lstAccount[0].Id);
        permissionSetMapping.put('Label', permssionSetNameToId);
        DataCategoryMappingService.getDatacategoryMap(
            lstAccount[0],
            regionAndAreaToPermissionSetApiMap,
            mapOfSobjectNameToSobject
        );
        DataCategoryMappingService.getMappingFromMetadeta();
        DataCategoryMappingService.getPermissionNameToId(
            'Label',
            permissionSetMapping,
            permssionSetNameToId
        );
        System.assertNotEquals(null,DataCategoryMappingService.getSetOfOpsSupportDataCategoryName().size());
        Test.stopTest();
    }
}