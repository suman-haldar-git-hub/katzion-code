@isTest
global class GoogleReCaptcha_MockHttpRespGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals(Label.GoogleReCaptcha_BaseURL, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        String respStr = '{"success": true, ' +
            				' "challenge_ts": "' + System.now() +'", '+
            				' "hostname": "'+ Label.Google_reCaptcha_Page +'", '+
            				' "score": 0.9, "action": "Webform"}';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(respStr);
        res.setStatusCode(200);
        return res;
    }
}