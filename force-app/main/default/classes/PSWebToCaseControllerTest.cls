/*
@Author: Saurabh Bisht
@Company: SaasFocus
@CreatedOn: 08-06-2020
@Description: This test class covers the positive and negatice scenarios for "PSWebToCaseController" class...
*/
@isTest(SeeAllData=false)
public class PSWebToCaseControllerTest {
    
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
		
        Id level1recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level1').getRecordTypeId();
    
        Id level2recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level2').getRecordTypeId();
    
        Id level3recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level3').getRecordTypeId();
        
        List<Employee_Relation_Master__c> emp = 
            EmployeeRelationTestData.createEmpRelRecords(1, level1recordTypeId);
        insert emp;
        
        List<Employee_Relation_Master__c> emp1 = 
            EmployeeRelationTestData.createEmpRelRecords(1, level2recordTypeId);
        emp1[0].recordtypeid=level1recordTypeId; 
        insert emp1;
        
        List<Employee_Relation_Master__c> emp2 = 
            EmployeeRelationTestData.createEmpRelRecords(1, level3recordTypeId);
        emp2[0].Parent_value__c = emp1[0].id;
        emp2[0].Further_Information__c = 'DateTimeLocation';
        insert emp2;
        
    }
    @isTest
    static void getAllPicklistDataTest(){
        test.startTest();
        LightningResponse resp = PSWebToCaseController.getpswebtocase();
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
    @isTest
    static void saveCaseDetailsTest(){
        Boolean isSecure = false;
        test.startTest();
        Case objCase = new Case();
        objCase.Web_On_Behalf_Of_Employee_Id__c = '123456';
        objCase.Category__c = 'Pay and the Basics';
        objCase.Sub_Category__c = 'WOW People Discount Card';
        LightningResponse resp = PSWebToCaseController.saveCaseDetails(objCase,isSecure);

        Case objCase1 = new Case();
        objCase1.Web_On_Behalf_Of_Employee_Id__c = '';
        objCase.Category__c = 'Pay and the Basics';
        objCase1.Sub_Category__c = '';
        LightningResponse resp1 = PSWebToCaseController.saveCaseDetails(objCase1,isSecure);

        Case objCase2 = new Case();
        objCase2.Category__c = 'Pay and the Basics';
        objCase2.Sub_Category__c = 'Salary Sacrifice Forms';
        LightningResponse resp2 = PSWebToCaseController.saveCaseDetails(objCase2,isSecure);

        LightningResponse resp3 = PSWebToCaseController.saveCaseDetails(null,null);
        LightningResponse resp4 = BigwWebFormController.saveCaseDetails(new Case());
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
    @isTest
    static void getAllPicklistDataForAttachmentTest(){
        test.startTest();
        String jsonStr = PSWebToCaseController.getAllPicklistDataForAttachment();
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
        LightningResponse resp = PSWebToCaseController.deleteDocuments(new List<String>{documents[0].Id});
        LightningResponse resp1 = PSWebToCaseController.deleteDocuments(null);
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
        LightningResponse resp = PSWebToCaseController.linkDocWithCase(str, caseTest.Id,isSecured);
        LightningResponse resp2 = PSWebToCaseController.linkDocWithCase('', caseTest.Id,isSecured);
        str = 'fdjios83924n';
        LightningResponse resp3 = BigwWebFormController.linkDocWithCase(str, caseTest.Id,isSecured);
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
    
    @isTest
    static void getTeamMemberDetailTest(){
        string employeeId = '123456';
        test.startTest();
        list<Account> teamMemberData= PSWebToCaseController.getTeamMemberDetail(employeeId);
        test.stopTest();
        system.assertEquals(teamMemberData.size(),1, true);
    }
}