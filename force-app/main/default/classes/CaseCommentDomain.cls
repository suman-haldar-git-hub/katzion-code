/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is a Domain Class for Case_Comment__c object
 */
public with sharing class CaseCommentDomain {
    
    /**
     * @author : Sumit Banarji
     * @param caseCommentId
     * @return Case_Comment__c
     * @description : This method is used to Query Case Comment object
    */
    public static Case_Comment__c queryCaseComments(String caseCommentId) {
        return [SELECT Id,Title__c, Case__c,Case__r.RecordType.DeveloperName,Type__c, Comment__c, Feed_Item_Id__c
                FROM Case_Comment__c 
                WHERE Id = :caseCommentId];
    }

    /**
     * @author : Sumit Banarji
     * @param caseComment
     * @description : This method is used to upsert Case Comment
    */
    public static void upsertCaseComment(Case_Comment__c caseComment) {
        if (caseComment != null){
            upsert caseComment;
        }
    }   
}