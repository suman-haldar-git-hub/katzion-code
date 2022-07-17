/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query and Task object
*/
public inherited sharing class TaskDomain {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Ankit Singh
    * @description :This method return Task with Nudges RecordType For CurrentWeek
    * @return lstTask
    * @param setOfOwnerId
    */
    public static List<Task> getNudgesTaskForCurrentWeek(Set<Id> setOfOwnerId) {
        List<Task> lstTask = new List<Task>();
        lstTask = [
                SELECT Id,
                TYPEOF Owner
                WHEN User THEN EmployeeID__c END
                FROM Task
                WHERE RecordType.Name =: labelToContentMap.get('RECORDTYPENUDGE')
                AND OwnerId IN: setOfOwnerId
                AND CreatedDate = THIS_WEEK
                AND Status =: labelToContentMap.get('TASKSTATUSINPROGRESS')
        ];
        return lstTask;
    }
}