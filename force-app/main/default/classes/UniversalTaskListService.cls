/**
 * @author : Ankit Singh
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UniversalTaskListService {
    /**
    * @Author : Monika Bisht
    * @description :This method used to Insert or Update UTL
    * @param triggerNew
    * @param isInsert
    * @param oldUniversalTask
    */
    public static void populateTaskApproval(
        List<UniversalTaskList__c> triggerNew,
        Boolean isInsert,
        Map<id,UniversalTaskList__c> oldUniversalTask
    ) {
        try {
            Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta(); //Added for TH-4637
            map<id,id> mapOfAccEmpUserId = new map<id,id>();
            map<string,id> mapOfPrimaryTaskId = new map<string,id>();
            set<string> setAccountId = new set<string>();
            set<String> setOfSecondarySourceId = new set<String>();
            Set<String> setRequestorId = new Set<String>();
            List<Account> systemGeneratedAccount = new List<Account>();
            // Added by Harshad Dani for TH-4637
            List<String> lstEmployeeId = new List<String> {
                labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID'),
                'aribasys'
            };
            String[] alertTypeSet = (labelToContentMap.get('ALERTTYPEUTL')).split(',');
            //Adding Compensation Category in the above List
            alertTypeSet.add(labelToContentMap.get('COMPENSATIONCATEGORY'));
            Map<String, Account> mapOfEmpIdToAccount = new Map<String, Account>();
            mapOfEmpIdToAccount = AccountDomain.getAccounts(lstEmployeeId);
            List<String> lstOfStatuses = new List<String>();
            lstOfStatuses = labelToContentMap.get('STATUSFORCOMPLETEDDATE').split(',');
            Map<String,String> apiLabelMapping = DescribeSObjectCall.picklistValueToLabelMap(
                'UniversalTaskList__c','OriginatingSystem__c'
            );
            Map<String, Map<String, String>> mapOfData = new Map<String, Map<String, String>>();
            Map<String, String> mapMetadata = UTLCommunicationService.getContentFromMetadata();
            mapOfData.put('mapMetadata', mapMetadata);
            mapOfData.put('categoryPicklistValue',
                PicklistFieldValueDomain.getPickListValue('UniversalTaskList__c', 'Category__c')
            );
            mapOfData.put('unitOfDurationPicklistValue',
                PicklistFieldValueDomain.getPickListValue('UniversalTaskList__c', 'UnitOfDuration__c')
            );
            Set<String> setCat = new Set<String>();
            setCat = UTLCommunicationService.getSetOfUTLCategory(mapMetadata, setCat);
            List<String> byPassStatus = new List<String>();
            byPassStatus = labelToContentMap.get('BYPASSCOMPLETEDSTATUS').split(',');

            if(mapOfEmpIdToAccount != null && mapOfEmpIdToAccount.containsKey(
                    labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID'))
            ) {
                systemGeneratedAccount.add(mapOfEmpIdToAccount.get(
                    labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID'))
                );
            }

            for(UniversalTaskList__c objUniversalTask : triggerNew){
                UniversalTaskService.setUTLFieldsValuesToVariables(
                    objUniversalTask,
                    setRequestorId,
                    setOfSecondarySourceId
                );
                UTLService.getUtlTaggedAccount(
                        objUniversalTask,
                        setAccountId,
                        systemGeneratedAccount
                );
                UniversalTaskService.setDefaultSubmittedByAccountUTL(
                    objUniversalTask,
                    mapOfEmpIdToAccount,
                    labelToContentMap
                );

                // Added by Ankit Singh on 20Jan 2021 for mapping Expiry Date for EC Alert Category
                // Updated by Praveen Tiwari as a part of TH-4076 : Enhanced the same functionality
                // for Category(Type__c) Compensation Default Category
                // Moved from setDefaultValueForUTL function by Harshad Dani for TH-4637
                if(objUniversalTask.OriginatingSystem__c ==
                       labelToContentMap.get('ORIGINATINGSYSTEMSUCCESSFACTOR')
                    &&
                    alertTypeSet.contains(objUniversalTask.Type__c)
                    &&
                    (
                        isInsert
                        ||
                        (
                            !isInsert
                            &&
                            oldUniversalTask.get(objUniversalTask.Id).Type__c != objUniversalTask.Type__c
                        )
                    )
                ) {
                    objUniversalTask.ExpiryDate__c = objUniversalTask.ReceivedDate__c!=null?
                    Date.valueOf(objUniversalTask.ReceivedDate__c).addDays(
                        Integer.valueOf(labelToContentMap.get('ECALERTEXPIRYDAYS'))):
                    System.TODAY().addDays(
                        Integer.valueOf(labelToContentMap.get('ECALERTEXPIRYDAYS')));
                }
                // update other tasks as "Completed" if new task is not in "Unsubmitted" Status.
                UTLCommunicationService.updateCompletedDate(
                    objUniversalTask,
                    labelToContentMap,
                    lstOfStatuses
                );

                // update the Originating system text field
                if(objUniversalTask.OriginatingSystem__c != null
                    &&
                    (
                        isInsert
                        ||
                        (
                            !isInsert
                            &&
                            oldUniversalTask.get(objUniversalTask.Id).OriginatingSystem__c
                                != objUniversalTask.OriginatingSystem__c
                        )
                    )
                ) {
                    objUniversalTask.OriginatingSystemValue__c = apiLabelMapping.get(
                            objUniversalTask.OriginatingSystem__c);
                }
                UniversalTaskService.mapAppyData(objUniversalTask, mapOfData, setCat);
                UTLService.insertUpdateUniversalTaskList(
                    objUniversalTask,
                    oldUniversalTask,
                    isInsert,
                    byPassStatus
                );
            }
            if(!setRequestorId.isEmpty()){
                Map<Id, Account> mapAccIdToAccount =
                    new Map<Id, Account>(AccountDomain.queryAccountForUniversalTask(setRequestorId));
                UTLService.stampRequestorNameOnTextField(triggerNew, mapAccIdToAccount);
            }
            for(UniversalTaskList__c objParentUTL : UniversalTaskListDomain.childAndParentSourceId(
                    setOfSecondarySourceId)
            ) {
                mapOfPrimaryTaskId.put(objParentUTL.PrimarySourceId__c,objParentUTL.id);
            }
            getUserData(setAccountId,triggerNew,mapOfPrimaryTaskId);
        } catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'UniversalTaskListService class in populateTaskApproval method',
                ex
            );
        }
    }
    /**
    * @Author : Monika Bisht
    * @description :This method used to Insert or Update UTL
    * @param setAccountId
    * @param triggerNew
    * @param mapOfPrimaryTaskId
    */
    public static void getUserData(
        Set<String> setAccountId,
        List<UniversalTaskList__c> triggerNew,
        Map<String,Id> mapOfPrimaryTaskId
    ) {
        map<Id,Id> mapOfAccEmpUserId = new map<Id,Id>();
        map<String,Id> mapOfAccEmpId = new map<String,Id>();
        for(Account objAcc : AccountDomain.queryAccountForUniversalTask(setAccountId)){
            if(objAcc.Employee_ID__c != null){
                mapOfAccEmpId.put(objAcc.Employee_ID__c,objAcc.id);
            }
        }
        for(user objuser : UserDomain.userEmpIdMatchesWithAccEmpId(mapOfAccEmpId.keyset())){
            if(objuser.EmployeeID__c != null){
                mapOfAccEmpUserId.put(mapOfAccEmpId.get(objuser.EmployeeID__c),objuser.id);
            }
        }
        for(UniversalTaskList__c objUniversalTask : triggerNew) {
            tagUserData(objUniversalTask, mapOfAccEmpUserId);
            if(mapOfPrimaryTaskId.containsKey(objUniversalTask.SecondarySourceId__c)
               && objUniversalTask.id != mapOfPrimaryTaskId.get(objUniversalTask.SecondarySourceId__c)){
                objUniversalTask.Parent__c = mapOfPrimaryTaskId.get(objUniversalTask.SecondarySourceId__c);
            }
        }
    }
    /**
    * @Author : Monika Bisht
    * @description :This method used to tag User Data
    * @param objUniversalTask
    * @param mapOfAccEmpUserId
    */
    public static void tagUserData(
        UniversalTaskList__c objUniversalTask,
        Map<Id, Id> mapOfAccEmpUserId
    ) {
        if(mapOfAccEmpUserId.containsKey(objUniversalTask.SubmittedByAccount__c)){
            objUniversalTask.SubmittedByUser__c = mapOfAccEmpUserId.get(objUniversalTask.SubmittedByAccount__c);
        }
        if(mapOfAccEmpUserId.containsKey(objUniversalTask.SubmittedForAccount__c)){
            objUniversalTask.SubmittedForUser__c = mapOfAccEmpUserId.get(objUniversalTask.SubmittedForAccount__c);
        }
        if(mapOfAccEmpUserId.containsKey(objUniversalTask.AssignedToAccount__c)){
            objUniversalTask.OwnerId = mapOfAccEmpUserId.get(objUniversalTask.AssignedToAccount__c);
        }
    }
    /**
    * @Author : Ankit Singh
    * @description :This method used to fire Universal Task List Platform Event
    * update other tasks as "Completed" if new task is not in "Unsubmitted" Status.
    * @param triggerNew
    * @param triggerOldMap
    * @param isInsert
    */
    public static void fireUniversalTaskListPlatformEvent(
        List<UniversalTaskList__c> triggerNew,
        Map<id,UniversalTaskList__c> triggerOldMap,
        Boolean isInsert
    ) {
        try {
            if(StopRecursion.stopRecursionAfterUpdate){
                return;
            }
            Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
            Set<Id> setOfUTLId = new Set<Id>();
            List<UniversalTaskList__c> utlRecordList = new List<UniversalTaskList__c>();
            List<UniversalTaskList__Share> utlShareRecordList = new List<UniversalTaskList__Share>();
            Set<String> setStatusToIgnore = new Set<String>{
                labelToContentMap.get('UTLSTATUSCOMPLETED'),
                labelToContentMap.get('NOTREQUIREDSTATUS')};
            Map<String, String> mapExpense8IdToStatus = new Map<String, String>();
            Set<String> setTaskId = new Set<String>();
            Set<String> setOfSecondaryIds = new Set<String>();
            Set<String> setOfExpense8Id = new Set<String>();
            Set<Id> utlIdSet = new Set<Id>();
            Set<Id> setOfOwnerId = new Set<Id>();            
            for(UniversalTaskList__c eachUtl : triggerNew) {
                setOfUTLId.add(eachUtl.Id);
                if(isInsert) {
                    utlShareRecordList = UniversalTaskListShareDomain.shareRecordWithSubmittedUser(
                        eachUtl,
                        utlShareRecordList,
                        labelToContentMap
                    );
                }
                if(
                    UniversalTaskServiceHelper.validateCurrrentTask(
                        eachUtl, setStatusToIgnore, labelToContentMap
                    )
                ) {
                    mapExpense8IdToStatus.put(eachUtl.Expense8Id__c,eachUtl.Status__c);
                    setTaskId.add(eachUtl.Id);
                }

                if(
                    UniversalTaskServiceHelper.isValid(eachUtl, triggerOldMap, labelToContentMap)
                    &&
                    UniversalTaskServiceHelper.isInsertOrUpdate(eachUtl, triggerOldMap, isInsert)
                ) {
                    setOfExpense8Id.add(eachUtl.Expense8Id__c);
                }
                if(
                    isInsert                    
                    &&
                    UTLCommunicationService.isValidForCampaignCreation(eachUtl, labelToContentMap)
                ) {
                    utlIdSet.add(eachUtl.id);
                    setOfOwnerId.add(eachUtl.OwnerId);
                }
            }

            UniversalTaskService.insertUTLShareRecords(
                setOfUTLId,
                utlRecordList,
                utlShareRecordList
            );
            UniversalTaskServiceHelper.setStatusToNotRequired(
                mapExpense8IdToStatus, setTaskId, labelToContentMap
            );
            UTLCommunicationService.deletePrimarySourceUTLRecords(setOfExpense8Id);
            UTLCommunicationService.createChildCampaigRecord(
                utlIdSet,
                setOfOwnerId,
                labelToContentMap
            );
        } catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'UniversalTaskListService class in fireUniversalTaskListPlatformEvent method',
                ex
            );
        }
    }
}