/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is apex controller of lightning component "UploadContentImage".
*/
public with sharing class UploadContentImageController {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();

    /**
* @author : Praveen Tiwari
* @description : This method is used to query ContentDocument to get uploaded file.
* @return : UploadFileResponseWrapper
* @param recordId
*/
    @AuraEnabled
    public static UploadFileResponseWrapper getFiles(String recordId){
        UploadFileResponseWrapper response = new UploadFileResponseWrapper();
        Set<Id> documentIds = new Set<Id>();
        for(ContentDocumentLink cdLink : ContentDocumentLinkDomain.getContentDocLinks(recordId)){
            documentIds.add(cdLink.ContentDocumentId);
        }
        Knowledge__kav articleRec = KnowledgeDomain.getKnowledgeDetailsForPublishController(recordId);
        response.publishStatus = articleRec.PublishStatus;
        if(!documentIds.isEmpty()){
            response.documentRecords = ContentVersionDomain.getContentVersionList(documentIds);
        }
        return response;
    }
    /**
* @author : Praveen Tiwari
* @description : This method is used to generate public url.
* @return : LightningResponse
* @param recordId
* @param docId
* @param articleType
*/
    @AuraEnabled
    public static LightningResponse generatePublicURL(String recordId, String docId, String articleType){
        String msg = '';
        try{
            LightningResponse response = new LightningResponse();
            if(Schema.sObjectType.Knowledge__kav.isUpdateable())
            {
                //Delete already existing file of the type articleType
                deleteExistingImage(recordId, articleType);
                //Get uploaded document
                ContentDocument conDocument = ContentDocumentDomain.getContentDocs(docId);
                List<ContentDocumentLink> cdlList = ContentDocumentLinkDomain.getContentDocLinks(recordId);
                ContentVersion conVersion = ContentVersionDomain.getContentVersion(cdlList[0].ContentDocumentId);
                conVersion.Title = conDocument.Title;
                conVersion.ImageType__c = articleType;
                //Quering Knowledge Article
                Knowledge__kav objKnowledge = KnowledgeDomain.getKnowledgeDetailsForPublishController(recordId);
                String articleName = objKnowledge.title;
                Integer maxSize = 100;
                if(articleName.length() > maxSize ){
                    articleName = articleName.substring(0, maxSize);
                }
                ContentDistribution cd = new ContentDistribution();
                cd.Name = articleName;
                cd.ContentVersionId = conVersion.Id;
                cd.PreferencesAllowViewInBrowser= true;
                cd.PreferencesLinkLatestVersion=true;
                cd.PreferencesNotifyOnVisit=false;
                cd.PreferencesPasswordRequired=false;
                cd.PreferencesAllowOriginalDownload= true;
                ContentDistributionDomain.insertContentDistribution(cd);
                String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm().remove('.my.salesforce.com');
                String orgId = UserInfo.getOrganizationId();
                ContentDistribution objCD = ContentDistributionDomain.getContentDistribution(cd.Id);
                String publicURL = objCD.ContentDownloadUrl;
                conVersion.PublicURL__c = publicURL;
                ContentVersionDomain.updateContentVersion(conVersion);
                response.hasObjectAccess = true;
            }else{
                deleteExistingImage(recordId, 'deleted');
            }
            return response;
        }
        catch(DmlException ex){
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ ex.getDmlMessage(i) +  '\n' ;
            }
            if(Schema.sObjectType.ContentDocument.isDeletable()){
                ContentDocumentDomain.deleteContentDocument(new Set<Id> {docId});
            }
            PublishLogEventService.publishExceptionEvent
                ('UploadContentImageController.cls on generatePublicURL',ex);
            throw new AuraHandledException(msg);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'UploadContentImageController.cls on generatePublicURL',
                ex
            );
            //throw all other exception message
            throw new AuraHandledException(ex.getMessage());
        }
    }
    /**
* @author : Praveen Tiwari
* @description : This method is used to delete already existing image of the type the user is uploading.
* @param articleId
* @param imageType
*/
    public static void deleteExistingImage(String articleId, String imageType){
        Set<Id> documentIds = new Set<Id>();
        Set<Id> conDocumentIds = new Set<Id>();
        for(ContentDocumentLink cdLink : ContentDocumentLinkDomain.getContentDocLinks(articleId)){
            documentIds.add(cdLink.ContentDocumentId);
        }
        Knowledge__kav articleRec = KnowledgeDomain.getKnowledgeDetailsForPublishController(articleId);
        if(!documentIds.isEmpty()){
            for(ContentVersion cv : ContentVersionDomain.getContentVersionList(documentIds)){
                if(cv.ImageType__c == imageType || imageType == 'deleted'){
                    conDocumentIds.add(cv.ContentDocumentId);
                }
            }
        }
        if(!conDocumentIds.isEmpty()){
            ContentDocumentDomain.deleteContentDocument(conDocumentIds);
        }
    }
    /**
* @author : Praveen Tiwari
* @description : This method is used to delete the file.
* @return LightningResponse
* @param sDocumentId
* @param articleId
* @param imageTyp
*/
    @AuraEnabled
    public static LightningResponse deleteFiles(String sDocumentId, String articleId, String imageTyp){
        try{
            LightningResponse response = new LightningResponse();
            ContentDocumentDomain.deleteContentDocument(new Set<Id> {sDocumentId});
            response.hasObjectAccess = true;
            return response;
        }
        catch (DmlException ex) {
            PublishLogEventService.publishExceptionEvent
                ('UploadContentImageController.cls on deleteFiles',ex);
            throw new AurahandledException(ex.getDmlMessage(0));
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'UploadContentImageController.cls on deleteFiles',
                ex
            );
            //throw all other exception message
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /**
    * @Author : Praveen Tiwari
    * @Company : Cognizant
    * @description : This inner class will make the response wrapper.
    */
    public class UploadFileResponseWrapper{
        @AuraEnabled
        public boolean success;
        @AuraEnabled
        public String publishStatus;
        @AuraEnabled
        public List<ContentVersion> documentRecords;
    }
 }