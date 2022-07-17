/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of BaseCommunityLayout Cmp.
*/
public without sharing class BaseCommunityLayoutController {
    /**
    * @author : Daksh
    * @description : This method is used to fetch all data on load.
    * @return : LightningResponse
    */
    @AuraEnabled
    public static LightningResponse fetchRequiredDataOnLoad(){
        return BaseCommunityLayoutService.getVerticalMgmtWrapperData();
    }
    /**
    * @author : Ankit Singh
    * @description : This method is used to update the Walk me detail on Account for User.
    * @return : LightningResponse
    * @param  walkThrough
    */
    @AuraEnabled
    public static LightningResponse completeWalkMeDetailOfUser(String walkThrough) {
        LightningResponse response = new LightningResponse();
        try{
            User objUser = new User(
                Id = UserInfo.getUserId(),
                WalkThroughCompleted__c = walkThrough
            );
            UserDomain.updateUserList(new List<User> {objUser});
            response.isError=false;
        }
        catch(Exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                    'BaseCommunityLayoutController.cls in completeWalkMeDetailOfUser method',
                    ex
            );
        }
        return response;
    }
   /**
    * @author : SunilKumar
    * @description : This method call the Learning API
    */
    @AuraEnabled
    public static void callLearningAPI(){
        GetEmployeeData.getData();
    }


    /**
     * @author      Abhishek Setia
     * @description Returns JWT token used in ChatBot
     * @param       formFactor
     * @return      String
     */ 
    @AuraEnabled
    public static String getJWTToken(String formFactor){
        return BaseCommunityLayoutService.getJWTTokenService(formFactor);        
    }
}