/**
 * @description       : 
 * @author            : Meghna Bhargava
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Meghna Bhargava
**/
global class RTW_InactiveDailyRes_Batch implements Database.Batchable<sObject>{
    
    //global final String query='Select Id from RTW_Daily_Reservation__c where RTW_Active__c=true';
    
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param bc 
    * @return Database.QueryLocator 
    **/
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = date.today();
        String query='Select Id from RTW_Daily_Reservation__c where RTW_Available_Date__c<:todayDate and RTW_Active__c=true';
        return Database.getQueryLocator(query);
    }
    
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param bc 
    * @param scope 
    **/
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        List<RTW_Daily_Reservation__c> listUpdateDailyReservations=new List<RTW_Daily_Reservation__c>();
        for(sobject obj :scope){
            RTW_Daily_Reservation__c dailyResObj=(RTW_Daily_Reservation__c)obj;
            dailyResObj.RTW_Active__c=false;
        }
        try{
            update scope;
        }catch(Exception e){
            System.debug('***Exception Occured While updating daily reservations'+e); 
            PublishLogEventService.publishExceptionEvent('RTW_InactiveDailyRes_Batch.cls on execute',e);
        }
    }
    
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param bc 
    **/
    global void finish(Database.BatchableContext bc){
        System.debug('Process Completed');
    }
}