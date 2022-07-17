/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This Domain Class is used API Class for RPA Bot.
*/
public with sharing class RPABotEmailServiceHelper {
    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This Class is used to thow exception.
    */
    public class EmailSizeLimitException extends Exception {}

    private static map<Id,Messaging.EmailFileAttachment> allEmailFiles;
    private static map<String,String> orgWideAddress;
    
    /**
     * @author : Sumit Banarji
     * @param emailParams
     * @return List
     * @description : This method is invoked by RPABot EmailService Class
    */
    public Static List<String> prepareEmailRequest(List<RPABotEmailService.EmailParameters> emailParams) {
    
        Set<String> attachmentIds = new Set<String>();
        Set<String> fromAddress = new Set<String>();

        for(RPABotEmailService.EmailParameters inputparam : emailParams){
            if(inputparam.documentIds != null){
                attachmentIds.addAll(inputparam.documentIds.split(ConstantsUtility.RPABOT_DOCUMENT_ID_SAPERATOR));
            }
            if(inputparam.fromAddress != null) {
                fromAddress.add(inputparam.fromAddress);
            }
        }

        //Creating map of all the attachments
        allEmailFiles = findAllAttachements(attachmentIds);
        orgWideAddress = setFromAddress(fromAddress);
        
        List<EmailService.EmailWrapper> emailWrapper = new List<EmailService.EmailWrapper>();
        List<String> responses = new List<String>();
        for(RPABotEmailService.EmailParameters inputparam : emailParams){

            EmailService.EmailWrapper emailWrap = new EmailService.EmailWrapper();
            emailWrap.toaddress = setToaddress(inputparam.toAddress);
            emailWrap.orgWideAddress = orgWideAddress.get(inputparam.fromAddress);
            emailWrap.subject = inputparam.subject;
            
            if(inputparam.htmlText){
                emailWrap.htmlBody = inputparam.emailBody;
            }
            else{
                emailWrap.plainTextBody = inputparam.emailBody;
            }
            emailWrap.attachments = setFiles(inputparam.documentIds);
            emailWrap.whatId = inputparam.caseId;
            emailWrap.saveAsActivity = true;
            emailWrapper.add(emailWrap);
        }
        EmailService.sendEmail(emailWrapper);

        for(integer i =0; i < emailWrapper.size(); i++) {
            responses.add(ConstantsUtility.RPABOT_SUCCESS_RESPONSE_MESSAGE);
        }
        return responses;
    }

    /**
     * @author : Sumit Banarji
     * @param fromAddress
     * @return String
     * @description : This method is to set from address
    */
    private Static map<String, Id> setFromAddress(Set<String> fromAddress) {
        map<String, Id> orgWideAddressMap = new map<String, Id>();
        for(OrgWideEmailAddress orgWideAddress: OrgWideEmailAddressDomain.getOrgWideAddress(fromAddress)){
            orgWideAddressMap.put(orgWideAddress.Address, orgWideAddress.Id);
        }
        return orgWideAddressMap;
    }

    /**
     * @author : Sumit Banarji
     * @param attachmentIds
     * @return List
     * @description : This method is to query all the attachments
    */
    private Static List<Messaging.EmailFileAttachment> setFiles(String attachmentIds) {
        List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
        if(allEmailFiles != null && attachmentIds != null){
            for(String attachmentId : attachmentIds.split(ConstantsUtility.RPABOT_DOCUMENT_ID_SAPERATOR)){
                if(allEmailFiles.containsKey(attachmentId)){
                    emailAttachments.add(allEmailFiles.get(attachmentId));
                }
            }
        }
        return emailAttachments;
    }


    /**
     * @author : Sumit Banarji
     * @param attachmentIds
     * @return map
     * @description : This method is to query all the attachments
    */
    private Static map<Id,Messaging.EmailFileAttachment> findAllAttachements(set<String> attachmentIds){
        map<Id,Messaging.EmailFileAttachment> emailFileAttachments = new map<Id,Messaging.EmailFileAttachment>();
        Integer totalSize = 0;
        for(ContentVersion contVer : ContentVersionDomain.getVersionData(attachmentIds)){
            Messaging.EmailFileAttachment emailFileAttachment = new Messaging.EmailFileAttachment();
            emailFileAttachment.filename = contVer.Title;
            if(contVer.FileExtension != null && emailFileAttachment.filename != null){
                emailFileAttachment.filename += + '.' + contVer.FileExtension;
            }
            emailFileAttachment.setBody(contVer.VersionData);
            emailFileAttachments.put(contVer.ContentDocumentId, emailFileAttachment);

            totalSize += contVer.ContentSize;
        }

        checkEmailMessageLimit(totalSize);

        return emailFileAttachments;
    }

    /**
     * @author : Sumit Banarji
     * @param toAddress
     * @return String
     * @description : This method is to set To Address
    */
    private Static String[] setToaddress(String toAddress) {
        if (String.isNotEmpty(toAddress)){
            return toAddress.split(ConstantsUtility.RPABOT_DOCUMENT_ID_SAPERATOR);
        }
        else {
            return null;
        }
    }

    /**
     * @author : Sumit Banarji
     * @param totalSize
     * @description : This method is to check the email limit
    */
    private Static void checkEmailMessageLimit(Integer totalSize){

        General_Setting__c genralSetting = General_Setting__c.getAll().get(ConstantsUtility.RPABOT_CUSTOMSETTING_NAME);
        if(genralSetting != null && genralSetting.Email_Size__c != null){
            Integer limitinBytes = Integer.valueOf(genralSetting.Email_Size__c * 1048576);

            if(totalSize > limitinBytes){
                throw new EmailSizeLimitException(ConstantsUtility.RPABOT_SIZE_EXCEPTION_MESSAGE);
            }
        }
    }
}