/**
* @description       : Scheduler class for daily reservations
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   22-07-2021   Akhil  Kumar     Initial Version
**/
global without sharing class RTW_DailyReservation_Scheduler implements Schedulable {
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param ctx 
    **/
    global void execute(SchedulableContext ctx) {
        RTW_ActiveDailyRes_Batch batchClassObj=new RTW_ActiveDailyRes_Batch();
        Database.executeBatch(batchClassObj,10);
    }
}