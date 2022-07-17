/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the following classes:-
1. GenericMultiSelectLookupService
2. GenericMultiSelectLookupController.
*/
@isTest(SeeAllData=false)
public class GenericMultiSelectLookupServiceTest {
    /**
* @author : Daksh
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            //create knowledge acticle records
            KnowledgeTestData knowledgeArticleObj = new KnowledgeTestData();
            List<knowledge__kav> knowledgeArticleList = knowledgeArticleObj.create(200, true);
            //create campaign records
            List<Campaign> campList = CampaignTestData.create(1);
            insert campList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test catch block of fetchLookUpValues method.
*/
    @isTest static void testCatchBlock(){
        GenericMultiSelectLookupController.DataWrapper dataWrapObj =
            new GenericMultiSelectLookupController.DataWrapper();
            dataWrapObj.searchKeyWord = 'Samples Art';
            dataWrapObj.objectName = 'knowledge__kav';
            dataWrapObj.excludeItemsIds = new List<Id>();
            dataWrapObj.fieldsString = 'Title,DateOfExpiry__c';
            dataWrapObj.filter = 'Title';
            dataWrapObj.dateTimeFilterForArticle = System.Now();
            dataWrapObj.isArticle = true;
        String jsonString = JSON.serialize(dataWrapObj);
        Test.startTest();
            System.assertNotEquals(GenericMultiSelectLookupService.fetchLookUpValues(jsonString),null);
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test article with DateTime filter available.
*/
    @isTest static void testArticleWithDateTime(){
        List<knowledge__kav> knowledgeArticleList = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online'
        ];
        GenericMultiSelectLookupController.DataWrapper dataWrapObj =
            new GenericMultiSelectLookupController.DataWrapper();
            dataWrapObj.searchKeyWord = 'Samples Art';
            dataWrapObj.objectName = 'knowledge__kav';
            dataWrapObj.excludeItemsIds = new List<Id>();
            dataWrapObj.fieldsString = ',Title,DateOfExpiry__c';
            dataWrapObj.filter = 'Title';
            dataWrapObj.dateTimeFilterForArticle = System.Now();
            dataWrapObj.isArticle = true;
        String jsonString = JSON.serialize(dataWrapObj);
        Test.startTest();
        List<sObject> resultLookupList =
            GenericMultiSelectLookupService.fetchLookUpValues(jsonString);
        LightningResponse response =
            GenericMultiSelectLookupService.fetchKnowledgeRecdTypes();
        System.assertNotEquals(response.payLoad, null);
        System.assertEquals(knowledgeArticleList.size(), 1);
        System.assertNotEquals(knowledgeArticleList.size(), 0);
        System.assertEquals(resultLookupList.size(), 1);
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test article without DateTime filter available.
*/
    @isTest static void testArticleWithoutDateTime(){
        List<knowledge__kav> knowledgeArticleList = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online'
        ];
        GenericMultiSelectLookupController.DataWrapper dataWrapObj =
            new GenericMultiSelectLookupController.DataWrapper();
            dataWrapObj.searchKeyWord = 'Samples Art';
            dataWrapObj.objectName = 'knowledge__kav';
            dataWrapObj.excludeItemsIds = new List<Id>();
            dataWrapObj.fieldsString = ',Title,DateOfExpiry__c';
            dataWrapObj.filter = 'Title';
            dataWrapObj.dateTimeFilterForArticle = null;
            dataWrapObj.isArticle = true;
        String jsonString = JSON.serialize(dataWrapObj);
        Test.startTest();
        List<sObject> resultLookupList =
            GenericMultiSelectLookupService.fetchLookUpValues(jsonString);
        System.assertEquals(knowledgeArticleList.size(), 1);
        System.assertNotEquals(knowledgeArticleList.size(), 0);
        System.assertEquals(resultLookupList.size(), 1);
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test other sObject.
*/
    @isTest static void testOtherObjects(){
        List<knowledge__kav> knowledgeArticleList = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online'
        ];
        List<Campaign> campList = [
            Select Id,Name From Campaign Limit 1
        ];
        List<Id> excludeItemsIds = new List<Id>();
        excludeItemsIds.add(knowledgeArticleList[0].Id);
        GenericMultiSelectLookupController.DataWrapper dataWrapObj =
            new GenericMultiSelectLookupController.DataWrapper();
            dataWrapObj.searchKeyWord = 'Campaign Test';
            dataWrapObj.objectName = 'Campaign';
            dataWrapObj.excludeItemsIds = excludeItemsIds;
            dataWrapObj.fieldsString = ',Name';
            dataWrapObj.filter = 'Name';
            dataWrapObj.dateTimeFilterForArticle = null;
            dataWrapObj.isArticle = false;
        String jsonString = JSON.serialize(dataWrapObj);
        Test.startTest();
        List<sObject> resultLookupList =
            GenericMultiSelectLookupService.fetchLookUpValues(jsonString);
        System.assertEquals(campList.size(), 1);
        System.assertNotEquals(campList.size(), 0);
        System.assertEquals(resultLookupList.size(), 1);
        Test.stopTest();
    }
}