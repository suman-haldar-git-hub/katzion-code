/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for FeedItem object.
*/
public inherited sharing class FeedItemDomain {
	/**
    * @author : Praveen
    * @description : This method is used to get FeedItem of type 'TrackedChange' under an article.
    * @return : List<FeedItem>
    * @param articleId
    */
    public static List<FeedItem> getTrackedChangeFeeds(String articleId){
        return [
            Select Id, Type
            From FeedItem
            Where Type = 'TrackedChange'
            AND ParentId =: articleId
        ];
    }
}