/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This test class will cover the CreateUtlAudienceBatch
*/
@isTest(SeeAllData=false)
public class CreateUtlAudienceBatchTest {
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
        testUser.TaskNotification__c = true;
        testUser.TaskNotificationChannel__c = 'TeamHub;Email';
        insert testUser;
        System.runAs(testUser) {
            Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
            //create account records
            List<Account> accountList =
                AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            accountList[0].Employee_Id__c = 'Test007';
            accountList[0].Area_Dept_Name__c = 'CEO Support;Corporate- Public Affair';
            accountList[0].Brand__c = 'Corporate';
            accountList[0].Group__c = 'Support Functions';
            accountList[0].OpsSupport__c = 'CEO Support;Corporate Strategy';
            accountList[0].Country__c = 'Australia';
            accountList[0].IsLineManager__c = 'No';
            accountList[0].HasDOA__c = 'No';
            insert accountList;
            Account accountRecd = [Select PersonContactId From Account Limit 1];
            List<DistributionList__c> listDL = DistributionListTestData.createDistributionListRecords(1);
            listDL[0].Area__c = 'CEO Support;Corporate- Public Affair';
            listDL[0].Brand__c = 'Corporate';
            listDL[0].Group__c = 'Support Functions';
            listDL[0].OpsSupport__c = 'CEO Support;Corporate Strategy';
            listDL[0].Country__c = 'Australia';
            listDL[0].IsLineManager__c = 'No';
            listDL[0].HasDOA__c = 'No';
            insert listDL;
            list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
            list<Communication__c> listCom = CommunicationTestData.create(1,listCam[0].id);
            listCom[0].AssigneeEmployeeId__c = 'Test007';
            insert listCom;
            List<Audience__c> listAudience = 
                AudienceTestData.create(1,accountRecd.PersonContactId,listCom[0].id);
            listAudience[0].DistributionList__c = listDL[0].Id;
            insert listAudience;
        }
    }
    @isTest
    static void testBatch(){
        List<Account> accountList = [
            Select id,PersonContactId,Area_Dept_Name__c,Brand__c,
            CareerLevel__c,Employee_Class__c,Employee_Type__c,Employee_ID__c,
            Group__c,Location_Name__c,Region__c,OpsSupport__c
            From Account
        ];
        List<DistributionList__c> listDL = [
            Select Active__c,Area__c,Brand__c,CareerLevel__c,Description__c,
            EmployeeGroup__c,EmployeeSubgroup__c,Group__c,Location__c,
            Region__c,Country__c,OpsSupport__c,IsLineManager__c,HasDOA__c
            From DistributionList__c
        ];
        list<Communication__c> listCom = [
            Select AssigneeEmployeeId__c,TaskTitle__c,TaskDueDate__c,
            OriginatingSystem__c,SystemToAction__c,TaskDescription__c,
            ActionURL__c,Campaign__r.Parent.CampaignCode__c
            From Communication__c
        ];
        List<Audience__c> listAudience = [
            Select Id,Communication__c,Contact__c,Contact__r.AccountId,
            DistributionList__c
            From Audience__c
        ];
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        System.assert(accountList[0].PersonContactId == listAudience[0].Contact__r.Id);
        Test.startTest();
        CreateUtlAudienceBatch.executeBatchMethod
            (new List<String>{listCam[0].Id+':'+listCom[0].Id+':200'});
        Test.stopTest();
    }
}