/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for Object_Field__c object.
*/
public with sharing class ObjectFieldDomain {
    /**
* @author : Daksh Madan
* @description : This method is used to query Object_Field__c object based on List of Field_API__c.
* @return : Map<Id,Object_Field__c>
* @param fieldApiList
* @param objectApiName
*/
    public static Map<Id,Object_Field__c> getMapOfObjectFieldRecords(List<String> fieldApiList,
        String objectApiName){
        return (new Map<Id,Object_Field__c>([
            Select Id,Name,Field_API__c
            From Object_Field__c
            Where Field_API__c IN: fieldApiList
            AND Object__c =: objectApiName
        ]));
    }
}