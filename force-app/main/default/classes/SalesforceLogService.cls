/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This Service is used for create salesforce log records.
*/
public with sharing class SalesforceLogService {
    /** 
    * @author : Shubham Shukla
    * @description : This method is used to insert salesforceLog record for exception Log Event.
    * @param  triggerNew
    */
    public static void logException(List<LogExceptionEvent__e> triggerNew) {
        List<SalesforceLog__c> objectSalesforceLogs = new List<SalesforceLog__c>();
        for(LogExceptionEvent__e instance : triggerNew) {
            objectSalesforceLogs.add(getSalesforcelogforexceution(instance));
        }
        SalesforceLogDomain.insertSalesforceLog(objectSalesforceLogs);
    }
/** 
    * @author : Shubham Shukla
    * @description : This method is used to get a getSalesforcelog for exceution
    * @param  instance
    * @return objectSalesforceLog
    */
    private static Salesforcelog__c getSalesforcelogforexceution(LogExceptionEvent__e instance){
        Id recordTypeId = 
        Schema.SObjectType.SalesforceLog__c.getRecordTypeInfosByDeveloperName().get('Exception').getRecordTypeId();
        SalesforceLog__c objectSalesforceLog = new SalesforceLog__c();
        objectSalesforceLog.DebugMessage__c = instance.DebugMessage__c;
        objectSalesforceLog.ExceptionLineNumber__c = instance.ExceptionLineNumber__c;
        objectSalesforceLog.ExceptionMessage__c = instance.ExceptionMessage__c;
        objectSalesforceLog.ExceptionStackTrace__c  = instance.ExceptionStackTrace__c ;
        objectSalesforceLog.RecordTypeId = recordTypeId;
        objectSalesforceLog.LogCode__c = instance.logCode__c;
        objectSalesforceLog.ExceptionTypeName__c = instance.ExceptionTypeName__c;
        objectSalesforceLog.DebugLevel__c = instance.DebugLevel__c;
        objectSalesforceLog.ObjectName__c = instance.ObjectName__c;
        objectSalesforceLog.ReferenceId__c = instance.ReferenceId__c;
        objectSalesforceLog.Source__c = instance.Source__c;
        objectSalesforceLog.sourceFunction__c = instance.Sourcefunction__c;
        objectSalesforceLog.user__c = instance.user__c;
        return objectSalesforceLog;
    }

    /** 
    * @author : Shubham Shukla
    * @description : This method is used to insert salesforceLog record for Web Callout Log Event.
    * @param  triggerNew
    */
    public static void logWebCallout(List<LogWebCalloutEvent__e> triggerNew) {
        List<SalesforceLog__c> objectSalesforceLogs = new List<SalesforceLog__c>();
        for(LogWebCalloutEvent__e instance : triggerNew) {
            objectSalesforceLogs.add(getSalesforceLogforWebcallout(instance));
        }
        SalesforceLogDomain.insertSalesforceLog(objectSalesforceLogs);
    }

    /** 
    * @author : Shubham Shukla
    * @description : This method is used to get a SalesforceLog for Webcallout
    * @param  instance
    * @return objectSalesforceLog
    */
    public static SalesforceLog__c getSalesforceLogforWebcallout(LogWebCalloutEvent__e instance){ 
        Id recordTypeId = 
        Schema.SObjectType.SalesforceLog__c.getRecordTypeInfosByDeveloperName().get(
            'WebCallout').getRecordTypeId();
        SalesforceLog__c objectSalesforceLog = new SalesforceLog__c();
        objectSalesforceLog.HTTPRequestBody__c = instance.HTTPRequestBody__c;
        objectSalesforceLog.HTTPRequestEndpoint__c = instance.HTTPRequestEndpoint__c;
        objectSalesforceLog.HTTPRequestHeader__c = instance.HTTPRequestHeader__c;
        objectSalesforceLog.HTTPRequestMethod__c = instance.HTTPRequestMethod__c;
        objectSalesforceLog.HTTPResponseBody__c = instance.HTTPResponseBody__c;
        objectSalesforceLog.HTTPResponseStatusCode__c = instance.HTTPResponseStatusCode__c;
        objectSalesforceLog.HTTPResponseStatusMessage__c = instance.HTTPResponseStatusMessage__c;
        objectSalesforceLog.RecordTypeId = recordTypeId;
        objectSalesforceLog.DebugMessage__c = instance.DebugMessage__c;
        objectSalesforceLog.HTTPResponseHeader__c=instance.HTTPResponseHeader__c;
        objectSalesforceLog.DebugLevel__c = instance.DebugLevel__c;
        objectSalesforceLog.LogType__c = instance.LogType__c;
        objectSalesforceLog.ReferenceId__c = instance.ReferenceId__c;
        objectSalesforceLog.Source__c = instance.Source__c;
        objectSalesforceLog.LogCode__c = instance.LogCode__c;
        objectSalesforceLog.user__c = instance.user__c;
        return objectSalesforceLog;
    }
}