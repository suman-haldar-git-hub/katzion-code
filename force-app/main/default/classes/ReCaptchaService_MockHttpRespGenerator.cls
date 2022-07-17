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
global class ReCaptchaService_MockHttpRespGenerator implements HttpCalloutMock {
    /**
    * @description This method is used to create mock response
    * @author Prathamesh Lad | 07-15-2021 
    * @param req 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest req) {
        String respStr = '{"success": true}';        
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(respStr);
        res.setStatusCode(200);
        return res;
    }
}
