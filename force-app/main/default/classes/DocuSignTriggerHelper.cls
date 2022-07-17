/**
 * @Author      :       Suman Nandy
 * @Date        :       17-Dec-2020
 * @Desc        :       This helper class will be called from DocuSignStatusUpdateTrigger 
 *                      to Delete Original document and Kept the signed version of this document
 * */
/**
 * @description DocuSignTriggerHelper
 *
 * Test Class Name : DocuSignTriggerHelperTest
 */
public Inherited Sharing class DocuSignTriggerHelper {

    private static final String CLASS_NAME = 'DocuSignController';
    private static final String METHOD_DELETEORIGINALDOCUMENT = 'deleteOriginalDocument'; 

    /**
    * @description Delete Original document and Kept the signed version of this document
        This method will perform three operation 
        1. Filter Record
        2. Process record to find which links needs to be deleted
        3. Insert record into DocuSign_Deleted_Files__c Object
        4. Delete the Document Link

    * @param docuSignStatusList
    */
    public static void deleteOriginalDocument(List<dsfs__DocuSign_Status__c> docuSignStatusList) {
        try {
            List<string> envelopIds=new List<string>();
            //***************************** 1. Filter Record*******************************************
            for(dsfs__DocuSign_Status__c docStatus:docuSignStatusList){
                if(docStatus.dsfs__Envelope_Status__c=='Completed'){
                    envelopIds.add(docStatus.dsfs__DocuSign_Envelope_ID__c); 
                }  
            }
            System.debug('DocuSignTriggerHelper envelopIds'+envelopIds);
            //***************************** 2. Process Record*******************************************
            
            if(envelopIds.size() > 0 ){
                //Get All Associated Envelop
                List<dsfs__DocuSign_Envelope__c> envlist=[SELECT Id  FROM dsfs__DocuSign_Envelope__c WHERE 
                                                        dsfs__DocuSign_Envelope_ID__c IN :envelopIds];
                                                        
                System.debug('DocuSignTriggerHelper envlist '+envlist);
                set<Id>setDocId = new set<Id>();
                for(dsfs__DocuSign_Envelope__c obj:envlist){
                    setDocId.add(obj.Id);
                
                }
                
                //Get List of Envelop Document 
                //Envelop Docu will give you ContentVersionID
                List<dsfs__DocuSign_Envelope_Document__c> envelopdocumentlist=[SELECT dsfs__External_Document_Id__c FROM 
                                                                            dsfs__DocuSign_Envelope_Document__c 
                                                                            WHERE dsfs__DocuSign_EnvelopeID__c in :setDocId];
                System.debug('DocuSignTriggerHelper envelopdocumentlist'+envelopdocumentlist);
                List<Id> contentversionIDs=new List<Id>();
                for(dsfs__DocuSign_Envelope_Document__c envdoc:envelopdocumentlist ){
                    contentversionIDs.add(envdoc.dsfs__External_Document_Id__c);
                }
                
                //Get all ContentDocument ID
                List<ContentVersion> conDoc=[SELECT ContentDocumentId,Title FROM ContentVersion WHERE Id = :contentversionIDs];
                System.debug('conDoc'+conDoc);
                //Map will be used to get DocumentName which will be used to indert data into Deleted Object 
                Map<Id,String> documentIDNameMap=new Map<Id,String>();
                List<Id> documentIds=new List<Id>();
                for(ContentVersion condocument:conDoc ){
                    documentIds.add(condocument.ContentDocumentId);
                    documentIDNameMap.put(condocument.ContentDocumentId,condocument.Title);
                }  
                
                //Get all document link associated with the document
                List<ContentDocumentLink> conDocLinkdata=[SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE ContentDocumentId = :documentIds ORDER BY ShareType ASC NULLS FIRST]; 
                System.debug('ConDocLinkdata'+ConDocLinkdata);
    
                //Get all link which are associated with case object
                List<ContentDocumentLink> linkonCaseObject=new List<ContentDocumentLink>();
                for(ContentDocumentLink link: ConDocLinkdata){
                    Id sampleid = link.LinkedEntityId; 
                    SObjectType type=sampleid.getsobjecttype();
                    if(type == Schema.Case.SObjectType){
                        linkonCaseObject.add(link);
                    }
                }
                System.debug('linkonCaseObject' +linkonCaseObject);
                
                //Keep track on all delete file
                List<DocuSign_Deleted_Files__c> files=new List<DocuSign_Deleted_Files__c>();
                for(ContentDocumentLink doclink:linkonCaseObject){
                    DocuSign_Deleted_Files__c deletedFile=new DocuSign_Deleted_Files__c();
                    deletedFile.Case__c =doclink.LinkedEntityId;
                    deletedFile.Status__c='SoftDelete';
                    deletedFile.Title__c=documentIDNameMap.get(doclink.ContentDocumentId);
                    deletedFile.ContentDocumentID__c    = doclink.ContentDocumentId;
                    files.add(deletedFile);
                }
                System.debug('files'+ files);
                System.debug('linkonCaseObject'+ linkonCaseObject);
                //************************* 3.Insert record into DocuSign_Deleted_Files__c Object *****************
                insert files;
                //************************* 4.Delete the Document Link *****************
                delete linkonCaseObject;
            }
            
        }
        catch (exception e){
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e(DebugLevel__c = 'Error',ExceptionLineNumber__c = e.getLineNumber(),ExceptionMessage__c = e.getMessage(),ExceptionStackTrace__c = e.getStackTraceString(),ExceptionTypeName__c = e.getTypeName(),Source__c = CLASS_NAME, SourceFunction__c = METHOD_DELETEORIGINALDOCUMENT, User__c = UserInfo.getUserId());
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
    }
}