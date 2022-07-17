public without sharing class FileUploadController {
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
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
 
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
            System.debug('parentId----> '+parentId);
            
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
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
    
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
                   // CreateExceptionLogs.logErrorMessage('WPSLightningWebToCaseController','deleteAttachment','delete record',e); 
                } 
                
            }
            return  cdlist;
        }
        catch (Exception ex){
            System.debug('Exception : '+ex.getMessage());
            throw createAuraHandledException.createException(ex.getMessage());
        }
    }
}