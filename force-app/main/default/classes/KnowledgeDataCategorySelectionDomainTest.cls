/**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
KnowledgeDataCategorySelectionDomain class.
*/
@isTest(SeeAllData=false)
public without sharing class KnowledgeDataCategorySelectionDomainTest {
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            //create knowledge acticle records
            KnowledgeTestData knowledgeArticleObj = new KnowledgeTestData();
            List<knowledge__kav> knowledgeArticleList = knowledgeArticleObj.create(1, true);
            //create Knowledge__DataCategorySelection records
            List<Knowledge__DataCategorySelection> knowledgeDataCategorySelectionRecdList = 
                KnowledgeDataCategorySelectionTestData.createKnowledgeDataCategorySelectionRecds
                (1,'OrgHierarchy',knowledgeArticleList[0].Id);
            insert knowledgeDataCategorySelectionRecdList;
        }
    }
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : Test getKnowledgeDetailsForPublishController method
*/
    @isTest
    static void getKnowledgeDetailsForPublishControllerTest() {
        knowledge__kav knowledgeArticleRecd = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online' Limit 1
        ];
        Knowledge__DataCategorySelection knowledgeDataCategorySelectionRecd = [
            SELECT Id, DataCategoryGroupName, DataCategoryName, ParentId
            FROM Knowledge__DataCategorySelection
            Limit 1
        ];
        Test.startTest();
        System.assertEquals(
            1,
            KnowledgeDataCategorySelectionDomain.getKnowledgeDetailsForPublishController
            (knowledgeArticleRecd.Id).size()
        );
        Test.stopTest();
    }
}