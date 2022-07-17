/**
* @Author		:		Suman Nandy
* @Date		:			03-Dec-2020
* @Desc		:			This class will be used by DocuSign LWC Component
						Test Class Name : DocuSignControllerTest
* */

/**
* @description DocuSignControllerTest : Test class for DocuSignController
*/
@isTest
public class DocuSignTriggerHelperTest {
    /**
    * @description Setting up test data
    */
    @testSetup 
    public static void setup() {
        String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PA ER Case').getRecordTypeId();
		String accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Account').getRecordTypeId();

        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        
		Account acc=new Account();
		acc.FirstName='Suman';
		acc.LastName='Nandy';
		acc.PersonEmail ='snandy@tcs.woolworths.com.au';
		insert acc;

		system.debug('acc'+acc);
		Case case1=new Case();
		case1.AccountId =acc.Id;
		case1.Subject = 'Testing - DocuSign';
		case1.Description = 'Testing - Description';
		case1.Origin = 'Email';
		case1.RecordTypeID = caseRecordTypeId;
		case1.Category__c='Salaried Pay Review';
		case1.Sub_Category__c='Feedback';
		case1.Preferred_Contact_Method__c = 'Email';//sekarchg
        Insert case1;
		system.debug('Case'+case1);  
        
 		Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=case1.Id;
		contentlink.ShareType= 'V';
		//contentlink.LinkedEntityId = case1.Id; 
		contentlink.ContentDocumentId=documents[0].Id;
		contentlink.Visibility = 'AllUsers'; 
        System.debug('contentlink'+contentlink);
		insert contentlink;
        
        dsfs__DocuSign_Envelope__c env=new dsfs__DocuSign_Envelope__c();
        Insert env;
        env.dsfs__DocuSign_Envelope_ID__c = env.Id;
        update env;
            
        System.debug('HelperTest env'+env);
        dsfs__DocuSign_Envelope_Document__c envdoc=new dsfs__DocuSign_Envelope_Document__c();
        envdoc.dsfs__External_Document_Id__c=cv.Id;
        envdoc.dsfs__SFDocument_Type__c='Content';
        envdoc.dsfs__DocuSign_EnvelopeID__c=env.Id;
        Insert envdoc;
        System.debug('HelperTest dsfs__DocuSign_Envelope_Document__c'+envdoc);
      
        
        dsfs__DocuSign_Status__c envStatus=new dsfs__DocuSign_Status__c();
        envStatus.dsfs__Envelope_Status__c='Sent';
        envStatus.dsfs__DocuSign_Envelope_ID__c= env.Id;
        envStatus.dsfs__Case__c =case1.Id;
        Insert envStatus;
        
        
     
		
    }
    
    /**
    * @description Testing The Batch Class
    */
    @isTest
    public static void test1() {
        test.startTest();
            List<dsfs__DocuSign_Status__c> lstDocStatus=[SELECT dsfs__Envelope_Status__c,dsfs__DocuSign_Envelope_ID__c FROM dsfs__DocuSign_Status__c];
            lstDocStatus[0].dsfs__Envelope_Status__c='Completed';
            update lstDocStatus;
        test.stopTest();

        List<DocuSign_Deleted_Files__c> deletedFiles = [SELECT Id, Status__c
                                                        FROM DocuSign_Deleted_Files__c
                                                        WHERE Status__c = 'SoftDelete' ];

        System.assert(deletedFiles.size() > 0);
    }
}