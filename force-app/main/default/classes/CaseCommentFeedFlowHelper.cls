/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This Helper Class is used as helper class CaseCommentFeedFlow Flow.
*/
public class CaseCommentFeedFlowHelper {
    
    private static final String CLASS_NAME = 'CaseCommentFeedFlowHelper';
    private static final String METHOD_HTMLTOPLAINTEXT = 'htmlToPlainText';
    
	/**
     * @author : Sumit Banarji
     * @param htmlTexts
     * @return List
     * @description : This method is invokable by Flow
    */
    @InvocableMethod(
        label='HTML 2 Plain Text'
        description='Converts HTML text to plain text.'
        category='String Conversion'
    )
    public static List<String> htmlToPlainText(List<String> htmlTexts) {
        List<String> listPlainText = new List<String>();
        try{
            for(String htmlString : htmlTexts){
                listPlainText.add(htmlString.stripHtmlTags());
            }
        }
        catch(Exception e){
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = CLASS_NAME;
            logExceptionEvent.SourceFunction__c = METHOD_HTMLTOPLAINTEXT;
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        
        return listPlainText;
    }
}