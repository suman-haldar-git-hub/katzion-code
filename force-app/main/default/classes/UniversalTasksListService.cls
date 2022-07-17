/**
 * @author : Praveen Tiwari
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UniversalTasksListService {
    /**
    * @Author : Praveen Tiwari
    * @description :This method is used to update date fields for Ariba
    * @param objUniversalTask
    * @param oldUniversalTask
    * @param isInsert
    */
    public static void updateCompletedDateForStatusUpdate(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask,
        Boolean isInsert
    ){
        //Populate Completed Date as Now() when status changes 2 to 4 or 8 or 16
        if(
            objUniversalTask.Status__c != null
            &&
            !isInsert
            &&
            isStatusChanged(objUniversalTask, oldUniversalTask)
        ){
            objUniversalTask.CompletedDate__c = System.Now();
        }
        //Make Completed Date blank when status changes from 16 or 8 or 4 to 2
        if(
            objUniversalTask.Status__c != null
            &&
            !isInsert
            &&
            isChangedStatus(objUniversalTask,oldUniversalTask)
        ) {
            objUniversalTask.CompletedDate__c = null;
        }
    }
    /**
    * @Author : Praveen Tiwari
    * @description : status changes 2 to 4 or 8 or 16
    * @param objUniversalTask
    * @param oldUniversalTask
    * @return Boolean
    */
    public static Boolean isStatusChanged(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask
    ) {
        if(
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '2'
                &&
                objUniversalTask.Status__c == '4'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '2'
                &&
                objUniversalTask.Status__c == 'Withdrawn'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '2'
                &&
                objUniversalTask.Status__c == '8'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '2'
                &&
                objUniversalTask.Status__c == '16'
            )
        ) {
            return true;
        }
        return false;
    }

    /**
    * @Author : Praveen Tiwari
    * @description : status changes from 16 or 8 or 4 to 2
    * @param objUniversalTask
    * @param oldUniversalTask
    * @return Boolean
    */
    public static Boolean isChangedStatus(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask
    ) {
        if(
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '16'
                &&
                objUniversalTask.Status__c == '2'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == 'Withdrawn'
                &&
                objUniversalTask.Status__c == '2'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '8'
                &&
                objUniversalTask.Status__c == '2'
            )
            ||
            (
                oldUniversalTask.get(objUniversalTask.id).Status__c == '4'
                &&
                objUniversalTask.Status__c == '2'
            )
        ) {
            return true;
        }
        return false;
    }

    /**
    * @Author : Praveen Tiwari
    * @description :This method is used to update date fields for Ariba
    * @param objUniversalTask
    * @param oldUniversalTask
    * @param labelToContentMap
    */
    public static void updateDateFieldsForAriba(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask,
        Map<String, String> labelToContentMap
    ){
        if(
            (
                objUniversalTask.Type__c == labelToContentMap.get('REQUISITIONS')
                &&
                objUniversalTask.ReceivedDate__c == null
                &&
                objUniversalTask.DueDate__c == null
            )
            ||
            (
                objUniversalTask.SubmittedDate__c != null
                &&
                oldUniversalTask != null
                &&
                oldUniversalTask.get(objUniversalTask.id) != null
                &&
                objUniversalTask.SubmittedDate__c != oldUniversalTask.get(objUniversalTask.id).SubmittedDate__c
            )
        ){
            objUniversalTask.ReceivedDate__c = system.Now();
            objUniversalTask.DueDate__c = objUniversalTask.NextFiveBusinessDays__c;
        }
    }
}