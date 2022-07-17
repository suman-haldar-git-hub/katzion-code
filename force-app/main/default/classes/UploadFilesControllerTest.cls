/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the UploadFilesController class
*/
@isTest(SeeAllData=false)
public class UploadFilesControllerTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
       
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,EmployeeID__c = '6789966',
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c ='Email');
        insert u;
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            'Individual Account').getRecordTypeId();
        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].Location_Name__c = 'Test';
        acctList[0].Employee_ID__c = '6789966';
        acctList[0].Line_Manager__c = '1234567';
        acctList[0].AribaExternalId__c = '56732hdw';
        insert acctList;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(3,transcationCaseId);
        cases[0].CaseApproved__c = 'Pending';
        
        cases[1].CaseApproved__c = 'Approved';
        
        cases[2].CaseApproved__c = 'Rejected';
        insert cases;
        
         //Creating ContentVersion
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        //Quering ContentDocument record
        List<ContentDocument> lscd = [SELECT Id, Title,LatestPublishedVersionId 
                                    FROM ContentDocument];
         //Creating ContentDocumentLink
        List<ContentDocumentLink> cdLinkList =
            ContentDocumentLinkTestData.create(1, cases[0].Id, lscd[0].Id);
        insert cdLinkList;

    }
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute the logic
    */
    @isTest
    static void testData(){
       
        List<ContentVersion> cvList = [Select ContentDocumentId from ContentVersion limit 1];
        System.assertEquals(cvList.size(), 1);
        UploadFilesController.getAllFiles(new List<String>{cvList[0].ContentDocumentId});
        UploadFilesController.getFiles(cvList[0].ContentDocumentId);
        List<Case> cases = [Select Id,CaseApproved__c  from Case limit 3];
        System.assertEquals(cases.size(), 3);
        UploadFilesController.getFilesData(cases[0].Id);
        UploadFilesController.getFilesDataCurrentUser(cases[0].Id);
        UploadFilesController.getContentFromMetadata(cases[0].CaseApproved__c);
        UploadFilesController.getContentFromMetadata(cases[1].CaseApproved__c);
        UploadFilesController.getContentFromMetadata(cases[2].CaseApproved__c);
        
        List<User> lstUser = [Select Id,EmployeeID__c from User limit 1];
        System.assertEquals(lstUser != null, true);
         List<Account> lstAcc = [Select Id,Employee_ID__c from Account limit 1];
         System.assertEquals(lstAcc != null, true);
        system.runAs(lstUser[0]){
            UploadFilesController.isSubmitNewApplicationVisible();
        }
        
        
        
    }
}