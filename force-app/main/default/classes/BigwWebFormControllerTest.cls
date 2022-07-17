/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for "BigwWebFormController" class...
 */
@isTest
public class BigwWebFormControllerTest {
    @testSetup
    static void makeData(){
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123456';
        insert accountTest;

        Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();
        caseRecTypeCS.Transaction_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.WOW_NZ_ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.Query_Case__c = String.valueOf(caseRecTypeId);
        insert caseRecTypeCS;

        List<Case> caseTest = CaseTestData.getCaseData(
            accountTest[0].Id,
            1,
            false
        );
        caseTest[0].recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        caseTest[0].ownerID = Label.Case_Owner_Id;
        insert caseTest;

        List<Object_Field__c> subCategoryData = ObjectFieldTestData.getObjectFieldData(
            'Sub Category',
            1,
            true
        );

        List<Object_Field__c> categoryData = ObjectFieldTestData.getObjectFieldData(
            'Category',
            1,
            true
        );

        List<Object_Field__c> attachmentData = ObjectFieldTestData.getObjectFieldData(
            'AttachmentType',
            1,
            true
        );

        List<Picklist_Field_Value__c> pfvCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            categoryData[0].Id,
            1,
            true
        );

        List<Picklist_Field_Value__c> pfvSubCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            subCategoryData[0].Id,
            1,
            true
        );

        List<Picklist_Field_Value__c> pfvAttachmentInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            attachmentData[0].Id,
            1,
            true
        );
        ////this creates only 1 test record...
        List<Related_Value__c> categoryRelatedData = RelatedValueTestData.getRelatedValueData(
            pfvSubCategoryInstance[0].Id,
            pfvCategoryInstance[0].Id,
            true
        );

    }
    @isTest
    static void getAllPicklistDataTest(){
        test.startTest();
        string jsonResp = BigwWebFormController.getAllPicklistData();
        test.stopTest();
        system.assertEquals(jsonResp!='', true);
    }
    @isTest
    static void saveCaseDetailsTest(){
        test.startTest();
        Picklist_Field_Value__c pfvTest = [SELECT Id,Web_Display__c,Big_W_Web_Display__c,Picklist_Field_Value__c,
                                            Big_W_Record_Type__c
                                            FROM Picklist_Field_Value__c
                                            WHERE Object_Field__r.Field_Name__c='Category'
                                            LIMIT 1];
                                            system.debug('test claaaaaaaa'+pfvTest);
        pfvTest.Web_Display__c = true;
        pfvTest.Big_W_Web_Display__c = true;
        pfvTest.Picklist_Field_Value__c = 'Pay and the Basics';
        pfvTest.Big_W_Record_Type__c = 'Big_W_Case';
        update pfvTest;
        
        Case objCase = new Case();
        objCase.Web_On_Behalf_Of_Employee_Id__c = '123456';
        objCase.Category__c = 'Pay and the Basics';
        objCase.Sub_Category__c = 'WOW People Discount Card';
        LightningResponse resp = BigwWebFormController.saveCaseDetails(objCase);

        pfvTest.Big_W_Record_Type__c = 'PS_Query_Case';
        update pfvTest;

        Case objCase1 = new Case();
        objCase1.Web_On_Behalf_Of_Employee_Id__c = '';
        objCase1.Sub_Category__c = '';
        objCase1.Category__c = 'Pay and the Basics';
        LightningResponse resp1 = BigwWebFormController.saveCaseDetails(objCase1);

        Case objCase2 = new Case();
        objCase2.Category__c = 'Pay and the Basics';
        objCase2.Sub_Category__c = 'Salary Sacrifice Forms';
        LightningResponse resp2 = BigwWebFormController.saveCaseDetails(objCase2);

        LightningResponse resp3 = BigwWebFormController.saveCaseDetails(null);
        LightningResponse resp4 = BigwWebFormController.saveCaseDetails(new Case());
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
    @isTest
    static void getAllPicklistDataForAttachmentTest(){
        test.startTest();
        String jsonStr = BigwWebFormController.getAllPicklistDataForAttachment();
        test.stopTest();
        system.assertEquals(jsonStr!='', true);
    }
    @isTest
    static void deleteDocumentsTest(){
        ContentVersion contentVersion = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = [SELECT Id FROM Case][0].id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        test.startTest();
        LightningResponse resp = BigwWebFormController.deleteDocuments(new List<String>{documents[0].Id});
        LightningResponse resp1 = BigwWebFormController.deleteDocuments(null);
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
    @isTest
    static void linkDocWithCaseTest(){
        Case caseTest = [SELECT Id FROM Case LIMIT 1];
        ContentVersion contentVersion = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = [SELECT Id FROM User][0].id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        String str = '[{"name":"salesforce_certified_platform_developer_1.jpg","documentId":"0691s000000H66jAAC"}]';
		String isSecured = 'true';
        test.startTest();
        LightningResponse resp = BigwWebFormController.linkDocWithCase(str, caseTest.Id,isSecured);
        LightningResponse resp2 = BigwWebFormController.linkDocWithCase('', caseTest.Id,isSecured);
        str = 'fdjios83924n';
        LightningResponse resp3 = BigwWebFormController.linkDocWithCase(str, caseTest.Id,isSecured);
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
}