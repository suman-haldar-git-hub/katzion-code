/**
* @Author: Praveen Tiwari
* @Company:Cognizant
* @description :This batch class rejects all Salary Sacrifice MyDevice pending
* Cases on change in Financial Year.
*/
global class RejectSalarySacrificeCaseBatch implements Database.Batchable<sObject>, Schedulable,
Database.Stateful{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    private Boolean isSSBatchEnabled = false;
    /**
    * @Author : Praveen Tiwari
    * @description : This method will query MyDevice application case which are not approved/rejected.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        isSSBatchEnabled = FeatureControlDomain.getFeatureControlRecord(
            labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableSSBatches__c;
        Date fyStartDate = Date.newInstance(System.Today().Year()-1,04,01);
        if(System.today().month() >= 4){
            fyStartDate = Date.newInstance(System.Today().Year(),04,01);
        }
        Datetime todayDateTime = System.now();
        String recordTypeValue = labelToContentMap.get('CASERECORDTYPETRANSACTION');
        String statusValue = labelToContentMap.get('CASESTATUSCLOSED');
        String originValue = labelToContentMap.get('CASEORIGINTEAMHUB');
        String categoryValue = labelToContentMap.get('CASECATEGORYPAYANDBASICS');
        String subCategoryValue = labelToContentMap.get('CASESUBCATSALARYSACRIFICE');
        String caseApprovedValue = labelToContentMap.get('CASEAPPROVEDPENDING');
        String query = 'SELECT Id, Status, Origin, RecordType.Name,Category__c,OwnerId,';
        query += 'Sub_Category__c, CaseApproved__c FROM Case';
        query += ' WHERE RecordType.Name =: recordTypeValue';
        query += ' AND Status !=: statusValue';
        query += ' AND Origin =: originValue';
        query += ' AND Category__c =: categoryValue';
        query += ' AND Sub_Category__c =: subCategoryValue';
        query += ' AND CaseApproved__c =: caseApprovedValue';
        query += ' AND CreatedDate >=: fyStartDate';
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
            if(isSSBatchEnabled){
                for(Case objCase: scope){
                    objCase.OwnerId = System.UserInfo.getUserId();
                    objCase.CaseApproved__c = labelToContentMap.get('REJECTEDSTATUS');
                    objCase.Status = labelToContentMap.get('CASESTATUSCLOSED');
                    objCase.Closed_Case_Comments__c = labelToContentMap.get('SSCASEREJECTIONREASON');
                    updatedCaseList.add(objCase);
                }
                if(!updatedCaseList.isEmpty()){
                    Database.update(updatedCaseList);
                }
            }
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent
                ('RejectSalarySacrificeCaseBatch.cls on execute',ex);
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
            new RejectSalarySacrificeCaseBatch(),
            Integer.valueOf(labelToContentMap.get('REJECTSALARYSACRIFICECASEBATCHSIZE'))
        );
    }
}