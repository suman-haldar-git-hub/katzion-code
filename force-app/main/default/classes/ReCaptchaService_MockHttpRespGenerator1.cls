/**
 * @description       : This class is used to create mock response
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-15-2021   Prathamesh Lad   Initial Version
**/
@isTest
global class ReCaptchaService_MockHttpRespGenerator1 implements HttpCalloutMock {
    /**
    * @description This method is used to create mock response
    * @author Prathamesh Lad | 07-15-2021 
    * @param req 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest req) {
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        throw e;
    }
}