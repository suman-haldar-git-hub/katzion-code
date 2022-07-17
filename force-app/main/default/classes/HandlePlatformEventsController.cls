/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used on streaming api LWC.
*/
public with sharing class HandlePlatformEventsController {
    /**
    * @author Ankit Singh
    * @description This methods retuen the curent user session id.
    * @return String
    */
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
}