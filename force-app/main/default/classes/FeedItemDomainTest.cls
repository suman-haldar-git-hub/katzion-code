/**
@Author : Praveen Tiwari
@Company : Cognizant
@description : This test class is used to cover FeedItemDomain class.
*/
@isTest
public class FeedItemDomainTest {
	@isTest
    static void testFeedItemDomainDomain(){
        //Creating and publishing Knowledge Article
        KnowledgeTestData knowledgeTestData = new KnowledgeTestData();
        List<Knowledge__kav> lstArticles = KnowledgeTestData.create(1, true);
        test.startTest();
        	FeedItemDomain.getTrackedChangeFeeds(lstArticles[0].KnowledgeArticleId);
            System.assertEquals(lstArticles.size(), 1);
        test.stopTest();
    }
}