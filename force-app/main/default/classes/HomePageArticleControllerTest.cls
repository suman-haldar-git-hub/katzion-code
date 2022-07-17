/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
HomePageArticleController class.
*/
@isTest(SeeAllData=false)
public without sharing class HomePageArticleControllerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpKnowledgeData() {
        KnowledgeTestData objData = new KnowledgeTestData();
        objData.create(2,True);
        List<Account> accountList = AccountTestData.createAccountRecords(1, '');
        insert accountList;
        List<Contact> lstContact = ContactTestData.createContactRecords(1, accountList[0].Id);
        insert lstContact;
    }
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test testKnowledge Domain method
    */
    @isTest
    static void testKnowledgeDomain()
    {
        Test.startTest();
            List<Knowledge__kav> listKnowledge = [
                    SELECT Id, UrlName, KnowledgeArticleId
                    FROM Knowledge__kav
            ];
            System.assert(!listKnowledge.isEmpty());
            List<Account> listOfAccount = [
                    SELECT Id FROM Account
            ];
            System.assert(!listOfAccount.isEmpty());
            List<Contact> contactList = [
                    SELECT Id FROM Contact
            ];
            System.assert(!ContactList.isEmpty());
            HomePageArticleController.getArticleRecords(10);
            HomePageArticleController.getArticleRecords(null);
            List<HomePageArticleController.ArticleListWrapper> articleList
                = HomePageArticleController.loadArticleRecords(50, 1);
        Test.stopTest();
    }
    /**
    @Author : Daksh Madan
    @Company : SaasFocus A Cognizant Company
    @description : Test catch block of getArticleRecords method
    */
    @isTest
    static void testCatchBlock1()
    {
        Test.startTest();
            List<Knowledge__kav> listKnowledge = [
                    SELECT Id
                    FROM Knowledge__kav
            ];
            System.assert(!listKnowledge.isEmpty());
            HomePageArticleController.getArticleRecords(10);
        Test.stopTest();
    }
    /**
    @Author : Daksh Madan
    @Company : SaasFocus A Cognizant Company
    @description : Test catch block of loadArticleRecords method
    */
    @isTest
    static void testCatchBlock2()
    {
        Test.startTest();
            List<Knowledge__kav> listKnowledge = [
                    SELECT Id
                    FROM Knowledge__kav
            ];
            System.assert(!listKnowledge.isEmpty());
            List<HomePageArticleController.ArticleListWrapper> articleList
                = HomePageArticleController.loadArticleRecords(-50, -1);
        Test.stopTest();
    }
}