/*
@author : Monika
@company : Cognizant
@description : This test class is used to cover positive and negative scenarios of
@               PublishKnowledgeController class.
*/
@isTest(SeeAllData=false)
public class PublishKnowledgeControllerTest {
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            //Creating Knowledge articles
            KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
            List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(2,false);
            insert listKnowledgeArticles;
            list<Knowledge__kav> obj1 = [SELECT Id,Title,KnowledgeArticleId FROM Knowledge__kav];
            KbManagement.PublishingService.publishArticle(obj1[0].KnowledgeArticleId, true);
            //Creating Campaigns
            List<Campaign> campList = CampaignTestData.create(1);
            insert campList;
            //Creating Campaign Contents
            List<CampaignContent__c> campConList = CampaignContentTestData.create(1,
                                                                                  listKnowledgeArticles[0].Id, campList[0].Id);
            insert campConList;
            //Creating Communications 
            List<Communication__c> commList = CommunicationTestData.create(1, campList[0].Id);
            insert commList;
        }
    }
    @isTest static void testDOEValidityAgainstCommsScheduleDate(){
        Knowledge__kav article = [Select Id,PublishStatus From Knowledge__kav Limit 1];
        test.startTest();
        PublishKnowledgeController.ResponseWrapper objResp =
            PublishKnowledgeController.fetchRecordData(
                article.id,
                String.valueOf(System.Today())
            );
        System.assertEquals(objResp.success, false);
        test.stopTest();
    }
    @isTest static void testDOEOfArticleNotLessThanToday(){
        Knowledge__kav article = [Select Id, DateOfExpiry__c,StartDate__c
                                  From Knowledge__kav Where PublishStatus = 'Draft' Limit 1];
        article.ArticleAuthorName__c = UserInfo.getUserId();
        update article;
        test.startTest();
        PublishKnowledgeController.ResponseWrapper objResp =
            PublishKnowledgeController.fetchRecordData(
                article.id,
                String.valueOf(System.Today())
            );
        PublishKnowledgeController.ResponseWrapper objResp2 =
            PublishKnowledgeController.fetchRecordData(
                article.id,
                null
            );
        test.stopTest();
        System.assert(article != null);
    }
    
    @isTest static void testStartDateOfArticleGreaterThanToday(){
        User testUser = UserTestData.getUser('Business Unit Admin', 'Test');
        testUser.UserName = 'testing1user@testorg.com';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            Id eventRecordTypeId = 
                Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Event').
                getRecordTypeId();
            Knowledge__kav article = [Select Id, DateOfExpiry__c,StartDate__c
                                      From Knowledge__kav Where PublishStatus = 'Draft' Limit 1];
            article.ArticleAuthorName__c = UserInfo.getUserId();
            article.StartDate__c = System.Now().addDays(1);
            article.EndDate__c = System.Now().addDays(3);
            article.DateOfExpiry__c = System.Today().addDays(3);
            article.RecordTypeId = eventRecordTypeId;
            article.PublisherName__c = UserInfo.getUserId();
            update article;
            test.startTest();
            PublishKnowledgeController.ResponseWrapper objResp =
                PublishKnowledgeController.fetchRecordData(
                    article.id,
                    String.valueOf(System.Today().addDays(2))
                );
            test.stopTest();
            System.assert(article != null);}
    }
    
    @isTest static void testCancelScheduledPublication(){
        Knowledge__kav article = [Select Id,KnowledgeArticleId,DateOfExpiry__c
                                  From Knowledge__kav Where PublishStatus = 'Draft' Limit 1];
        test.startTest();
        KbManagement.PublishingService.scheduleForPublication(article.KnowledgeArticleId , System.Today()+1);
        PublishKnowledgeController.cancelScheduledPublication(article.id);
        test.stopTest();
        System.assert(article!=null);
    }
    
    @isTest static void testGetArticleDetails(){
        Knowledge__kav article = [Select Id, DateOfExpiry__c,RecordType.Name,StartDate__c
                                  From Knowledge__kav Where PublishStatus = 'Draft' Limit 1]; 
        test.startTest();
        PublishKnowledgeController.getArticleDetails(article.id);
        test.stopTest();
        System.assert(article!=null);
    }
    
    @isTest static void testCatchBlock1(){
        Campaign campRecd = [Select Id From Campaign Limit 1];
        test.startTest();
        PublishKnowledgeController.ResponseWrapper objResp =
            PublishKnowledgeController.fetchRecordData(
                campRecd.id,
                String.valueOf(System.Today())
            );
        System.assertEquals(objResp.success, false);
        test.stopTest();
    }
    
    @isTest static void testCatchBlock2(){
        Campaign campRecd = [Select Id From Campaign Limit 1];
        test.startTest();
        System.assertEquals(PublishKnowledgeController.getArticleDetails(campRecd.id).success,false);
        test.stopTest();
    }
}