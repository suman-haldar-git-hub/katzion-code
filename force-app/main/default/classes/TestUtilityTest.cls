/*
    Author:             Jerome To
    Created Date:       JUNE 23, 2015 
    Brief:              TestUtility Test class
    Description:        TestUtility Test class

    Visualforce Page:   N/A
    Test Class:         N/A
    Apex Class:         TestUtility.cls   
    Version Control:    v1.0

    @Revision History:  AUGUST 08, 2015	-	Added headers and comments

*/

@isTest
private class TestUtilityTest {
	
	// test creation of transaction cases
	@isTest 
	static void createTrxCasesTest() {
		Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
		List<Case> trxCases = TestUtility.createTrxCases(3,caseRec.Transaction_Case__c);
		System.assertEquals(trxCases.size(), 3);
		System.assertEquals(trxCases.get(0).RecordTypeId, caseRec.Transaction_Case__c);
	}
	
	// test creation of Query Cases
	@isTest
	static void createQueryCasesTest() {
		Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
		List<Case> queryCases = TestUtility.createQueryCases(2,caseRec.Query_Case__c);
		System.assertEquals(queryCases.size(), 2);
		System.assertEquals(queryCases.get(0).RecordTypeId, caseRec.Query_Case__c);
	}

	// test creation of Person Accounts
	@isTest
	static void createPersonAccountTest() {
		List<Account> personAcounts = TestUtility.createPersonAccount(3);
		System.assertEquals(personAcounts.size(), 3);
	}

}