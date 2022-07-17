/**
 * @description       : 
 * @author            : Meghna Bhargava
 * @group             : 
 * @last modified on  : 09-15-2021
 * @last modified by  : Meghna Bhargava
**/
global without sharing class RTW_InactiveDailyRes_Scheduler implements Schedulable {
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param ctx 
    **/
    global void execute(SchedulableContext ctx) {
        RTW_Batch_Details__c rtwBatchDetailsObj=[Select id,Batchdate__c from RTW_Batch_Details__c limit 1];
        Date batchDate=rtwBatchDetailsObj.Batchdate__c;
        Date schedulerRunningDate=batchDate.addDays(14);
        Date todayDate=Date.today();            
        if(schedulerRunningDate.isSameDay(todayDate)){
            RTW_InactiveDailyRes_Batch batchClassObj=new RTW_InactiveDailyRes_Batch();
            Database.executeBatch(batchClassObj,10);   
        }
    }   
}