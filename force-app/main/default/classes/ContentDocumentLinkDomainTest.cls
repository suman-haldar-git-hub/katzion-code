/**
@Author : Praveen Tiwari
@Company : Cognizant
@description : This test class is used to cover ContentDocumentLinkDomain class.
*/
@isTest
public class ContentDocumentLinkDomainTest {

    @TestSetup
    static void makeData(){
        //Creating ContentVersion
        List<ContentVersion> cvList = ContentVersionTestData.create(2);
        insert cvList;
        //Creating Knowledge record
        KnowledgeTestData objData = new KnowledgeTestData();
        List<Knowledge__kav> knowledgeInsert = objData.create(1, false);
        insert knowledgeInsert;
    }

	@isTest
    static void testContentDocumentLinkDomain(){
        
        //Quering ContentDocument record
        List<ContentDocument> lscd = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(lscd.size(), 2);
        List<Knowledge__kav> knowledgeInsert = [SELECT Id FROM Knowledge__kav];
        //Creating ContentDocumentLink
        List<ContentDocumentLink> cdLinkList =
            ContentDocumentLinkTestData.create(1, knowledgeInsert[0].Id, lscd[0].Id);
        insert cdLinkList;
        Test.startTest();
        //Querying ContentDocumentLink
        List<ContentDocumentLink> cdLinkList1 =
            ContentDocumentLinkDomain.getContentDocLinks(knowledgeInsert[0].Id);
        System.assertEquals(1, cdLinkList1.size());
        List<ContentDocumentLink> cdLinkList2 = ContentDocumentLinkDomain.queryRelatedContentDocumentLink(
            new Set<String>{knowledgeInsert[0].Id},
            new Set<Id>{lscd[1].Id}
        );
        System.assert(cdLinkList2.size()==1);
        Test.stopTest();
    }

    @isTest
    private static void testInsertContentDocumentLink(){
        List<Knowledge__kav> entityList = [SELECT Id FROM Knowledge__kav];
        List<ContentDocument> listCD = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> listToInsert=ContentDocumentLinkTestData.create(1,entityList[0].Id,listCD[0].Id);
        ContentDocumentLinkDomain.insertContentDocumentLink(listToInsert);
        List<ContentDocumentLink> cdl = ContentDocumentLinkDomain.getContentDocLinks(new Set<Id>{entityList[0].Id});
        System.assert(cdl.size()==1);
    }
}