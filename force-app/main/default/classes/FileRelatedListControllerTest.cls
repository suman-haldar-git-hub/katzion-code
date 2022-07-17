/**
* @author : Shreya Tripathi
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* FileRelatedListController class.
*/
@isTest(SeeAllData=false)
public class FileRelatedListControllerTest {
    /**
* @author : Shreya Tripathi
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup 
    static void testdata() {
        
        Account accRecord = new Account(Name = 'The Pepsico Company', Rating = 'Hot');
        insert accRecord;
        Case[] caseRecord= CaseTestData.getCaseData(accRecord.Id,1,False);
        insert caseRecord;
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing');           
        ContentVersion contentVersionTest = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
            );
            insert contentVersionTest;
        
        ContentVersion contentVersionRes = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersionTest.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = caseRecord[0].Id;
            contentlink.contentdocumentid = contentVersionRes.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;
    }
    /**
@Author : Shreya Tripathi
@Company : Cognizant
@description : Test method 1
*/
    @isTest
    static void testGetFileDetails() {
        Id p= [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User u = new User(
            ProfileId = p,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        System.runAs(u)
        {
            Test.startTest();
            Case[] testcase = [SELECT Id FROM Case WHERE Subject = 'test Subject' ];
            String caseId;
            if(testcase.size()>0)
            {
                caseId=testcase[0].Id;
            }
            List<ContentVersion> cv = FileRelatedListController.getFileDetails(caseId);
            Test.stopTest();
            ContentVersion[] cList = [SELECT Id FROM ContentVersion where Id = :cv[0].Id];
            System.assertEquals(1,cList.size());
        }
        
        
    }
}