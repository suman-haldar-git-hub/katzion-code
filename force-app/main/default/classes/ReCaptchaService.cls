/**
 * @description       : This is the service class which is used to validate 
 *                      the recaptcha at the server side based on the response token.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-20-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-13-2021   Prathamesh Lad   Initial Version
**/
public with sharing class ReCaptchaService {
    /**
	* @description This method is used to verify recaptcha
	* @author Prathamesh Lad | 07-14-2021 
	* @param recaptchaResponse
    * @param webformName 
	* @return String 
	**/
	public static Boolean verifyCaptcha(String recaptchaResponse, String webformName){
        try{
            if(webformName==null || String.isBlank(webformName)){
                webformName='All';            
            }
            
            List<ReCaptchaMaster__mdt> listRecaptchaMaster
                = ReCaptchaMasterDomain.getRecaptchaMasters(webformName);

            if(listRecaptchaMaster!=null && listRecaptchaMaster.size()>0){
                String recaptchaSecretKey=listRecaptchaMaster[0].Secret_Key__c;
                String requestBody='secret=' + recaptchaSecretKey + '&response=' + recaptchaResponse;
                String endPoint=Label.ReCaptchaV2EndPoint;
                HttpResponse response =HTTPCalloutService.makeCallout(requestBody,endPoint,'POST');
                if (response.getStatusCode() == 200) {
                    Map<String, Object> result 
                        = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    if(result.containsKey('success') && result.get('success') == true) {					
                            return true;
                    }
                else{
                        return false;
                    }
                }
            }
        }
        catch(Exception e){
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = 'ReCaptchaService';
            logExceptionEvent.SourceFunction__c = 'verifyCaptcha';
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        return false;
	}


	/**
	* @description This method is used to get Recaptcha Setting from Custom metadata
	* @author Prathamesh Lad | 07-20-2021 
	* @param webformName 
	* @return lightningResponse 
	**/
    @AuraEnabled
	public static lightningResponse getReCaptchMasters(String webformName){
        lightningResponse response = new lightningResponse();
        try{
            response.isError = false;
            
            if(webformName==null || String.isBlank(webformName)){
                webformName='All';            
            }
            List<ReCaptchaMaster__mdt> listRecaptchaMaster
                = ReCaptchaMasterDomain.getRecaptchaMasters(webformName);
    		
            if(listRecaptchaMaster!=null && listRecaptchaMaster.size()>0){
            	response.payload = JSON.serialize(listRecaptchaMaster);
            }else{
				throw new IllegalArgumentException('Invalid Form Name');				
            }    
        }
        catch(Exception e){
            response.isError = true;
            response.errorType = e.getTypeName();
            response.errorOrSuccessMessage = e.getMessage();

            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = 'ReCaptchaService';
            logExceptionEvent.SourceFunction__c = 'getReCaptchMasters';
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        return response;
    }    

}