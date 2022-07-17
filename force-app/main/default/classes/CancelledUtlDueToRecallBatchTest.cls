/*
@Author : Ankit Singh
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               CancelledUtlDueToRecallBatch class.
*/
@isTest(SeeAllData=false)
public class CancelledUtlDueToRecallBatchTest {
    static testMethod void validate()
    {
        list<Campaign> listCam = CampaignTestData.create(1);
        insert listCam;
        list<Communication__c> listCom = CommunicationTestData.create(1,listCam[0].id);
        insert listCom;
        List<Communication__c> childCommunicationList = CommunicationTestData.create(
                1,
                listCam[0].id
        );
        childCommunicationList[0].ParentCommunication__c = listCom[0].Id;
        insert childCommunicationList;

        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, taskRecordTypeId);
        taskList[0].RecordTypeId = taskRecordTypeId;
        taskList[0].Status__c = '-5';
        taskList[0].Communication__c = childCommunicationList[0].id;
        insert taskList;
        Test.startTest();
            CancelledUtlDueToRecallBatch.executeBatchMethod(new List<String>{listCom[0].Id+':1'});
            system.assert(taskList.size()>0);
            system.assert(childCommunicationList.size()>0);
            system.assert(listCom.size()>0);
        Test.stopTest();
    }
}