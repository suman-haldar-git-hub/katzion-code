/*
@author : Anubha
@company : Cognizant
@description : This test class is used to cover positive and negative scenarios of
@               ArticleArchiveController class.
*/
@isTest(SeeAllData=false)
public class ArticleArchiveComponentControllerTest {
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            //Creating Knowledge articles
            KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
            List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(2,True);
            //Creating Campaigns
            List<Campaign> campList = CampaignTestData.create(1);
            insert campList;
            //Creating Campaign Contents
            List<CampaignContent__c> campConList = CampaignContentTestData.create(1, listKnowledgeArticles[0].Id, campList[0].Id);
            insert campConList;
            System.assertEquals(1, campConList.size());
            //Creating Communications 
            List<Communication__c> commList = CommunicationTestData.create(1, campList[0].Id);
            insert commList;
            System.assertEquals(1, commList.size());
        }
    }
    @isTest 
    static void testArticleArchiveWithActiveCommunication(){
        Campaign cam = [Select Id From Campaign Limit 1];
        Knowledge__kav article = [Select Id From Knowledge__kav Limit 1 ];
        CampaignContent__c camc = [SELECT Id, Name, Campaign__c, KnowledgeArticle__c FROM CampaignContent__c WHERE KnowledgeArticle__c = :article.Id limit 1];
        Communication__c com = [SELECT Id, Campaign__c, Active__c , ScheduledDate__c FROM Communication__c  WHERE  Active__c = true AND Campaign__c =: cam.id limit 1]; 
        System.assertEquals(cam.Id, com.Campaign__c);
        test.startTest();
        ArticleArchiveComponentController.getArchivedArticles(article.id);
        test.stopTest();
    }
    @isTest 
    static void testArticleArchiveWithActiveCommunication1(){
        Knowledge__kav article = [Select Id,PublishStatus From Knowledge__kav where PublishStatus != 'Online'Limit 1 ];
        System.assertEquals(article.PublishStatus, 'Draft');
        test.startTest();
        ArticleArchiveComponentController.getArchivedArticles(article.id);
        test.stopTest();
    }
    @isTest 
    static void testArticleArchiveWithNoActiveCommunication(){
        Campaign cam = [Select Id From Campaign Limit 1];
        Knowledge__kav article = [Select Id From Knowledge__kav Limit 1];
        CampaignContent__c camc = [SELECT Id, Name, Campaign__c, KnowledgeArticle__c FROM CampaignContent__c WHERE KnowledgeArticle__c = :article.Id limit 1 ];
        Communication__c com = [SELECT Id, Campaign__c, Active__c , ScheduledDate__c FROM Communication__c WHERE  Active__c = true AND Campaign__c =: cam.id limit 1] ;
        com.Active__c = false;
        update com;
        System.assertEquals(cam.Id, com.Campaign__c);
        test.startTest();
        ArticleArchiveComponentController.getArchivedArticles(article.id);
        ArticleArchiveComponentController.getArticleDetails(article.id);
        test.stopTest();
    }
    @isTest 
    static void testCatchBlock(){
        Campaign cam = [Select Id From Campaign Limit 1];
        Communication__c com = [SELECT Id, Campaign__c, Active__c , ScheduledDate__c FROM Communication__c  WHERE  Active__c = true AND Campaign__c =: cam.id limit 1]; 
        System.assertEquals(cam.Id, com.Campaign__c);
        test.startTest();
        ArticleArchiveComponentController.getArchivedArticles(cam.id);
        ArticleArchiveComponentController.getArticleDetails(cam.id);
        test.stopTest();
    }
}