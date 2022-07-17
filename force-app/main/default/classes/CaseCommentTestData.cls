/**
* @author : Sumit banarji
* @company : Cognizant
* @description : This is test data builder class for Case_Comment__c object.
*/
@isTest
public with sharing class CaseCommentTestData {
    /**
    * @author : Sumit Banarji
    * @company : Cognizant
    * @description : This will create test records.
    * @return : List<Case_Comment__c>
    * @param count
    * @param caseId
    */
    public static List<Case_Comment__c> createAccountRecords(Integer count, String caseId){
        List<Case_Comment__c> caseComments = new List<Case_Comment__c>();
        for (Integer i = 0; i < count; i++) {
            Case_Comment__c singleRecord = new Case_Comment__c();
            singleRecord.Case__c = CaseId;
            singleRecord.Comment__c = 'Test Comment : ' + i;
            caseComments.add(singleRecord);
        }
        return caseComments;
    }
}