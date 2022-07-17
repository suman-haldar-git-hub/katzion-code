/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class is utlity class for all the SOQL and DMLs for Campaign object.
*/
public inherited sharing class CampaignDomain {
    /**
* @author : Daksh Madan
* @description : This method is used to insert campaign Record.
* @param campaignRecd
* @param operation
*/
    public static void dmlOnCampaignRecd(List<Campaign> campaignRecd,String operation){
        if(operation.equalsIgnoreCase('insert')){
            insert campaignRecd;
        }
        else if(operation.equalsIgnoreCase('update')){
            update campaignRecd;
        }
    }
    /**
    * @author : Daksh
    * @description : This method is used to get Campaign record based on id.
    * @return : Campaign
    * @param campaignId
    */
    public static Campaign getCampaignRecordById(String campaignId){
        return [SELECT Id,Name,CampaignCode__c
                FROM Campaign 
                WHERE Id =: campaignId];
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used to get Campaign record based on Campaign code
    * @return : Campaign
    * @param campaignCode
    */
    public static Campaign getCampaignRecordByCode(String campaignCode){
        return
        [
                SELECT Id, Name, CampaignCode__c
                FROM Campaign
                WHERE CampaignCode__c =: campaignCode Limit 1
        ];
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record 
    * @return Campaign
    * @param campaignName name of the child campaign
    * @param parentId - parent campaign id
    * @param uniqueId - unique combination of campaign id and utl id
    */
    public static Campaign createCampaignRecord(String campaignName,Id parentId,String uniqueId){
        Campaign childCampaign = new Campaign(
        Name = campaignName,
        ParentId = parentId,
        UniqueId__c = uniqueId
        );
        
        return childCampaign;
    }
}