/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
HomePageEventController class.
*/
@isTest(SeeAllData=false)
public with sharing class HomePageEventControllerTest {
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
    @description : Test HomePageEventController method
    */
    @isTest
    static void testHomePageEventController()
    {
        Test.startTest();
            HomePageEventController.ResponseWrapper getfutureEvents = HomePageEventController.getEvents();
            system.assert(!getfutureEvents.listKnowledge.isEmpty());
        Test.stopTest();
    }
}