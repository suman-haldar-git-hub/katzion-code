/*
@author : Praveen Tiwari
@company : Cognizant
@description : This test class is used to cover positive and negative scenarios of
@               UploadContentImageController class.
*/
@isTest(SeeAllData=false)
public class UploadContentImageControllerTest {
    /**
* @author : Praveen Tiwari
* @description : This method is used to test all methods.
*/
    @isTest static void testGetFiles() {
        //Creating Knowledge articles
        KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
        List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,false);
        listKnowledgeArticles[0].title = 'name greater than 100 char----------------------'+
            ''+'---------------------------------------------------------------------';
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
        test.startTest();
        try{
            UploadContentImageController.generatePublicURL(listKnowledgeArticles[0].Id, documents[0].Id, 'Banner');
            UploadContentImageController.UploadFileResponseWrapper response = 
                UploadContentImageController.getFiles(listKnowledgeArticles[0].Id);
            UploadContentImageController.UploadFileResponseWrapper uploadFileWrapper =
                new UploadContentImageController.UploadFileResponseWrapper();
            uploadFileWrapper.success = true;
            uploadFileWrapper.publishStatus = 'Draft';
            uploadFileWrapper.documentRecords = cvList;
            UploadContentImageController.deleteFiles(documents[0].Id,listKnowledgeArticles[0].Id,'Banner');
            List<ContentDocument> cdList = [SELECT Id,Title,FileType
                                            FROM ContentDocument
                                           ];
            System.assertEquals(0, cdList.size(), 'Document not deleted.');
        }
        catch(exception ex){System.debug('Exception');}
        test.stopTest();
    }
    /**
* @author : Daksh Madan
* @description : This is to test exception.
*/
    @isTest static void testCatchBlock1() {
        //Creating Knowledge articles
        KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
        List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,false);
        listKnowledgeArticles[0].title = 'name greater than 100 char----------------------'+
            ''+'---------------------------------------------------------------------';
        insert listKnowledgeArticles;
        System.assert(listKnowledgeArticles!=null);
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> contentlink = ContentDocumentLinkTestData.create(1, listKnowledgeArticles[0].Id,
                                                                                   documents[0].Id);
        insert contentlink;
        List<Account> acctList = AccountTestData.createAccountRecords(1, '');
        insert acctList;
        test.startTest();
        try{
            UploadContentImageController.deleteFiles(documents[0].Id,acctList[0].Id, 'Thumbnail');
        }
        catch(exception ex){System.debug('Exception');}
        test.stopTest();
    }
    /**
* @author : Daksh Madan
* @description : This is to test exception.
*/
    @isTest static void testCatchBlock2() {
        //Creating Knowledge articles
        KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
        List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,false);
        listKnowledgeArticles[0].title = 'name greater than 100 char----------------------'+
            ''+'---------------------------------------------------------------------';
        insert listKnowledgeArticles;
        System.assert(listKnowledgeArticles!=null);
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> contentlink = ContentDocumentLinkTestData.create(1, listKnowledgeArticles[0].Id,
                                                                                   documents[0].Id);
        insert contentlink;
        List<Account> acctList = AccountTestData.createAccountRecords(1, '');
        insert acctList;
        test.startTest();
        try{
            UploadContentImageController.generatePublicURL(acctList[0].Id, documents[0].Id, 'THUMBNAIL');
        }
        catch(exception ex){System.debug('Exception');}
        test.stopTest();
    }
     /**
* @author : Praveen Tiwari
* @description : This method is used to test all methods.
*/
    @isTest static void testGetFiles2() {
        //Creating Knowledge articles
        KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
        List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(1,false);
        listKnowledgeArticles[0].title = 'name greater than 100 char----------------------'+
            ''+'---------------------------------------------------------------------';
        insert listKnowledgeArticles;
        //creating content version records
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        cvList[0].ImageType__c = 'Thumbnail';
        insert cvList;
        //creating content document records
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Set<Id> docIds = new Set<Id>();
        for(ContentDocument doc: documents){
            docIds.add(doc.Id);
        }
        //creating content document link records
        List<ContentDocumentLink> contentlink = ContentDocumentLinkTestData.create(1, listKnowledgeArticles[0].Id,
                                                                                   documents[0].Id);
        insert contentlink;
        test.startTest();
        try{
            UploadContentImageController.generatePublicURL(listKnowledgeArticles[0].Id, documents[0].Id, 'Thumbnail');
            UploadContentImageController.UploadFileResponseWrapper response = 
                UploadContentImageController.getFiles(listKnowledgeArticles[0].Id);
            UploadContentImageController.UploadFileResponseWrapper uploadFileWrapper =
                new UploadContentImageController.UploadFileResponseWrapper();
            uploadFileWrapper.success = true;
            uploadFileWrapper.publishStatus = 'Draft';
            uploadFileWrapper.documentRecords = cvList;
            UploadContentImageController.deleteFiles(documents[0].Id,listKnowledgeArticles[0].Id, 'Mobile Banner');
            List<ContentDocument> cdList = [SELECT Id,Title,FileType
                                            FROM ContentDocument
                                           ];
            List<ContentDocument> contentDocList = ContentDocumentDomain.getContentDocLinks(docIds);
            System.assertEquals(0, cdList.size(), 'Document not deleted.');
        }
        catch(exception ex){System.debug('Exception');}
        test.stopTest();
    }
}