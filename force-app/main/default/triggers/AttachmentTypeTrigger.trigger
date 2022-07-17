/*
Author:             Venky
Created Date:       Mar 03, 2017 
Brief:              Email Function



Description:     

This trigger was developed to validate  the attachments sent through to the email to cases 
and delete them if the file type is not in accepted list and make an entry in the case comment with the file name being removed.
Problem# PRB00001449
*/


trigger AttachmentTypeTrigger on Attachment (after insert) {
      system.debug('***Attachment Trigger***');
      AttachmentTypeTriggerHandler.validateEmailAttachments(trigger.new);  
}