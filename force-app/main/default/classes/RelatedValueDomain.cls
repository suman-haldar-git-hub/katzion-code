/**
* Author:             Saurabh Bisht
* @description :        This domain class will be used to query "Related_Value__c" data...
* Company:            SaasFocus
**/
public with sharing class RelatedValueDomain {
    /**
    * @Author : Saurabh
    * @Company : SaaSFocus
    * @description : This method will return Related_Value__c list..
    * @return List<Related_Value__c>
    */
    public static List<Related_Value__c> getData() {
        List<Related_Value__c> picklistData = [SELECT id,Top_Field_Value__r.Name,Top_Field_Value__r.Picklist_Field_Value__c,
                                               Top_Field_Value__r.Web_Value__c,Dependant_Field_Value__r.Name,
                                               Dependant_Field_Value__r.Picklist_Field_Value__c,Dependant_Field_Value__r.Web_Value__c
                                               FROM Related_Value__c
                                               WHERE Big_W_Web_Display__c = True
                                               ORDER BY Sequence_Number__c];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Related_Value__c>();
        }
    }
    /**
    @Author : Saurabh
    @Company : SaaSFocus
    @description : This method will return Related_Value__c list for PS query form..
    @return : List<Related_Value__c>
    */
    public static List<Related_Value__c> getDataForPS() {
        List<Related_Value__c> picklistData = [SELECT id,Top_Field_Value__r.Name,Top_Field_Value__r.Picklist_Field_Value__c,
                                               Top_Field_Value__r.Web_Value__c,Dependant_Field_Value__r.Name,
                                               Dependant_Field_Value__r.Picklist_Field_Value__c,Dependant_Field_Value__r.Web_Value__c
                                               FROM Related_Value__c
                                               WHERE Web_Display__c = True
                                               ORDER BY Dependant_Field_Value__r.Picklist_Field_Value__c ASC];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Related_Value__c>();
        }
    }

    /**
    * @author : Daksh Madan
    * @description : This method is used to query Related_Value__c object based on Set of 
    Picklist_Field_Value__c Ids.
    * @return : Map<Id, Related_Value__c>
    * @param picklistFieldValueIdSet
    */
    public static Map<Id, Related_Value__c> getMapOfRelatedValueRecords
    (Set<Id> picklistFieldValueIdSet){
        return (new Map<Id, Related_Value__c>([
            Select Id,Name,Top_Field_Value__c,Dependant_Field_Value__c,Sub_Category__c
            From Related_Value__c
            Where (Top_Field_Value__c IN: picklistFieldValueIdSet
            OR Dependant_Field_Value__c IN: picklistFieldValueIdSet)
            AND Top_Field_Value__c != null
            AND Dependant_Field_Value__c !=null
        ]));
    }
}