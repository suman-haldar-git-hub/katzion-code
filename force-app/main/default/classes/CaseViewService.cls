/**
@author : Saurabh Bisht
@company : SaasFocus
@description : This class handles the operations performed in CaseView object...
*/
public with sharing class CaseViewService{
    /**
    @author : Saurabh Bisht
    @description : This method creates a new CaseView record, whenever a user land on the Case record...
    @param caseId
    */
    @auraEnabled
    public static void createNewRecord(String caseId){
        Case_View__c cview = new Case_View__c();
        cview.Last_Viewed_By__c = [SELECT name FROM User WHERE Id=:UserInfo.getUserId()].name;
        cview.Case__c = caseId;
        if(Schema.sObjectType.Case_View__c.fields.Last_Viewed_By__c.isCreateable() && 
            Schema.sObjectType.Case_View__c.fields.Case__c.isCreateable()){
            performDML(JSON.serialize(cview));
        }
    }
    /**
    @author: Saurabh Bisht
    @description : This method inserts the new caseView records...
    @param obj
    */
    @future
    public static void performDML(String obj) {
       insert (Case_View__c) JSON.deserialize(obj, Case_View__c.class);        
    }
}