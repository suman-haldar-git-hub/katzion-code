/**
* @author : Monika Bisht
* @company : Cognizant
* @description : This is test data builder class for Task object.
*/
public with sharing class TaskTestData {
     private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
* @description : This will create the Task records.
* @return : List<Task>
* @param count
* @param recordTypeId
*/
    public static List<Task> createTaskRecds(Integer count, String recordTypeId){
        List<Task> taskList = new List<Task>();
        for (Integer i = 0; i < count; i++) {
            Task taskRecd = new Task();
            taskRecd.Status = labelToContentMap.get('TASKSTATUSINPROGRESS');
            taskRecd.Subject = labelToContentMap.get('NUDGETYPETASKSUBJECT');
            taskRecd.Type = labelToContentMap.get('TASKTYPENUDGE');
            taskRecd.Status = labelToContentMap.get('TASKSTATUSINPROGRESS');
            taskList.add(taskRecd);
        }
        return taskList;
    }
}