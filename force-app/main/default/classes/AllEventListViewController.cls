/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for lazy loading of article in home page
*/
public with sharing class AllEventListViewController {
    /**
    * @author :Ankit Singh
    * @description : This method To return initial article records
    * @param initialRows
    * @param articleRecordType
    * @param columnSorting
    * @return ArticleWrapper
    */
    @AuraEnabled
    public static ArticleWrapper getArticleRecords(
        Integer initialRows,
        String articleRecordType,
        String columnSorting
    ) {
        ArticleWrapper articleWrapper= new ArticleWrapper();
        Map<String, Knowledge__kav> mapIdToKnowledge = new Map<String, Knowledge__kav>();
        try{
            if(articleRecordType == Label.ARTICLE) {
                articleWrapper.articleList = KnowledgeDomain.getinitialArticleByRecordtype(
                    initialRows,
                    Label.ARTICLE,
                    columnSorting
                );
            }
            else if(articleRecordType == Label.FAVORITE) {
                BookmarkComponentController obj = new BookmarkComponentController();
                articleWrapper.favoriteList = obj.getAllBookmarks();
            }
            else if(articleRecordType == Label.EVENT) {
                articleWrapper.articleList = KnowledgeDomain.getinitialEventforFutureFromNow(
                    initialRows,
                    Label.EVENT,
                    columnSorting
                );
                // if current List does not return data with size same as rowLimit
                if(
                    articleWrapper.articleList != null
                    //&&
                    //articleWrapper.articleList.size() > 0
                    &&
                    articleWrapper.articleList.size() < initialRows
                ) {
                    String wrapData = initialRows + '-:-' + 0 +'-:-'+ columnSorting;
                    //articleWrapper = getPastEventDataFromNow(initialRows, 0, articleWrapper);
                    articleWrapper = getPastEventDataFromNow(wrapData, articleWrapper);
                }
            }
            if(articleRecordType == Label.FAVORITE){
                articleWrapper.totalRecords = articleWrapper.FavoriteList.size();
            }else{
                articleWrapper.totalRecords = KnowledgeDomain.getTotalCountOfArticle(articleRecordType);
            }
            articleWrapper.message = '';
            articleWrapper.success = true;
        }
        catch(Exception ex) {
            articleWrapper.message = ex.getMessage();
            articleWrapper.success = false;
            PublishLogEventService.publishExceptionEvent(
                'AllEventListViewController.cls on load',
                ex
            );
        }
        return articleWrapper;
    }
    /**
* @author :Ankit Singh
* @description : This method To return additional records based on offset
* @param wrapParam
* @param articleRecordType
* @param hasSearchedPastData
* @return ArticleWrapper
*/
    @AuraEnabled
    public static ArticleWrapper loadArticleRecords(
        String wrapParam,
        String articleRecordType,
        Boolean hasSearchedPastData
    ) {
        ArticleWrapper articleWrapper= new ArticleWrapper();
        try{
            articleWrapper = 
                loadingArticleRecords(wrapParam,articleRecordType,hasSearchedPastData);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'AllEventListViewController.cls on loadArticleRecords',
                ex
            );
        }
        return articleWrapper;
    }
    /**
* @author :Ankit Singh
* @description : This method logic for returning additional records based on offset
* @param wrapParam
* @param articleRecordType
* @param hasSearchedPastData
* @return ArticleWrapper
*/
    private static ArticleWrapper loadingArticleRecords(
        String wrapParam,
        String articleRecordType,
        Boolean hasSearchedPastData
    ) {
        Map<String, Object> wrapLimitObj = (Map<String, Object>) JSON.deserializeUntyped(wrapParam);
        Integer rowLimit = (Integer)wrapLimitObj.get('rowLimit');
        Integer rowOffset = (Integer)wrapLimitObj.get('rowOffset');
        String sortingData = (String)wrapLimitObj.get('sortingData');
        ArticleWrapper articleWrapper = new ArticleWrapper();
        if(articleRecordType == Label.ARTICLE) {
            articleWrapper.articleList = KnowledgeDomain.getNextArticleUsingOffsetByRecordType(
                rowLimit,
                rowOffset,
                sortingData
            );
        }
        else if(articleRecordType == Label.EVENT) {
            // get next record with future date from now
            if(!hasSearchedPastData) {
                articleWrapper.articleList = KnowledgeDomain.getNextEventUsingOffsetForFutureFromNow(
                    rowLimit,
                    rowOffset,
                    sortingData
                );
            }
            // if current List does not return data with size same as rowLimit
            if(
                !hasSearchedPastData
                &&
                articleWrapper.articleList != null
                //&&
                //articleWrapper.articleList.size() > 0
                &&
                articleWrapper.articleList.size() < rowLimit
            ) {
                // fetch remaining data for past from current time.
                String wrapData = rowLimit + '-:-' + 0 +'-:-'+ sortingData;
                //articleWrapper = getPastEventDataFromNow(rowLimit, 0, articleWrapper);
                articleWrapper = getPastEventDataFromNow(wrapData, articleWrapper);
            }
            // if no future data is available check for past data
            else if(articleWrapper.articleList.size() == 0) {
                String wrapData = rowLimit + '-:-' + rowOffset +'-:-'+ sortingData;
                //articleWrapper = getPastEventDataFromNow(rowLimit, rowOffset, articleWrapper);
                articleWrapper = getPastEventDataFromNow(wrapData, articleWrapper);
            }
        }
        return articleWrapper;
    }
    /**
* @author :Ankit Singh
* @description : This method To return Past Event Data From Now
* @param wrapData
* @param articleWrapper
* @return ArticleWrapper
*/
    public static ArticleWrapper getPastEventDataFromNow(
        String wrapData,
        ArticleWrapper articleWrapper
    ) {
        String[] splitWrapData = wrapData.split('-:-');
        Integer rowLimit = Integer.valueOf(splitWrapData[0]);
        Integer rowOffset = Integer.valueOf(splitWrapData[1]);
        String sortingData = '';
        if(splitWrapData.size() == 3 && String.isNotBlank(splitWrapData[2])) {
            sortingData = splitWrapData[2];
        }
        List<Knowledge__kav> getPastEventData = new List<Knowledge__kav>();
        getPastEventData = KnowledgeDomain.getNextEventUsingOffsetForPastFromNow(
            rowLimit,
            rowOffset,
            sortingData
        );
        if(getPastEventData != null && !getPastEventData.isEmpty()) {
            articleWrapper.hasSearchedPastData = true;
            articleWrapper.articleList.addAll(getPastEventData);
        }
        return articleWrapper;
    }
    /**
* @author : Praveen Tiwari
* @description : This method deletes favorite record
* @param recId
* @return LightningResponse
*/
    @AuraEnabled
    public static LightningResponse deleteFavoriteRecord(String recId){
        LightningResponse response = new LightningResponse();
        try{
            response = BookmarkComponentController.createOrDeleteBookmark(recId);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'AllEventListViewController.cls on deleteFavoriteRecord',
                ex
            );
        }
        return response;
    }
    /**
* @author :Ankit Singh
* @description : wrapper class
*/
    public class ArticleWrapper{
        @AuraEnabled
        public Boolean hasSearchedPastData = false;
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Knowledge__kav> articleList = new List<Knowledge__kav>();
        @AuraEnabled
        public List<BookmarkComponentController.FavoriteWrapper> favoriteList =
                                    new List<BookmarkComponentController.FavoriteWrapper>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }
}