/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for UniversalTaskList__c object.
*/
@isTest
public without sharing class UniversalTaskListTestData {
	/**
    * @author : Daksh Madan
    * @company : Cognizant
    * @description : This will create the UniversalTaskList__c records.
    * @return : List<UniversalTaskList__c>
    * @param count
    * @param recordTypeId
    */
    public static List<UniversalTaskList__c> createAccountRecords(Integer count, String recordTypeId){
        List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
        for (Integer i = 0; i < count; i++) {
            UniversalTaskList__c taskRecd = new UniversalTaskList__c();
            taskRecd.RecordTypeId = recordTypeId;
            taskRecd.Status__c = 'approved';
            taskRecd.SubmittedDate__c = System.now();
            taskRecd.From__c = System.now().addDays(1);
            taskRecd.ToDate__c = System.now().addDays(3);
            taskRecd.UnitOfDuration__c = 'Hours';
            //taskRecd.Type__c = 'SuccessFactors';
            taskRecd.Priority__c = '1';
            taskRecd.DeepLink__c = 'https://www.test.com/';
            taskList.add(taskRecd);
        }
        return taskList;
    }
}