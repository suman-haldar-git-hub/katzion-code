/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This is test data builder class for Salesorce Log.
*/
@isTest
public class SalesforceLogTestData {
    /**
     * @author : Sunil
     * @description : This is test data builder class for Exception Salesorce Log.
     * @return : objectSalesforceLog
     * @param recordTypeId
    */
    public static list<SalesforceLog__c> getExceptionSalesforceLog(
        Id recordTypeId
    ) {
        list<SalesforceLog__c> objectSalesforceLog =new list<SalesforceLog__c>();
        for (Integer i = 0; i < 100; i++) {
            SalesforceLog__c log = new SalesforceLog__c();
            log.DebugMessage__c = 'Ending position out of bounds';
            log.ExceptionLineNumber__c = 32;
            log.ExceptionMessage__c = 'Message';
            log.ExceptionStackTrace__c = 'Exception';
            log.ExceptionTypeName__c = 'Exception ERROR';
            log.User__c = UserInfo.getUserId();
            log.RecordTypeId = recordTypeId;
            objectSalesforceLog.add(log);
        }
        return objectSalesforceLog;
    }
}