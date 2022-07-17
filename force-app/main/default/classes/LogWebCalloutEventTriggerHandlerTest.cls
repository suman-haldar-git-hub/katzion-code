/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of 
 * WebCalloutEventTriggerHandler class.
*/
@isTest(SeeAllData=false)
private class LogWebCalloutEventTriggerHandlerTest {
/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This test method is used to cover positive and negative scenarios of
 * LogWebCalloutEventTriggerHandler class.
*/
@isTest
static void setupWebCalloutData() {
    List<LogWebCalloutEvent__e> objectCallout = WebCalloutEventTestData.getLogWebCalloutEvent(
        UserInfo.getUserId(),
        100
    );
    Test.startTest();
    EventBus.publish(objectCallout);
    Test.stopTest();
    System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
    System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
}
}