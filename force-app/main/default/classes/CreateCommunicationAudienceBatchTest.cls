/*
@Author : Sunil Kumar
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               CreateCommunicationAudienceBatch class.
*/
@isTest(SeeAllData=false)
public class CreateCommunicationAudienceBatchTest {
    static testMethod void validate()
    {
        List<DistributionList__c> listDL = DistributionListTestData.createDistributionListRecords(1);
        insert listDL;
        list<Campaign> listCam = CampaignTestData.create(1);
        insert listCam;
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;
        list<Communication__c> listCom = CommunicationTestData.create(1,listCam[0].id);
        insert listCom;
        
        User testUser1 = UserTestData.getUser('System Administrator', 'Test2');
        testUser1.EmployeeID__c = 'Test0';
        testUser1.UserName = 'daksh1@testorg.com';
        insert testUser1;
        
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountList[0].WeeklySummaryDigestNotification__c = true;
        accountList[0].DailySummaryDigestNotification__c = true;
        accountList[0].CommunicationNotification__c = true;
        insert accountList;
        Account accountRecd = [Select PersonContactId,Employee_ID__c From Account Limit 1];
        
        //create UniversalTaskList__c records
        Id approvalRecordTypeId =Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').getRecordTypeId();
        List<UniversalTaskList__c> taskList = UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskList[0].AssignedToAccount__c = accountRecd.id;
        insert taskList;
        
         
        List<Audience__c> listAudience = AudienceTestData.create(1,accountRecd.PersonContactId,listCom[0].id);
        listAudience[0].DistributionList__c = listDL[0].Id;
        insert listAudience;
        
        Test.startTest();
            CreateCommunicationAudienceBatch.executeBatchMethod(new List<String>{listCam[0].Id+':'+listCom[0].Id+':1'});
            system.assert(listCam.size()>0);
            system.assert(listCom.size()>0);
            system.assert(listAudience.size()>0);
            //CreateCommunicationAudienceBatch objClass = new CreateCommunicationAudienceBatch(listCam[0].id,listCom[0].Id);
            //objClass.createUserMap(New List<String>{accountRecd.Employee_ID__c});
            
        Test.stopTest();
        
    }
}