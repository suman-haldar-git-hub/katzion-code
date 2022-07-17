/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
CampaignMemberDomain class.
*/
@isTest(SeeAllData=false)
public class CampaignMemberDomainTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
* @author : Daksh Madan
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
            Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
            //create account records
            List<Account> accountList =
                AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            insert accountList;
            Account accountRecd = [Select PersonContactId From Account Limit 1];
            //create campaign records
            List<Campaign> campList = CampaignTestData.create(1);
            campList[0].CampaignCode__c = 'WEEKLY NOTIF';
            insert campList;
            //create CampaignMember records
            List<CampaignMember> campaignMemberList = 
                CampaignMemberTestData.createCampaignMemberRecords(
                    1,
                    campList[0].Id,
                    accountRecd.PersonContactId
                );
            CampaignMemberDomain.dmlOnCampaignMemberRecd(campaignMemberList,'insert');
        }
    }
    /**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test all methods of classes.
*/
    @isTest static void testAllCampaignMemberDomainMethods() {
        List<CampaignMember> campaignMemberList = [
            Select CampaignId,ContactId
            From CampaignMember
        ];
        Test.startTest();
        System.assertEquals(
            1,
            CampaignMemberDomain.getCampaignMemberRecord(campaignMemberList[0].CampaignId).size()
        );
        //updating CampaignMember
        CampaignMemberDomain.dmlOnCampaignMemberRecd(campaignMemberList,'update');
        Test.stopTest();
    }
}