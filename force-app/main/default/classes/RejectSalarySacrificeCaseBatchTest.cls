/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This test class will cover the RejectSalarySacrificeCaseBatch class
*/
@isTest(SeeAllData=false)
public class RejectSalarySacrificeCaseBatchTest {
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
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = CaseTestData.getCaseData(accountRecd.Id, 50,false);
        for(integer i=0; i<cases.size(); i++){
            cases[i].CaseApproved__c = 'Pending';
            cases[i].RecordTypeId = transcationCaseId;
            cases[i].Category__c = 'Pay and the Basics';
            cases[i].Sub_Category__c  = 'Salary Sacrifice';
            cases[i].Origin = 'TeamHub';
            cases[i].OwnerId = payrollServiceDeliveryQueueId;
        }
        insert cases;
    }
    /**
    @Author : Praveen Tiwari
    @Company : SaasFocus A Cognizant Company
    @description : Test RejectSalarySacrificeCaseBatch method
    */
    @isTest
    static void testSSRejectionBatch(){
        RejectSalarySacrificeCaseBatch obj = new RejectSalarySacrificeCaseBatch();
        Database.executeBatch(obj);
        List<Case> caseLst = [Select Id,CaseApproved__c,Status From Case];
        test.startTest();
            String jobID = System.schedule(
                        'RejectSalarySacrificeCaseBatch',
                        '0 0 0 1 4 ?',
                        new RejectSalarySacrificeCaseBatch()
                );
        	System.assert(!caseLst.isEmpty());
        test.stopTest();
    }
}