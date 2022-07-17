/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to maintain all query for DataCategoryPermissionSetMapping
custom metadeta.
*/
public inherited sharing class DataCategoryPermissionSetMappingDomain {
    /**
    * @author : Ankit Singh
    * @description : This method is used to profile User object records based on userId.
    * @return : List<DataCategoryPermissionSetMapping__mdt>
    */
    public static List<DataCategoryPermissionSetMapping__mdt> queryDataCategoryMapping(){
        return [
                SELECT RegionAreaF__c, PrimaryKey__c, PermissionSetApiName__c
                FROM DataCategoryPermissionSetMapping__mdt
                WHERE PrimaryKey__c != null
                LIMIT 50000
        ];
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used to profile User object records based on userId.
    * @return : List<DataCategoryPermissionSetMapping__mdt>
    */
    public static List<DataCategoryPermissionSetMapping__mdt> queryDataCategoryNameMapping(){
        return [
                SELECT PermissionSetApiName__c, DataCategoryName__c, DataCategoryGroupName__c
                FROM DataCategoryPermissionSetMapping__mdt
                WHERE DataCategoryName__c != null
                AND DataCategoryGroupName__c != null
        ];
    }
}