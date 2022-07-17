@isTest
global class RTWGoogleReCaptcha_MockHttpRespGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals(Label.PC_GoogleReCaptcha_BaseURL, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        String respStr = '{"success": true, ' +
            ' "challenge_ts": "' + System.now() +'", '+
            ' "hostname": "'+ Label.RTW_FormSubmissionURL +'", '+
            ' "score": 0.9, "action": "RTWWebToCase"}';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(respStr);
        res.setStatusCode(200);
        return res;
    }
}