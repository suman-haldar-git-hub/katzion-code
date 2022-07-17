/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 10-25-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
public class NoteToCaseCommentBatch implements Database.Batchable<sObject>,Database.Stateful {
    //Below code can be run in anynomus window to run batch apex
    //Database.executeBatch(new NoteToCaseCommentBatch(), 200);
    Map<String,String> conDocIdVsLinkedId = new Map<String,String>();
    Set<Id> conDocIdSet = new Set<Id>();
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 10-22-2021 
    * @param bc 
    * @return Database.QueryLocator 
    **/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        for(ContentDocumentLink conLinkRecord :[SELECT Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink WHERE LinkedEntityId IN(SELECT Id from Case) AND ContentDocument.FileExtension = 'snote']){
            conDocIdVsLinkedId.put(conLinkRecord.ContentDocumentId,conLinkRecord.LinkedEntityId);
            conDocIdSet.add(conLinkRecord.ContentDocumentId);
        }
        String query = 'SELECT Id,VersionData,ContentDocumentId,ContentDocument.Title from ContentVersion WHERE IsLatest =true AND ContentDocumentId IN: conDocIdSet';
        return Database.getQueryLocator(query);
    }
    
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 10-22-2021 
    * @param bc 
    * @param conVersionRecordsList 
    **/
    public void execute(Database.BatchableContext bc, List<ContentVersion> conVersionRecordsList) {
        
        List<Case_Comment__c> caseCommentList = new List<Case_Comment__c>();
        for(ContentVersion conVersionRecord : conVersionRecordsList) {        
            Case_Comment__c newComment = new Case_Comment__c();
            newComment.Case__c = conDocIdVsLinkedId.get(conVersionRecord.ContentDocumentId);
            newComment.Comment__c= conVersionRecord.VersionData.toString();
            newComment.Title__c = conVersionRecord.ContentDocument.Title;
            caseCommentList.add(newComment);
        }
        try {
            insert caseCommentList;
            system.debug('CaseCommentList'+caseCommentList);
            
        } catch(Exception e) {
            System.debug(e);
        }
        
    }
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 10-22-2021 
    * @param bc 
    **/
    public void finish(Database.BatchableContext bc) {
        system.debug('INSIDE FINISH');
    }
}