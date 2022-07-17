/**
 * @author : Sunil
 * @company : Cognizant
 * @description : Helper class for UniversalTaskService class.
*/
public with sharing class UniversalTaskServiceHelper {
    /**
    * @Author : Sunil
    * @description :This method used to update status to Not Required.
    * @param mapExpense8IdToStatus
    * @param setTaskId
    * @param labelToContentMap
    */
    public static void setStatusToNotRequired(
        Map<String, String> mapExpense8IdToStatus,
        Set<String> setTaskId,
        Map<String, String> labelToContentMap
    ) {
        if(mapExpense8IdToStatus.keyset().size()>0){
            List<UniversalTaskList__c> lstUtlToUpdate = new List<UniversalTaskList__c>();
            List<UniversalTaskList__c> lstUtl = new List<UniversalTaskList__c>();
            lstUtl = UniversalTaskListDomain.getUTLRecordFromExpense8Id(
                mapExpense8IdToStatus.keyset(),
                setTaskId
            );
            for(UniversalTaskList__c objUniversalTask : lstUtl){
                if(validateTaskToUpdate(objUniversalTask.Status__c,
                        mapExpense8IdToStatus.get(objUniversalTask.Expense8Id__c), labelToContentMap))
                {
                    objUniversalTask.Status__c =  labelToContentMap.get('UTLSTATUSCOMPLETED');
                    lstUtlToUpdate.add(objUniversalTask);
                }
                else if(validateTaskToRejected(objUniversalTask.Status__c,
                                    mapExpense8IdToStatus.get(objUniversalTask.Expense8Id__c), labelToContentMap)
                       )
                {
                    objUniversalTask.Status__c =  labelToContentMap.get('REJECTEDSTATUS');
                    objUniversalTask.CompletedDate__c = System.now();
                    lstUtlToUpdate.add(objUniversalTask);
                }
                else if(validateNotRequiredTask(objUniversalTask.Status__c,
                                    mapExpense8IdToStatus.get(objUniversalTask.Expense8Id__c),labelToContentMap)
                            )
                {
                    objUniversalTask.Status__c =  labelToContentMap.get('NOTREQUIREDSTATUS');
                    lstUtlToUpdate.add(objUniversalTask);
                }
            }
            Database.update(lstUtlToUpdate);
            StopRecursion.stopRecursionAfterUpdate = true;
        }
    }
    /**
    * @Author : Sunil
    * @description :This method used to validate the status of new task.
    * @param objUniversalTask
    * @param setStatusToIgnore
    * @param labelToContentMap
    * @return boolean
    */
    public static boolean validateCurrrentTask(
        UniversalTaskList__c objUniversalTask,
        set<String> setStatusToIgnore,
        Map<String, String> labelToContentMap
    ){
        return (
                    objUniversalTask.OriginatingSystem__c.equalsIgnoreCase
                    (
                        labelToContentMap.get('ORIGINATINGSYSTEMEXPENSE8')
                    )
                    &&
                    (
                    !setStatusToIgnore.contains(objUniversalTask.Status__c)
                    ||
                    (
                        setStatusToIgnore.contains(objUniversalTask.Status__c)
                        &&
                        String.isEmpty(objUniversalTask.AssignedToAccount__c)
                    )
                    )
                    &&
                    String.isNotEmpty(objUniversalTask.Expense8Id__c)
                    //&&
                    //UserInfo.getUserId() == (Id)labelToContentMap.get('INTEGRATIONPROFILEID')
                );
    }
    /**
    * @Author : Sunil
    * @description :This method used to validated the status of task to be updated.
    * @param strStatus
    * @param strMapStatus
    * @param labelToContentMap
    * @return boolean
    */
    public static boolean validateTaskToUpdate(
        String strStatus,
        String strMapStatus,
        Map<String, String> labelToContentMap
    ){
        return  (
                    strStatus == labelToContentMap.get('UNSUBMITTEDSTATUS')
                    ||
                    (
                        strStatus == labelToContentMap.get('REJECTEDSTATUS')
                        &&
                        (
                            strMapStatus == labelToContentMap.get('SUBMITTEDSTATUS')
                            ||
                            strMapStatus == labelToContentMap.get('AUTHORISEDSTATUS')
                        )
                    )
                );
    }
    /**
    * @Author : Sunil
    * @description :This method used to validated the status of task to be updated with Rejected Status.
    * @param strStatus
    * @param strMapStatus
    * @param labelToContentMap
    * @return boolean
    */
    public static boolean validateTaskToRejected(
        String strStatus,
        String strMapStatus,
        Map<String, String> labelToContentMap
    ) {
        return  (strStatus == labelToContentMap.get('SUBMITTEDSTATUS')
                &&
                strMapStatus == labelToContentMap.get('REJECTEDSTATUS')) ;
    }
    /**
    * @Author : Sunil
    * @description :This method used to validated the status of task to be updated with not_required Status.
    * @param strStatus
    * @param strMapStatus
    * @param labelToContentMap
    * @return boolean
    */
    public static boolean validateNotRequiredTask(
        String strStatus,
        String strMapStatus,
        Map<String, String> labelToContentMap
    ) {
        return  (strStatus == labelToContentMap.get('SUBMITTEDSTATUS')
                &&
                strMapStatus == labelToContentMap.get('UNSUBMITTEDSTATUS'));
    }
    /**
    * @Author : Sunil
    * @description :This method used to check the Assignment Type as update the status accordingly.
    * @param objUniversalTask
    */
    public static void checkAssignmentType(UniversalTaskList__c objUniversalTask){
        // Add type check in below conditions for Issue no 4622
        if(objUniversalTask.AssignmentType__c == 'LearningAssignment' && objUniversalTask.Type__c != 'Leave'
           && objUniversalTask.Type__c != 'UTL'){
            objUniversalTask.Status__c = '-5';
        }else
        if(objUniversalTask.AssignmentType__c == 'LearningHistory' && objUniversalTask.Type__c != 'Leave'
           && objUniversalTask.Type__c != 'UTL'){
            objUniversalTask.Status__c = '3';
        }
    }
    /**
    * @Author : Ankit Singh
    * @description :verify condition is valid or not
    * @param eachUtl
    * @param triggerOldMap
    * @param labelToContentMap
    * @return true
    */
    public static Boolean isValid(
        UniversalTaskList__c eachUtl,
        Map<Id, UniversalTaskList__c> triggerOldMap,
        Map<String, String> labelToContentMap
    ) {
        if(
                String.isNotBlank(eachUtl.Status__c)
                &&
                String.isNotBlank(eachUtl.OriginatingSystem__c)
                &&
                eachUtl.OriginatingSystem__c == labelToContentMap.get('ORIGINATINGSYSTEMEXPENSE8')
                &&
                String.isNotBlank(eachUtl.Expense8Id__c)
                &&
                eachUtl.Status__c != labelToContentMap.get('COMPLETEDSTATUS')
                &&
                eachUtl.THStatus__c != labelToContentMap.get('COMPLETEDSTATUS')
        ) {
            return true;
        }
        return false;
    }

    /**
    * @Author : Ankit Singh
    * @description :verify condition is valid or not
    * @param eachUtl
    * @param triggerOldMap
    * @param isInsert
    * @return true
    */
    public static Boolean isInsertOrUpdate(
        UniversalTaskList__c eachUtl,
        Map<Id, UniversalTaskList__c> triggerOldMap,
        Boolean isInsert
    ) {
        if(
                isInsert
                ||
                (
                    !isInsert
                    &&
                    triggerOldMap != null
                    &&
                    triggerOldMap.get(eachUtl.Id).Status__c != eachUtl.Status__c
                )
        ) {
            return true;
        }
        return false;
    }
}