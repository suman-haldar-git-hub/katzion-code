/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the following classes:- 1. TeamHubMainContainerService 2. TeamHubMainContainerController.
*/
@isTest
public class TeamHubMainContainerServiceTest {
    /**
* @author : Daksh
* @description : This method contains the actual scenarios to test the classes.
*/
    public static testMethod void getRequestedDataOnLoadTest(){
        KnowledgeTestData knowledgeArticleObj = new KnowledgeTestData();
        List<knowledge__kav> knowledgeArticleList = knowledgeArticleObj.create(200, false);
        
        Test.startTest();
        TeamHubMainContainerController.RequestDataWrapper requestDataWrap = TeamHubMainContainerService.getRequestedDataOnLoad();
        System.assertEquals(requestDataWrap.KnowledgeArticleList.size(),0);
        System.assertNotEquals(requestDataWrap.KnowledgeArticleList.size(),1);
        Test.stopTest();
    }
}