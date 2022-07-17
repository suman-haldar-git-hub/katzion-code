/*
@author : Monika
@company : Cognizant
@description : This test class is used to cover positive and negative scenarios of
@               TeamHubArticleDetailController class.
*/
@isTest(SeeAllData=false)
public class TeamHubArticleDetailControllerTest{
   @isTest static void testMethod1(){
        List<Knowledge__kav> lstKnowledge = [Select Id,Title,UrlName From Knowledge__kav Limit 1];
        test.startTest();
             KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
             List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,True); 
             List<Knowledge__kav> lstArticle = TeamHubArticleDetailController.fetchArticle('Samples-Articles0',true);
       		TeamHubArticleDetailController.GetMapMetadata getMetadata
                = TeamHubArticleDetailController.setMetadataMethod(listKnowledgeArticles[0].Id);
        test.stopTest();
        System.assertEquals(lstArticle.size(),0);
    }
}