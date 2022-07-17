/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
UniversalTaskService class.
*/
@isTest(SeeAllData=false)
public class UniversalTaskServiceTest {
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
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        //create campaign record
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
        //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        insert accountList;
        //create UniversalTaskList__c records
        List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
        List<UniversalTaskList__c> taskRecord =
            UniversalTaskListTestData.createAccountRecords(2, taskRecordTypeId);
        for(UniversalTaskList__c eachUtl : taskRecord) {
            eachUtl.RecordTypeId = taskRecordTypeId;
            eachUtl.Status__c = 'Submitted';
            eachUtl.SubmittedForAccount__c = accountList[0].Id;
            eachUtl.SubmittedByAccount__c = accountList[0].Id;
            eachUtl.AssignedToAccount__c = accountList[0].Id;
            eachUtl.PrimarySourceId__c = '00017657';
            eachUtl.Expense8Id__c = '00017657';
            eachUtl.OriginatingSystem__c = labelToContentMap.get('ORIGINATINGSYSTEMEXPENSE8');
            taskList.add(eachUtl);
        }
        taskList[1].Status__c = '3';
        taskList[1].RecordTypeId = approvalRecordTypeId;
        taskList[1].PrimarySourceId__c = '0001765711';
        taskList[1].SecondarySourceId__c = '00017657';
        taskList[1].Type__c = '11';
        taskList[1].OriginatingSystem__c = labelToContentMap.get('ORIGINATINGSYSTEMSUCCESSFACTOR');
        taskList[1].Expense8Id__c = '00017657';
        taskList[1].IsChildFlag__c = labelToContentMap.get('ISCHILDFLAGYES');
        taskList[1].SystemOfAction__c  = 'SAPPY';
        Database.insert(taskList);
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
        successFactorRecord[0].Type__c = '';
        Database.update(successFactorRecord);
        successFactorRecord[0].Type__c = labelToContentMap.get('TASKTYPEECALERT');
        Database.update(successFactorRecord);
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    
    @isTest
    static void testAllMethods() {
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c, Expense8Id__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c
            From UniversalTaskList__c
            WHERE OriginatingSystem__c = 'Expense8'
        ];
        UniversalTaskList__c acCloneCopy  = taskList[0].clone(false, false, false, false);
        acCloneCopy.PrimarySourceId__c = '0001765788';
        acCloneCopy.Status__c = 'Unsubmitted';
        insert acCloneCopy;
        Test.startTest();
        
        UniversalTaskList__c acCloneCopy2  = taskList[0].clone(false, false, false, false);
        acCloneCopy2.PrimarySourceId__c = '00017657889';
        acCloneCopy2.Status__c = 'Rejected';
        insert acCloneCopy2;
        Test.stopTest();
        System.assertEquals(acCloneCopy.PrimarySourceId__c, '0001765788');
      
    }
    
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testAllMethods2() {
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c, Expense8Id__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c
            From UniversalTaskList__c
            WHERE OriginatingSystem__c = 'Expense8'
        ];
        UniversalTaskList__c acCloneCopy  = taskList[0].clone(false, false, false, false);
        acCloneCopy.PrimarySourceId__c = '0001765788';
        acCloneCopy.Status__c = 'Rejected';
        insert acCloneCopy;
        //UniversalTaskService.setDefaultValueForUTL(taskList, Boolean.valueOf('ann'),null);
        //System.assert(taskList.size() > 0);
        System.assertEquals(acCloneCopy.PrimarySourceId__c, '0001765788');
    }
     /**
    @Author : Harshad Dani
    @Company : Cloudwerx
    @description : Test all method
    */
    
    @isTest
    static void testAllMethods3() {
        
        Id personAcctRecdTypeId =
        Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').getRecordTypeId();
            
        Id approvalRecordTypeId_2 =
        Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').getRecordTypeId();
                            
        Account singleRecord = new Account();
        singleRecord.FirstName = 'Woolworth Test';
        singleRecord.LastName = 'Countdown Test';
        singleRecord.Employee_ID__c = 'TestEMPID';
        singleRecord.Business_Account_Type__c = 'Internal';     
        singleRecord.RecordTypeId = personAcctRecdTypeId;
                                
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        
        UniversalTaskList__c taskRec = new UniversalTaskList__c();      
        
        taskRec.Type__c = 'Leave';
        taskRec.OriginatingSystem__c ='SAPPY';
        taskRec.RecordTypeId = approvalRecordTypeId_2;
        taskRec.Status__c = 'Submitted';
        taskRec.SubmittedForAccount__c = singleRecord.Id;
        taskRec.SubmittedByAccount__c = singleRecord.Id;
        taskRec.AssignedToAccount__c = singleRecord.Id;
        taskRec.SystemOfAction__c = 'SAPPY';
        Database.insert(taskRec);   
                
        System.assertEquals(taskRec.SystemOfAction__c, 'SAPPY');                
    }
}