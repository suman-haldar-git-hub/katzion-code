/**
* @Author       :       Suman Nandy
* @Date     :       03-Sep-2020
* @Desc     :       This class will be used by national stockakeform
* */

/**
* @description StoreController
*/
public with sharing class DocuSignController {

    private static final String CLASS_NAME = 'DocuSignController';
    private static final String METHOD_CREATEREQUEST = 'createRequest'; 
    private static final String METHOD_GETDELETEDFILELIST = 'getDeletedFileList'; 
    private static final String METHOD_ATTCHFILE = 'attachFile'; 
    private static final String METHOD_GETFILELIST = 'getFileList';

    /**
    * @description searchEmployee
    * @param caseId
    * @param fileList
    * @return String 
    */
    @AuraEnabled
    public static String createRequest(String caseId, String fileList) {
        try {
            Case caseDeatil = [SELECT Description,Subject,CaseNumber FROM Case WHERE Id = :CaseId];
            
            String emailsubject= Label.DocuSign_Default_EmailSubject.replace('<CaseNumber>', caseDeatil.caseNumber);
        
            Pagereference pg=Page.dsfs__DocuSign_CreateEnvelope;
            pg.getParameters().put('SourceID',CaseId);
            pg.getParameters().put('DSEID','0');
            pg.getParameters().put('CES',emailsubject);
            //pg.getParameters().put('CEM',emailMessage);
            //pg.getParameters().put('CRL',CRL);
            pg.getParameters().put('CCTM','Signer 1~Signer');
            pg.getParameters().put('CCRM','Signer 1~Signer 1');
            pg.getParameters().put('LA','0');
            pg.getParameters().put('LF','0');
            pg.getParameters().put('FILES',filelist);
            String baseUrl=System.URL.getSalesforceBaseUrl().toExternalForm();
            String navigationUrl=baseUrl + '/' + pg.getUrl();
            system.debug('navigationUrl'+navigationUrl);

            return navigationUrl;
        }
        catch(exception e) {
            logException(e, METHOD_CREATEREQUEST);

            return null;
        }
    }

    /**
    * @description Get Deleted Files
    * @param caseId
    * @return List 
    */
    @AuraEnabled
    public static List<FileList> getDeletedFileList(String caseId) {    
        
        List<FileList> fsList=new List<FileList>();

        try {
            
            Map<Id,String> contentDocTitle=new Map<Id,String>();

            List<DocuSign_Deleted_Files__c> doclist=[SELECT ContentDocumentID__c,Status__c FROM DocuSign_Deleted_Files__c WHERE Case__c =  :CaseId and Status__c = 'SoftDelete'];
            
            Set<Id> docID = new Set<Id>();

            for(DocuSign_Deleted_Files__c doc: doclist) {
                docID.add(doc.ContentDocumentID__c);
            }
            
            List<ContentDocument> contentdoc=[SELECT Title,Id FROM ContentDocument WHERE Id IN :docID];
            
            for(ContentDocument condoc: contentdoc) {
                ContentDocTitle.put(condoc.Id, condoc.Title);
            }

            for(DocuSign_Deleted_Files__c doc: doclist) {
                FileList singlefile=new FileList();
                singlefile.Title=ContentDocTitle.get(doc.ContentDocumentID__c);
                singlefile.FileId=doc.ContentDocumentID__c;
                fsList.add(singlefile);
            }
        }
        catch(exception e) {
            logException(e, METHOD_GETDELETEDFILELIST);
        }
        return fsList;
    }

     /**
    * @description File List
    * @param caseId
    * @return List 
    */
    @AuraEnabled
    public static list<FileList> getFileList(String caseId) {   
        List<FileList> fsList = new List<FileList>();
        try {
            
            List<ContentDocumentLink> doclist=[SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility,ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId =  :CaseId ];
            for(ContentDocumentLink doc: doclist) {
                FileList singlefile = new FileList();
                singlefile.Title = doc.ContentDocument.Title;
                singlefile.FileId = doc.ContentDocumentId;
                fsList.add(singlefile);
            }
        }
        catch(exception e) {
            logException(e, METHOD_GETFILELIST);
        }
        return fsList;
    }

    /**
    * @description Attach Files Files
    * @param e
    * @param methodName
    */
    private static void logException(Exception e, string methodName){

        LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e(DebugLevel__c = 'Error',ExceptionLineNumber__c = e.getLineNumber(),ExceptionMessage__c = e.getMessage(),ExceptionStackTrace__c = e.getStackTraceString(),ExceptionTypeName__c = e.getTypeName(),Source__c = CLASS_NAME, SourceFunction__c = methodName, User__c = UserInfo.getUserId());
            
        LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
    }
    
    /**
    * @description Wrapper class for files
    */
    public class FileList {
        /**
        * @description Title of File
        */
        @AuraEnabled
        public string title{get;set;}

        /**
        * @description File Id
        */
        @AuraEnabled
        public string fileId{get;set;}
    }
    
}