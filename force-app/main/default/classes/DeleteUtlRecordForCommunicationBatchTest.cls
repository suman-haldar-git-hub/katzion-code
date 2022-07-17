/*
@Author : Amit Sharma
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               DeleteUtlRecordForCommunicationBatch class.
*/
@isTest(SeeAllData=false)
public class DeleteUtlRecordForCommunicationBatchTest {
    static testMethod void validate()
    {
        
        list<Campaign> listCam = CampaignTestData.create(1);
        insert listCam;
        list<Communication__c> listCom = CommunicationTestData.create(1,listCam[0].id);
        insert listCom;
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
        //create CampaignMember records
        List<CampaignMember> campaignMemberList = 
        CampaignMemberTestData.createCampaignMemberRecords(1,listCam[0].Id,accountRecd.PersonContactId);
        Insert campaignMemberList;
        //create UniversalTaskList__c records
        Id approvalRecordTypeId =Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').getRecordTypeId();
        List<UniversalTaskList__c> taskList = UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskList[0].Communication__c = listCom[0].id;
        insert taskList;
        
        
        Test.startTest();
            DeleteUtlRecordForCommunicationBatch objBatchClass = new DeleteUtlRecordForCommunicationBatch(new Set<Id>{listCom[0].id},listCam[0].id);
            database.executeBatch(objBatchClass);
            system.assert(listCam.size()>0);
            system.assert(listCom.size()>0);
            system.assert(accountList.size()>0);
        Test.stopTest();
        
    }
}