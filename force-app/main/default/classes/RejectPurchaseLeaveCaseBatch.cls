/**
* @Author: Praveen Tiwari
* @Company:Cognizant
* @description :This batch class rejects all Purchase Leave open
* Cases on change in Financial Year.
*/
global class RejectPurchaseLeaveCaseBatch implements Database.Batchable<sObject>, Schedulable,
Database.Stateful{
	private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    private Boolean isLeaveFeatureEnabled = false;
    /**
    * @Author : Praveen Tiwari
    * @description : This method will query Purchase Leave application case which are not processed.
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
        String recordTypeValue = labelToContentMap.get('CASERECORDTYPEQUERYCASE');
        String statusValue = labelToContentMap.get('CASESTATUSCLOSED');
        String originValue = labelToContentMap.get('CASEORIGINTEAMHUB');
        String categoryValue = labelToContentMap.get('CASECATEGORYPAYANDBASICS');
        String subCategoryValue = labelToContentMap.get('PLLEAVEFORMS');
        String query = 'SELECT Id, Status, Origin, RecordType.DeveloperName,Category__c,OwnerId,';
        query += 'Sub_Category__c, TaskAndApproval__c FROM Case';
        query += ' WHERE RecordType.DeveloperName =: recordTypeValue';
        query += ' AND Status !=: statusValue';
        query += ' AND Origin =: originValue';
        query += ' AND Category__c =: categoryValue';
        query += ' AND Sub_Category__c =: subCategoryValue';
        query += ' AND CreatedDate >=: fromDate';
        query += ' AND TaskAndApproval__c != null';
        query += ' AND CreatedDate <=: todayDateTime';
        return Database.getQueryLocator(query);
    }
    /**
    * @Author : Praveen Tiwari
    * @description : This method will process each batch of records to change the Case Owner
    * to logged in user if assigned to queue and then reject and close the case.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<Case> scope){
        try{
            List<Case> updatedCaseList = new List<Case>();
            if(isLeaveFeatureEnabled){
                for(Case objCase: scope){
                    objCase.OwnerId = System.UserInfo.getUserId();
                    objCase.Status = labelToContentMap.get('CASESTATUSCLOSED');
                    objCase.Closed_Case_Comments__c = labelToContentMap.get('PLCASEREJECTIONREASON');
                    objCase.CaseApproved__c = labelToContentMap.get('CASEREJECTED');
                    updatedCaseList.add(objCase);
                }
                if(!updatedCaseList.isEmpty()){
                    Database.update(updatedCaseList);
                }
            }
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent
                ('RejectPurchaseLeaveCaseBatch.cls on execute',ex);
        }
    }
    /**
    * @Author : Praveen Tiwari
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('This is Finish Block');
    }
    /**
    * @Author : Praveen Tiwari
    * @description : This method will Schedule the batch.
    * @param sc
    */
    global void execute(SchedulableContext sc){
        Database.executeBatch(
            new RejectPurchaseLeaveCaseBatch(),
            Integer.valueOf(labelToContentMap.get('REJECTPURCHASELEAVECASEBATCHSIZE'))
        );
    }
}