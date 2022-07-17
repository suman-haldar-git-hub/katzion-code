/*
@Author: Akshansh Jain
@Company: Cognizant
@CreatedOn: 10-09-2021
@Description: This test class covers the positive and negatice scenarios for "CasePortalFlowService" class
*/
@isTest(SeeAllData=false)
public with sharing class CasePortalFlowServiceTest {
    
    @testSetup
    static void makeData(){
        User loggedInUser = UserTestData.getUser('System Administrator', 'Test1');
        loggedInUser.EmployeeID__c = '123456';
        insert loggedInUser;

        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123456';
        insert accountTest;

        List<Form__c> forms = FormTestData.getForm(1, true);
        forms[0].CaseCategory__c = 'Pay & Basics';
        insert forms;

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
        caseTest[0].recordTypeId = caseRecTypeCS.Query_Case__c;
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
        
        List<Picklist_Field_Value__c> pfvCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            categoryData[0].Id,
            1,
            false
        );
        pfvCategoryInstance[0].Web_Value__c='Pay & Basics';
        insert pfvCategoryInstance;

        List<Picklist_Field_Value__c> pfvSubCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            subCategoryData[0].Id,
            1,
            true
        );
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
        LightningResponse resp = CasePortalFlowService.getpswebtocase();
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }

    @isTest
    static void getFormDataOnLoadTest(){
        List<Form__c> forms = [SELECT Id FROM Form__c];
        User testUser = [Select Id From User Where EmployeeId__c = '123456' LIMIT 1];
        System.runAs(testUser) {
            test.startTest();
            CasePortalFlowService.SelectedCategoryWrapper wrapper = CasePortalFlowService.getFormDataOnLoad(forms[0].Id);
            String userId = CasePortalFlowService.getUserId();
            test.stopTest();
            system.assertEquals(userId!=null, true);
            system.assertEquals(wrapper.accDetails.FirstName, 'Woolworth');
        }
    }

    @isTest
    static void saveCaseDetailsTest(){
        List<Form__c> forms = [SELECT Id FROM Form__c];
        User testUser = [Select Id From User Where EmployeeId__c = '123456' LIMIT 1];
        Account objAcc = [SELECT Id FROM Account LIMIT 1];
        List<Case> caseTest = CaseTestData.getCaseData(objAcc.Id,1,false);
        System.runAs(testUser) {
            test.startTest();
            LightningResponse response = CasePortalFlowService.saveCaseDetails(caseTest[0]);
            response = CasePortalFlowService.saveCaseDetails(new Case());
            test.stopTest();
            system.assertEquals(response.payLoad!=null, true);
        }
    }

    @isTest
    static void deleteDocumentsTest(){
        List<ContentVersion> cvList = ContentVersionTestData.create(1);
        insert cvList;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Account objAcc = [SELECT Id FROM Account LIMIT 1];
        List<Case> caseTest = CaseTestData.getCaseData(objAcc.Id,1,true);
        test.startTest();
        LightningResponse response = CasePortalFlowService.deleteDocuments(documents[0].Id);
        CasePortalFlowService.createContentDocLinkWithCase(new List<String>{documents[0].Id}, String.valueOf(caseTest[0].Id));
        test.stopTest();
        system.assertEquals(response.isError==false, true);
    }
     @isTest
    static void deleteDocumentsTestElseBlock(){
        test.startTest();
        LightningResponse response = CasePortalFlowService.deleteDocuments(null);
        test.stopTest();
        system.assertEquals(response.errorType=='success', true);
    }
}