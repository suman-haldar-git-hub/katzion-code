/**
* @Author : Praveen Tiwari
* @Company : Cognizant
* @description : This class is used as apex controller for lightning components viz. FavoriteComponent and FavoriteListView.
*/
public with Sharing class BookmarkComponentController {
    /**
* @Author : Praveen Tiwari
* @description : This method is used to fetch all the latest favorite records specific to logged in user.
* @return List<FavoriteWrapper>
*/
    @AuraEnabled
    public List<FavoriteWrapper> getAllBookmarks(){
        FavoriteDomain favDomainInst = new FavoriteDomain();
        List<FavoriteWrapper> listFavWrapper = getLatestPublishedArticles(favDomainInst);
      	return listFavWrapper;
    }
    /**
* @Author : Praveen Tiwari
* @description : This is helper method for createOrDeleteBookmark.
* @return List<FavoriteWrapper>
* @param fav
*/
    public List<FavoriteWrapper> getLatestPublishedArticles(FavoriteDomain fav) {
        List<FavoriteWrapper> favoriteWrapList = new List<FavoriteWrapper>();
        List<Favorite__b> favoriteList = new List<Favorite__b>();
        Map<String, Knowledge__kav> mapIdToKnowledge = new Map<String, Knowledge__kav>();
        Set<String> setFavoriteArticleIds = new Set<String>();
        for(Favorite__b eachFavorite:
                        fav.queryFavBasedOnLoggedInUser(UserInfo.getUserId())
        ){
            setFavoriteArticleIds.add(eachFavorite.FavoriteRecordId__c);
        }
        for(Knowledge__kav eachArticleVersion:
                            KnowledgeDomain.getLatestPublishedArticles(setFavoriteArticleIds)
        ){
            mapIdToKnowledge.put(eachArticleVersion.Id, eachArticleVersion);
        }
        for(Favorite__b eachFav: fav.queryFavoriteRecord(
                                                            UserInfo.getUserId(),
                                                            mapIdToKnowledge.keySet()
                                                        )
           )
        {
            FavoriteWrapper favWrap = new FavoriteWrapper();
            favWrap.title = mapIdToKnowledge.get(eachFav.FavoriteRecordId__c).Title;
            favWrap.favoriteRecordId = eachFav.FavoriteRecordId__c;
            favWrap.description = mapIdToKnowledge.get(eachFav.FavoriteRecordId__c).Summary;
            favWrap.favoriteType = eachFav.FavoriteType__c;
            if(mapIdToKnowledge.get(eachFav.FavoriteRecordId__c).PublisherName__c != null){
                favWrap.publisherName =
                    mapIdToKnowledge.get(eachFav.FavoriteRecordId__c).PublisherName__r.Name;
            }
            favWrap.publishedDate =
                mapIdToKnowledge.get(eachFav.FavoriteRecordId__c).LastPublishedDate;
            favWrap.favoriteId = eachFav.Id;
            favoriteWrapList.add(favWrap);
        }
        return favoriteWrapList;
    }
    /**
* @Author : Praveen Tiwari
* @description : This method is used to create or delete favorite record when a user click on favorite icon.
* @return LightningResponse
* @param recId
*/
    @AuraEnabled
    public static LightningResponse createOrDeleteBookmark(String recId){
        LightningResponse response = new LightningResponse();
        try{
            FavoriteDomain favDomain = new FavoriteDomain();
            BookmarkComponentController bCompInstance = new BookmarkComponentController();
            response = bCompInstance.createDeleteBookmarkHelper(favDomain, recId);
        }
        catch (Exception e){
            response.isError=true;
            response.errorOrSuccessMessage = System.Label.GENERICERRORMESSAGE;
            PublishLogEventService.publishExceptionEvent('BookmarkComponentController.cls on Load',e);
        }
        return response;
    }
    /**
* @Author : Praveen Tiwari
* @description : This is helper method for createOrDeleteBookmark.
* @return LightningResponse
* @param favDomain
* @param recId
*/
    public LightningResponse createDeleteBookmarkHelper(FavoriteDomain favDomain, String recId){
        List<Favorite__b> favList = new List<Favorite__b>();
        LightningResponse lightningResp = new LightningResponse();
        Knowledge__kav kA = KnowledgeDomain.getKnowledgeDetailsForPublishController(recId);
        favList = favDomain.queryFavBasedOnLoggedInUserAndFavRec(recId, UserInfo.getUserId());
        if(favList != null && !favList.isEmpty()){
            lightningResp.hasObjectAccess = FavoriteDomain.deleteFavorite(favList);
            lightningResp.errorOrSuccessMessage = kA.Title +' '+  System.Label.FAVORITEREMOVEDMESSAGE;
        }
        else{
            Favorite__b fav = new Favorite__b();
            String favoriteName;
            Id recordId = recId;
            String objectName = String.valueOf(recordId.getsobjecttype());
            if(objectName == 'Knowledge__kav'){
                Knowledge__kav article = KnowledgeDomain.getKnowledgeDetailsForPublishController(recordId);
                favoriteName = article.Title;
                fav.FavoriteRecordId__c = article.Id;
                fav.FavoriteType__c = SObjectType.Knowledge__kav.getLabel();
                fav.Summary__c = article.Summary;
                fav.Title__c = favoriteName;
                fav.UserId__c = UserInfo.getUserId();
            }
            lightningResp.hasObjectAccess = FavoriteDomain.insertFavorite(fav);
            lightningResp.errorOrSuccessMessage = fav.Title__c +' '+ System.Label.FAVORITEADDEDMESSAGE;
        }
        return lightningResp;
    }
    /**
* @Author : Praveen Tiwari
* @description : This method is used to check if favorite record exists based on record Id.
* @return Boolean
* @param recId
*/
    @AuraEnabled
    public static Boolean checkIfFavoriteExists(String recId){
        Boolean doesExist = false;
        try{
            FavoriteDomain favDomain = new FavoriteDomain();
            List<Favorite__b> favList = favDomain.queryFavBasedOnLoggedInUserAndFavRec(recId, UserInfo.getUserId());
            if(favList != Null && !favList.isEmpty()){
                doesExist = true;
            }
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent('BookmarkComponentController.cls on load',ex);
        }
        return doesExist;
    }
    /**
     * @author : Praveen Tiwari
     * @description : wrapper to store values of Article and Favorite
     */
    public class FavoriteWrapper{
        @AuraEnabled
        public String favoriteId;
        @AuraEnabled
        public String favoriteRecordId;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String favoriteType;
        @AuraEnabled
        public String publisherName;
        @AuraEnabled
        public Datetime publishedDate;
    }
}