/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : Schedule Class For SyncUserFromAccountScheduled
*/
global without sharing class SyncUserFromAccountScheduled implements Schedulable {
	/**
    * @author : Ankit Singh
    * @description : This method is schedule SyncUserFromAccountBatch
    * @param sc
    */
    global void execute(SchedulableContext sc) {
        SyncUserFromAccountBatch batchInstance = new SyncUserFromAccountBatch();
        Database.executebatch(batchInstance,200);
    }
}