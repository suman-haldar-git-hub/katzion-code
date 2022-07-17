/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This test class will cover the CampaignDomain
*/
@isTest
public class CampaignDomainTest {
    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        //create campaign records
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;
    }
    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testAllCampaignDomainMethods() {
        Campaign campRecord = [
            Select Id,Name,CampaignCode__c From Campaign Limit 1
        ];
        System.assertNotEquals(campRecord.CampaignCode__c, null);
        Test.startTest();
            CampaignDomain.dmlOnCampaignRecd(new List<Campaign>{campRecord},'update');
            CampaignDomain.getCampaignRecordById(campRecord.Id);
            CampaignDomain.getCampaignRecordByCode(campRecord.CampaignCode__c);
        Test.stopTest();
    }
}