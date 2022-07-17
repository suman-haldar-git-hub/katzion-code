/**
 * @description       : This class is used to get the access token for Wow automation user.
 * @author            : Aman Kumar
 * @group             : 
 * @last modified on  : 03-10-2022
**/
public without sharing class FileUploadService {

        /**
     * @description       : This method is called form the customFileUpload LWC component to get the access token for the WOW Automation user
     * @author            : Aman Kumar
     * @group             : 
     * @return            : ResponseWrapper
     * @last modified on  : 03-10-2022
    **/
    @AuraEnabled 
    public static ResponseWrapper  getAccessToken(){
        // While custom setting creation the site guest user or it's profile is not reflected by salesforce for the location value and 
        // hence query done to get the WOW Automation user since for protected custom setting location value this user is selected
        User wowAutomationUser = [SELECT Id FROM USER WHERE CommunityNickname='User16245007591349291131' LIMIT 1];
  
        // Custom setting query
        Salesforce_File_Upload_Pre_Requisites__c cs = Salesforce_File_Upload_Pre_Requisites__c.getInstance(wowAutomationUser.Id);

        // Getting the instance type
        String endpointURL = UtilityClass.runningInASandbox ? 'https://test.salesforce.com/services/oauth2/token' : 'https://login.salesforce.com/services/oauth2/token';
		
        // Request Body creation for the HTTP call
        String reqbody = 'grant_type=password&client_id='+cs.Client_Id__c+'&client_secret=' +cs.Client_Secret__c+'&username='+cs.UserName__c+'&password='+cs.Password__c;
        
        //Creation of HTTP request 
        Http h= new Http();
        HttpRequest req= new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(endpointURL);
        //req.setEndpoint('callout:File_Upload_API');
        HttpResponse res=h.send(req);
        
        ResponseWrapper wResp = (ResponseWrapper) JSON.deserialize(res.getBody(), ResponseWrapper.class);
       
        return wResp;
    }

      /**
     * @description       : This method is called form the customFileUpload LWC component to get the access token for the WOW Automation user
     * @author            : Aman Kumar
     * @group             : 
     * @last modified on  : 03-10-2022
    **/
    public class ResponseWrapper {
        @AuraEnabled  public string id;
        @AuraEnabled  public string access_token; //cannot changethe varibale name as it is directly being with response via JSON.deserialize.
        @AuraEnabled  public string instance_url; //cannot changethe varibale name as it is directly being with response via JSON.deserialize.
    }
}