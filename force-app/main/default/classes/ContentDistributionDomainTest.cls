/**
@Author : Praveen Tiwari
@Company : Cognizant
@description : This test class is used to cover ContentDistributionDomain class.
*/
@isTest
public class ContentDistributionDomainTest {
	@isTest
    static void testContentDistributionDomain(){
        //Creating ContentVersion
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        //Quering ContentDocument record
        List<ContentDocument> lscd = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(lscd.size(), 1);
        //Creating Knowledge record
        KnowledgeTestData objData = new KnowledgeTestData();
        List<Knowledge__kav> knowledgeInsert = new List<Knowledge__kav>();
        knowledgeInsert = objData.create(1, false);
        insert knowledgeInsert;
        //Creating ContentDistribution record
        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'Test CD';
        cd.ContentVersionId = cvList[0].Id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        Test.startTest();
        //Inserting ContentDistribution
        ContentDistributionDomain.insertContentDistribution(cd);
        //Querying ContentDistribution records
        List<ContentDistribution> cdList = new List<ContentDistribution>();
        ContentDistribution objCD = ContentDistributionDomain.getContentDistribution(cd.Id);
        cdList.add(objCD);
        System.assertEquals(cdList.size(), 1);
        List<ContentDistribution> listCDS = ContentDistributionDomain.getContentDistributions(new Set<Id>{cvList[0].Id});
        System.assert(listCDS.size()==1);
        Test.stopTest();
    }
}