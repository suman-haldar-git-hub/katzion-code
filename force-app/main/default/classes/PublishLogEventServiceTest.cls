/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
 * LogWebCalloutDomain class.
*/
@isTest(SeeAllData=false)
private class PublishLogEventServiceTest {
    /**
     * @author : Sunil
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void setupExceptionSalesforceLogData() {
        Test.startTest();
            try {
                Exception ex;
                PublishLogEventService.publishExceptionEvent(
                    'Exception ERROR',
                    ex
                );
                System.assertNotEquals(ex, null);
            }
            catch(Exception ex) {
                PublishLogEventService.publishExceptionEvent(
                    'Exception ERROR',
                    ex
                );
            }
        Test.stopTest();
    }
    /**
     * @author : Sunil
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void publishWebCalloutEventLogData() {
        HTTPRequest req =new HTTPRequest();
        HTTPResponse res =new HTTPResponse();
        res.setHeader('headerKey', 'HeaderValue');
        Test.startTest();
            PublishLogEventService.publishWebCalloutEvent(
                'WebCallout',
                req,
                res
            );
        System.assertNotEquals(res, null);
        Test.stopTest();
    }
    /**
     * @author : Sunil
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void publishWebCalloutEventForRestServicesLogData() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Test.startTest();
            PublishLogEventService.publishWebCalloutEventForRestServices(
                'WebCallout',
                req,
                res,
                'resBody'
            );
            PublishLogEventService.publishPlatformEventLogs('WebCallout','resBody');
            PublishLogEventService.publishWebCalloutEventAsync(
                'WebCallout',
                'reqBody',
                'reqEndPoint',
                'reqMethod',
                'resHeaders',
                'resBody',
                'resStatus',
                100,
                'reqHeaders'
            );
            System.assertNotEquals(res, null);
        Test.stopTest();
    }
    /**
     * @author : Sunil
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void setupExceptionobject() {
        Test.startTest();
            try {
                Exception ex;
                PublishLogEventService.publishExceptionEvent(
                    'Exception ERROR',
                    ex
                );
                System.assertNotEquals(ex, null);
            }
            catch(Exception ex) {
                PublishLogEventService.getLogExceptionEvent(
                    'Exception ERROR',
                    ex
                );
            }
        Test.stopTest();
    }
    
    
    /**
     * @author : Shubham Shukla
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void publishWebCalloutEventLogDatanewone() {
        Test.startTest();
        Webcalloutlogwrapper obj = new Webcalloutlogwrapper();
        obj.debugMessage = 'Error in the process builder-Notify Users';
        obj.debuglevel = 'Error';
        obj.logCode='1001'; 
        obj.source='PCMUserNotificationController';
        obj.sourceFunction='notifyUsers';
        obj.httpRequestBody = 'wertyuiop';
        publishlogeventservice.publishWebCalloutEvent(obj);
        System.assertNotEquals(obj, null);
        Test.stopTest();
    }
    
    
    
    /**
     * @author : Shubham Shukla
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void publishWebCalloutEventLogDatanew() {
        Test.startTest();
        Webcalloutlogwrapper obj = new Webcalloutlogwrapper();
        obj.debugMessage = 'Error in the process builder-Notify Users';
        obj.debuglevel = 'Error';
        obj.logCode='1001'; 
        obj.source='PCMUserNotificationController';
        obj.sourceFunction='notifyUsers';
        obj.httpRequestBody = 'wertyuiop';
        publishlogeventservice.publishWebCalloutEvent(obj);
        System.assertNotEquals(obj, null);
        Test.stopTest();
    }
    
    /**
     * @author : Sunil
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * PublishLogEventService class.
    */
    @isTest
    static void publishExceptionSalesforceLogDataNewone() {
        Test.startTest();
        	Exception e ;
      		Exceptionlogwrapper obj = new Exceptionlogwrapper();
            obj.debugMessage = 'Error in the process builder-Notify Users';
            obj.debuglevel = 'Error';
            obj.logCode='1001'; 
            obj.source='PCMUserNotificationController';
            obj.sourceFunction='notifyUsers';
            obj.ex = e;
            publishlogeventservice.publishExceptionEvent(obj);
            System.assertNotEquals(obj, null);
        Test.stopTest();
    }
   
}