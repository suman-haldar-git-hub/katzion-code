/**
@author : Sunil
@company : Cognizant
@description : This is test data builder class for Knowledge__kav.
*/
@isTest
public class KnowledgeTestData {
    /**
* @author : Monika
* @description : This will create the knowledge artice data.
* @return : List<Knowledge__kav>
* @param count
* @param persisted
*/
    public List<Knowledge__kav> create(Integer count, Boolean persisted) {
    
        // List Intilization
        List<Knowledge__kav> knowledgeInsert = new List<Knowledge__kav>();
        for (Integer i = 0; i < count; i++) {
            Knowledge__kav knowledgeInstance = new Knowledge__kav();
            knowledgeInstance.DateOfExpiry__c = system.today();
            knowledgeInstance.Public_Article_Description2__c = 'This is test article.';
            knowledgeInstance.Title = 'Samples Articles'+i;
            knowledgeInstance.UrlName = 'Samples-Articles'+i;
            knowledgeInstance.Summary = 'Summary Articles'+i;
            knowledgeInsert.add(knowledgeInstance);
        }
        if (persisted) {
            insert knowledgeInsert;
            list<Knowledge__kav> obj1 = [SELECT Id,Title,KnowledgeArticleId FROM Knowledge__kav];
            KbManagement.PublishingService.publishArticle(obj1[0].KnowledgeArticleId, true);
            list<Knowledge__kav> ob21 = [SELECT Id,Title,KnowledgeArticleId FROM Knowledge__kav];
        }
        return knowledgeInsert;
    }
}