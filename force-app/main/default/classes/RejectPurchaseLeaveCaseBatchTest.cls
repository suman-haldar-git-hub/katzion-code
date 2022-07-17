/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This test class will cover the RejectPurchaseLeaveCaseBatch class
*/
@isTest(SeeAllData=false)
public class RejectPurchaseLeaveCaseBatchTest {
	/**
    * @author : Praveen Tiwari
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData(){
        //create account records
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                'Individual Account').getRecordTypeId();
         List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            insert accountList;
        Account accountRecd = [Select Id From Account Limit 1];
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        String payrollServiceDeliveryQueueId =
                GroupDomain.getGroupId(
                FeatureControlDomain.getFeatureControlRecord('PAYROLLSERVICEDELIVERYQUEUE').Content__c);
        Id approvalRecordTypeId =
            Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').
            getRecordTypeId();
        list<Campaign> listCam = CampaignTestData.create(1);
            listCam[0].CampaignCode__c = 'UTL NOTIF';
            insert listCam;
            
        List<UniversalTaskList__c> taskList =
            UniversalTaskListTestData.createAccountRecords(1, approvalRecordTypeId);
        insert taskList;
        // create Query Case type of cases
        Id queryCaseId= Id.valueOf(caseRec.Query_Case__c);
        List<Case> cases = CaseTestData.getCaseData(accountRecd.Id, 20,false);
        for(integer i=0; i<cases.size(); i++){
            cases[i].RecordTypeId = queryCaseId;
            cases[i].Category__c = 'Pay and the Basics';
            cases[i].Sub_Category__c  = 'Leave Forms';
            cases[i].Origin = 'TeamHub';
            cases[i].OwnerId = payrollServiceDeliveryQueueId;
            cases[i].TaskAndApproval__c = taskList[0].Id;
        }
        insert cases;
    }
    /**
    @Author : Praveen Tiwari
    @Company : SaasFocus A Cognizant Company
    @description : Test RejectPurchaseLeaveCaseBatch method
    */
    @isTest
    static void testPLCaseRejectionBatch(){
        test.startTest();
        RejectPurchaseLeaveCaseBatch obj = new RejectPurchaseLeaveCaseBatch();
        Database.executeBatch(obj);
        List<Case> caseLst = [Select Id,CaseApproved__c,Status From Case];
        
            String jobID = System.schedule(
                        'RejectPurchaseLeaveCaseBatch',
                        '0 0 0 1 7 ?',
                        new RejectPurchaseLeaveCaseBatch()
                );
        	System.assert(!caseLst.isEmpty());
        test.stopTest();
    }
}