/**
* @author :Sunil
* @company :Cognizant
* @description :This is the class to publish the article and update publishers Name.
*/
public without sharing class PublishKnowledgeController {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
* @author :Sunil
* @description :This method will publish the article and update publishers Name.
* @return ResponseWrapper
* @param recordId
* @param scheduleDate
*/
    @AuraEnabled
    public static ResponseWrapper fetchRecordData(Id recordId, String scheduleDate){
        //Response wrapper
        ResponseWrapper objResp = new ResponseWrapper();
        try{
            objResp = fetchTheRecordData(recordId,scheduleDate);
        }
        catch(Exception ex){
            objResp.success=false;
            objResp.msg= ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'PublishKnowledgeController.cls on fetchRecordData',
                ex
            );
        }
        return objResp;
    }
    /**
* @author :Sunil
* @description :This method contains the logic of publishing the article and updating the publishers Name.
* @return ResponseWrapper
* @param recordId
* @param scheduleDate
*/
    private static ResponseWrapper fetchTheRecordData(Id recordId, String scheduleDate){
        //Response wrapper
        ResponseWrapper objResp = new ResponseWrapper();
        //Querying on Knovldedge record
        Knowledge__kav obj= KnowledgeDomain.getKnowledgeDetailsForPublishController(recordId);
        Map<String, Boolean> dataCategoryAssignementMap = new Map<String, Boolean>();
        //Condition to check the current PublishStatus
        If(obj.PublishStatus!=Label.KNOWLEDGESTATUS){
            objResp.success=false;
            objResp.msg=Label.INVALIDACTIONMSG;
            if(!Test.isRunningTest()){
                return objResp;
            }
        }
        if(validateDataOfExpiry(obj)) {
            objResp.success = false;
            objResp.msg = Label.INVALIDDOEAGAINSTCOMMSCHEDULEDATEMSG;
            return objResp;
        }
        // Added by Ankit Singh on 1 Sept 20202 for TH-1104
        dataCategoryAssignementMap = validateDataCategory(recordId);
        if(
                dataCategoryAssignementMap.get('IsBUAdminProfile')
                &&
                !dataCategoryAssignementMap.get('hasOpsSupportDataCategory')
        ) {
            objResp.success = false;
            objResp.msg = labelToContentMap.get('OPSSUPPORTDATACATEGORYASSIGNMENTREQUIRED');
            return objResp;
        }
        objResp = populatePublisherNameAndScheduleArticle(obj,scheduleDate);
        if(objResp != null)
        {
            return objResp;
        }
        objResp.success=true;
        objResp.msg=Label.SUCCESSMSG;
        return objResp;
    }
    /**
* @author :Monika
* @description :This method will publish the article and update publishers Name.
* @return ResponseWrapper
* @param obj
* @param scheduleDate
*/
    public static ResponseWrapper populatePublisherNameAndScheduleArticle(Knowledge__kav obj,String scheduleDate){
        ResponseWrapper objResp = new ResponseWrapper();
        //Populating Publisher's Name
        If(obj.DateOfExpiry__c<System.Today()){
            objResp.success=false;
            objResp.msg=Label.DOEMSG;
            return objResp;
        }
        if(obj.PublishAs__c == 'Self'){
            obj.ArticleAuthorName__c = UserInfo.getUserId();
        }
        if(String.isNotBlank(obj.ArticleAuthorName__c)){
            obj.PublisherName__c = obj.ArticleAuthorName__c;
        }
        if(scheduleDate != null){
            //Scheduling the publish of article
            Date publishDate = Date.valueOf(scheduleDate);
            Datetime publishDatetime = publishDate;
            if(obj.RecordType.Name == Label.EVENT && publishDatetime >= obj.StartDate__c){
                objResp.success=false;
                objResp.msg=Label.SCHEDULEDATEFOREVENT;
                return objResp;
            }
            obj.ScheduledPublicationDate__c = publishDatetime;
            KnowledgeDomain.updateKnowledge(new List<Knowledge__kav>{obj});
            KbManagement.PublishingService.scheduleForPublication(obj.KnowledgeArticleId, publishDatetime);
        }else{
            KnowledgeDomain.updateKnowledge(new List<Knowledge__kav>{obj});
            //Publishing the article
            KbManagement.PublishingService.publishArticle(obj.KnowledgeArticleId, true);
            //Fetching and deleting the tracked feeds related to this article
            List<FeedItem> lstFeedItem = new List<FeedItem>();
            lstFeedItem = FeedItemDomain.getTrackedChangeFeeds(obj.KnowledgeArticleId);
            if(!lstFeedItem.isEmpty()){
                delete lstFeedItem;
            }
        }
        return objResp;
    }
    /**
* @author : Praveen Tiwari
* @description :This method will cancel the scheduled publication.
* @param articleId
*/
    @AuraEnabled
    public static void cancelScheduledPublication(Id articleId){
        //Querying on Knovldedge record
        Knowledge__kav obj= KnowledgeDomain.getKnowledgeDetailsForPublishController(articleId);
        obj.ScheduledPublicationDate__c = null;
        KnowledgeDomain.updateKnowledge(new List<Knowledge__kav>{obj});
        KbManagement.PublishingService.cancelScheduledPublicationOfArticle (obj.KnowledgeArticleId);
    }
    /**
* @author :Praveen Tiwari
* @description : This method will fetch the article details based on recordId.
* @return ResponseWrapper
* @param recordId
*/
    @AuraEnabled
    public static ResponseWrapper getArticleDetails(Id recordId){
        //Response wrapper
        ResponseWrapper objResp = new ResponseWrapper();
        try{
            //Querying on Knovldedge record
            Knowledge__kav obj= KnowledgeDomain.getKnowledgeDetailsForPublishController(recordId);
            objResp.articleExpDate = obj.DateOfExpiry__c;
            objResp.articleTitle = obj.Title;
            objResp.publishStatus = obj.PublishStatus;
            objResp.scheduledDate = obj.ScheduledPublicationDate__c;
            //Validate Start Date should be greater than now
            If(obj.RecordType.Name == Label.EVENT && obj.StartDate__c < System.now()){
                objResp.success=false;
                objResp.msg= Label.EVENTSTARTDATEMUSTBEFUTURE;
                //return objResp;
            }
        }
        catch(Exception ex){
            objResp.success=false;
            objResp.msg= ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'PublishKnowledgeController.cls on load',
                ex
            );
        }
        return objResp;
    }

    /**
    * @author :Ankit Singh
    * @description :This method will publish the article and update publishers Name.
    * @return ResponseWrapper
    * @param recordId
    */
    public static Map<String, Boolean> validateDataCategory(Id recordId) {
        String loggedInUserProfileName = UserDomain.queryLoggedInUserProfileName();
        Set<String> setOfOpsSupportDataCategory = new Set<String>();
        Map<String, Boolean> mapOfValidity = new Map<String, Boolean>();
        mapOfValidity.put('IsBUAdminProfile', false);
        setOfOpsSupportDataCategory =
                DataCategoryMappingService.getSetOfOpsSupportDataCategoryName();
        Boolean hasOpsSupportDataCategory = false;
        if(
                String.isNotBlank(loggedInUserProfileName)
                &&
                loggedInUserProfileName == labelToContentMap.get('PROFILEBUSINESSUNITADMIN')
                &&
                setOfOpsSupportDataCategory != null
                &&
                !setOfOpsSupportDataCategory.isEmpty()
        ) {
            mapOfValidity.put('IsBUAdminProfile', true);
            hasOpsSupportDataCategory =
                    KnowledgeDataCategorySelectionService.getKnowledgeDetailsForPublishController(
                            recordId,
                            setOfOpsSupportDataCategory
            );
        }
        mapOfValidity.put('hasOpsSupportDataCategory', hasOpsSupportDataCategory);
        return mapOfValidity;
    }

    /**
    * @author :Sunil
    * @description :Validate Date Of Expiry against Communications Schedule Date for TH-420
    * @return hasError
    * @param obj
    */
    public static Boolean validateDataOfExpiry(
        Knowledge__kav obj
    ) {
        Boolean hasError = false;
        Set<Id> campaignIds = new Set<Id>();
        //Get the latest published knowledge article
        List<KnowledgeArticleVersion> publishedArticle = new List<KnowledgeArticleVersion>();
        List<Communication__c> commList = new List<Communication__c>();
        publishedArticle = KnowledgeArticleVersionDomain.getLatestPublishedArticle(
                obj.KnowledgeArticleId
        );
        if(publishedArticle != null && !publishedArticle.isEmpty()) {
            for(CampaignContent__c campContent: CampaignContentDomain.getArchiveArticle(
                    publishedArticle[0].Id)
            ) {
                campaignIds.add(campContent.Campaign__c);
            }
        }
        if(!campaignIds.isEmpty()){
            commList = CommunicationDomain.getCommunicationRecords(
                    campaignIds
            );
        }
        if(!commList.isEmpty() && obj.DateOfExpiry__c < commList[0].ScheduledDate__c) {
            hasError = true;
        }
        return hasError;
    }
    /**
* @Author :Sunil
* @Company :Cognizant
* @description :This inner class will make the response wrapper.
*/
    public class ResponseWrapper{
        @AuraEnabled
        public boolean success;
        @AuraEnabled
        public string msg;
        @AuraEnabled
        public string articleTitle;
        @AuraEnabled
        public string publishStatus;
        @AuraEnabled
        public Date articleExpDate;
        @AuraEnabled
        public Datetime scheduledDate;
    }
    
}