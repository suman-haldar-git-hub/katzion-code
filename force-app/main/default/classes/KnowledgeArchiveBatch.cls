/**
* @Author:Sunil
* @Company:Cognizant
* @description :This is the batch class to auto archive published articles after expiry date.
*/
global class KnowledgeArchiveBatch implements Database.Batchable<sObject>,Schedulable,Database.Stateful{
    private Boolean isCommFeatureEnabled = false;
    /**
    * @Author : Sunil
    * @description : This method will query knowledge articles whose date of expiry is today.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        isCommFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableCommsBatches__c;
        //set to store PublishStatus from Label
        Set<String> setStatus = new Set<String>();
        //Adding Label values to set
        setStatus.addAll(Label.KNOWLEDGEPUBLISHSTATUS.split(';'));
        //Getting DateOfExpiry
        Date doe = System.Today();
        // collect the batches of records or objects to be passed to execute
        string query = 'Select Id, KnowledgeArticleId, PublishStatus, DateOfExpiry__c FROM Knowledge__kav';
        query += ' WHERE PublishStatus in:setStatus';
        query += ' AND DateOfExpiry__c=:doe';
        return Database.getQueryLocator(query);
    }

    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and auto archive the data.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<Knowledge__kav> scope){
        try{
            if(isCommFeatureEnabled) {
                for(Knowledge__kav obj : scope){
                    KbManagement.PublishingService.archiveOnlineArticle(obj.KnowledgeArticleId, null);
                }
            }
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent
            ('KnowledgeArchiveBatch.cls on execute',ex);}
    }

    /**
    * @Author : Sunil
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('This is Finish Block');
    }

    /**
    * @Author : Sunil
    * @description : This method will Schedule the batch.
    * @param sc
    */
    global void execute(SchedulableContext sc){
        Database.executeBatch(new KnowledgeArchiveBatch(),Integer.valueOf(Label.KABATCHSIZE));
    }
}