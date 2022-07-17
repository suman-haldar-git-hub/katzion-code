/**
@Author : Monika
@Company : Cognizant
@description : This test class is used to cover positive and negative scenarios of
KnowledgeDomain class.
*/
@isTest(SeeAllData=false)
public class KnowledgeDomainTest {
    /**
    @Author : Monika
    @Company : Cognizant
    @description : create set up data
    */
    @testSetUp
    static void setUpKnowledgeData() {
        KnowledgeTestData objData = new KnowledgeTestData();
        Id recordTypeIdArticle = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get(
            Label.ARTICLE).getRecordTypeId();
        List<Knowledge__kav> knowledgeInsert = new List<Knowledge__kav>();
        knowledgeInsert = objData.create(1, false);
        knowledgeInsert[0].RecordTypeId = recordTypeIdArticle;
        knowledgeInsert[0].Title='Test';
        knowledgeInsert[0].Summary='Test';
        knowledgeInsert[0].Public_Article_Description2__c='Test';
        knowledgeInsert[0].PublishAs__c='Self';        
        insert knowledgeInsert;
        List<Knowledge__kav> publishArticle = [
                SELECT Id,Title,KnowledgeArticleId
                FROM Knowledge__kav
        ];
        KbManagement.PublishingService.publishArticle(publishArticle[0].KnowledgeArticleId, true);        
    }

    /**
    @Author : Monika
    @Company : Cognizant
    @description : Test testKnowledge Domain method
    */
    @isTest
    static void testKnowledgeDomain()
    {
        List<Knowledge__kav> listKnowledge = [
                SELECT Id, UrlName, KnowledgeArticleId
                FROM Knowledge__kav
        ];
        String sortingData = ' ORDER BY StartDate__c DESC';
        KnowledgeDomain.getKnowledgeDetailsForPublishController(listKnowledge[0].id);
        system.assert(listKnowledge[0].id != null);
        KnowledgeDomain.getKnowledgeDetailsForArticledetail(listKnowledge[0].UrlName,true);
        system.assert(listKnowledge[0].UrlName != null);
        KnowledgeDomain.getRelatedArticle('Samples',listKnowledge[0].UrlName);
        KnowledgeDomain.getKnowledgeArticleList();
        KnowledgeDomain.getinitialArticle(10);
        KnowledgeDomain.getTotalCountOfArticle(Label.ARTICLE);
        KnowledgeDomain.getNextEventUsingOffsetForPastFromNow(1, 1, sortingData);
        KnowledgeDomain.getNextEventUsingOffsetForFutureFromNow(1, 1, sortingData);
        KnowledgeDomain.getinitialEventforFutureFromNow(1, Label.ARTICLE, sortingData);
        KnowledgeDomain.getNextArticleUsingOffsetByRecordType(1, 1, sortingData);
        KnowledgeDomain.getinitialArticleByRecordtype(1, Label.ARTICLE, sortingData);
        KnowledgeDomain.getfutureEvents();
        List<Knowledge__kav> getNextArticle = KnowledgeDomain.getNextArticleUsingOffset(1, 1);
        KnowledgeDomain.getAllKnowledgeArticleList();
        KnowledgeDomain.getLatestPublishedArticles(new Set<String>{listKnowledge[0].Id});
        List<Knowledge__kav> listOfDraftKnowledge = [
                SELECT Id, UrlName, KnowledgeArticleId
                FROM Knowledge__kav WHERE publishStatus != 'Online'
        ];
        KnowledgeDomain.updateKnowledge(listOfDraftKnowledge);
    }
}