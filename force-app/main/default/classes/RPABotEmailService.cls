/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This Domain Class is used API Class for RPA Bot.
*/
global with sharing class RPABotEmailService {

    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This Class is used to thow exception.
    */
    public class EmailSizeLimitException extends Exception {} 

    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This Class is used to thow exception.
    */
    public class RPABotUnhandledException extends Exception {} 

    private static final String CLASS_NAME = 'RPABotEmailService';
    private static final String METHOD_SENDEMAIL = 'sendEmail';

    /**
     * @author : Sumit Banarji
     * @param emailParams
     * @return List
     * @description : This method is invokable by RPA Bot
    */
    @InvocableMethod(
        label='Send Email'
        description='Sends Emails as per the details provoided in the parameter.'
        category='Email Service'
    )
    global static List<String> sendEmail(List<EmailParameters> emailParams) {
        List<String> responses = new List<String>();

        try{
            responses = RPABotEmailServiceHelper.prepareEmailRequest(emailParams);
        }
        catch(exception e){
            
            if(e.getMessage() == ConstantsUtility.RPABOT_SIZE_EXCEPTION_MESSAGE){
                throw new EmailSizeLimitException(ConstantsUtility.RPABOT_SIZE_EXCEPTION_MESSAGE);
            }
            else {

                LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
                logExceptionEvent.DebugLevel__c	= 'Error';
                logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
                logExceptionEvent.ExceptionMessage__c = e.getMessage();
                logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
                logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
                logExceptionEvent.Source__c = CLASS_NAME;
                logExceptionEvent.SourceFunction__c = METHOD_SENDEMAIL;
                logExceptionEvent.User__c = UserInfo.getUserId();
                
                LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);

                throw new RPABotUnhandledException(e.getMessage());
            }
        }
        return responses;
    }

    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This wrapper is used for Email Parameter Input.
    */
    global class EmailParameters {
        @InvocableVariable(required=true)
        public String toAddress;

        @InvocableVariable(required=true)
        public String fromAddress;

        @InvocableVariable(required=true)
        public String subject;

        @InvocableVariable(required=true)
        public Boolean htmlText;

        @InvocableVariable(required=true)
        public String emailBody;

        @InvocableVariable(required=false)
        public String documentIds;

        @InvocableVariable(required=true)
        public String caseId;
    }
}