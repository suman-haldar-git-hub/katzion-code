/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of WalkThroughTooltip Cmp.
*/
public without sharing class WalkThroughTooltipController {
    /**
    * @author : Ankit Singh
    * @description : This method is used to update the Walk me detail on Account for User.
    * @return : LightningResponse
    * @param  completedWalkThrough
    */
    @AuraEnabled
    public static LightningResponse updateWalkMeDetailOfUser(
        String completedWalkThrough
    ) {
        LightningResponse response = new LightningResponse();
        try{
            if(String.isNotBlank(completedWalkThrough)) {
                User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
                String walkthroughCompleted = String.isNotBlank(userDetail.WalkThroughCompleted__c) ?
                    userDetail.WalkThroughCompleted__c + ';'+ completedWalkThrough :
                    completedWalkThrough;
                User objUser = new User(
                    Id = UserInfo.getUserId(),
                    WalkThroughCompleted__c = walkthroughCompleted
                );
                UserDomain.updateUserList(new List<User> {objUser});
            }
            response.isError=false;
        }
        catch(Exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                    'WalkThroughTooltipController.cls in updateWalkMeDetailOfUser method',
                    ex
            );
        }
        return response;
    }
}