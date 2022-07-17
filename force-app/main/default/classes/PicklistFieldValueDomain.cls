/**
*@author :             Saurabh Bisht
*@company :            SaasFocus
*@description :        This domain class will be used to query "Picklist_Field_Value__c" data...
**/
public inherited sharing class PicklistFieldValueDomain {
    /**
    *@author : Saurabh
    *@description : This method will return Picklist_Field_Value__c Map.
    *@return : List<Picklist_Field_Value__c>
    *@param objectName
    *@param fieldName
    */
    public static List<Picklist_Field_Value__c> getData(String objectName, String fieldName) {
        List<Picklist_Field_Value__c> picklistData = [SELECT id,Picklist_Field_Value__c,Web_Value__c,
                                                        Sub_Category_Mandatory_in_Webform__c
                                                        FROM Picklist_Field_Value__c
                                                        WHERE Object_Field__r.Object__c =: objectName
                                                        AND Object_Field__r.Field_Name__c =: fieldName
                                                        AND Web_Display__c = true
                                                        AND Big_W_Web_Display__c = true
                                                        ORDER BY Sequence_Number__c];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Picklist_Field_Value__c>();
        }
    }

    /**
    *@author : Saurabh
    *@description : This method will return the data related to AttachmentType record....
    *@return : List<Picklist_Field_Value__c>
    */
    public static List<Picklist_Field_Value__c> getAttachmentData(){
        List<Picklist_Field_Value__c> attachmentData = [SELECT id,Picklist_Field_Value__c,Web_Value__c
                                                        FROM Picklist_Field_Value__c
                                                        WHERE Object_Field__r.Name = 'Case-AttachmentType'
                                                        AND Web_Display__c = true];  
        if(attachmentData!=null){
            return attachmentData;
        }else{
            return new List<Picklist_Field_Value__c>();
        }
    }
    /**
    *@author : Saurabh
    *@description : This method will return Picklist_Field_Value__c data based on object and field types...
    *@return : List<Picklist_Field_Value__c>
    *@param objectName
    *@param fieldName
    */
    public static List<Picklist_Field_Value__c> getValues(String objectName, String fieldName) {
        List<Picklist_Field_Value__c> picklistData = [SELECT id,Picklist_Field_Value__c,Web_Value__c,
                                                        Sub_Category_Mandatory_in_Webform__c
                                                        FROM Picklist_Field_Value__c
                                                        WHERE Object_Field__r.Object__c =: objectName
                                                        AND Object_Field__r.Field_Name__c =: fieldName
                                                        AND Web_Display__c = true
                                                        ORDER BY Sequence_Number__c];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Picklist_Field_Value__c>();
        }
    }
    /**
    *@author : Saurabh
    *@description : This method will return Picklist_Field_Value__c data based on object and field types...
    *@return : List<Picklist_Field_Value__c>
    *@param fieldValue
    *@param fieldName
    */
    public static List<Picklist_Field_Value__c> getMandatorySetting(String fieldValue, String fieldName) {
        List<Picklist_Field_Value__c> picklistData = [SELECT id,Sub_Category_Mandatory_in_Webform__c
                                                        FROM Picklist_Field_Value__c
                                                        WHERE Picklist_Field_Value__c =: fieldValue
                                                        AND Object_Field__r.Field_Name__c =: fieldName
                                                        AND Web_Display__c = true
                                                        LIMIT 1];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Picklist_Field_Value__c>();
        }
    }
    /**
    *@author : Saurabh
    *@description : This method will return Picklist_Field_Value__c data for setting BigW recordType...
    *@return : List<Picklist_Field_Value__c>
    *@param fieldValue
    *@param fieldName
    */
    public static List<Picklist_Field_Value__c> getDataForBigWRecordType(String fieldValue, String fieldName) {
        List<Picklist_Field_Value__c> picklistData = [SELECT id,Big_W_Record_Type__c
                                                        FROM Picklist_Field_Value__c
                                                        WHERE Picklist_Field_Value__c =: fieldValue
                                                        AND Object_Field__r.Field_Name__c =: fieldName
                                                        AND Web_Display__c = true
                                                        AND Big_W_Web_Display__c = true
                                                        LIMIT 1];  
        if(picklistData!=null){
            return picklistData;
        }else{
            return new List<Picklist_Field_Value__c>();
        }
    }

    /**
    * @author : Daksh Madan
    * @description : This method is used to query Picklist_Field_Value__c object based on Set of 
    bject_Field__c Ids.
    * @return : Map<Id, Picklist_Field_Value__c>
    * @param objectFieldIdSet
    */
    public static Map<Id, Picklist_Field_Value__c> getMapOfPicklistFieldValueRecords
    (Set<Id> objectFieldIdSet){
        return (new Map<Id, Picklist_Field_Value__c>([
            Select Id,Name,Object_Field__c,Picklist_Field_Value__c,Web_Value__c,PrimaryUniqueKey__c,
            Object_Field__r.Field_API__c
            From Picklist_Field_Value__c
            Where Object_Field__c IN: objectFieldIdSet
            ORDER BY Sequence_Number__c
        ]));
    }
    /**
    * @Author : Sunil
    * @description :This method returns the all required picklist values  using DescribeSObject call
    * @return Map<String, String>
    * @param  objApiName
    * @param  fieldName
    */
    public static Map<String, String> getPickListValue(String objApiName, String fieldName)
    {
        Map<String, String> mapPicklistAPIToLabel = new Map<String, String>();
        schema.SObjectType convertType = Schema.getGlobalDescribe().get(objApiName);
        Sobject objectName = convertType.newSObject();
        Schema.SObjectType objType=objectName.getSObjectType();
        Schema.DescribeSObjectResult objDesc= objType.getDescribe();
        Map<String,Schema.SObjectField> fldMap=objDesc.fields.getMap();
        List<Schema.PicklistEntry> pickList=fldMap.get(fieldName).getDescribe().getPickListValues();
        for( Schema.PicklistEntry pickListVal : pickList){
            mapPicklistAPIToLabel.put(pickListVal.getValue() ,pickListVal.getLabel());
        }
        return mapPicklistAPIToLabel;
        
    }
}