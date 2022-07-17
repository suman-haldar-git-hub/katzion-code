public with sharing class CasePageViewCounter {
    
    public Case cs{get;set;}
    public Case_View__c cv{get;set;}
    public user u{get;set;}
    public String csId{get;set;} 
    
    public CasePageViewCounter(ApexPages.StandardController controller){    
    }
    
    public pagereference updatecount(){
        cs=[SELECT Id FROM Case WHERE Id =:ApexPages.currentPage().getParameters().get('Id')];
        //csId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('xxxxxcsIdxxxxx' +cs.Id);
        u=[SELECT name FROM User WHERE Id=:UserInfo.getUserId()];
        cv= new Case_View__c();
        
        cv.Last_Viewed_By__c = u.name;
        cv.Case__c = cs.Id;
        if(Schema.sObjectType.Case_View__c.fields.Last_Viewed_By__c.isCreateable() && 
           Schema.sObjectType.Case_View__c.fields.Case__c.isCreateable()){
               performDML(JSON.serialize(cv));
           }
        system.debug('xxxxxcvId'+cv.Id);
        return null;
        
    }
    
    @future
    public static void performDML(String obj) {
       insert (Case_View__c) JSON.deserialize(obj, Case_View__c.class);        
    }
    
}