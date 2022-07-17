/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover the SendCommunicationService
*/
@isTest(SeeAllData=false)
public class SendCommunicationServiceTest {
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
            //create account records
            Id businessAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').
            getRecordTypeId();
            //create account records
            List<Account> accountList =
                AccountTestData.createAccountRecords(1, businessAcctRecdTypeId);
            insert accountList;
            //create contact records
            List<Contact> contactList = ContactTestData.createContactRecords(1, accountList[0].Id);
            insert contactList;
            //create distribution list records
            List<DistributionList__c> distributionList =
            DistributionListTestData.createDistributionListRecords(2);
            insert distributionList;
            List<Communication__c> communicationList = CommunicationTestData.create(
                    1,
                    campList[0].id
            );
            insert communicationList;
        }
    }
    /**
    * @author : Daksh
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testAllSendCommunicationServiceMethods() {
        List<knowledge__kav> knowledgeArticleList = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online'
        ];
        Campaign campRecord = [
            Select Id,Name From Campaign Limit 1
        ];
        List<Contact> contactList = [
            Select Id,Name From Contact
        ];
        List<Id> multiRecordIds = new List<Id>();
        for(Contact singleRecord : contactList){
            multiRecordIds.add(singleRecord.Id);
        }
        List<DistributionList__c> distributionList = [
            Select Id from DistributionList__c
        ];
        for(DistributionList__c singleRecord : distributionList){
            multiRecordIds.add(singleRecord.Id);
        }
        SendCommunicationController.DataWrapper dataWrapObj = new SendCommunicationController.DataWrapper();
        dataWrapObj.multiSelectLookupIds = multiRecordIds;
        dataWrapObj.primaryCampaign = campRecord;
        dataWrapObj.knowledgeArticleList = knowledgeArticleList;
        dataWrapObj.scheduleTimeForCommunication = System.now();
        String jsonString = JSON.serialize(dataWrapObj);
        List<Communication__c> commList = [
            Select Id From Communication__c Limit 1
        ];
        System.assertEquals(commList.size(), 1);
        Test.startTest();
            SendCommunicationService.insertCommunicationRelatedRecords(jsonString);
            SendCommunicationService.updateCommunicationRecords(commList[0].Id,true,'comment');
            SendCommunicationService.getWrapData(commList[0].Id);
            SendCommunicationService.getArticlesForPreview(knowledgeArticleList[0].Id);
        Test.stopTest();
    }
}