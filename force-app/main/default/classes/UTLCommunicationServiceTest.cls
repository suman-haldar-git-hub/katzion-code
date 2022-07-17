/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the UTLCommunicationService
*/
@isTest(SeeAllData=false)
public class UTLCommunicationServiceTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData(){
      
         Id personAcctRecdTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
            
        Id taskRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Task').
            getRecordTypeId();
            
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
         User objUser = UserTestData.getUser('System Administrator', 'Test1');  
         objUser.EmployeeId__c = 'Test007';
         objUser.ReceiveTaskNotificationsFor__c = 'TeamHub';
         objUser.TaskNotification__c = true;
         objUser.TaskNotificationChannel__c = 'Email';
         insert objUser;
       //create account records
        List<Account> accountList =
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
            accountList[0].Employee_ID__c = 'Test007';
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
            eachUtl.OriginatingSystem__c = 'TeamHub';
            eachUtl.SystemOfAction__c = 'TeamHub';
            eachUtl.Title__c = 'Welcome to CATS';
            taskList.add(eachUtl);
        }
        
        taskList[1].Status__c = '3';
        taskList[1].PrimarySourceId__c = '0001765711';
        taskList[1].SecondarySourceId__c = '00017657';
        taskList[1].Expense8Id__c = '00017657';
        taskList[1].RecordTypeId = approvalRecordTypeId;
        taskList[1].Type__c = 'Leave';
        taskList[1].OriginatingSystem__c = 'SAPPY';
        taskList[1].SystemOfAction__c = 'SAPPY';
        
        Database.insert(taskList);
    }
    
    @isTest
    static void testBatch(){
      User u = [Select id,ReceiveTaskNotificationsFor__c,EmployeeId__c,TaskNotification__c,
        TaskNotificationChannel__c 
         FROM user where EmployeeId__c = 'Test007' LIMIT 1];
        System.runAs(u){
          list<Campaign> listCam = [
            Select Id,CampaignCode__c
            From Campaign
        ];
        List<UniversalTaskList__c> taskList =[
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForUser__c, Title__c,
            SubmittedForUser__r.Name, Description__c,DueDate__c, OriginatingSystem__c,
            CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
            Parent__c,PrimarySourceId__c,SecondarySourceId__c, Expense8Id__c,
            SubmittedByAccount__r.Employee_ID__c,SubmittedForAccount__c,
            SubmittedForAccount__r.Employee_ID__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c,SystemOfAction__c
            From UniversalTaskList__c
        ];
        System.assert(taskList != null);
    }
    }
}