/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
 * ExceptionEventTriggerHandler class.
*/
@isTest(SeeAllData=false)
private class LogExceptionEventTriggerHandlerTest {
    /**
 * @author : Sunil
 * @ccompany : Cognizant
 * @description : This test method is used to cover positive and negative scenarios of
 * LogExceptionEventTriggerHandler class.
*/
    @isTest
    static void setupExceptionData() {
        List<LogExceptionEvent__e> objectException = ExceptionEventTestData.getLogExceptionEvent(
        'Exception ERROR',UserInfo.getUserId(),100);
        Test.startTest();
            EventBus.publish(objectException);
        Test.stopTest();
    
        System.assertEquals(32,objectException[0].ExceptionLineNumber__c);
    }
}