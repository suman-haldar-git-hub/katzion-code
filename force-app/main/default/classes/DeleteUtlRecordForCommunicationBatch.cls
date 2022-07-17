/**
* @Author :Ankit Singh
* @Company :Cognizant
* @description :This is the batch class to delete UTL record for set of COmmunication Id
*/
global class DeleteUtlRecordForCommunicationBatch implements Database.Batchable<sObject>{
    public Set<Id> setOfCommunicationId = new Set<Id>();
    public Id childCampaignId;
    /**
    * @Author :Ankit Singh
    * @Company :Cognizant
    * @description :This is the constructor of batch class.
    * @param childcommunicationId
    */
    global DeleteUtlRecordForCommunicationBatch(Set<Id> childcommunicationId, Id campaignId) {
        this.setOfCommunicationId = childcommunicationId;
        this.childCampaignId = campaignId;
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will query Audience record based on Communication Id.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id,Communication__c';
        query += ' FROM UniversalTaskList__c WHERE Communication__c IN:setOfCommunicationId';
        return Database.getQueryLocator(query);
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will process each batch of records and creates campaign members.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<UniversalTaskList__c> scope) {
        try{
            List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
            if(scope != null && !scope.isEmpty()) {
                Database.delete(scope);
            }
            if(childCampaignId != null) {
                lstCampaignMember = CampaignMemberDomain.getCampaignMemberRecord(childCampaignId);
            }
            if(lstCampaignMember != null && !lstCampaignMember.isEmpty()) {
                Database.delete(lstCampaignMember);
            }
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent
            ('CreateCommunicationAudienceBatch.cls on execute',ex);}
    }

    /**
    * @Author : Ankit Singh
    * @description : After deleting UTL delete all child Communication
    * @param bc
    */
    global void finish(Database.BatchableContext bc) {
        if(setOfCommunicationId != null && !setOfCommunicationId.isEmpty()) {
            List<Communication__c> lstCommunication = new List<Communication__c>();
            for(Id eachCommunicationId : setOfCommunicationId) {
                Communication__c eachCommunication = new Communication__c(
                        Id=eachCommunicationId
                );
                lstCommunication.add(eachCommunication);
            }
            if(lstCommunication != null && !lstCommunication.isEmpty()) {
                Database.delete(lstCommunication);
            }
        }
        if(childCampaignId != null) {
            Campaign objCampaign = new Campaign(Id= childCampaignId);
            Database.delete(objCampaign);
        }
    }
}