/**
 * @author : Monika Bisht
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
 * ReportOnCommunicationController class.
*/
@isTest(SeeAllData=false)
public with sharing class ReportOnCommunicationControllerTest{
     /**
     * @author : Monika Bisht
     * @company : SaaSFocus
     * @description : This test class is used to cover positive and negative scenarios of
     * ReportOnCommunicationController class.
    */
    @isTest static void fetchRecordIdTest(){
        //create knowledge records
        KnowledgeTestData knowledgeArticleObj = new KnowledgeTestData();
        List<knowledge__kav> knowledgeArticleList = knowledgeArticleObj.create(5, true);
        //create campaign records   
        list<Campaign> listCampaign = 
        CampaignTestData.create(5);
        insert listCampaign;
        //create campaign content records 
        list<CampaignContent__c> listCampContent =
        CampaignContentTestData.create(5,knowledgeArticleList[0].id,listCampaign[0].id);
        insert listCampContent;
        //create communication records
        List<Communication__c> communicationList = 
        CommunicationTestData.create(5,listCampaign[0].id);
        insert communicationList;
        //create account records 
        Id businessAcctRecdTypeId = 
        Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').
        getRecordTypeId();
        List<Account> accountList = 
        AccountTestData.createAccountRecords(1, businessAcctRecdTypeId);
        insert accountList;
        //create contact records 
        List<Contact> contactList = ContactTestData.createContactRecords(1, accountList[0].Id);
        insert contactList;
        //create distribution list records 
        list<DistributionList__c> distributionList =
        DistributionListTestData.createDistributionListRecords(5);
        insert distributionList;
        //create audience records 
        List<Audience__c> listAudience =
        AudienceTestData.create(5,contactList[0].id,communicationList[0].id);
        listAudience[0].DistributionList__c = distributionList[0].id;
        insert listAudience;
        System.assert(!listAudience.isEmpty());
        ReportOnCommunicationController.reportData();
    }
}