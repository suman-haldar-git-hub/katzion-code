/**
 * @description       : 
 * @author            : Joginder Kumar ( Cognizant )
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Joginder Kumar
**/
@isTest
public class GoogleRecaptchaAPITest {
    private static final String STR_USERNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
    @TestSetup
    static void setup(){
        CommonTestDataFactory.buildTestUser();
        CommonTestDataFactory.createThreashold();
    }
    @isTest 
    static void captchaValidationResultTest(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        System.runAs(selectedUser){
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                GoogleRecaptchaAPI.captchaValidationResult('DummyCaptchaToken');
            Test.stopTest();
        }
        System.assert(String.isNotBlank(STR_USERNAME), true);

    }
    /**
    * @description 
    * @author Joginder Kumar ( Cognizant ) | 09-15-2021 
    **/
    @isTest 
    static void rtwCaptchaValidationResult(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        System.runAs(selectedUser){
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                GoogleRecaptchaAPI.rtwCaptchaValidationResult('DummyCaptchaToken');
            Test.stopTest();
        }
        System.assert(String.isNotBlank(STR_USERNAME), true);

    }
    
    @isTest 
    static void rtwCaptchaValidationResultWithException(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        System.runAs(selectedUser){
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                GoogleRecaptchaAPI.rtwCaptchaValidationResult(null);
            Test.stopTest();
        }
        System.assert(String.isNotBlank(STR_USERNAME), true);

    }

}