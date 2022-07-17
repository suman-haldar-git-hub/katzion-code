/**
* @Author:             Jerome To
* @Created Date:       JUNE 23, 2015 
* @Brief:              Case Trigger Handler methods
* @description :        This Triggerhandler class is used to update 
the total amount of time and set the data 
entry field (effort hours) to blank ( null )
and update person account contact name on Query Case Record Type

* Visualforce Page:   N/A
* Test Class:         CaseTriggerHandlerTest.cls

Version Control:    v1.0

* @Revision History:  N/A

* @Test Coverage:     100%    -   July 31, 2015
*/

public with sharing class CaseTriggerHandler {

    /*** 
     * @author : Amit Sharma
     * @description : This method is used to handle before Update events of CaseTrigger.
     * @param triggerNew - list of new cases
     * @param triggerOldMap - map of Case Id and Old version of case detail
    */
    public static Void beforeUpdate(List<Case> triggerNew,Map<Id,Case> triggerOldMap) {
        CaseTriggerService.shareCase(triggerNew, triggerOldMap);
    }
    
    /**
* @author:        Jerome To
* @createDate:    JULY 24, 2015   
* @description :This method is used to update Contact Name on Query Cases
* @Revision History   
* @param cases
*/
    public static void updateContactName(List<Case> cases)
    {    
        List<Id> acctIdsWithNoContact = new List<Id>();
        
        // filter Records with Account Ids but no Contact
        for(Case c : cases)
        {            
            if(isQueryCase(c.RecordTypeId) 
               && c.ContactId == null
               && c.AccountId != null)
            {   
                acctIdsWithNoContact.add(c.AccountId);
            }
        }
        
        // get personAccounts
        List<Id> acctIds = new List<Id>();
        {
            for(Account acct : [SELECT Id, IsPersonAccount FROM Account WHERE Id IN :acctIdsWithNoContact])
            {
                if(acct.IsPersonAccount)
                {
                    acctIds.add(acct.Id);
                }
            }
        }
        
        if (!acctIds.isEmpty())
        {
            // gets Contact ids of the account
            Map<Id,Id> accConMap = new Map<Id,Id>();
            for(Contact con : [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :acctIds])
            {
                accConMap.put(con.AccountId, con.Id);
            }
            
            // place the Contact Id values
            for(Case c : cases)
            {            
                if(accConMap.containsKey(c.AccountId))
                {   
                    c.ContactId = accConMap.get(c.AccountId);
                }
            }
        }
    }

    /*** 
     * @author : Akshansh Jain
     * @description : This method is used to handle after insert events of CaseTrigger.
     * @param triggerNew - list of new cases
    */
    public static Void afterInsert(List<Case> triggerNew) {
        CaseTriggerService.shareCaseWithCreator(triggerNew);
        // this method is calling for Salary sacrifice and case portal 
        CaseCampaignService.createChildCampaigRecord(triggerNew,null);
    }

    /*** 
     * @author : Akshansh Jain
     * @description : This method is used to handle after insert events of CaseTrigger.
     * @param triggerNew - list of new cases
     * @param triggerOldMap - list of old cases
    */
    public static Void afterUpdate(List<Case> triggerNew, Map<Id, Case> triggerOldMap) {
        List<Case> lstCase = new List<Case>();

        for(Case obj : triggerNew) {
            if(triggerOldMap.get(obj.Id).ownerId != obj.ownerId) {
                lstCase.add(obj);
            }
        }
        if(!lstCase.isEmpty()) {
            CaseTriggerService.shareCaseWithCreator(lstCase);
        }
        // sending email functionlaity for Salary sacrifice and case portal
        if(!StopRecursion.stopRecursionBeforeUpdate){
            CaseCampaignService.createChildCampaigRecord(triggerNew, triggerOldMap);
            StopRecursion.stopRecursionBeforeUpdate = true;
        }
    }

    /**
* @author:        Jerome To
* @createDate:    JULY 31, 2015   
* @description : This method is used to make sure that Person Account name and Contact name are in Synch
* @Revision History 
* @param oldMap
* @param newMap
*/
    public static void synchAccountAndContactName(Map<Id, Case> oldMap, Map<Id, Case> newMap)
    {    
        //List<Id> caseWithChanges = new List<Id>();        
        List<Id> caseWithChangesInAccount = new List<Id>();
        List<Id> caseWithChangesInContact = new List<Id>();
        Map<Id, Boolean> mapChangesInAccount = new Map<Id, Boolean>();
        
        // filter Records with Account Ids but no Contact
        for(Case c : newMap.values())
        {            
            //Boolean hasBeenAddedToCaseWithChanges = false;
            Case cse = oldMap.get(c.Id);
            Boolean hasChangesInAccountName = false;
            if(c.AccountId != null && 
               cse.AccountId != null &&
               c.AccountId != cse.AccountId)
            {   
                caseWithChangesInAccount.add(c.AccountId);
                mapChangesInAccount.put(c.Id , true);
                hasChangesInAccountName = true;
            }
            
            if(!hasChangesInAccountName && 
               c.ContactId != null && 
               cse.ContactId != null &&
               c.ContactId != cse.ContactId)
            {
                caseWithChangesInContact.add(c.ContactId);
                mapChangesInAccount.put(c.Id , false);
            }
        }
        
        // get personAccounts from caseWithChangesInAccount List
        List<Id> acctIds = new List<Id>();
        if(!caseWithChangesInAccount.isEmpty()){
            for(Account acct : [SELECT Id, IsPersonAccount FROM Account WHERE Id IN :caseWithChangesInAccount])
            {
                if(acct.IsPersonAccount)
                {
                    acctIds.add(acct.Id);
                }
            }
        }
        
        // get personAccounts from caseWithChangesInContact List
        List<Id> acctIdsForContactChanges = new List<Id>();
        if(!caseWithChangesInContact.isEmpty()){
            for(Account acct : [SELECT Id, IsPersonAccount FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE Id IN :caseWithChangesInContact)])
            {
                if(acct.IsPersonAccount)
                {
                    acctIdsForContactChanges.add(acct.Id);
                }
            }
        }
        
        
        if (!acctIds.isEmpty() || !acctIdsForContactChanges.isEmpty())
        {
            // gets Contact ids of the account
            Map<Id,Id> accConMap = new Map<Id,Id>();
            for(Contact con : [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :acctIds])
            {
                accConMap.put(con.AccountId, con.Id);
            }
            
            Map<Id,Id> conAccMap = new Map<Id,Id>();
            for(Contact con : [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :acctIdsForContactChanges])
            {
                conAccMap.put(con.Id, con.AccountId);
            }
            
            // place the Contact Id values
            for(Case c : newMap.values())
            {          
                
                if(mapChangesInAccount.containsKey(c.Id) && !mapChangesInAccount.get(c.Id) 
                   && conAccMap.containsKey(c.ContactId))
                {   
                    c.AccountId = accConMap.get(c.ContactId);
                }
                
                if(mapChangesInAccount.containsKey(c.Id) && mapChangesInAccount.get(c.Id) && accConMap.containsKey(c.AccountId))
                {   
                    c.ContactId = accConMap.get(c.AccountId);
                }
            }
        }
    }

        /**
* @createDate:     MARCH 13, 2020      
* @description : This method is used to make sure that Person Account name and Contact name are in Synch when cloning
* @Revision History   
* @param cases
*/
    
   public static void synchAccountAndContactName(List<case> cases)   {
        list<id> accountIds = new list<id>();
        for(case cs  : cases) {
            if(cs.AccountId != null) {
                accountIds.add(cs.AccountId);
            }
        }
        if(accountIds != null && accountIds.size() > 0) {
            map<id, contact> accIdmap = new map<id, contact>();
            for(contact con : [Select id, Accountid FROM contact WHere Accountid IN:accountIds ]) {
                accIdmap.put(con.accountId, con);
            }
            for(case cs  : cases) {
                if(accIdmap.containskey(cs.AccountId)) {
                    cs.ContactId = accIdmap.get(cs.AccountId).Id;
                }
            }
        }
   }
    
    /**
* @author:        Jerome To
* @createDate:    JUNE 23, 2015   

* @description :
This method is used to update 
total amount of time of effort hours 

* @Revision History  
JULY 24, 2015 - treat input 1.3 to 1 hour and 30 minutes   
JULY 31, 2015 - Move error message to Effort_To_Date__c field

* @param cases
*/
    
    public static void updateTotalTime(List<Case> cases)
    {       
        for(Case c : cases)
        {
            
            if((isCaseTrxOrEr(c.RecordTypeId)||isWowNZERCase(c.RecordTypeId)) && c.Effort_To_Date__c != null )
                //if(isCaseTrxOrEr(c.RecordTypeId) && c.Effort_To_Date__c != null )
            {   
                if(isValidAddedEffortMinutes(c.Effort_To_Date__c))
                {
                    if(c.Total_Time__c == null)
                    {
                        c.Total_Time__c = 0.00;
                    }                   
                    //c.Total_Time__c += c.Effort_To_Date__c;
                    Integer hoursTotalTime = Integer.valueof(String.valueOf(c.Total_Time__c).substringBefore('.'));
                    Integer minutesTotalTime = Integer.valueof(String.valueOf(c.Total_Time__c).substringAfter('.'));
                    
                    Integer hoursEffortTime = Integer.valueof(String.valueOf(c.Effort_To_Date__c).substringBefore('.'));
                    Integer minutesEffortTime = Integer.valueof(String.valueOf(c.Effort_To_Date__c).substringAfter('.'));
                    
                    Integer computedMinutes = Math.mod(minutesTotalTime + minutesEffortTime, 60);
                    Integer computedHours = Integer.valueOf((minutesTotalTime + minutesEffortTime)/60);
                    
                    c.Total_Time__c = hoursTotalTime + hoursEffortTime + computedHours + (decimal.valueOf(computedMinutes)/100);
                    c.Effort_To_Date__c = null;
                }
                else
                {
                    c.Effort_To_Date__c.addError(Label.Invalid_Time_Input); 
                }
            }
        }       
    }
    
    /*
@author:        Jerome To
@createDate:    JULY 27, 2015   

@Description:
This method is used to validate 
minutes in Additional Efort Time

@Revision History                                               
----------------
*/
    private static Boolean isValidAddedEffortMinutes(Decimal effortTime)
    {
        return (Integer.valueof(String.valueOf(effortTime).substringAfter('.')) < 60);
    }
    
    /*
@author:        Jerome To
@createDate:    JUNE 23, 2015   

@Description:
This method is used to validate 
Case record type

@Revision History                                               
----------------
*/
    private static Boolean isCaseTrxOrEr(Id recTypeId)
    {
        Case_Record_Types__c caseRec = Case_Record_Types__c.getInstance();
        //below condition added by joginder
        if(caseRec.Transaction_Case__c == null && caseRec.ER_Case__c == null){
            return false;
        }
        return (recTypeId == Id.valueOf(caseRec.Transaction_Case__c) || recTypeId == Id.valueOf(caseRec.ER_Case__c));
    }
    private static Boolean isWowNZERCase(Id recTypeId)
    {
        Case_Record_Types__c caseRec = Case_Record_Types__c.getInstance();
        //below condition added by joginder
        if(caseRec.WOW_NZ_ER_Case__c == null){
            return false;
        }
        return (recTypeId == Id.valueOf(caseRec.WOW_NZ_ER_Case__c));
    }
    /*
@author:        Jerome To
@createDate:    JULY 24, 2015   

@Description:
This method is used to check 
Query Case record type

@Revision History                                               
----------------
*/
    private static Boolean isQueryCase(Id recTypeId)
    {
        Case_Record_Types__c caseRec = Case_Record_Types__c.getInstance();
        if(caseRec.Query_Case__c == null){
            return false;
        }
        return (recTypeId == Id.valueOf(caseRec.Query_Case__c));         
    }
    
    /**
* @author:        Prathamesh Lad
* @createDate:    JAN 3, 2019   

* @description :
This method is used to set priority

* @Revision History                                               
* @param listCases	
----------------
*/
    public static void setPriority(List<Case> listCases){
        system.debug('***Inside setPriority***');
        
        Map<String,List<Case>> mapSubCatToCase=new Map<String,List<Case>>();
        for (Case cs : listCases) {
            cs.priority='Low';
            if (cs.Sub_Category__c != null) {
                List<Case> listTempCases=new List<Case>();
                if(mapSubCatToCase.containskey(cs.Sub_Category__c)){
                    listTempCases=mapSubCatToCase.get(cs.Sub_Category__c);
                }
                listTempCases.add(cs);
                mapSubCatToCase.put(cs.Sub_Category__c,listTempCases);
            }
        }
        system.debug('***mapSubCatToCase***'+mapSubCatToCase);
        system.debug('***mapSubCatToCase.keySet()***'+mapSubCatToCase.keySet());
        
        
        List<Picklist_Field_Value__c> lpfvc = [select
                                               Case_Priority__c,Picklist_Field_Value__c
                                               from Picklist_Field_Value__c 
                                               where Object_Field__r.Field_Name__c = 'Sub Category'
                                               and Picklist_Field_Value__c IN: mapSubCatToCase.keySet()];
        system.debug('***lpfvc***'+lpfvc);
        
        
        if( lpfvc!=null && !lpfvc.isEmpty() ) {
            for (Picklist_Field_Value__c pfvc : lpfvc) {
                List<Case> listTempCase=mapSubCatToCase.get(pfvc.Picklist_Field_Value__c);
                system.debug('***listTempCase***'+listTempCase);
                if(listTempCase!=null){
                    for(Case cs :listTempCase){
                        if (pfvc.Case_Priority__c != null) {
                            cs.priority = pfvc.Case_Priority__c;
                            system.debug('***cs.priority***'+cs.priority);                        
                        } 
                    }
                }
                
            }
        }
    }
    
    /**
* @author:        Prathamesh Lad
* @createDate:    JAN 6, 2020   

* @description :
 This method is used to update subcategory and case reason

* @Revision History   
* @param cases
* @param isInsert - boolean
* @param isUpdate - boolean
----------------
*/
    
    public static void updateSubCatAndReason(List<Case> cases,Boolean isInsert,Boolean isUpdate){ 
        for(Case caseObj : cases){
            if(isUpdate){
                Case oldCaseObj = (Case)Trigger.oldMap.get(caseObj.ID);
                if(caseObj.Sub_Category_New__c != oldCaseObj.Sub_Category_New__c) {
                    caseObj.Sub_category__c=caseObj.Sub_Category_New__c;
                }
                if(caseObj.Case_Reason__c != oldCaseObj.Case_Reason__c) {
                    caseObj.Reason=caseObj.Case_Reason__c;
                }
            }
            if(isInsert){
                if(caseObj.Sub_Category_New__c!=null){
                    caseObj.Sub_category__c=caseObj.Sub_Category_New__c;
                } 
                if(caseObj.Case_Reason__c!=null){
                    caseObj.Reason=caseObj.Case_Reason__c;
                }
            }
        }
    }
    
     /**
* @author : Aman Kumar
* @createDate:    Sept 20, 2021 
* @description : This method will validate either Account Verified or Account Verified N/A is checked
* @param triggerNew 
* @param oldMapCase
*/

    public static void accountCheck (list<case> triggerNew,Map<Id,Case> oldMapCase ){
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        for(Case c: triggerNew){
            if(isQueryCase(c.RecordTypeId) && system.label.CaseTriggerProfile.contains(profile.Name) && string.valueOf(oldMapCase.get(c.Id).OwnerId).startsWith('005') ){
                if ((c.Account_Verified__c && c.Account_Verified_N_A__c) || (!c.Account_Verified__c && !c.Account_Verified_N_A__c)){
                    c.addError(system.label.Case_Trigger_Account_Check_Validation);
                }          
            }	
        }
    }

 private static boolean run = true;
    /**
* @author : Aman Kumar
* @createDate:    Sept 20, 2021 
* @description : This method avoid the recussion
* @return Boolean
*/
public static boolean runOnce(){
    if(run){
        run=false;
        return true;
    }else{
        return run;
        }
    }  
}
