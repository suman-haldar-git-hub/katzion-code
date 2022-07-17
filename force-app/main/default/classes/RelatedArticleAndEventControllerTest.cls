/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
RelatedArticleAndEventController class.
*/
@isTest(SeeAllData=false)
public without sharing class RelatedArticleAndEventControllerTest {
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
        knowledgeInsert = objData.create(3, false);
        knowledgeInsert[0].RecordTypeId = recordTypeIdArticle;
        knowledgeInsert[0].Title = 'Message from Brad';
        knowledgeInsert[1].RecordTypeId = recordTypeIdEvent;
        knowledgeInsert[1].Title = 'Message from Caryn';
        knowledgeInsert[1].DateOfExpiry__c = system.today().addDays(8);
        knowledgeInsert[1].StartDate__c = system.today().addDays(1);
        knowledgeInsert[1].EndDate__c = system.today().addDays(2);
        knowledgeInsert[1].Public_Article_Description2__c = 'Article0';            
        knowledgeInsert[2].Title = 'Message from Phil';
        knowledgeInsert[2].RecordTypeId = recordTypeIdArticle;
        insert knowledgeInsert;
        List<Knowledge__kav> publishArticle = [
                SELECT Id,Title,KnowledgeArticleId,StartDate__c,IsLatestVersion
                FROM Knowledge__kav
        ];
        KbManagement.PublishingService.publishArticle(publishArticle[0].KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(publishArticle[1].KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(publishArticle[2].KnowledgeArticleId, true);
        RelatedArticleAndEventController.fetchArticleData(publishArticle,'Event');
        
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test RelatedArticleAndEventController method
    */
    @isTest
    static void testRelatedArticleAndEventController()
    {
        Test.startTest();
            List<Knowledge__kav> listKnowledge = [
                    SELECT Id, Title, UrlName, KnowledgeArticleId, IsLatestVersion, Recordtype.Name,
                    StartDate__c
                    FROM Knowledge__kav where PublishStatus = 'Online'
            ];
            List<User> lstUser = [SELECT Id FROM User];
            System.assert(!listKnowledge.isEmpty());
        	RelatedArticleAndEventController.fetchArticleOrEventData(listKnowledge[0].UrlName,true);
            RelatedArticleAndEventController.fetchArticleOrEventData(listKnowledge[1].UrlName,true);
            RelatedArticleAndEventController.fetchArticleOrEventData(listKnowledge[2].UrlName,true);
            System.runAs(lstUser[0]) {
                Id [] fixedSearchResults= new Id[1];
                fixedSearchResults[0] = listKnowledge[0].Id;
                Test.setFixedSearchResults(fixedSearchResults);
                KnowledgeDomain.getRelatedArticle('Brad',listKnowledge[0].UrlName);
                RelatedArticleAndEventController.fetchArticleOrEventData(
                        listKnowledge[0].UrlName, false
                );
                RelatedArticleAndEventController.fetchArticleOrEventData(
                        listKnowledge[1].UrlName, false
                );
                RelatedArticleAndEventController.fetchArticleOrEventData(
                        listKnowledge[2].UrlName, false
                );
                RelatedArticleAndEventController.fetchArticleData(
                        listKnowledge,
                        'Test'
                );
            }
        Test.stopTest();
    }
}