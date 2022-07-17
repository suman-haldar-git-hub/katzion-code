/**
* @author : Anubha Billore
* @company : Cognizant
* @description : This class will be used to archive the published article
*/

public with sharing  class ArticleArchiveComponentController {
    /**
* @author : Anubha Billore
* @description : This method will archive the article and update published status to Archive
* @return : LightningResponse
* @param articleId
*/
    @AuraEnabled
    public static LightningResponse getArchivedArticles(String articleId){
        LightningResponse response = new LightningResponse();
        //Querying on CampaignContent record
        try{
            // Added by Ankit Singh on 17 June 2020 for TH-486
            // if Article PublishStatus is 'Draft' or 'Archived'
            // then show error message
            Knowledge__kav knowledgeObj = new Knowledge__kav();
            if(String.isNotBlank(articleId)) {
                knowledgeObj = KnowledgeDomain.getKnowledgeDetailsForPublishController(articleId);
                response.payLoad = knowledgeObj.PublishStatus;
                response.title = knowledgeObj.Title;
            }
            if(
                knowledgeObj != null
                &&
                knowledgeObj.PublishStatus != Label.KNOWLEDGEPUBLISHSTATUS
            ) {
                response.isError=true;
                response.errorOrSuccessMessage = Label.DRAFTANDARCHIVEDEVENTCANNOTBEARCHIVED;
                return response;
            }
            Set<Id> campaignIds = new Set<Id>();
            for(CampaignContent__c record: CampaignContentDomain.getArchiveArticle(articleId)) {
                if(record.Campaign__c != null) {
                    campaignIds.add(record.Campaign__c);
                }
            }
            List<Communication__c> communicationRecords = CommunicationDomain.getCommunicationRecords(campaignIds);
            if(!communicationRecords.isEmpty()) {
                response.isError=true;
                response.errorOrSuccessMessage = System.Label.KNOWLEDGEARTICLEARCHIVE;
            } else {
                Knowledge__kav article = KnowledgeDomain.getKnowledgeDetailsForPublishController(articleId);
                response.isError = false;
                response.errorOrSuccessMessage = System.Label.KNOWLEDGEARTICLESUCCESFULLYARCHIVE;
                KbManagement.PublishingService.archiveOnlineArticle(article.KnowledgeArticleId, null);
            }
        }
        catch (Exception e) {
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = e.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'ArticleArchiveComponentController.cls on getArchivedArticles',
                e
            );
        }
        return response;
    }
    /**
* @author : Praveen Tiwari
* @description : This method will get article/event details.
* @return : LightningResponse
* @param articleId
*/
    @AuraEnabled
    public static LightningResponse getArticleDetails(String articleId){
        LightningResponse response = new LightningResponse();
        try{
            //Querying on Knovldedge record
            Knowledge__kav knowledgeObj = KnowledgeDomain.getKnowledgeDetailsForPublishController(articleId);
            response.payLoad = knowledgeObj.PublishStatus;
            response.title = knowledgeObj.Title; 
        }
        catch(Exception ex){
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'ArticleArchiveComponentController.cls on load',
                ex
            );
        }
        return response;
    }
}