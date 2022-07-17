/**
* @author : Sunil Kumar
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for SalarySacrificeContent component related logic
*/
public with sharing class SalarySacrificeContainerController {
    /**
    * @author : Sunil
    * @description : This method is used to fetch Form__c data on load.
    * @param isDesktop
    * @param isMobile
    * @return : LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getFormDataOnLoad(Boolean isDesktop, Boolean isMobile) {
        return SalarySacrificeContainerService.getFormData(isDesktop, isMobile);
    }
   
}