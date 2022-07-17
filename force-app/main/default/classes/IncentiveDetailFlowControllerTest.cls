/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the IncentiveDetailFlowController class
*/
@isTest(SeeAllData=false)
public class IncentiveDetailFlowControllerTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
       
        List<Form__c> formData = FormTestData.getForm(1, false);
        formData[0].CaseCategory__c='Pay and the Basics';
        formData[0].ActionCentreIcon__c='test.svg';
        formData[0].FormTab__c='MyIncentive';
        formData[0].FormType__c='SalarySacrifice';
        formData[0].EndDate__c = system.today()+30;
        insert formData;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(2,transcationCaseId);
        cases[0].CaseApproved__c = 'Pending';
        insert cases[0];
        
        cases[1].CaseApproved__c = 'Approved';
        insert cases[1];

    }
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute the logic
    */
    @isTest
    static void testData(){
        List<Form__c> lstForm = [Select Id,CaseCategory__c,FormTab__c,FormType__c,
                                      EndDate__c from Form__c limit 1];
        System.assertEquals(lstForm.size() != null,true);
        
        List<Case> lstCasePending = [SELECT Id,Subject,CaseApproved__c 
                                            FROM Case where CaseApproved__c =: 'Pending'];
        System.assertEquals(lstCasePending.size() != null,true);
        
        IncentiveDetailFlowController.getContentFromMetadata(
                                                    lstCasePending[0].CaseApproved__c,true);
        IncentiveDetailFlowController.getContentFromMetadata(
                                                    lstCasePending[0].CaseApproved__c,false);
        
        List<Case> lstCaseApproved = [SELECT Id,Subject,CaseApproved__c 
                                            FROM Case where CaseApproved__c =: 'Approved'];
        System.assertEquals(lstCaseApproved.size() != null,true);
        
        IncentiveDetailFlowController.getContentFromMetadata(
                                                    lstCaseApproved[0].CaseApproved__c,false);
        IncentiveDetailFlowController.getDayOfMonthSuffix(1);
        IncentiveDetailFlowController.getDayOfMonthSuffix(2);
        IncentiveDetailFlowController.getDayOfMonthSuffix(3);
        
    }
}