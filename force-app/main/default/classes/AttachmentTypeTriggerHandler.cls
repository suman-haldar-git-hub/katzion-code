/*
Author:             Prathamesh
Created Date:       Jan 03, 2019 
Brief:              Email Function

Description:     

This trigger handler was developed to validate  the attachments sent through to the email to cases 
and delete them if the file type is not in accepted list and make an entry in the case comment with the file name being removed.
Problem# PRB00001449
*/
public without sharing Class AttachmentTypeTriggerHandler {
    public static void validateEmailAttachments(List<Attachment> listAttachments){
        system.debug('***validateEmailAttachments***');
        Set<String> attachmentTypes = new Set<String>();
        List<String> emailParams=new List<String>();
        List<Id> listDeleteAttach=new List<Id>();
        String caseId;
        String atchTypesString;
        boolean sendEmail=false;
        List<Picklist_Field_Value__c> atchTypes = [select id
                                                   ,Web_Value__c
                                                   from Picklist_Field_Value__c
                                                   where Object_Field__r.Object__c = 'Case'
                                                   and Object_Field__r.Field_Name__c = 'AttachmentType'
                                                   and Web_Display__c = true
                                                   order by Sequence_Number__c];
        system.debug('***atchTypes***'+atchTypes);
        if(atchTypes!=null && !atchTypes.isEmpty()) {
            for (Picklist_Field_Value__c ps : atchTypes) {
                attachmentTypes.add(ps.Web_Value__c.toLowerCase());
            }
        }
        
        List<Id> listParentIds=new List<Id>();
        for(Attachment atc:listAttachments){
            listParentIds.add(atc.ParentId);
        }
        system.debug('***listParentIds***'+listParentIds);
        if(listParentIds!=null && listParentIds.size()>0){
            Map<Id,Id> mapAttachParentToEMParent=new Map<Id,Id>();
            List<EmailMessage> listEmailMessages=new List<EmailMessage>();
            listEmailMessages=[SELECT Id,ParentId from EmailMessage WHERE Id IN:listParentIds];
            system.debug('***listEmailMessages***'+listEmailMessages);
            if(listEmailMessages.size()>0){
                for(EmailMessage emailMessage:listEmailMessages){
                    mapAttachParentToEMParent.put(emailMessage.Id,emailMessage.parentId); 
                }
            }
            
            Map<Id,Case> mapEMParentToCase=new Map<Id,Case>();
            system.debug('***mapAttachParentToEMParent***'+mapAttachParentToEMParent);
            if(mapAttachParentToEMParent.values()!=null && mapAttachParentToEMParent.values().size()>0){
                List<Case> listCases=new List<Case>();
                listCases=[SELECT Id,Origin from Case WHERE Id IN:mapAttachParentToEMParent.values()];
                if(listCases.size()>0){
                    for(Case caseObj:listCases){
                        mapEMParentToCase.put(caseObj.Id,caseObj); 
                    }
                }
            }
            
            List<CaseComment> listCaseComments=new List<CaseComment>();
            for(Attachment atc:listAttachments){
                List<String> fileNameExtension = atc.Name.split('\\.');
                String fileExtension = fileNameExtension[fileNameExtension.size() - 1];
                if( !attachmentTypes.contains(fileExtension.toLowerCase())){
                    Id emailMsgParentId=mapAttachParentToEMParent.get(atc.parentId);
                    if(emailMsgParentId!=null){
                        Case cas=mapEMParentToCase.get(emailMsgParentId);
                        if(cas!=null && cas.Origin=='Email'){
                            CaseComment cm=new CaseComment();
                            cm.CommentBody='Attachment with name '+ atc.Name+' has been removed';
                            cm.IsPublished=TRUE; 
                            cm.ParentId=emailMsgParentId;
                            caseId=emailMsgParentId;
                            String atchname=atc.Name;
                            listCaseComments.add(cm);
                            emailParams.add(atchname);
                            sendEmail=true;
                            listDeleteAttach.add(atc.id);
                        }
                    }
                }
            } 
            if(listDeleteAttach.size()>0){
                Database.delete(listDeleteAttach); 
            }
            if(listCaseComments.size()>0){
               insert listCaseComments;
               system.debug('***listCaseComments***'+listCaseComments);
            }
            if(sendEmail){
                if(!attachmentTypes.isEmpty()){
                    for(String s:attachmentTypes) {
                        if(!String.isBlank(atchTypesString)){
                            atchTypesString +=','+s;
                        }else{
                            atchTypesString=s;
                        }
                    }
                }
                EmailFunction em1=new EmailFunction();
                em1.doSendEmail(emailParams,caseId,atchTypesString);
            }
        }
    }
}