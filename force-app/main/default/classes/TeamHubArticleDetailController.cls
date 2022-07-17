/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This class is used as apex controller for lightning component TeamHubArticleDetail.
*/
public class TeamHubArticleDetailController {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
     /**
    * @author : Monika Bisht
    * @description : This method is used to get the metadata.
    * @return : GetMapMetadata
    * @param articleId
    */
    @AuraEnabled
    public static GetMapMetadata setMetadataMethod(String articleId){
        GetMapMetadata mapMetadata = new GetMapMetadata();
        try{
            mapMetadata.labelAndContentWrapperMap = labelToContentMap;
            mapMetadata.isFavorite = BookmarkComponentController.checkIfFavoriteExists(articleId);
            mapMetadata.showShareButton = FeatureControlDomain.getFeatureControlRecord(
                'EnableShareButton').Active__c;
            mapMetadata.showPrintButton = FeatureControlDomain.getFeatureControlRecord(
                'EnablePrintButton').Active__c;
        }
        catch(Exception ex){
            //log exception
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return mapMetadata;
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to get the metadata.
    */
    public class GetMapMetadata {
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
        @AuraEnabled
        public Boolean isFavorite;
        @AuraEnabled
        Public Boolean showShareButton;
        @AuraEnabled
        Public Boolean showPrintButton;
    }
    /**
* @author : Sunil Kumar
* @description : This method is used to fetch KNowledge__kav.
* @return : List<Knowledge__kav>
* @param urlname
* @param preview
*/
    @AuraEnabled
    public static List<Knowledge__kav> fetchArticle(string urlname,boolean preview){
        List<Knowledge__kav> knowledgeDetail = 
            new List<Knowledge__kav>();
        try{
            knowledgeDetail = 
                KnowledgeDomain.getKnowledgeDetailsForArticledetail(urlname,preview);
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent('TeamHubArticleDetailController.cls on load',ex);}
        return 
            knowledgeDetail;
    }
}