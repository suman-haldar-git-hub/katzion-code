/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for Campaign Member object.
*/
public inherited sharing class CampaignMemberDomain {
    /**
    * @author : Ankit Singh
    * @description : This method is used to get Campaign Member record based on Campaign id.
    * @return : List<CampaignMember>
    * @param campaignId
    */
    public static List<CampaignMember> getCampaignMemberRecord(String campaignId){
        return
        [
                SELECT Id, CampaignId
                FROM CampaignMember
                WHERE CampaignId =: campaignId LIMIT 10000
        ];
    }
    /**
* @author : Daksh Madan
* @description : This method is used to insert campaign member Record.
* @param campaignMemberRecd
* @param operation
*/
    public static void dmlOnCampaignMemberRecd(List<CampaignMember> campaignMemberRecd,String operation){
        if(operation.equalsIgnoreCase('insert')){
            insert campaignMemberRecd;
        }
        else if(operation.equalsIgnoreCase('update')){
            update campaignMemberRecd;
        }
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return the list of campaign member
    * @return List<CampaignMember>
    * @param lstCampaign - list of campaign
    * @param mapIdAndUtl
    * @param mapUniqueAndUtlId 
    */
    public static List<CampaignMember> getCampaignMemberList(List<Campaign> lstCampaign,
                      Map<ID,UniversalTaskList__c> mapIdAndUtl,Map<String,Id> mapUniqueAndUtlId){
        List<CampaignMember> lstCampaignMember = new List<CampaignMember> ();
        for(Campaign objChildCampaign : lstCampaign){
            CampaignMember campaignMember   = new CampaignMember();
            campaignMember.CampaignId       = objChildCampaign.id;
            campaignMember.ContactId        = mapIdAndUtl.get(mapUniqueAndUtlId.get(
                            objChildCampaign.UniqueId__c)).AssignedToAccount__r.PersonContactId;
            campaignMember.UniversalTask__c = mapIdAndUtl.get(mapUniqueAndUtlId.get(
                                                            objChildCampaign.UniqueId__c)).Id;
            lstCampaignMember.add(campaignMember);
        }
        return lstCampaignMember;
    } 
}