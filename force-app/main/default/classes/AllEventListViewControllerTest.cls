/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
AllEventListViewController class.
*/
@isTest(SeeAllData=false)
public without sharing class AllEventListViewControllerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id recordTypeIdArticle = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get(
            Label.ARTICLE).getRecordTypeId();
        Id recordTypeIdEvent = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get(
            Label.EVENT).getRecordTypeId();
        List<Knowledge__kav> knowledgeInsert = new List<Knowledge__kav>();
        KnowledgeTestData objData = new KnowledgeTestData();
        knowledgeInsert = objData.create(2, false);
        knowledgeInsert[0].RecordTypeId = recordTypeIdArticle;
        knowledgeInsert[1].RecordTypeId = recordTypeIdEvent;
        knowledgeInsert[1].DateOfExpiry__c = system.today().addDays(8);
        knowledgeInsert[1].StartDate__c = system.today().addDays(1);
        knowledgeInsert[1].EndDate__c = system.today().addDays(2);
        knowledgeInsert[1].Public_Article_Description2__c = 'Test';
        knowledgeInsert[1].PublisherName__c = UserInfo.getUserId();
        insert knowledgeInsert;
        List<Knowledge__kav> publishArticle = [
                SELECT Id,Title,KnowledgeArticleId
                FROM Knowledge__kav
        ];
        KbManagement.PublishingService.publishArticle(publishArticle[0].KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(publishArticle[1].KnowledgeArticleId, true);
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test testKnowledge Domain method
    */
    @isTest
    static void testAllEventListViewController()
    {
        Test.startTest();
            List<Knowledge__kav> listKnowledge = [
                    SELECT Id, UrlName, KnowledgeArticleId
                    FROM Knowledge__kav
            ];
            String sortingData = ' ORDER BY StartDate__c DESC';
            String wrapParam = '{"rowLimit": 1, "rowOffset": 1, "sortingData":" ORDER BY StartDate__c DESC"}';
            String wrapParamObj = '{"rowLimit": 5, "rowOffset": 1,"sortingData":"  ORDER BY StartDate__c DESC"}';
            System.assert(!listKnowledge.isEmpty());
            AllEventListViewController.deleteFavoriteRecord(listKnowledge[0].Id);
            AllEventListViewController.getArticleRecords(1, Label.ARTICLE, sortingData);
            AllEventListViewController.getArticleRecords(1, Label.EVENT, sortingData);
            AllEventListViewController.getArticleRecords(5, Label.EVENT, sortingData);
            AllEventListViewController.loadArticleRecords(wrapParam, Label.ARTICLE, false);
            AllEventListViewController.loadArticleRecords(wrapParam, Label.EVENT, false);
            AllEventListViewController.loadArticleRecords(wrapParam, Label.EVENT, true);
            AllEventListViewController.loadArticleRecords(wrapParamObj, Label.EVENT, false);
            AllEventListViewController.getArticleRecords(1, Label.FAVORITE, sortingData);
            AllEventListViewController.getArticleRecords(null, Label.ARTICLE, sortingData);
        Test.stopTest();
    }
}