/*
@Author : Ankit Singh
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               AutoCompleteECAlertCategoryUTL class.
*/
@isTest(SeeAllData=false)
public class AutoCompleteECAlertCategoryUTLTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id personAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        insert accountList;
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
        List<UniversalTaskList__c> successFactorRecord =
            UniversalTaskListTestData.createAccountRecords(1, taskRecordTypeId);
        successFactorRecord[0].Type__c = labelToContentMap.get('TASKTYPEECALERT');
        successFactorRecord[0].OriginatingSystem__c =
            labelToContentMap.get('ORIGINATINGSYSTEMSUCCESSFACTOR');
        successFactorRecord[0].RecordTypeId = taskRecordTypeId;
        successFactorRecord[0].Status__c = labelToContentMap.get('SUBMITTEDSTATUS');
        successFactorRecord[0].SubmittedForAccount__c = accountList[0].Id;
        successFactorRecord[0].SubmittedByAccount__c = accountList[0].Id;
        successFactorRecord[0].AssignedToAccount__c = accountList[0].Id;
        Database.insert(successFactorRecord);
        successFactorRecord[0].ExpiryDate__c = System.TODAY();
        Database.update(successFactorRecord);
    }
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    static testMethod void validate(){
        AutoCompleteECAlertCategoryUTL objUtl = new AutoCompleteECAlertCategoryUTL();       
        Test.startTest();
            Database.executeBatch(objUtl,100);
            system.assert(objUtl != null);
            String sch = '20 30 8 10 2 ?';
            String jobID = System.schedule(
                'Auto Complete EC AlertCategory UTL', sch, objUtl
            );
        Test.stopTest();
    }
}