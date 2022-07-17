/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for CampaignMember object.
*/
@isTest
public without sharing class CampaignMemberTestData {
    /**
* @author : Daksh Madan
* @company : Cognizant
* @description : This will create the CampaignMember records.
* @return : List<CampaignMember>
* @param count
* @param campaignId
* @param contactId
*/
    public static List<CampaignMember> createCampaignMemberRecords
        (Integer count, String campaignId, String contactId){
            // List Intilization
            List<CampaignMember> campaignMemberList = new List<CampaignMember>();
            for (Integer i = 0; i < count; i++) {
                CampaignMember campaignMemberRecd = new CampaignMember();
                campaignMemberRecd.CampaignId = campaignId;
                campaignMemberRecd.ContactId = contactId;
                campaignMemberList.add(campaignMemberRecd);
            }
            return campaignMemberList;
        }
}