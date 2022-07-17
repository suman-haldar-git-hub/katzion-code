/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for lazy loading of article in home page
*/
public with sharing class HomePageArticleController {

    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author :Ankit Singh
    * @description : This method To return initial article records
    * @param initialRows
    * @return ArticleWrapper
    */
    @AuraEnabled
    public static ArticleWrapper getArticleRecords(Integer initialRows) {
        ArticleWrapper articleWrapper= new ArticleWrapper();
        List<Knowledge__kav> articlesList = new List<Knowledge__kav>();
        try{
            articlesList = KnowledgeDomain.getinitialArticle(initialRows);
            articleWrapper.articleList = createArticleWrapper(articlesList);
            articleWrapper.totalRecords = KnowledgeDomain.getTotalCountOfArticle(Label.ARTICLE);
            articleWrapper.message = '';//'Article records are loaded';
            articleWrapper.success = true;
            articleWrapper.labelAndContentWrapperMap = labelToContentMap;
        }
        catch(Exception ex) {
            articleWrapper.message = ex.getMessage();
            articleWrapper.success = false;
            PublishLogEventService.publishExceptionEvent(
                'HomePageArticleController.cls on load',
                ex
            );
        }
        return articleWrapper;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method creates wrapper for article and bookmarks.
    * @param articlesList
    * @return List<ArticleListWrapper>
    */
    public static List<ArticleListWrapper> createArticleWrapper(List<Knowledge__kav> articlesList){
        List<ArticleListWrapper> articleListWrap = new List<ArticleListWrapper>();
        Set<Id> articleIdSet = new Set<Id>();
        Map<String, String> mapArticleToFav = new Map<String, String>();
        map<String, String> mapImageKeyToUrl = new map<String, String>();
        for(Knowledge__kav eachArticle: articlesList){
                articleIdSet.add(eachArticle.Id);
            }
            for(Favorite__b favArticle:
                    FavoriteDomain.queryFavBasedOnArticleIdSet
                    (
                        articleIdSet,
                        UserInfo.getUserId()
                    )
               )
            {
                mapArticleToFav.put(favArticle.FavoriteRecordId__c, favArticle.Id);
            }
            //Added by sunil to dynamically fetch ContentDocumentList and ContentDistribution
            mapImageKeyToUrl = ContentDistributionService.fetchPublicUrl(articleIdSet);
            for(Knowledge__kav article: articlesList){
                ArticleListWrapper articleWrap = new ArticleListWrapper();
                articleWrap.title = article.Title;
                articleWrap.urlName = article.UrlName;
                articleWrap.summary = article.Summary;
                articleWrap.articleBody = article.ArticleBody__c;
                articleWrap.id = article.Id;
                articleWrap.articleTotalViewCount = article.ArticleTotalViewCount;
                articleWrap.publisherName = article.PublishAs__c == 'Team'?
                                            article.PublisherTeamName__c:article.PublisherName__r.Name;
                articleWrap.lastPublishedDate = article.LastPublishedDate;
                articleWrap.bannerImageURL = mapImageKeyToUrl.containsKey(article.Id+'-'+labelToContentMap.get('BANNER'))?
                                       mapImageKeyToUrl.get(article.Id+'-'+labelToContentMap.get('BANNER')):'';
                articleWrap.thumbnailURL = mapImageKeyToUrl.containsKey(article.Id+'-'+labelToContentMap.get('THUMBNAIL'))?
                                       mapImageKeyToUrl.get(article.Id+'-'+labelToContentMap.get('THUMBNAIL')):'';
                articleWrap.isShareable = article.IsShareable__c;
                articleWrap.publicURL = article.PublicURL__c;
                articleWrap.confidentialityLevel = article.ConfidentialityLevel__c;
                if(mapArticleToFav.containsKey(article.Id)){
                    articleWrap.isFavorite = true;
                }else{
                    articleWrap.isFavorite = false;
                }
                articleListWrap.add(articleWrap);
            }
        return articleListWrap;
    }
    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @return List<Knowledge__kav>
    */
    @AuraEnabled
    public static List<ArticleListWrapper> loadArticleRecords(
        Integer rowLimit,
        Integer rowOffset
    ) {
        List<ArticleListWrapper> articleWrapperList = new List<ArticleListWrapper>();
        List<Knowledge__kav> knowledgeArticleList = new List<Knowledge__kav>();
        try{
            knowledgeArticleList = KnowledgeDomain.getNextArticleUsingOffset(rowLimit, rowOffset);
            articleWrapperList = createArticleWrapper(knowledgeArticleList);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'HomePageArticleController.cls on loadArticleRecords',
                ex
            );
        }
        return articleWrapperList;
    }
    /**
    * @author : Praveen Tiwari
    * @description : wrapper class
    */
    public class ArticleListWrapper{
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String urlName;
        @AuraEnabled
        public String summary;
        @AuraEnabled
        public String articleBody;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public Integer articleTotalViewCount;
        @AuraEnabled
        public String publisherName;
        @AuraEnabled
        public Datetime lastPublishedDate;
        @AuraEnabled
        public String bannerImageURL;
        @AuraEnabled
        public String thumbnailURL;
        @AuraEnabled
        public Boolean isShareable;
        @AuraEnabled
        public String publicURL;
        @AuraEnabled
        public String confidentialityLevel;
        @AuraEnabled
        public Boolean isFavorite;
    }
    /**
    * @author :Ankit Singh
    * @description : wrapper class
    */
    public class ArticleWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<ArticleListWrapper> articleList = new List<ArticleListWrapper>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
    }
}