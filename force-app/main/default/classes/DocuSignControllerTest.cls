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
public class DocuSignControllerTest {
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
        
        
        DocuSign_Deleted_Files__c deletedFile=new DocuSign_Deleted_Files__c();
    	deletedFile.Case__c =case1.Id;
    	deletedFile.Status__c='SoftDelete';
    	deletedFile.Title__c='Test File';
    	deletedFile.ContentDocumentID__c	= documents[0].Id;
    	Insert deletedFile;
		
    }
    
    /**
    * @description Testing getDeletedFileList method
    */
    @isTest
    public static void getDeletedFileListTest()
    {
        Case caseId=[Select Id From Case where Subject='Testing - DocuSign'];
        List<DocuSignController.FileList> fslist=DocuSignController.GetDeletedFileList(caseId.Id);
        Integer recCount=fslist.size();
        System.assertEquals(1, recCount);
    }
    
    /**
    * @description Testing GetFileList method
    */
    @isTest
    public static void getFileListTest()
    {
        Case caseId=[Select Id From Case where Subject='Testing - DocuSign'];
        List<DocuSignController.FileList> fslist=DocuSignController.GetFileList(caseId.Id);
        Integer recCount=fslist.size();
        System.assertEquals(1, recCount);
    }

    /**
    * @description Testing CreateRequest method
    */
    @isTest
    public static void createRequestTest()
    {
        Case caseId=[Select Id From Case where Subject='Testing - DocuSign'];
        List<DocuSignController.FileList> fslist=DocuSignController.GetFileList(caseId.Id);
        String filelist=fslist[0].FileId;
        string response=DocuSignController.CreateRequest(caseId.Id,filelist);
        if(response != null)
        {
            System.assert(true);
        }
    }
}