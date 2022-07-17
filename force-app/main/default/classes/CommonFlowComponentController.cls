/**
* @author : Sunil Kumar
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for CommonFlowComponent component related logic
*/
public with sharing class CommonFlowComponentController {
    /**
    * @author : Sunil
    * @description : This method is used to fetch required data for Device Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getDataForDeviceFlow() {
        return CommonFlowComponentService.getDeviceData();
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for myIncentive Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getDataFormyIncentiveFlow() {
        return CommonFlowComponentService.getIncentiveData();
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return the Case
    * @return Case
    * @param caseId
    */
    @AuraEnabled
    public static LightningResponse getCaseRecordDetail(Id caseId) {
        return CommonFlowComponentService.getCaseRecordDetail(caseId);
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to return the Form details
    * @return Case
    * @param formId
    */
    @AuraEnabled
    public static Form__c getFormRecordDetail(Id formId) {
        return FormDomain.getFormDataOnLoad(formId);
    }

}