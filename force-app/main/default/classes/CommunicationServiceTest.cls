/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class will cover the SendCommunicationController
*/
@isTest
public class CommunicationServiceTest {
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
        String communicationRecord = '{"Type__c":"Communication","ActionURL__c":"Test","SystemToAction__c":"TeamHub", "TaskDescription__c" : "Communication","TaskTitle__c" : "Communication","OriginatingSystem__c" : "TeamHub"}';
        SendCommunicationController.DataWrapper dataWrapObj = new SendCommunicationController.DataWrapper();
        dataWrapObj.multiSelectLookupIds = multiRecordIds;
        dataWrapObj.primaryCampaign = campRecord;
        dataWrapObj.knowledgeArticleList = knowledgeArticleList;
        dataWrapObj.scheduleTimeForCommunication = System.now();
        dataWrapObj.utlCommunicationRecord = communicationRecord;
        dataWrapObj.dueDate = System.now();
        String jsonString = JSON.serialize(dataWrapObj);
        String utlCommunicationRecord = '{"Type__c":"UTLAction","ActionURL__c":"Test","SystemToAction__c":"TeamHub", "TaskDescription__c" : "Communication","TaskTitle__c" : "Communication","OriginatingSystem__c" : "TeamHub"}';
        dataWrapObj.utlCommunicationRecord = utlCommunicationRecord;
        String jsonStringUTL = JSON.serialize(dataWrapObj);
        List<Communication__c> commList = [
            Select Id From Communication__c Limit 1
        ];
        System.assertEquals(commList.size(), 1);
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        Test.startTest();
            SendCommunicationController.insertCommunicationRelatedRecords(
                    jsonString,
                    labelToContentMap
            );
            SendCommunicationController.insertCommunicationRelatedRecords(
                    jsonStringUTL,
                    labelToContentMap
            );
            SendCommunicationController.updateCommunicationRecords(commList[0].Id,true,'comment');
            SendCommunicationController.updateCommunicationRecords(commList[0].Id,true,'');
            SendCommunicationController.updateCommunicationRecords('commList',true,'sdd');
            SendCommunicationController.fetchCommunicateRec(commList[0].Id);
        Test.stopTest();
    }

    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testDeactivateCommunicationOnEdit() {
        List<Communication__c> commList = [
            Select Id From Communication__c Limit 1
        ];
        System.assertEquals(commList.size(), 1);
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        Test.startTest();
            SendCommunicationController.updateCommunicationRecords(commList[0].Id,false,'comment');
        Test.stopTest();
    }

    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testhasChildCommunication() {
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        List<Campaign> campList = [SELECT Id FROM Campaign Limit 1];
        System.assertEquals(campList.size(), 1);
        List<Communication__c> communicationList = CommunicationTestData.create(
                1,
                campList[0].id
        );
        communicationList[0].Type__c = labelToContentMap.get('TYPEUTLACTION');
        insert communicationList;
        List<Communication__c> childCommunicationList = CommunicationTestData.create(
                1,
                campList[0].id
        );
        childCommunicationList[0].ParentCommunication__c = communicationList[0].Id;
        communicationList[0].Type__c = labelToContentMap.get('TYPECOMMUNICATION');
        insert childCommunicationList;
        Communication__c communicationObj = [
                SELECT Id, Type__c , (SELECT Id FROM Communications__r)
                FROM Communication__c
                WHERE Id =: communicationList[0].Id
        ];
        Communication__c childcommunicationObj = [
                SELECT Id, Type__c
                FROM Communication__c
                WHERE Id =: childCommunicationList[0].Id
        ];
        CommunicationService.hasChildCommunication(communicationObj);
        CommunicationService.isCommunicationType(childcommunicationObj);
    }
}