/**
* @author : Sunil Kumar
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for DistributionListPreview component related logic
*/
public with sharing class DistributionListPreviewController {
    /**
    * @author : Sunil
    * @description : This method is used to fetch DistributionList__c data on load.
    * @return LightningResponse
    * @param recordId
    */
    @AuraEnabled
    public static LightningResponse getReportData(String recordId) {
        return DistributionListPreviewService.generateReport(recordId);
    }
   
}