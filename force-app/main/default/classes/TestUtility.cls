/*
    Author:             Jerome To
    Created Date:       JUNE 23, 2015 
    Brief:              This class is used to for testing purposes
    Description:        This class is used to for testing purposes

    Visualforce Page:   N/A
    Test Class:         TestUtilityTest.cls

    Version Control:    v1.0

    @Revision History:  N/A

    @Test Coverage:     100%    -   July 31, 2015
*/

public with sharing class TestUtility {
    

    /*
        @author:        Jerome To
        @createDate:    JULY 23, 2015   
        
        @Description:
        This method is used to create Tranaction Cases
        Fields marked as required are populated in this test
                
        @Revision History                                               
        ----------------
    */
    public static List<Case> createTrxCases(Integer numberOfCases, Id recordTypeId)
    {
        List<Case> cases = createCases( numberOfCases,  recordTypeId);
        for(Case c : cases)
        {
            c.Category__c = 'Employee Relations';
            c.Sub_Category__c = 'Recruitment';
            c.Preferred_Contact_Method__c = 'Email';
        }
        return cases;
    }

    /*
        @author:        Jerome To
        @createDate:    JULY 23, 2015   
        
        @Description:
        This method is used to create Query Cases
         Fields marked as required are populated in this test class
                
        @Revision History                                               
        ----------------
    */
    public static List<Case> createQueryCases(Integer numberOfCases, Id recordTypeId)
    {
        List<Case> cases = createCases( numberOfCases,  recordTypeId);
        for(Case c : cases)
        {
            c.Category__c = 'Our Culture';
            c.Sub_Category__c = 'Our Values';
            c.Origin = 'Email';
            //c.SuppliedEmail = 'jerometo@test.com';
        }
        return cases;
    }

    /*
        @author:        Jerome To
        @createDate:    JULY 23, 2015   
        
        @Description:
        This method is used to create Cases
                
        @Revision History                                               
        ----------------
    */
    private static List<Case> createCases(Integer numberOfCases, Id recordTypeId){
        List<Case> cases = new List<Case>();
        for(Integer i=1; i<=numberOfCases; i++){

            Case c = new Case(Subject = 'TEST_CASE_' + i);
            
            if(recordTypeId != null){ 
                c.RecordTypeId = recordTypeId;                 
            }

            cases.add(c);                         
        }
        return cases;
    }

    /*
        @author:        Jerome To
        @createDate:    JULY 23, 2015   
        
        @Description:
        This method is used to create Person Account
                
        @Revision History                                               
        ----------------
    */
    public static List<Account> createPersonAccount(Integer numberOfAccounts)
    {
        List<Account> accts = new List<Account>();
        // Find any person account record type
        RecordType recordType = [ Select Id, Name, DeveloperName 
                                  From RecordType 
                                  Where SObjectType = 'Account' 
                                  And IsPersonType = true limit 1 ];
        
        for(Integer i=1; i<=numberOfAccounts; i++){
            Account newAccount 
                = new Account( FirstName='User_' + i, 
                                LastName='Test_'+ i, RecordTypeId = recordType.id );

            accts.add(newAccount);
        }

        return accts;
    }

    /*
        @author:        Jerome To
        @createDate:    JULY 23, 2015   
        
        @Description:
        This method is used to create Case Record Type Custom Settings
                
        @Revision History                                               
        ----------------
    */
    public static Case_Record_Types__c getCaseRecordTypesCustomSettings()
    {
        //Custom Settings
        Case_Record_Types__c caseRec = new Case_Record_Types__c();
        caseRec.Transaction_Case__c = '0122800000094iF';
        caseRec.ER_Case__c = '012280000008xsX';
        caseRec.Query_Case__c = '012280000008xsS';
        caseRec.WOW_NZ_ER_Case__c = '0120K000000OkLT';
        return caseRec;
    }
    

    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @return Case
     * @description : This method is used to create Case Record of PS_Query_Case Record Type.
     * 
    */
    public static Case createPSQueryCase(){

        RecordType recType = [SELECT ID, Name, DeveloperName, sObjectType 
                                FROM RecordType 
                                WHERE sObjectType = 'Case' 
                                AND DeveloperName = 'PS_Query_Case'];

        Case objCase = new Case();
        objCase.Web_On_Behalf_Of_Employee_Id__c = '123456';
        objCase.Category__c = 'Pay and the Basics';
        objCase.Sub_Category__c = 'WOW People Discount Card';
        objCase.recordTypeId = recType.Id;
        insert objCase;

        return objCase;
    }


    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @param parentId
     * @return ContentDocumentLink
     * @description : This test method is used to create test data for Content Docuemnt.
     * 
    */
    public static ContentDocumentLink createTestDocument (Id parentId){
        
        ContentVersion contVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data')
        );
        insert contVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = parentId;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        return cdl;
    }

    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This method is used setup test data
     * GetResults method.
    */
    public static void crateCaseRecTypeCustomSettings(){

        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();

        for(RecordType recType : [SELECT ID, Name, DeveloperName, sObjectType 
                                    FROM RecordType 
                                    WHERE sObjectType = 'Case']){
            if(recType.DeveloperName == 'Transaction'){
                caseRecTypeCS.Transaction_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'ER_Case'){
                caseRecTypeCS.ER_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'WOW_NZ_ER_Case'){
                caseRecTypeCS.WOW_NZ_ER_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'PS_Query_Case'){
                caseRecTypeCS.Query_Case__c = recType.Id;
            }
        }
        insert caseRecTypeCS;
    }
}