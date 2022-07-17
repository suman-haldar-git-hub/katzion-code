/*
@Author : Surabhi
@Company : SaaSFocus
@Description : This test class is used to cover positive and negative scenarios of
              LogWebCalloutDomain class.
*/
@isTest(SeeAllData=false)
private class LogWebCalloutDomainTest {

    @isTest
    static void setupWebCalloutData() {
        List<LogWebCalloutEvent__e> objectCallout = WebCalloutEventTestData.getLogWebCalloutEvent(
            UserInfo.getUserId(),
            100
        );
        Test.startTest();
            LogWebCalloutDomain.publishLogWebCalloutEventEvent(objectCallout[0]);
        Test.stopTest();
        System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
        System.assertEquals(objectCallout[0].HTTPResponseStatusCode__c, '500');
    }
}