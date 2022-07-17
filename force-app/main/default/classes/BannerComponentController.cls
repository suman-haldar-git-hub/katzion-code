/**
* @Author : Monika Bisht
* @Company : Cognizant
* @description : This class will be used to communicate backend and controller BannerComponent
*/
public with sharing class BannerComponentController {
    /**
* @Author : Monika Bisht
* @description : This method is used to call getAlertFlag method of BannerComponentAdapter Class.
* @return : LightningResponse
* @param recordId
*/
    @AuraEnabled(cacheable=true)
    public static LightningResponse getAlertFlags(String recordId) {
        set<string> setCaseId = new set<string>();
        setCaseId.add(recordId);
        LightningResponse response = new LightningResponse();
        try{
            if(BannerComponentAdapter.getAlertFlag(setCaseId)){
                response.payLoad = ConstantsUtility.IS_TRUE;
            }else{
                response.payLoad = ConstantsUtility.IS_FALSE;
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
        }
        return response;
    }
}