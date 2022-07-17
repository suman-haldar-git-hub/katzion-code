/**
 * @author            : Shreya Tripathi
 * @Company           : Cognizant
 * @description       : This class is used as controller for the FileRelatedList component.
 * @last modified on  : 28-02-2022
 * @last modified by  : Shreya Tripathi
**/
public with sharing class FileRelatedListController {
     /**
    * @author : Shreya Tripathi
    * @description : Method to fetch records
    * @return : List<ContentVersion>
    * @param caseId
    * @Last Modified : Shreya Tripathi
    */
     @AuraEnabled
    public static List<ContentVersion> getFileDetails(String caseId){
        EmailMessage[] emails;
        List<ContentDocumentLink> cdList= new List<ContentDocumentLink>();
        List<ContentVersion> cvList= new List<ContentVersion>();
        if(caseId!=NULL)
            {
                cdList= [SELECT Id, ContentDocument.Title, ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink 
                             where LinkedEntityId =:caseId  and LinkedEntity.Type='Case' order by ContentDocument.CreatedDate desc];
                                
                List<Id> cdlIdList=new List<Id>();
                for(ContentDocumentLink cdl: cdList)
                {
                    cdlIdList.add(cdl.ContentDocumentId);
                }
                cvList =[select Id, Title,ContentSize,ContentUrl,FileExtension,Owner.Name ,ContentDocumentId 
                                         from ContentVersion where ContentDocumentId IN :cdlIdList];
            }
        return cvList;
    }
}