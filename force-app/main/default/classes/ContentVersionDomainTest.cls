/**
@Author : Praveen Tiwari
@Company : Cognizant
@description : This test class is used to cover ContentVersionDomain class.
*/
@isTest
public class ContentVersionDomainTest {
	@isTest
    static void testContentVersionDomain(){
        //Creating ContentVersion
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        //Quering ContentDocument record
        List<ContentDocument> lscd = [SELECT Id, Title, LatestPublishedVersionId 
                                                            FROM ContentDocument];
        System.assertEquals(lscd.size(), 1);
        Set<Id> conDocIdSet = new Set<Id>();
        conDocIdSet.add(lscd[0].Id);
        test.startTest();
        //Querying ContentVersion
        ContentVersion conVersionRec = ContentVersionDomain.getContentVersion(lscd[0].Id);
        conVersionRec.ImageType__c = 'Thumbnail';
        conVersionRec.PublicURL__c = 'TestURL';
        ContentVersionDomain.updateContentVersion(conVersionRec);
        
        //Querying ContentVersion
        ContentVersionDomain.getContentVersionList(conDocIdSet);
        System.assertEquals('Thumbnail', conVersionRec.ImageType__c);
        test.stopTest();
    }
}