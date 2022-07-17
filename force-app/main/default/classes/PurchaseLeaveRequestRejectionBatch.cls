/**
* @Author: Ankit Singh
* @Company:Cognizant
* @description :This batch class automatically reject all pending Purchase Leave Application
* Approval requests on change in Financial Year.
*/
global class PurchaseLeaveRequestRejectionBatch implements Database.Batchable<sObject>, Schedulable,
    Database.Stateful{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    private Boolean isLeaveFeatureEnabled = false;
    /**
    * @Author : Ankit Singh
    * @description : This method will query Purchase leave Request Leave with status submitted.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        isLeaveFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableLeaveBatches__c;
        Integer financialYearStartMonth =
                            Integer.valueOf(labelToContentMap.get('FINANCIALYEARSTARTMONTH'));
        Date fromDate = Date.newInstance(System.Today().Year()-1, financialYearStartMonth, 1);
        if(System.Today().Month() >= financialYearStartMonth){
            fromDate = Date.newInstance(System.Today().Year(), financialYearStartMonth, 1);
        }
        Datetime todayDateTime = System.now();
        String recordTypeId = labelToContentMap.get('UTLRECORDTYPEAPPROVAL');
        String leaveStatus = labelToContentMap.get('THSTATUSPENDINGAPPROVAL');
        String leaveType = labelToContentMap.get('LEAVELABEL');
        String category = labelToContentMap.get('PURCHASEDLEAVECODE');
        String query = 'SELECT Id, status__c, THStatus__c, RecordType.Name FROM UniversalTaskList__c';
        query += ' WHERE RecordType.Name =: recordTypeId';
        query += ' AND THStatus__c =: leaveStatus';
        query += ' AND Type__c =: leaveType';
        query += ' AND Category__c =: category';
        query += ' AND SubmittedDate__c >=: fromDate';
        query += ' AND SubmittedDate__c <=: todayDateTime';
        query += ' AND SystemRejected__c = false';
        return Database.getQueryLocator(query);
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will process each batch of records update the Leave status as
    * Rejected and SystemRejected__c = true
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<UniversalTaskList__c> scope){
        try{
            List<UniversalTaskList__c> lstLeave = new List<UniversalTaskList__c>();
            if(isLeaveFeatureEnabled) {
                for(UniversalTaskList__c objLeave : scope) {
                    objLeave.SystemRejected__c = true;
                    objLeave.status__c = labelToContentMap.get('REJECTED');
                    objLeave.Description__c = labelToContentMap.get('PLREJECTIONREASON');
                    lstLeave.add(objLeave);
                }
            }
            if(lstLeave != null && !lstLeave.isEmpty()) {
                Database.update(lstLeave);
            }
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent
            ('PurchaseLeaveRequestRejectionBatch.cls on execute',ex);
        }
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc) {
        System.debug('This is Finish Block');
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will Schedule the batch.
    * @param sc
    */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(
                new PurchaseLeaveRequestRejectionBatch(),
                Integer.valueOf(labelToContentMap.get('PURCHASELEAVEREQUESTREJECTIONBATCHSIZE'))
        );
    }
}