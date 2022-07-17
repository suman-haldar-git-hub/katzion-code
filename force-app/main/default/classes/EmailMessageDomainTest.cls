/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the EmailMessageDomain class
*/
@isTest(SeeAllData=false)
public class EmailMessageDomainTest {
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                'Individual Account').getRecordTypeId();
         List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            insert accountList;
        Account accountRecd = [Select PersonContactId From Account Limit 1];
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c ='Email');
        insert u;
        
        list<Campaign> listCam = CampaignTestData.create(2);
            listCam[0].CampaignCode__c = 'SALARY SACRIFICE NOTIF';
            listCam[1].CampaignCode__c = 'CASEPORTALNOTIF';
            insert listCam;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c);
        List<Case> cases = TestUtility.createTrxCases(1,transcationCaseId);
       
        cases[0].RequesterUser__c = u.id;
        cases[0].Category__c = 'Benefits';
        cases[0].Sub_Category__c  = 'Payroll Payslips';
        cases[0].ContactId  = accountRecd.PersonContactId;
        cases[0].Origin = 'TeamHub';
        cases[0].Send_Notification__c = 'Send with comments';
        cases[0].Status = 'In Progress';
        insert cases[0];
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Subject = 'test subject';
        emailMessage.ToAddress = u.Email;
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
    * @description : This is the test method to execute emaiiMessage logic
    */
    @isTest
    static void testData(){
         List<Case> lstCase = [SELECT Id,Subject,CaseApproved__c,Send_Notification__c,
                            Closed_Case_Comments__c,OwnerId,Status,Category__c
                                 FROM Case ];
        System.assertEquals(lstCase.size() != null,true);
        
        List<User> lstUser = [Select Id,Email,UserName from User limit 1];
        System.assertEquals(lstUser.size() != null,true); 
        List<EmailMessage> lstEmailMessage = [Select TextBody,Status,CreatedDate,
                                            Subject,ToAddress,FromAddress,CcAddress,
                                            (Select Id,Name from Attachments)
                            FROM EmailMessage 
                        Where ParentId =: lstCase[0].id];
        System.assertEquals(lstEmailMessage.size() != null,true); 
        
        EmailMessageDomain.getEmailAndAttachment(lstCase[0].id,lstUser[0]);
    }
}