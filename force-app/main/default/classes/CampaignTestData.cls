/**
@author : Praveen Tiwari
@company : Cognizant
@description : This is test data builder class for Campaign object.
*/
@isTest
public class CampaignTestData {
/**
* @author : Praveen Tiwari
* @description : This will create the Campaign record.
* @return : List<Campaign>
* @param count
*/
    public static List<Campaign> create(Integer count) {
    
        // List Intilization
        List<Campaign> campaignList = new List<Campaign>();
        for (Integer i = 0; i < count; i++) {
            Campaign camp = new Campaign();
            camp.Name = 'Campaign Test'+i;
            camp.Status = 'Planned';
            camp.Type = 'Advertisement';
            camp.IsActive = true;
            campaignList.add(camp);
        }
        return campaignList;
    }
}