/** File Name: SandboxRefreshMaskBatch
* Description: This class is used update records email addresses after Sandbox refresh
* @author : Ankur Garg
**/ 
global class SandboxRefreshMaskBatch implements Database.Batchable<sObject>{
    
    global final String query;
    global final String objects;

/*
** Method Name : SandboxRefreshMaskBatch
** Description : Constructor to accept query and object name
** Parameters : String query,String objects
** Return Type :
*/     
    global SandboxRefreshMaskBatch(String query,String objects){
        this.query=query;
        this.objects=objects;        
    }   

/*
** Method Name : start
** Description : Batch start method
** Parameters  : Database.BatchableContext
** Return Type : Database.QueryLocator
*/       
    global Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);
    }

/*
** Method Name : execute method 
** Description : Batch execute method for batch with updates to email addresses
** Parameters  : Database.BatchableContext, List<sObject>
** Return Type : 
*/ 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sobject obj : scope){
            if(objects=='Contact'){
                Contact cObj=(Contact)obj;            
                cObj.Email = cObj.Email+'xxx';                
            }
            if(objects=='Account'){
                Account cObj=(Account)obj;            
                cObj.Mass_Email_Address__c = cObj.Mass_Email_Address__c+'xxx';                
            } 
            if(objects=='Case'){
                Case caseObj=(Case)obj;
                if(caseObj.Account_Email_Address__c!=null)
                    caseObj.Account_Email_Address__c=caseObj.Account_Email_Address__c+'xxx';
                if(caseObj.On_Behalf_Of_Employee_Email__c!=null)
                    caseObj.On_Behalf_Of_Employee_Email__c=caseObj.On_Behalf_Of_Employee_Email__c+'xxx';
                if(caseObj.Preferred_Email__c!=null)
                    caseObj.Preferred_Email__c=caseObj.Preferred_Email__c+'xxx';
                if(caseObj.Respondent_Employee_Email__c!=null)
                    caseObj.Respondent_Employee_Email__c=caseObj.Respondent_Employee_Email__c+'xxx';
                if(caseObj.SuppliedEmail!=null)
                    caseObj.SuppliedEmail=caseObj.SuppliedEmail+'xxx';
                if(caseObj.WOW_Web_Email_Address__c!=null)
                    caseObj.WOW_Web_Email_Address__c=caseObj.WOW_Web_Email_Address__c+'xxx';                
            }            
        }
        try{
            Database.SaveResult[] srList =Database.update(scope, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('***Successfully updated '+objects +'. ID: ' + sr.getId());        
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Exception occured while updating' + objects + 'in SandboxRefreshMaskBatch');
        }
    }
    
/*
** Method Name : finish
** Description : Batch finish method
** Parameters  : Database.BatchableContext
** Return Type : 
*/
    global void finish(Database.BatchableContext BC){
    }    
}