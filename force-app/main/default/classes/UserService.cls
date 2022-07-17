/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used as service class for user object.
*/
public with sharing class UserService {
    /**
    * @author :Ankit Singh
    * @description : This method get map of EmployeeId to Small Photo Url
    * @param setOfTeamEmployeeId
    * @param myTeamWrapper
    * @return employeeIdToSmallPhotoUrl
    */
    public static Map<String, String> getEmployeeIdToUserSmallPhoto(
        Set<String> setOfTeamEmployeeId,
        MyTeamLeaveService.MyTeamWrapper myTeamWrapper
    ) {
        List<User> lstUser = new List<User>();
        Map<String, String> employeeIdToSmallPhotoUrl = new Map<String, String>();
        if(
                myTeamWrapper.wrapData != null
                &&
                !myTeamWrapper.wrapData.isEmpty()
        ) {
            lstUser = UserDomain.getUserRecords(setOfTeamEmployeeId);
        }
        if(lstUser != null && !lstUser.isEmpty()) {
            for(User eachUser : lstUser) {
                employeeIdToSmallPhotoUrl.put(eachUser.EmployeeID__c, eachUser.SmallPhotoUrl);
            }
        }
        return employeeIdToSmallPhotoUrl;
    }

    /**
    * @author :Ankit Singh
    * @description : This method get map of EmployeeId to User Id
    * @param setOfTeamEmployeeId
    * @return employeeIdToUserId
    */
    public static Map<String, Id> getEmployeeIdToUserId(
        Set<String> setOfTeamEmployeeId
    ) {
        List<User> lstUser = new List<User>();
        Map<String, Id> employeeIdToUserId = new Map<String, Id>();
        if(
                setOfTeamEmployeeId != null
                &&
                !setOfTeamEmployeeId.isEmpty()
        ) {
            lstUser = UserDomain.getUserRecords(setOfTeamEmployeeId);
        }
        if(lstUser != null && !lstUser.isEmpty()) {
            for(User eachUser : lstUser) {
                employeeIdToUserId.put(eachUser.EmployeeID__c, eachUser.Id);
            }
        }
        return employeeIdToUserId;
    }


    /**
     * author       Abhishek Setia
     * @description Returns Map of UserId, Username
     * @param       userids
     * @return      Map<Id,String>
     */
    public static Map<Id,String> getIdUsernameMap(Set<Id> userids){
        List<User> listUsr=UserDomain.getUsersProfile(new List<Id>(userids));
        Map<Id,String> mIdUsername=new Map<Id,String>();
        for(User usr:listUsr){
            mIdUsername.put(usr.Id, usr.Name);
        }
        return mIdUsername;
    }
    
    /**
     * author       Tintu Babu
     * @description Logic will be executed when profile is changed and User's profile is changed to one with LicenseSalesforce Platform.
     * 				Marketing User, Chat User, Service cloud User and Forecast Checkbox which is not available for  Salesforce Platform License will be unchecked.
     * 				Added as a part of IAM - Sailpoint Integration User Provisioning. ECICD-1349
     * @param       New User List, Ols User Map
     */
    public static void uncheckUserSettings(List<User> newUserList, Map<Id,User> oldUserMap) {
         Map<ID, Profile> pidMap = new Map<ID, Profile>([Select id From Profile  where UserLicense.Name  ='Salesforce Platform']);
         for(User usr:newUserList){
              if(oldUserMap != null && oldUserMap.ContainsKey(usr.Id) && (oldUserMap.get(usr.Id).ProfileId != usr.ProfileId)  && (pidMap.keySet().contains(usr.ProfileId))){
                  if(usr.UserPermissionsMarketingUser)usr.UserPermissionsMarketingUser =false;
                  if(usr.UserPermissionsSupportUser) usr.UserPermissionsSupportUser =false;
                  if(usr.UserPermissionsLiveAgentUser) usr.UserPermissionsLiveAgentUser =false;
                  if(usr.ForecastEnabled) usr.ForecastEnabled = false;
             }
         }
    }
}