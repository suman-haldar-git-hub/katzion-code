/***
* @description     	GoogleRecaptchaAPI
* @author          	Ashish Takke
* @date            	18/03/2020
* @company         	Woolworths
* last modified		v2.0 - Ashish Takke - 06/05/2020 - reCaptcha Implementation for Return to work project
*/
global with sharing class GoogleRecaptchaAPI {
    public static String baseUrl = Label.GoogleReCaptcha_BaseURL;
    public static String reCaptchaSecretKey = '';
    public static String rtwReCaptchaSecretKey = '';
    public static String rtwReCaptcha2SecretKey = '';
    
    static {
        ReCaptcha__c primConnCustSettings = ReCaptcha__c.getInstance();
        reCaptchaSecretKey = primConnCustSettings.ReCAPTCHA_v3_Secret_Key__c; 
        Return_to_Work_Settings__c rtwConnCustSettings = Return_to_Work_Settings__c.getInstance();
        rtwReCaptcha2SecretKey = rtwConnCustSettings.RTW_reCAPTCHA_v2_Secret_Key__c;

    }
    
    /**
    * Make request to verify captcha and check response for "National Transport" forms
    * @return      response message from google
    */
    /**
     * @description captchaValidationResult
     * @return response message from google
     */
    public static Boolean captchaValidationResult(String captchaToken){
        String responseBody = makeRequest(baseUrl,
                                          'secret=' +reCaptchaSecretKey +
                                          '&response='+ captchaToken
                                         );
        String captchaSuccess = getValueFromJson(responseBody, 'success');
        if(captchaSuccess.equalsIgnoreCase('true')){
            Double thresholdScore = ReCaptcha__c.getInstance().ReCaptcha_Threshold_Score__c;
            String score = getValueFromJson(responseBody, 'score');
            System.debug('score'+score);
            return (Double.valueOf(score) > thresholdScore);
        }
        return false;
    }
    
	
     /**
    * @description Make request to verify captcha and check response for "Return to Work" forms
    * @author Joginder Kumar ( Cognizant ) | 09-15-2021 
    * @param captchaToken 
    * @return Boolean (response message from google)
    **/
    public static Boolean rtwCaptchaValidationResult(String captchaToken){
        try{
            
            if(String.isBlank(captchaToken)){
                throw new AuraHandledException('captchaToken can not be blank or null');
            }
            String responseBody = makeRequest(baseUrl,
                                            'secret=' +rtwReCaptcha2SecretKey+
                                            '&response='+ captchaToken
                                            );
            String captchaSuccess = getValueFromJson(responseBody, 'success');
            if(captchaSuccess.equalsIgnoreCase('true')){
                Double thresholdScore = PC_Primary_Connect_Setting__c.getInstance().PC_reCaptcha_Threshold_Score__c;
                if(responseBody.contains('score') && thresholdScore!=null){
                    String score = getValueFromJson(responseBody, 'score');
                    if(!String.isBlank(score)){
                        return (Double.valueOf(score) > thresholdScore);
                    }
                }
                return true; 
            }
            return false;
        }catch(Exception e){
            PublishLogEventService.publishExceptionEvent(
                'GoogleRecaptchaAPI.cls on rtwCaptchaValidationResult',
                e
            );
            return false;
        }
    }    
    
    /**
    * Make request to verify captcha
    * @description makeRequest
    * @return      response message from google
    */
    
    public static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        
        try {
            Http http = new Http();
            response = http.send(req);
            return response.getBody();
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
            return '{"success":false, "error":'+e+'}';
        }
    }
    
    /**
    * to get value of the given json string
    * @return          string value
    * @description getValueFromJson
    */
    public static String getValueFromJson ( String strJson, String field ){
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            //System.debug('@@parser.getCurrentToken()::-'+parser.getCurrentToken()+'*****'+JSONToken.FIELD_NAME);
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                //System.debug('@@parser.getText()'+parser.getText());
                if(parser.getText() == field){
                    ///////////////////////////
                    //parser.nextValue();
                    //system.debug('parser.nextValue()'+parser.nextValue());
                    //system.debug('parser.nextToken()'+parser.nextToken());
                    //system.debug('parser.getCurrentName())'+parser.getCurrentName());
                    //////////////////////////////////////
                    
                    // Get the value.
                    parser.nextToken();
                    if(field == 'success'){
                        //return String.valueOf(parser.nextValue()).split('_')[1];
                        return String.valueOf(parser.getBooleanValue());
                    } else if(field == 'score'){
                        return String.valueOf(parser.getDoubleValue());
                    }
                }
                
            }
        }
        return null;
    }
}