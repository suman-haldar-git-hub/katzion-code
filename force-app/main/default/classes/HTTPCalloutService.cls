/**
 * @description       : This is the HTTP Framework class to make callouts.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-14-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-13-2021   Prathamesh Lad   Initial Version
**/
public with sharing class HTTPCalloutService {
    /**
    * @description  This method is used to make Callout request.
    * @author Prathamesh Lad | 07-13-2021 
    * @param requestBody 
    * @param endPoint 
    * @param methodType
    * @return HTTPResponse  
    **/
    public Static HTTPResponse makeCallout(String requestBody,
                            String endPoint,
                            String methodType
    ){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(methodType);
        request.setBody(requestBody);
        
        Http http = new Http();
        return http.send(request);
    }
}
