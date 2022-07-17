/**
 * @description       : 
 * @author            : Meghna Bhargava
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Meghna Bhargava
**/
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class WPSLightningWebToCaseController {
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param parentId 
    * @param fileName 
    * @param base64Data 
    * @param contentType 
    * @param fileId 
    * @return ContentDocument 
    **/
  @AuraEnabled
    public static ContentDocument saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks 
        try {
            ContentDocument cd ;  
            if (fileId == '') {
                cd = saveTheFile(parentId, fileName, base64Data, contentType);
            } else {
                appendToFile(fileId, base64Data); 
            }
            
            return cd; 
        }
        catch (Exception ex){
            System.debug('saveChunk Exception : '+ex.getMessage());
            PublishLogEventService.publishExceptionEvent('WPSLightningWebToCaseController.cls on saveChunk',ex);
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
 
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param parentId 
    * @param fileName 
    * @param base64Data 
    * @param contentType 
    * @return ContentDocument 
    **/
    public static ContentDocument saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        try {
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Blob data = Blob.valueOf(base64Data);
            ContentVersion cv = new ContentVersion();
            cv.VersionData = data;
            cv.PathOnClient = 'file_' + Datetime.now().getTime();
            cv.Origin = 'C';
            cv.Title = fileName;
            insert cv;
            
            System.debug('CV----> '+cv.Id);
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = parentId;
            cDe.ShareType = 'I';
            cDe.Visibility = 'AllUsers';
            insert cDe;
            
            ContentDocument cd = [Select Id,Title,Description,ContentSize from ContentDocument where Id =:conDoc];
            
            return cd;
        }catch (Exception ex){
            System.debug('saveTheFile Exception : '+ex.getMessage());
            PublishLogEventService.publishExceptionEvent('WPSLightningWebToCaseController.cls on saveTheFile',ex);
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        
        try {
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            
            ContentVersion cv = [Select VersionData from ContentVersion where ContentDocumentId =: fileId];
            
            String existingBody = EncodingUtil.base64Encode(cv.VersionData);
            
            Blob body = EncodingUtil.base64Decode(existingBody + base64Data);
            
            cv.VersionData = body;
            
            update cv;
        }catch (Exception ex){
            PublishLogEventService.publishExceptionEvent('WPSLightningWebToCaseController.cls on appendToFile',ex);
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
    
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param attachmentid 
    * @param recordId 
    * @return List<ContentDocument> 
    **/
    @AuraEnabled
    public static List<ContentDocument> deleteAttachment(String attachmentid,String recordId) {
        try {
            system.debug('attachment id-->'+attachmentid);
            List<ContentDocument> cdlist ; 
            ContentDocument cd = [Select Id,Title,Description,ContentSize from ContentDocument where Id =:attachmentid];
            Set<Id> docIdSet = new Set<Id>();
            
            if(cd != null) {
                try {
                    delete cd;
                    for (ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId]){
                        docIdSet.add(cdl.ContentDocumentId);
                    }
                    if (!docIdSet.isEmpty()){
                        cdlist = [Select Id,Title,Description,ContentSize from ContentDocument where Id IN: docIdSet];
                    }
                    
                } catch (Exception e) {
                    PublishLogEventService.publishExceptionEvent('WPSLightningWebToCaseController.cls on deleteAttachment',e);
                } 
                
            }
            return  cdlist;
        }
        catch (Exception ex){
            System.debug('Exception : '+ex.getMessage());
            PublishLogEventService.publishExceptionEvent('WPSLightningWebToCaseController.cls on deleteAttachment',ex);
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
    
    /**
    * @description 
    * @author Meghna Bhargava | 09-15-2021 
    * @param recid 
    * @return string 
    **/
    @AuraEnabled
    public static string selectRecordfromController(string recid) {
        return [select Name from Work_Requests__c where id=:recid].Name;
    } 
}