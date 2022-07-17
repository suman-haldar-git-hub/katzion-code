/**
 * @author      Abhishek Setia
 * @description Test class for ContentDistributionService
 */
@isTest
private class ContentDistributionServiceTest {

    @TestSetup
    static void makeData(){
        KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
        List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,false);
        listKnowledgeArticles[0].title = 'name less than 100 char';
        insert listKnowledgeArticles;
        //creating content version records
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        //creating content document records
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //creating content document link records
        List<ContentDocumentLink> contentlink = ContentDocumentLinkTestData.create(1, listKnowledgeArticles[0].Id,
                                                                                   documents[0].Id);
        insert contentlink;
        ContentDistribution cd = new ContentDistribution();
        cd.Name = listKnowledgeArticles[0].title;
        cd.ContentVersionId = cvList[0].Id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        insert cd;
    }
    
    @isTest private static void testfetchPublicUrl(){
        List<Knowledge__kav> lst=[SELECT Id FROM Knowledge__kav];
        Map<String,String> m=ContentDistributionService.fetchPublicUrl(new Set<Id>{lst[0].Id});
        System.assert(m.isEmpty()==false);
    }    
}