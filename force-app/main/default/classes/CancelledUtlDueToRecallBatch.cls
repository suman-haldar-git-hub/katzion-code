/**
* @Author :Ankit Singh
* @Company :Cognizant
* @description :This is the batch class to delete UTL record for set of COmmunication Id
*/
global class CancelledUtlDueToRecallBatch implements Database.Batchable<sObject>{
    public Set<Id> setOfCommunicationId = new Set<Id>();
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author :Ankit Singh
    * @Company :Cognizant
    * @description :This is the constructon of batch class.
    * @param lstParams
    */
    @InvocableMethod(label='exuete the batch CancelledUtlDueToRecallBatch'
                     description='This method will execute the CancelledUtlDueToRecallBatch')
    public static void executeBatchMethod(List<string> lstParams) {
        String parentCommunicationId = lstParams[0].split(':')[0];
        Integer batchSize = Integer.valueOf(lstParams[0].split(':')[1]);
        Set<Id> communicationIdSet = new Set<Id>();
        Boolean isUtlFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableUTLBatches__c;
        for(Communication__c objCommunication:
                CommunicationDomain.getChildCommunication(parentCommunicationId)) {
                communicationIdSet.add(objCommunication.Id);
        }
        if(communicationIdSet != null && !communicationIdSet.isEmpty() && isUtlFeatureEnabled) {
            Database.executeBatch(
                    new CancelledUtlDueToRecallBatch(communicationIdSet),
                    batchSize
            );
        }
    }

    /**
    * @Author :Ankit Singh
    * @Company :Cognizant
    * @description :This is the constructor of batch class.
    * @param childcommunicationId
    */
    global CancelledUtlDueToRecallBatch(Set<Id> childcommunicationId) {
        this.setOfCommunicationId = childcommunicationId;
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will query UTL record based on Communication Id.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String completedStatus = labelToContentMap.get('UTLSTATUSCOMPLETED');
        String query = 'SELECT Id, Communication__c, Status__c, Description__c';
        query += ' FROM UniversalTaskList__c WHERE Communication__c IN:setOfCommunicationId';
        query += ' AND Status__c !=: completedStatus';
        return Database.getQueryLocator(query);
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will process each batch of records and UPDATE Utl record.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<UniversalTaskList__c> scope) {
        try{
            if(scope != null && !scope.isEmpty()) {
                for(UniversalTaskList__c eachUtl : scope) {
                    eachUtl.Status__c = labelToContentMap.get('UTLSTATUSCOMPLETED');
                    eachUtl.Description__c = labelToContentMap.get('CANCELLEDDUETORECALL');
                    eachUtl.CompletedDate__c = System.now();
                }
                Database.update(scope);
            }
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                    'CancelledUtlDueToRecallBatch.cls on execute',
                    ex
            );
        }
    }

    /**
    * @Author : Ankit Singh
    * @description : method for post execution of batch
    * @param bc
    */
    global void finish(Database.BatchableContext bc) {
        System.debug('Cancellation due to recall is finished.');
    }
}