/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This batch class is used to sync user detail from Account.
*/
public without sharing class DataCategoryMappingService {
    /**
    * @author : Ankit Singh
    * @description : This method is used to get permission set Assignment which need to be deleted.
    * @return : mapOfSobjectNameToSobject
    * @param objAccount
    * @param primaryKeyToPermissionSetApiMap
    * @param mapOfSobjectNameToSobject
    */
    public static Map<String, sobject> getDatacategoryMap(
        Account objAccount,
        Map<String, DataCategoryPermissionSetMapping__mdt> primaryKeyToPermissionSetApiMap,
        Map<String, sobject> mapOfSobjectNameToSobject
    ) {
        if(
                primaryKeyToPermissionSetApiMap != null
                &&
                !primaryKeyToPermissionSetApiMap.isEmpty()
                &&
                objAccount.CompanyCode__c != null
                &&
                objAccount.GroupCode__c != null
                &&
                objAccount.BrandCode__c != null
                &&
                objAccount.OpsSupport__c != null
                &&
                primaryKeyToPermissionSetApiMap.containsKey(
                        objAccount.CompanyCode__c +'_'+
                        objAccount.GroupCode__c +'_'+
                        objAccount.BrandCode__c +'_'+
                        objAccount.OpsSupport__c
                )
                &&
                primaryKeyToPermissionSetApiMap.get(
                        objAccount.CompanyCode__c +'_'+
                        objAccount.GroupCode__c +'_'+
                        objAccount.BrandCode__c +'_'+
                        objAccount.OpsSupport__c
                ) != null
        ) {
            mapOfSobjectNameToSobject.put(
                    'DataCategoryPermissionSetMapping__mdt',
                    primaryKeyToPermissionSetApiMap.get(
                        objAccount.CompanyCode__c +'_'+
                        objAccount.GroupCode__c +'_'+
                        objAccount.BrandCode__c +'_'+
                        objAccount.OpsSupport__c
                    )
            );
        }
        return mapOfSobjectNameToSobject;
    }

    /**
    * @author : Ankit Singh
    * @description : This method is get DataCategory mapping using custom metadeta
    * @return : primaryKeyToPermissionSetApiMap
    */
    public static Map<String, DataCategoryPermissionSetMapping__mdt> getMappingFromMetadeta() {
        List<DataCategoryPermissionSetMapping__mdt> lstDataCategoryMapping = new
                List<DataCategoryPermissionSetMapping__mdt>();
        lstDataCategoryMapping = DataCategoryPermissionSetMappingDomain.queryDataCategoryMapping();
        Map<String, DataCategoryPermissionSetMapping__mdt> primaryKeyToPermissionSetApiMap = new
            Map<String, DataCategoryPermissionSetMapping__mdt>();
        if(lstDataCategoryMapping != null && !lstDataCategoryMapping.isEmpty()) {
            for(DataCategoryPermissionSetMapping__mdt eachMapping : lstDataCategoryMapping) {
                primaryKeyToPermissionSetApiMap.put(
                        eachMapping.PrimaryKey__c,
                        eachMapping
                );
            }
        }
        return primaryKeyToPermissionSetApiMap;
    }

    /**
    * @author : Ankit Singh
    * @description : This method is get DataCategory mapping using custom metadeta
    * @return : permssionSetNameToId
    * @param labelOrApiName
    * @param permissionSetMapping
    * @param permssionSetNameToId
    */
    public static Map<String, Id> getPermissionNameToId(
        String labelOrApiName,
        Map<String, Map<String, Id>> permissionSetMapping,
        Map<String, Id> permssionSetNameToId) {
        if(
                permissionSetMapping != null
                &&
                !permissionSetMapping.isEmpty()
                &&
                permissionSetMapping.containsKey(labelOrApiName)
                &&
                permissionSetMapping.get(labelOrApiName) != null
        ) {
            permssionSetNameToId = permissionSetMapping.get(labelOrApiName);
        }
        return permssionSetNameToId;
    }

    /**
    * @author : Ankit Singh
    * @description : This method is get DataCategory mapping using custom metadeta
    * @return : setOfOpsSupportDataCategory
    */
    public static Set<String> getSetOfOpsSupportDataCategoryName() {
        List<DataCategoryPermissionSetMapping__mdt> lstDataCategoryMapping = new
                List<DataCategoryPermissionSetMapping__mdt>();
        Set<String> setOfOpsSupportDataCategory = new Set<String>();
        lstDataCategoryMapping =
                DataCategoryPermissionSetMappingDomain.queryDataCategoryNameMapping();
        if(lstDataCategoryMapping != null && !lstDataCategoryMapping.isEmpty()) {
            for(DataCategoryPermissionSetMapping__mdt eachMapping : lstDataCategoryMapping) {
                setOfOpsSupportDataCategory.add(eachMapping.DataCategoryName__c);
            }
        }
        return setOfOpsSupportDataCategory;
    }
}