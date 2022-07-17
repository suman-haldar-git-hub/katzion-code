/**
 * @description       : This is test class for  RecaptchaService 
 *                      to cover positive and negative scenarios
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-15-2021   Prathamesh Lad   Initial Version
**/
@isTest
public class RecaptchaServiceTest {
    
    private static testmethod void testVerifyCaptcha1() {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ReCaptchaService_MockHttpRespGenerator());
        Boolean flag=ReCaptchaService.verifyCaptcha('captchaTokenstr','All');
        Test.stopTest();
        System.assertEquals(true, flag);        
    }
    
    private static testmethod void testVerifyCaptcha2() {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ReCaptchaService_MockHttpRespGenerator());
        Boolean flag=ReCaptchaService.verifyCaptcha('captchaTokenstr',null);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    private static testmethod void testVerifyCaptcha3() {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ReCaptchaService_MockHttpRespGenerator1());
        Boolean flag=ReCaptchaService.verifyCaptcha('captchaTokenstr','All');
        Test.stopTest();
        System.assertEquals(false, flag);        
    }
    
    private static testmethod void testGetReCaptchMasters1() {        
        Test.startTest();
        lightningResponse resp=ReCaptchaService.getReCaptchMasters('All');
        Test.stopTest();
        System.assertEquals(false, resp.isError);
    }
    
    private static testmethod void testGetReCaptchMasters2() {        
        Test.startTest();
        lightningResponse resp=ReCaptchaService.getReCaptchMasters(null);
        Test.stopTest();
        System.assertEquals(false, resp.isError);
    }
    
    private static testmethod void testGetReCaptchMasters3() {        
        Test.startTest();
        lightningResponse resp=ReCaptchaService.getReCaptchMasters('INVALID');
        Test.stopTest();
        System.assertEquals(true, resp.isError);
    }
}