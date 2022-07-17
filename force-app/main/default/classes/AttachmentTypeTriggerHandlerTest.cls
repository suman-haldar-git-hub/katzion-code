@isTest
public class AttachmentTypeTriggerHandlerTest {
    @testSetup static void setup() {
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        
        //Insert test case record
        Case tempCase1 = new Case();
        tempCase1.Web_On_Behalf_Of_First_Name__c = 'Test';
        tempCase1.Web_On_Behalf_Of_Last_Name__c = 'lastname';
        tempCase1.Web_On_Behalf_Of_Employee_Id__c = '123456';
        tempCase1.Web_Employee_Id__c = '1234567';
        tempCase1.SuppliedName = 'Aaron Smith1';
        tempCase1.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase1.Subject = 'Testing - Util';
        tempCase1.Description = 'Testing - Description';
        tempCase1.RecordTypeID = caseRec.Transaction_Case__c;//'012280000008xsSAAQ';
        tempCase1.Preferred_Contact_Method__c = 'Phone';//sekarchg
        tempCase1.Preferred_Phone__c = '0401010101';//sekarchg
        tempCase1.New_People_Query_or_Process_Request__c = 'Yes';//sekarchg
        tempCase1.suppliedemail='test@woolworths.com.au';
        
        try {
            insert tempCase1;
        } catch (Exception e) {
            system.debug('************* trying to insert case -'  + e + '****************');
        }
        
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = tempCase1.Id; 
        insert email;
        
        Attachment testAtt1 = new Attachment();
        testAtt1.name = 'Test1.csv';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        testAtt1.body=bodyBlob1;
        testAtt1.ParentId= email.Id;
        insert testAtt1;        
    }
    @isTest static void testMethod1() {
        
    }    
}