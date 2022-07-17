/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
 * SalesforceLogService class.
*/
@isTest(SeeAllData=false)
private class SalesforceLogServiceTest {
    /**
 * @author : Sunil
 * @ccompany : Cognizant
 * @description : This test method is used to cover positive and negative scenarios of
 * SalesforceLogService class.
*/
    @isTest
    static void setupExceptionData() {
        List<LogExceptionEvent__e> objectException = ExceptionEventTestData.getLogExceptionEvent(
            'Exception ERROR',
            UserInfo.getUserId(),
            100
        );
        Test.startTest();
        SalesforceLogService.logException(objectException);
        Test.stopTest();
        System.assertEquals(objectException[0].ExceptionLineNumber__c, 32);
        System.assertEquals(objectException[0].ExceptionLineNumber__c, 32);
    }
    /**
 * @author : Sunil
 * @ccompany : Cognizant
 * @description : This test method is used to cover positive and negative scenarios of
 * SalesforceLogService class.
*/
    @isTest
    static void setupWebCalloutData() {
        List<LogWebCalloutEvent__e> objectCallout = WebCalloutEventTestData.getLogWebCalloutEvent(
            UserInfo.getUserId(),
            100
        );
        Test.startTest();
        SalesforceLogService.logWebCallout(objectCallout);
        Test.stopTest();
        System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
        System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
    }
}