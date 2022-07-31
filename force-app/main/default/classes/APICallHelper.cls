public class APICallHelper{

    @future(callout=true)
    public static void doAPICall(String jsonRequestBody, String endPointUrl) {
        system.debug('jsonRequestBody -->'+jsonRequestBody);
        
        // Creating the call out code
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setEndPoint(endPointUrl); // This URL is also to be set in a remote site setting for URL whitelisting
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Set the body as a JSON object
        request.setBody(jsonRequestBody);
        
        HttpResponse response = http.send(request); // Doing the rest call out
        
        // Parse the JSON response
        if (response.getStatusCode() == 200) {
            // Do things post successfull execution of the api call    
        } else {
            System.debug(response.getBody());// Store this message in some custom object to do the RCA
        }
    }
}
