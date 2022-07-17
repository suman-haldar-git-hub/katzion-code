/** 
    * @author : Sunil
    * @company : Cognizant
    * @description : This is test data builder class for Exception Event.
    */
@isTest
public class ExceptionEventTestData {
    /** 
    * @author : Sunil
    * @param  stackName
    * @param  userName
    * @param  count
    * @return : logExceptionEventInsert
    * @description : This is test data builder class for Exception Salesorce Log.
    */
    public static list<LogExceptionEvent__e> getLogExceptionEvent(
        String stackName,
        String userName,
        Integer count
    ) {
        List<LogExceptionEvent__e> logExceptionEventInsert = new List<LogExceptionEvent__e>();
        for (Integer i = 0; i < count; i++) {
            LogExceptionEvent__e logException = New LogExceptionEvent__e();
            logException.DebugMessage__c = 'Ending position out of bounds';
            logException.ExceptionLineNumber__c = 32;
            logException.ExceptionMessage__c = 'Message';
            logException.ExceptionStackTrace__c = stackName;
            logException.ExceptionTypeName__c = 'Exception';
            logException.User__c = userName;
            logExceptionEventInsert.add(logException);
        }
        return logExceptionEventInsert;
    }
}