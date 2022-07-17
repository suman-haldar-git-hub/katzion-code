/**
* @author : Shreya Tripathi
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* FileModalPopUpController class.
*/
@isTest(SeeAllData=false)
public class FileModalPopUpControllerTest {
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
    }
    /**
@Author : Shreya Tripathi
@Company : Cognizant
@description : Test method 1
*/
    @isTest
    static void testCreateFile() {
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
            ContentVersion contentVersionTest = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = Blob.valueOf('Unit Test'), 
                origin = 'H'
            );
            insert contentVersionTest;
        
            ContentVersion contentVersionRes = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Title='SampleTitle' LIMIT 1];
            List<String> testcvList=new List<String>();
            testcvList.add(contentVersionRes.Id);
            List<ContentVersion> tvalue=FileModalPopUpController.createFile(caseId,testcvList);
            Test.stopTest();
            System.assertEquals(1,tvalue.size());
        }
    }
    /**
@Author : Shreya Tripathi
@Company : Cognizant
@description : Test method 2 for catching exception
*/
    @isTest
    static void testCatch() {
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
            String caseId=System.Label.DummyCaseId;
            List<String> testcvList=new List<String>();
            String testFileId=System.Label.DummyFileId;
            testcvList.add(testFileId); 
            List<ContentVersion> tvalue;
            try{
                tvalue=FileModalPopUpController.createFile(caseId,testcvList);
            }
            catch (Exception e)
            {
                tvalue=Null;
            }
            Test.stopTest();
            System.assertEquals(Null,tvalue);
            
        }
    }
}