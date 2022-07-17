/**
* @author : Praveen Tiwari
* @company : SaaSFocus A Cognizant Company
* @description : This is the controller class of CommonLeaveApplicationComp
*/
public with sharing class CommonLeaveApplicationFlowController {
	/**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for cashout leave Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getDataForCashoutFlow() {
        return CommonLeaveApplicationService.getCashoutData();
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for purchase leave Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getDataForPurchaseFlow() {
        return CommonLeaveApplicationService.getPurchaseLeaveData();
    }
}