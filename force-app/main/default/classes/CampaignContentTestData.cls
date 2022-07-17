/**
@author : Praveen Tiwari
@company : Cognizant
@description : This is test data builder class for CampaignContent__c object.
*/
@isTest
public class CampaignContentTestData{
/**
* @author : Praveen Tiwari
* @description : This will create the CampaignContent__c record.
* @return : List<CampaignContent__c>
* @param count
* @param articleId
* @param campaignId
*/
    public static List<CampaignContent__c> create(Integer count, String articleId, String campaignId) {
        // List Intilization
        List<CampaignContent__c> campaignContentList = new List<CampaignContent__c>();
        for (Integer i = 0; i < count; i++) {
            CampaignContent__c campCon = new CampaignContent__c();
            campCon.Name = 'Campaign Content Test'+i;
            campCon.Campaign__c = campaignId;
            campCon.KnowledgeArticle__c = articleId;
            campaignContentList.add(campCon);
        }
        return campaignContentList;
    }
}