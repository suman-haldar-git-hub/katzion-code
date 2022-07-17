/**
* @author : Daksh Madan
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
UniversalTaskListDomain class.
*/
@isTest(SeeAllData=false)
public class UniversalTaskListDomainTest {
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        Id loggedInUserId = UserInfo.getUserId();
        //create UniversalTaskList__c records
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
            
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        insert taskList;
       
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
            
        List<UniversalTaskList__c> taskList2 =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskList2[0].RecordTypeId = taskRecordTypeId;
        taskList2[0].Status__c = '3';
        insert taskList2;
        
        List<UniversalTaskList__c> taskList3 =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        taskList3[0].RecordTypeId = taskRecordTypeId;
        taskList3[0].Status__c = 'Unsubmitted';
        taskList3[0].OriginatingSystem__c = 'Expense8';
        taskList3[0].Expense8Id__c = 'Expense8';
        taskList3[0].SecondarySourceId__c = 'gygdj92e9u3';
        insert taskList3;
    }
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : Test all method
*/
    @isTest
    static void testAllMethods() {
        list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c
            From UniversalTaskList__c
        ];
        Map<String, String> paramsMap = new Map<String, String>();
        paramsMap.put('initialRows','0');
        paramsMap.put('filterType','Archive');
        paramsMap.put('columnSorting','');
        System.assertNotEquals(
            null,
            UniversalTaskListDomain.getLoggedInUserTask(paramsMap,new Set<String>{'Completed'})
        );
        System.assertEquals(
            1,
            UniversalTaskListDomain.getTotalCountOfTask(new Set<String>{'Approved'})
        );
        System.assertEquals(
            3,
            UniversalTaskListDomain.getAllTaskForLoggedInUser().size()
        );
        String jsonStr ='{'+
            '"rowLimit" : 0,'+
            '"rowOffset" : 0,'+
            '"sortingData" : ""'+
            '}';
            /*
        UniversalTaskListDomain.getNextTaskUsingOffset(
                jsonStr,
                new Set<String>{'Pending'},
                'My Task'
            );
        System.assertNotEquals(
            null,
            UniversalTaskListDomain.getNextTaskUsingOffset(
                jsonStr,
                new Set<String>{'Completed'},
                'Archive'
            );
        ); */
        UniversalTaskListDomain.taskAndApproval();
        UniversalTaskListDomain.getTaskBasedOnId(taskList[0].Id);
        UniversalTaskListDomain.getUTLRecorcdBySetOfId(new Set<Id> {taskList[0].Id});
        UniversalTaskListDomain.getTaskBasedOnEmpId(
            new List<String> {'00000'},
            new Set<String> {'Pending'},
            new Set<String> {'Task'}
        );
        UniversalTaskListDomain.getLearningTask();
        UniversalTaskListDomain.getUTLRecordFromPrimarySourceId(new Set<String> {'0999'});
        
        List<UniversalTaskList__c> taskListEx =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c,Expense8Id__c,SecondarySourceId__c 
            From UniversalTaskList__c where OriginatingSystem__c =: 'Expense8'
        ];
        System.assert(taskListEx != null);
        UniversalTaskListDomain.getUTLRecordFromExpense8Id(new Set<String>{taskListEx[0].Expense8Id__c},
                 new Set<String>());
        UniversalTaskListDomain.getUTLRecordFromSecondarySourceId(
                    new Set<String>{taskListEx [0].SecondarySourceId__c});
        
        //UniversalTaskListDomain.countLoggedInUserTask(
                            //,new Set<String>{'Approved'});
    }
}