/**
* @author : Sunil
* @company : SaaSFocus
* @description : This test class is used to cover positive and negative scenarios of
* LogWebCalloutDomain class.
*/
@isTest(SeeAllData=false)
private class LogExceptionDomainTest {
    /**
* @author : Sunil
* @company : Cognizant
* @description : This test method is used to cover positive and negative scenarios of
* LogWebCalloutEventTriggerHandler class.
*/
    @isTest
    static void createExpectionData() {
        Test.startTest();
        List<LogExceptionEvent__e> objectException = ExceptionEventTestData.getLogExceptionEvent(
            'Exception ERROR2',
            UserInfo.getUserId(),
            100
        );
        LogExceptionDomain.publishLogExceptionEvent(objectException);
        LogExceptionDomain.publishLogExceptionEvent(objectException[0]);
        System.assertEquals(objectException[0].ExceptionLineNumber__c, 32);
        System.assertEquals(objectException[0].ExceptionLineNumber__c, 32);
        Test.stopTest();
    }
}