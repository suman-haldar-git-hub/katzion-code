/**
* @description       : This class is used for custom lookup search
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   13-08-2021   Akhil  Kumar     Initial Version
**/
@SuppressWarnings('PMD.ApexSOQLInjection')
public without sharing class CustomLookupSearch {
   /**
    * @description 
    * @author Akhil Kumar ( Cognizant ) | 09-15-2021 
    * @param searchKey 
    * @param objectName 
    * @param searchField 
    * @return List<SObject> 
    **/
    @AuraEnabled(cacheable = true)
    public static List<SObject> findRecords(String searchKey, String objectName, String searchField){
        List<SObject> sObjectList = new List<SObject>();
        try{
            String userId = userInfo.getUserId();
            String key = '';
            if(!string.isBlank(searchKey)){
                key = '%' + searchKey + '%';
            }
            String query = 'Select Id, '+searchField+' From '+objectName +' Where '+searchField +' LIKE :key AND createdById =: userId';
            sObjectList = Database.query(query);
            return sObjectList;
        }catch(Exception e){
            PublishLogEventService.publishExceptionEvent(
                'CustomLookupSearch.cls on findRecords',
                e
            );
            return sObjectList;
        }
    }
}