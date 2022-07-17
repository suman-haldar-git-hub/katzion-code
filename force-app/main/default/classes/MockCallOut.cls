/**
 * @description       : This class is used to do a mock callout for Test execution scenarios of Apex classes where HTTP call out is done.
 * @author            : Aman Kumar
 * @group             : 
 * @last modified on  : 03-10-2022
**/
@isTest
public class MockCallOut implements HttpCalloutMock {

        /**
     * @description       : To send a Mock Response.
     * @author            : Aman Kumar
     * @group             : 
     * @last modified on  : 03-10-2022
     * @param request
     * @return: HTTPResponse
    **/
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal": {"id":2, "name":"Test"}}');
        response.setStatusCode(200);
        return response; 
    }
}