/**
 * @author : Ankit Singh
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UTLService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Ankit Singh
    * @description :get UtlTagged Account
    * @param objUniversalTask
    * @param setAccountId
    * @param systemGeneratedAccount
    */
    public static void getUtlTaggedAccount(
        UniversalTaskList__c objUniversalTask,
        Set<String> setAccountId,
        List<Account> systemGeneratedAccount
    ) {
        if(objUniversalTask.SubmittedByAccount__c != null){
            setAccountId.add(objUniversalTask.SubmittedByAccount__c);
        }
        if(objUniversalTask.SubmittedForAccount__c != null){
            setAccountId.add(objUniversalTask.SubmittedForAccount__c);
        }
        if(objUniversalTask.AssignedToAccount__c != null){
            setAccountId.add(objUniversalTask.AssignedToAccount__c);
        }
        // get systemGenerated Requestor if requestor is null
        if(
                objUniversalTask.SubmittedForAccount__c == null
                &&
                systemGeneratedAccount != null
                &&
                !systemGeneratedAccount.isEmpty()
        ) {
            objUniversalTask.SubmittedForAccount__c = systemGeneratedAccount[0].Id;
            setAccountId.add(objUniversalTask.SubmittedForAccount__c);
        }
    }

    /**
    * @Author : Praveen Tiwari
    * @description :This method used to stamp Requestor Name on text field
    * @param triggerNew
    * @param mapAccIdToAccount
    */
    public static void stampRequestorNameOnTextField(
        List<UniversalTaskList__c> triggerNew,
        Map<Id, Account> mapAccIdToAccount
    ){
        for(UniversalTaskList__c utlRec: triggerNew){
            Account accRecord = mapAccIdToAccount.get(utlRec.SubmittedForAccount__c);
            if(accRecord != null){
                utlRec.Requester__c = accRecord.Name;
            }
        }
    }
    /**
    * @Author : Monika Bisht
    * @description :This method used to Insert or Update UTL
    * @param objUniversalTask
    * @param oldUniversalTask
    * @param isInsert
    * @param byPassStatus
    */
    public static void insertUpdateUniversalTaskList(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask,
        Boolean isInsert,
        List<String> byPassStatus
    ) {
        if(objUniversalTask.OriginatingSystem__c == labelToContentMap.get('SUCCESSFACTOR')){
            if(objUniversalTask.SubmittedDate__c != null && isInsert){
                objUniversalTask.ReceivedDate__c = objUniversalTask.SubmittedDate__c;
            }
            if(
                    !isInsert
                    &&
                    objUniversalTask.OwnerId != oldUniversalTask.get(objUniversalTask.id).OwnerId
                    &&
                    !byPassStatus.contains(objUniversalTask.Status__c)
            ) {
                objUniversalTask.ReceivedDate__c = system.now();
            }
        }
        updateCompletedDateForAriba(objUniversalTask, oldUniversalTask, isInsert);
    }
    /**
    * @Author : Monika Bisht
    * @description :This method used to update Completed Date for Ariba
    * @param objUniversalTask
    * @param oldUniversalTask
    * @param isInsert
    */
    public static void updateCompletedDateForAriba(
        UniversalTaskList__c objUniversalTask,
        Map<id,UniversalTaskList__c> oldUniversalTask,
        Boolean isInsert
    ) {
        if(objUniversalTask.OriginatingSystem__c == labelToContentMap.get('ARIBA')){
            if(
                !isInsert
                &&
                objUniversalTask.THStatus__c != null
                &&
                objUniversalTask.THStatus__c != oldUniversalTask.get(objUniversalTask.id).THStatus__c
                &&
                (
                    objUniversalTask.THStatus__c == 'Approved'
                    ||
                    objUniversalTask.THStatus__c == 'Completed'
                )
                && objUniversalTask.CompletedDate__c == null
            ) {
                objUniversalTask.CompletedDate__c = system.now();
            }
            UniversalTasksListService.updateDateFieldsForAriba(
                objUniversalTask, oldUniversalTask, labelToContentMap
            );
            UniversalTasksListService.updateCompletedDateForStatusUpdate(
                objUniversalTask, oldUniversalTask, isInsert
            );
        }
    }
}