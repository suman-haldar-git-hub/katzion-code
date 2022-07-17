/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class is utlity class for all the SOQL and DMLs for Audience__c object.
*/
public with sharing class AudienceDomain {
	/**
* @author : Daksh Madan
* @description : This method is used to insert audience Record List.
* @param audienceList
* @param operation
*/
    public static void dmlOnAudienceList(List<Audience__c> audienceList,String operation){
        if(operation.equalsIgnoreCase('insert')){
        	insert audienceList;
        }
        //please uncomment the following code in case of update.
        /*
        else if(operation.equalsIgnoreCase('update')){
            update audienceList;
        }*/
    }
}