@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global static boolean isBadRequest = false;
    // Implement this interface method
    /**
    * @Author : Sunil
    * @description : This method is used to return fake response.
    * @return HTTPResponse
    * @param req
    */
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        if(!isBadRequest){
            res.setStatusCode(200);
            }
            else{
                res.setStatusCode(400);
            }
        return res;
    }
}