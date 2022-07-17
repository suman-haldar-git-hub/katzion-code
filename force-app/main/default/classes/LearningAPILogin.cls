/**
@author : Sunil
@company : Cognizant
@description : This class is used for LearningAPILogin.
*/
global class LearningAPILogin{
    /**
    * @author : Sunil
    * @description : This method is used for LearningAPILogin.
    * @return String
    */
    global static String login(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LearningAPI');
        req.setMethod('POST');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        if(String.valueOf(res.getStatusCode()).StartsWith('2')){
        map<String,object> objmp = (map<String,object>)JSON.deserializeUntyped(res.getBody());
        System.debug(objmp.get('access_token'));
        return string.valueOf(objmp.get('access_token'));
        }
        return null;
    }
}