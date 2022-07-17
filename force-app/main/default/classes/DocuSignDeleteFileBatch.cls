/**
* @Author       :       Suman Nandy
* @Date     :       03-Sep-2020
* @Desc     :       This class will be used to Delete DocuSign File Attachment
* */

/**
* @description Batch to Delete Files
*/
global class DocuSignDeleteFileBatch implements Database.Batchable<sObject>,schedulable  {

    private static final String CLASS_NAME = 'DocuSignController';
    private static final String METHOD_EXECUTE = 'execute'; 

    /**
    * @description Start Method of batch
    * @param bc
    * @return Database.QueryLocator 
    */
    global Database.QueryLocator start(Database.BatchableContext bc){

        Integer days = Integer.valueOf(System.Label.DocuSign_BatchJob_Days);
        
        Date deletedate = Date.today().addDays( - days);
        
        String query='SELECT Case__c,ContentDocumentID__c,Name,Status__c FROM DocuSign_Deleted_Files__c WHERE CreatedDate <= :deletedate and Status__c=\'SoftDelete\' ';
        
        return Database.getQueryLocator(query);
    }
    
    /**
    * @description execute Method of batch
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        try {
            List<Id> filesneedtobeDeleted=new List<Id>();
            List<DocuSign_Deleted_Files__c> docuSignDeletedFiles=(List<DocuSign_Deleted_Files__c>)scope;
            List<DocuSign_Deleted_Files__c> updateStatus=new List<DocuSign_Deleted_Files__c>();

            for(DocuSign_Deleted_Files__c filedata: DocuSignDeletedFiles){
                filesneedtobeDeleted.add(filedata.ContentDocumentID__c);
            }
            
            List<ContentDocument> condoc= [SELECT Id FROM ContentDocument WHERE Id = :filesneedtobeDeleted];
            delete condoc;
            
            for(DocuSign_Deleted_Files__c filedata: DocuSignDeletedFiles){
                filedata.Status__c='Deleted';
                updateStatus.add(filedata);
            }
            
            update updateStatus;
        }
        catch(Exception e) {
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e(DebugLevel__c = 'Error',ExceptionLineNumber__c = e.getLineNumber(),ExceptionMessage__c = e.getMessage(),ExceptionStackTrace__c = e.getStackTraceString(),ExceptionTypeName__c = e.getTypeName(),Source__c = CLASS_NAME, SourceFunction__c = METHOD_EXECUTE, User__c = UserInfo.getUserId());
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
    }
    /**
    * @description execute Method of batch
    * @param sc
    */
    global void execute(SchedulableContext sc) {
        database.executebatch(new DocuSignDeleteFileBatch());
    }
    
    /**
    * @description Finish Method of batch
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('Batch Execution Finished');
    }
}