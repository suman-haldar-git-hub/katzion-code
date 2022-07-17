/**
* @author : Manohara Dudi
* @company : SaaSFocus A Cognizant Company
* @description : Schedule Class For UpdateCaseTransactionRecBatch
*/
global without sharing class UpdateCaseTransactionRecBatchSchedular implements Schedulable {
	/**
    * @author : Manohara Dudi
    * @description : This method is schedule UpdateCaseTransactionRecBatch
    * @param sc
    */
    global void execute(SchedulableContext sc) {
        UpdateCaseTransactionRecBatch batchInstance = new UpdateCaseTransactionRecBatch();
        Database.executebatch(batchInstance,200);
    }
}