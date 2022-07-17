/**
 * @author : Monika Bisht
 * @company : Cognizant
 * @description : This class is an Email Service Class to send outbound emails.
*/
public inherited sharing class EmailService {
    /**
     * @author : Monika Bisht
     * @param emailList
     * @description : This method is used to Trigger the Outbound Email
    */
    public static void sendEmail(List<EmailWrapper> emailList){

        List<Messaging.SingleEmailMessage> sendEmails = new List< Messaging.SingleEmailMessage>();

        for(EmailWrapper objEmail : emailList){

            Messaging.SingleEmailMessage emailToSent = new Messaging.SingleEmailMessage();
            //set email template
            setEmailTemplate(emailToSent, objEmail);
            //set Target Object Id
            emailToSent.setTargetObjectId(objEmail.targetObjectId);

            //Set What Id if exist
            setWhatId(emailToSent, objEmail.whatId);

            //set Activity 
            emailToSent.setSaveAsActivity(objEmail.saveAsActivity);
            //set email attachments
            setAttachments(emailToSent, objEmail.attachments);
            //set to address
            setToAddress(emailToSent, objEmail.toaddress);
            //set CC Address
            setCcAddress(emailToSent, objEmail.ccAddress);
            //set OrgWide Address
            emailToSent.setOrgWideEmailAddressId(objEmail.orgWideAddress);
            
            sendEmails.add(emailToSent);
        }
        //Sending the Mail
        Messaging.sendEmail(sendEmails);        
    }
    
    /**
     * @author : Monika Bisht
     * @param emailToSent
     * @param objEmail
     * @description : This method is used to set Email Template
    */
    private static void setEmailTemplate(Messaging.SingleEmailMessage emailToSent, EmailWrapper objEmail){
        if (objEmail.emailTemplateId != null){
            //set Template Id
            emailToSent.setTemplateId(objEmail.emailTemplateId);
        }
        else {
          if(objEmail.subject != null){
              emailToSent.setSubject(objEmail.subject);
            }
            if(objEmail.htmlBody != null){
              emailToSent.setHtmlBody(objEmail.htmlBody);
            }
            if(objEmail.plainTextBody != null){
              emailToSent.setPlainTextBody(objEmail.plainTextBody);
            }
        }
    }

    /**
     * @author : Sumit Banarji
     * @param emailToSent
     * @param whatId
     * @description : This method is used to set what id
    */
    private static void setWhatId(Messaging.SingleEmailMessage emailToSent, string whatId){
        if(whatId != null){
            emailToSent.setWhatId(whatId);
        }
    }
    
    
    /**
     * @author : Monika Bisht
     * @param emailToSent
     * @param attachments
     * @description : This method is used to set attachments
    */
    private static void setAttachments(Messaging.SingleEmailMessage emailToSent, List<Messaging.Emailfileattachment> attachments){
        if(attachments <> null && attachments.size()>0){
            emailToSent.setFileAttachments(attachments);
        }
    }
    
    /**
     * @author : Monika Bisht
     * @param emailToSent
     * @param toAddress
     * @description : This method is used to set To Address
    */
    private static void setToAddress(Messaging.SingleEmailMessage emailToSent, list<string> toAddress){
        if(toAddress <> null && toAddress.size()>0){
            emailToSent.setToAddresses(toAddress);
        }
    }
    
    /**
     * @author : Monika Bisht
     * @param emailToSent
     * @param ccAddress
     * @description : This method is used to set CC Address
    */
    private static void setCcAddress(Messaging.SingleEmailMessage emailToSent, list<string> ccAddress){
        if(ccAddress <> null && ccAddress.size()>0){
            emailToSent.setccAddresses(ccAddress);
        }
    }
    
    
    /**
     * @author : Monika Bisht
     * @company : Cognizant
     * @description : This class is an Wrapper Class for Email Service.
    */
    public class EmailWrapper{
        
        public String whatId;
        public String targetObjectId;
        public String emailTemplateId;
        public boolean saveAsActivity;
        public List<Messaging.Emailfileattachment> attachments;
        public List<string> toaddress;
        public List<string> ccAddress; 
        public String subject;
        public String htmlBody;
        public String plainTextBody;
        public String orgWideAddress;
    }
}