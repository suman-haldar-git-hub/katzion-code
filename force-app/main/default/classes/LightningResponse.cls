/**
@author : Praveen Tiwari
@company : Cognizant
@description : This class is used to send the response to a lightning component
*/

public with sharing class LightningResponse {
    @AuraEnabled public String payLoad;
    @AuraEnabled public String title;
    @AuraEnabled public Boolean isError;
    @AuraEnabled public String errorOrSuccessMessage;
    @AuraEnabled public String errorType;
    @AuraEnabled public Boolean hasObjectAccess;

    /**
* @author : Praveen Tiwari
* @description : This method is a contructor of the wrapper class.
*/
    public LightningResponse() {
        this.payLoad = '';
        this.title = '';
        this.isError = false;
        this.errorOrSuccessMessage = '';
        this.errorType = '';
        this.hasObjectAccess = false;
    }
}