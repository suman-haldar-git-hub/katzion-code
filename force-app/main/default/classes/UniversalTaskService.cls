/**
 * @author : Ankit Singh
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UniversalTaskService {
    /**
    * @Author : Harshad Dani
    * @description :This method used to set variables from UTL fields
    * @param objUniversalTask
    * @param setRequestorId
    * @param setOfSecondarySourceId
    */
    public static void setUTLFieldsValuesToVariables(UniversalTaskList__c objUniversalTask,
        Set<String> setRequestorId,
        set<String> setOfSecondarySourceId)
    {
        if(objUniversalTask.SubmittedForAccount__c != null){
            setRequestorId.add(objUniversalTask.SubmittedForAccount__c);
        }
        if(objUniversalTask.THStatus__c != null){
            objUniversalTask.THStatusForSearch__c = objUniversalTask.THStatus__c;
        }
        if(objUniversalTask.SecondarySourceId__c != null){
            setOfSecondarySourceId.add(objUniversalTask.SecondarySourceId__c);
        }
    }

    /**
    * @Author : Harshad Dani
    * @description :This method used to update default Submitted by Account
    * @param objUniversalTask
    * @param mapOfEmpIdToAccount
    * @param labelToContentMap
    */
    public static void setDefaultSubmittedByAccountUTL(
        UniversalTaskList__c objUniversalTask,
        Map<String, Account> mapOfEmpIdToAccount,
        Map<String, String> labelToContentMap
    ) {
        if(
            mapOfEmpIdToAccount != null
            &&
            mapOfEmpIdToAccount.containsKey(labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID'))
            &&
            mapOfEmpIdToAccount.containsKey('aribasys')
        ){
            if(objUniversalTask.SubmittedByAccount__c == mapOfEmpIdToAccount.get('aribasys').Id) {
                objUniversalTask.SubmittedByAccount__c = mapOfEmpIdToAccount.get(
                    labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID')).Id;
            }
        }
    }

    /**
    * @Author: Harshad Dani
    * @description :This method used to publish UTL records and insert UTL share
    * @param setOfUTLId
    * @param utlRecordList
    * @param utlShareRecordList
    */
    public static void insertUTLShareRecords(
        Set<Id> setOfUTLId,
        List<UniversalTaskList__c> utlRecordList,
        List<UniversalTaskList__Share> utlShareRecordList)
    {
        if(setOfUTLId != null && !setOfUTLId.isEmpty()) {
            utlRecordList = UniversalTaskListDomain.getUTLRecorcdBySetOfId(setOfUTLId);
        }
        publishEvent(utlRecordList);
        if(utlShareRecordList != null && !utlShareRecordList.isEmpty()) {
            Database.insert(utlShareRecordList);
        }
    }

    /**
    * @Author : Ankit Singh
    * @description :This method used to publish Universal Task List Platform Event
    * @param utlRecordList
    */
    public static void publishEvent(List<UniversalTaskList__c> utlRecordList) {
        List<UniversalTaskListEvent__e> utlEventList = new List<UniversalTaskListEvent__e>();
        if(utlRecordList != null && !utlRecordList.isEmpty()) {
            for(UniversalTaskList__c eachUtl : utlRecordList) {
                UniversalTaskListEvent__e newUtlEvent = new UniversalTaskListEvent__e();
                newUtlEvent.DateReceived__c = eachUtl.ReceivedDate__c;
                newUtlEvent.DueDate__c = eachUtl.DueDate__c;
                newUtlEvent.Operation__c = Trigger.isInsert ? 'Insert' : 'Update';
                newUtlEvent.OwnerId__c = eachUtl.OwnerId;
                newUtlEvent.PrimarySourceSystemId__c = eachUtl.PrimarySourceId__c;
                newUtlEvent.RequestorName__c = eachUtl.SubmittedForAccount__c != null ?
                    eachUtl.SubmittedForAccount__r.Name : null;
                newUtlEvent.Requestor__c = eachUtl.SubmittedForAccount__c;
                newUtlEvent.SourceSystem__c = eachUtl.OriginatingSystem__c;
                newUtlEvent.Status__c = eachUtl.THStatus__c;
                newUtlEvent.Title__c = eachUtl.Title__c;
                newUtlEvent.UniversalTaskId__c = eachUtl.Id;
                utlEventList.add(newUtlEvent);
            }
        }
        if(utlEventList != null && !utlEventList.isEmpty()) {
            // Call method to publish events
            Database.SaveResult [] sr = EventBus.publish(utlEventList);
        }
    }

    /**
    * @Author : Sunil
    * @description :Map duration, title, due date for Appy
    * @param objUniversalTask
    * @param mapOfData
    * @param setCat
    */
    public static void mapAppyData(
        UniversalTaskList__c objUniversalTask,
        Map<String, Map<String, String>> mapOfData,
        Set<String> setCat
    ) {
        Map<String, String> mapMetadata = mapOfData.get('mapMetadata');
        Map<String, String> categoryPicklistValue = mapOfData.get('categoryPicklistValue');
        Map<String, String> unitOfDurationPicklistValue = mapOfData.get('unitOfDurationPicklistValue');
        if(
            objUniversalTask.OriginatingSystem__c == mapMetadata.get('UTLORIGINATINGSYSTEMSAPPY')
            &&
            objUniversalTask.SystemOfAction__c == mapMetadata.get('UTLORIGINATINGSYSTEMSAPPY')
            &&
            objUniversalTask.RecordTypeName__c == mapMetadata.get('UTLRECORDTYPEAPPROVAL')
            &&
            objUniversalTask.Type__c == mapMetadata.get('UTLTYPELEAVE')
        ) {
            String duration = UTLCommunicationService.validateCategory(
                setCat, objUniversalTask
            );
            objUniversalTask.UnitOfDuration__c =
                String.isEmpty(objUniversalTask.UnitOfDuration__c)? '001' :
                    objUniversalTask.UnitOfDuration__c;
            if(
                String.isEmpty(objUniversalTask.Title__c)
                || !objUniversalTask.Title__c.StartsWith('Delete')
            ) {
            objUniversalTask.Title__c = UTLCommunicationService.validateString(
                categoryPicklistValue.get(objUniversalTask.Category__c)
                ) + ' Request ' + UTLCommunicationService.validateString(
                    objUniversalTask.From__c.format('dd-MM-YYYY')
                ) + ' '+ duration + ' ' + UTLCommunicationService.validateString(
                    unitOfDurationPicklistValue.get(objUniversalTask.UnitOfDuration__c)
                );
            }
            objUniversalTask.DueDate__c = objUniversalTask.SubmittedDate__c.addDays(14);
        }
        
    }
}