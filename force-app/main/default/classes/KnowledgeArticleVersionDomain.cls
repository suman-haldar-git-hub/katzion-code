/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This Class is used to query & insert data for KnowledgeArticleVersion object
*/

public with sharing class KnowledgeArticleVersionDomain {

    /**
    @author : Praveen Tiwari
    @description : This method returns latest version of published Knowledge article version
    @return : List<KnowledgeArticleVersion>
    @param articleId
    */
    public static List<KnowledgeArticleVersion> getLatestPublishedArticle(String articleId) {
        List<KnowledgeArticleVersion> publishedArticles = new List<KnowledgeArticleVersion>();
        publishedArticles = [SELECT Id, KnowledgeArticleId, VersionNumber,
                            LastPublishedDate, ArchivedDate
                            FROM KnowledgeArticleVersion
                            WHERE PublishStatus='Online'
                            AND KnowledgeArticleId =:articleId
                           ];
		return publishedArticles;
    }
}