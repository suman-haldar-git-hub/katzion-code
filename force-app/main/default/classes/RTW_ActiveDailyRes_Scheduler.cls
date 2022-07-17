global class RTW_ActiveDailyRes_Scheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        RTW_Batch_Details__c RTWBatchDetailsObj=[Select id,Batchdate__c from RTW_Batch_Details__c limit 1];
        Date batchDate=RTWBatchDetailsObj.Batchdate__c;
        Date schedulerRunningDate=batchDate.addDays(14);
        Date todayDate=Date.today();            
        if(schedulerRunningDate.isSameDay(todayDate)){
            RTW_Visitor_ActiveDailyRes_Class.Execute();
        }
    }   
}