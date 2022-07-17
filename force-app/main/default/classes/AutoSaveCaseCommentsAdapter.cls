/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is an Adapter Class for GenericSingleRelatedListController Class
 */
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class AutoSaveCaseCommentsAdapter {
    
    public static final String CLASS_NAME = 'AutoSaveCaseCommentsAdapter';
    public static final String METHOD_GETDATA = 'getData';
    public static final String METHOD_SAVEDATA = 'saveData';

    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param commentId
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse getData(String commentId){
        lightningResponse response = new lightningResponse();
        try{
            response.isError = false;
            Case_Comment__c caseComment = CaseCommentDomain.queryCaseComments(commentId);

            map<String, String> payload = new map<String, String>();
            payload.put('Id', caseComment.Id);
            payload.put('Case__c', caseComment.Case__c);
            payload.put('Comment__c', caseComment.Comment__c);
            payload.put('Type__c', caseComment.Type__c);
            payload.put('Title__c', caseComment.Title__c);
            payload.put('CaseRecordType', caseComment.Case__r.RecordType.DeveloperName);
            payload.put('feedItemId', caseComment.Feed_Item_Id__c);

            response.payload = JSON.serialize(payload);
        }
        catch(Exception e){
            response.isError = true;
            response.errorType = e.getTypeName();
            response.errorOrSuccessMessage = e.getMessage();

            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = CLASS_NAME;
            logExceptionEvent.SourceFunction__c = METHOD_GETDATA;
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        return response;
    }

    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param commentId
     * @param caseId
     * @param comment
     * @param caseType
     * @param caseTitle
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse saveData(String commentId, String caseId, String comment,String caseType,String caseTitle){
        lightningResponse response = new lightningResponse();
        try{
            response.isError = false;

            Case_Comment__c caseComment = new Case_Comment__c();
            caseComment.Id = commentId;
            if(commentId == NULL){
                caseComment.Case__c = caseId;
            }
            
            caseComment.Comment__c = comment;
            caseComment.Type__c = caseType;
            caseComment.Title__c = caseTitle;
            CaseCommentDomain.upsertCaseComment(caseComment);

            map<String, String> payload = new map<String, String>();
            payload.put('Id', caseComment.Id);

            response.payload = JSON.serialize(payload);
        }
        catch(Exception e){
            response.isError = true;
            response.errorType = e.getTypeName();
            response.errorOrSuccessMessage = e.getMessage();

            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = CLASS_NAME;
            logExceptionEvent.SourceFunction__c = METHOD_SAVEDATA;
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        return response;
    }
}