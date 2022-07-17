/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the following classes:- 
1. GenericLookupService 
2. GenericLookupServiceCtrl.
*/
@isTest(SeeAllData=false)
public class GenericLookupServiceTest {
        /**
    * @author : Daksh
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        User admin = new User();
        admin = [
            SELECT id, UserName
            FROM User
            WHERE Profile.Name = 'System Administrator' and isActive =: true LIMIT 1
        ];
        System.runAs(admin){
            //create campaign records
            List<Campaign> campList = CampaignTestData.create(200);
            insert campList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test other sObject.
*/
    @isTest static void testOtherObjects(){
        List<Campaign> campList = [
            Select Id,Name From Campaign
        ];
        Test.startTest();
        List<sObject> resultList = 
            GenericLookupService.fetchLookUpValues('Campaign Test','Select Id,Name From Campaign');
        System.assertEquals(resultList.size(), 200);
        System.assertNotEquals(resultList.size(), 0);
        Test.stopTest();
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This test catch block.
*/
    @isTest static void testCatchBlock(){
        List<Campaign> campList = [
            Select Id,Name From Campaign
        ];
        Test.startTest();
        List<sObject> resultList = 
            GenericLookupService.fetchLookUpValues('Campaign Test','Select Id,Name Campaign');
        System.assertEquals(resultList.size(), 0);
        Test.stopTest();
    }
}