/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class will cover the CommunicationDomain
*/
@isTest
public class CommunicationDomainTest {
    /**
    * @author : Ankit Singh
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
            campList[0].CampaignCode__c = 'UTL NOTIF';
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
            List<Audience__c> audienceList = AudienceTestData.create(
                    1,
                    contactList[0].Id,
                    communicationList[0].Id
            );
            insert audienceList;
            List<CampaignContent__c> lstCampaignContent = CampaignContentTestData.create(
                    1,
                    knowledgeArticleList[0].Id,
                    campList[0].Id
            );
            insert lstCampaignContent;
        }
    }

    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testCommunicationDomainMethods() {
        List<Communication__c> commList = [
            SELECT Id, Campaign__c FROM Communication__c Limit 1
        ];
        System.assertEquals(commList.size(), 1);
        Test.startTest();
            CommunicationDomain.getCommunicationRecords(new Set<Id>{commList[0].Campaign__c});
            CommunicationDomain.getInActiveCommunicationByRecordId(commList[0].Id);
            CommunicationDomain.getCommunicationWithAudiences(commList[0].Id);
            CommunicationDomain.getCommunicationRecordById(commList[0].Id);
            CommunicationDomain.dmlOnCommunicationRecd(commList[0], 'update');
            CommunicationDomain.getCommunicationForReport();
            CommunicationDomain.getChildCommunication(commList[0].Id);
            CommunicationDomain.getCommunicationForBatch(commList[0].Id);
        Test.stopTest();
    }
}