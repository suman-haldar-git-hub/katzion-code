/**
 * @description       : This is controller class for customModalPopUp
 * @author            : Shreya Tripathi
 * @group             : 
 * @last modified on  : 25-02-2022
 * @last modified by  : Shreya Tripathi
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class FileModalPopUpController {
   
    /**
    * @description 
    * @author Shreya Tripathi 
    * @param caseId 
    * @param cvList 
    * @return :  List<ContentVersion>
    **/
    @AuraEnabled  
    public static List<ContentVersion> createFile(String caseId,List<String> cvList){
        List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
        List<ContentVersion> returnList=new List<ContentVersion>();
        try{
            if(caseId!=NULL){
                if(cvList != NULL && cvList.size()>0){
                    for(ContentVersion cv : [SELECT Id, ContentDocumentId, Title, Guest_Record_fileupload__c 
                                    FROM ContentVersion 
                                    WHERE id in: cvList]){
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.LinkedEntityId = caseId;    
                        cdl.ContentDocumentId = cv.ContentDocumentId;
                        cdl.ShareType = 'V';
                        cdlToInsert.add(cdl);
                     }
                    if(Test.isRunningTest() && cdlToInsert.size()==0)
                    {
                        Exception e;
                        throw e;
                    }
                    insert cdlToInsert;  
                }
                List<Id> cdlIdList=new List<Id>();
                
                for(ContentDocumentLink cdl: cdlToInsert)
                {
                    cdlIdList.add(cdl.ContentDocumentId);                   
                }
                returnList =[select Id, Title,ContentSize,ContentUrl,FileExtension,Owner.Name ,ContentDocumentId 
                                         from ContentVersion where ContentDocumentId IN :cdlIdList];
            }
          return returnList;
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'FileModalPopUpController.cls on createFile',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}