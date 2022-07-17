/**
* @Author		:		Suman Nandy
* @Date		:			03-Dec-2020
* @Desc		:			This class willbe used to test the DocuSignDeleteFileBatch Class
* */

/**
* @description DocuSignDeleteFileBatchTest : Test class for DocuSignController
*/
@istest
public class DocuSignDeleteFileBatchTest {
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
        cv.title = 'test Batch Class1';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;  
        
        ContentVersion cv2 = new ContentVersion();
        cv2.title = 'test Batch Class2';      
        cv2.PathOnClient ='test';           
        cv2.VersionData =beforeblob;          
        insert cv2;  

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

		ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.LinkedEntityId=case1.Id;
		contentlink.ShareType= 'V';
		//contentlink.LinkedEntityId = case1.Id; 
		contentlink.ContentDocumentId=documents[0].Id;
		contentlink.Visibility = 'AllUsers'; 
        System.debug('contentlink'+contentlink);
		insert contentlink;
        
        
        DocuSign_Deleted_Files__c deletedFile2=new DocuSign_Deleted_Files__c();
    	deletedFile2.Case__c =case1.Id;
    	deletedFile2.Status__c='SoftDelete';
    	deletedFile2.Title__c='Test File';
    	deletedFile2.ContentDocumentID__c	= documents[0].Id;
    	Insert deletedFile2;
        
        DocuSign_Deleted_Files__c deletedFile=new DocuSign_Deleted_Files__c();
    	deletedFile.Case__c =case1.Id;
    	deletedFile.Status__c='SoftDelete';
    	deletedFile.Title__c='Test File';
    	deletedFile.ContentDocumentID__c	= documents[1].Id;
    	Insert deletedFile;
        
        
        
    }
    
	/**
    * @description Testing The Batch Class
    */
    @istest
    public static void testBatch() {
        List<DocuSign_Deleted_Files__c> deletedFile2=[SELECT ID FROM DocuSign_Deleted_Files__c];
        Date todayDate=Date.today();
        Date deletedate=todayDate.addDays(-10);
		Test.setCreatedDate(deletedFile2[0].Id, deletedate); 
        Test.setCreatedDate(deletedFile2[1].Id, deletedate); 
        Test.startTest();
       	DocuSignDeleteFileBatch docuSignBat=new DocuSignDeleteFileBatch();
       	Id batchJobId = Database.executeBatch(docuSignBat);
		System.assert(batchJobId != null);
       	Test.stopTest();
    }
}