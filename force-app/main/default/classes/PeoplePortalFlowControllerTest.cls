/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the PeoplePortalFlowController class
*/
@isTest(SeeAllData=false)
public class PeoplePortalFlowControllerTest {
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
     //create account records
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                'Individual Account').getRecordTypeId();
         List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
            
         list<Campaign> listCam = CampaignTestData.create(2);
            listCam[0].CampaignCode__c = 'SALARY SACRIFICE NOTIF';
            listCam[1].CampaignCode__c = 'CASEPORTALNOTIF';
            insert listCam;
                    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c = 'Email');
        insert u;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(1,transcationCaseId);
       
        
        cases[0].RequesterUser__c = u.id;
        cases[0].Category__c = 'Benefits';
        cases[0].Sub_Category__c  = 'Payroll Payslips';
        cases[0].ContactId  = accountRecd.PersonContactId;
        cases[0].Origin = 'TeamHub';
        cases[0].Send_Notification__c = 'Send with comments';
        cases[0].Closed_Case_Comments__c = 'test close comment';
        cases[0].Status = 'In Progress';
        insert cases[0];
        
        Form__c objForm = new Form__c();
        objForm.CaseCategory__c = 'Benefits';
        objForm.ApplicationDetailIcon__c = 'benefits-appdetail.svg';
        objForm.Name = 'Benefits';
        objForm.Active__c = true;
        insert objForm;
        
        User objUser = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Subject = 'test subject';
        emailMessage.ToAddress = objUser.Email;
        emailMessage.ParentId = cases[0].id;
        insert emailMessage;
        
        Attachment att = new Attachment();
        att.Name = 'sample.pdf';
        att.ParentId = emailMessage.id;
        att.Body = Blob.ValueOf('test attachment body');
        insert att;
        
    }
    
     /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to executecase in progress logic
    */
    @isTest
    static void testData(){
               
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c,Send_Notification__c,
                            Closed_Case_Comments__c,OwnerId,Status,Category__c,Owner.Name
                                 FROM Case ];
        System.assertEquals(lstCase.size() != null,true);
        
        List<Form__c> lstForm = [Select Id,CaseCategory__c,
                ApplicationDetailIcon__c
             FROM Form__c];
        System.assertEquals(lstForm.size() != null,true);  
        
        List<EmailMessage> lstEmailMessage = [Select TextBody,Status,CreatedDate,
                                            Subject,ToAddress,FromAddress,CcAddress,
                                            (Select Id,Name from Attachments)
                            FROM EmailMessage 
                        Where ParentId =: lstCase[0].id];
        System.assertEquals(lstEmailMessage.size() != null,true); 
           
        
        PeoplePortalFlowController.getContentFromMetadata(lstCase[0]);
        PeoplePortalFlowController.insertCaseComment(lstCase[0].id,'test comment');
        PeoplePortalFlowController.getCaseAndFormWrapper(lstCase[0].id);
        PeoplePortalFlowController.createFinalWrapperData(lstCase[0].id);
        
    }
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute case closed logic
    */
    @isTest
    static void testData1(){
               
        List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c,Send_Notification__c,
                            Closed_Case_Comments__c,OwnerId,Status,Category__c,Owner.Name
                                 FROM Case ];
        System.assertEquals(lstCase.size() != null,true);
        
        lstCase[0].OwnerId = UserInfo.getUserId();
        lstCase[0].Status = 'Closed';
        lstCase[0].Page_View_Count__c = 4;
        lstCase[0].Preferred_Email__c = 'test@abc.com';
        lstCase[0].CSR_Reporting__c = true;
        update lstCase[0];
        
        PeoplePortalFlowController.createOtherData(lstCase[0].id);
        
    }
}