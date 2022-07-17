/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This is test data builder class for Web Callout Event.
*/
@isTest
public class WebCalloutEventTestData {
    /**
     * @author : Sunil
     * @description : This is test data builder class for Web Callout Salesorce Log.
     * @param  userName
     * @param  count
     * @return : logWebCalloutInsert
    */
    public static list<LogWebCalloutEvent__e> getLogWebCalloutEvent(
        String userName,
        Integer count
    ) {
        List<LogWebCalloutEvent__e> logWebCalloutInsert = new List<LogWebCalloutEvent__e>();
        for (Integer i = 0; i < count; i++) {
            LogWebCalloutEvent__e logWebCallout = new LogWebCalloutEvent__e();
            logWebCallout.DebugMessage__c = 'WebCallout';
            logWebCallout.HTTPRequestBody__c = 'The formatter threw an exception while trying to deserialize the message';
            logWebCallout.HTTPRequestEndpoint__c = 'https://test1.api.hcfbiz.com.au/web-customers/v1/interactions';
            logWebCallout.HTTPRequestHeader__c = 'RequestHeader';
            logWebCallout.HTTPRequestMethod__c = 'POST';
            logWebCallout.HTTPResponseBody__c = 'application/json;charset=windows-1252';
            logWebCallout.HTTPResponseHeader__c = 'application/json;charset=windows-1252';
            logWebCallout.HTTPResponseStatusCode__c = '500';
            logWebCallout.HTTPResponseStatusMessage__c = 'Server Error';
            logWebCallout.User__c = userName;
            logWebCalloutInsert.add(logWebCallout);
        }
         return logWebCalloutInsert;
    }
}