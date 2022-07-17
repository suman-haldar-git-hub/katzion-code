/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for User object.
*/
public with sharing class UserDomain {
    /**
    * @author : Daksh Madan
    * @description : This method is used to query data for User object based on userId.
    * @return : User
    * @param userId
    */
    public static User queryUserBasedOnId(String userId){
        return [SELECT EmployeeID__c,name,IsActive, WalkThroughCompleted__c,TimeZoneSidKey,
                Email,UserName
               from User where Id =: userId];
    }

    /**
    * @author : Ankit Singh
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to query data for User object based on employee Id
    * @param setOfEmployeeId
    * @return List<User>
    */
    public static List<User> queryUserFromEmployeeIdSet(Set<String> setOfEmployeeId) {
        return [
            SELECT Id, Area__c, Department__c, EmployeeID__c, JobTitle__c, Location__c,
            Region__c, Profile.Name, LineManager__c,
            (
                SELECT Id, PermissionSetId, PermissionSet.Name,
                AssigneeId, PermissionSet.Description
                FROM PermissionSetAssignments
                WHERE PermissionSet.Description =:
                Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES
            )
            FROM User
            WHERE EmployeeID__c IN: setOfEmployeeId
            AND IsActive = True
        ];
    }
    /**
    * @author : Daksh Madan
    * @description : This method is used to query data for User object based on Manager Id
    * where EmployeeID__c != null.
    * @return : List<User>
    * @param managerId
    public static List<User> queryUserListFromManagerId(String managerId){
        return [
            SELECT EmployeeID__c
            FROM User
            WHERE ManagerId =: managerId
            AND EmployeeID__c != null
        ];
    }
    */

    /**
    * @author : Ankit Singh
    * @description : This method is used to query data for User object from Line Manager
    * @return : List<User>
    * @param lineManager
    */
    public static List<User> queryUserListFromLineManager(String lineManager){
        return [
            SELECT Id, EmployeeID__c
            FROM User
            WHERE EmployeeID__c =: lineManager
        ];
    }

    /**
    * @author : Daksh
    * @description : This method is used to query data for User object based on Employee id
    * Or Line manager Id.
    * @return : List<User>
    * @param empIdSet
    */
    public static List<User> getUserRecords(Set<String> empIdSet){
        List<User> userList = new List<User>();
        userList = [
            SELECT Id, EmployeeID__c, SmallPhotoUrl, FullPhotoUrl
            FROM User
            WHERE EmployeeID__c != null
            AND EmployeeID__c IN: empIdSet
        ];
        return userList;
    }
     /**
    * @author : Monika Bisht
    * @description : This method is used to query data for User object based on user name
    * @return : User
    * @param selectedUserName
    */
    public static User searchCTorBUAdminUser(string selectedUserName){
        return [
            SELECT Id, Name
            FROM User
            WHERE Name =: selectedUserName
            Limit 1
        ];
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used to get Logged in User Profile Name
    * @return : String
    */
    public static String queryLoggedInUserProfileName() {
        User loggedInUser =  new User();
        loggedInUser = [
            SELECT Id, Profile.Name
            FROM User
            WHERE Id =: UserInfo.getUserId() Limit 1
        ];
        return loggedInUser.Profile.Name;
    }
     /**
    * @author : Monika Bisht
    * @description : This method is used to query data where employee id is equal to account employee id for UTL
    * @return : List<user>
    * @param mapOfAccEmpId
    */
    public static List<user> userEmpIdMatchesWithAccEmpId(set<string> mapOfAccEmpId){
        return[
            select id,name,EmployeeID__c from user where EmployeeID__c IN: mapOfAccEmpId 
            AND IsActive = true // This check is added for TH-3083 by Amit Sharma 21/4/21
        ]; 
    }

    /**
    * @author : Sunil
    * @description : This method is used to query data for User object based on Employee id
    * Or Line manager Id.
    * @return : Map<User>
    * @param empIdSet
    * @param setStatus
    * @param setRecType
    */
    public static List<User> getUserRecordsForComm(List<String> empIdSet,
    Set<String> setStatus,
    Set<String> setRecType){
        List<User> userList = new List<User>();
        userList = [
            SELECT Id, EmployeeID__c, DailySummaryDigestNotification__c,
            WeeklySummaryDigestNotification__c,DailySummaryDigestNotificationChannel__c,
            WeeklySummaryDigestNotificationChannel__c,
            LeaveNotificationChannel__c,LeaveNotification__c, TaskNotification__c,
            TaskNotificationChannel__c, CommunicationNotification__c,
            CommunicationNotificationChannel__c,
            (
            Select id, RecordType.DeveloperName, Status__c
            FROM SubmittedForUser__r
            WHERE RecordType.DeveloperName IN :
            setRecType
            AND
            Status__c IN : setStatus
            )
            FROM User
            WHERE EmployeeID__c != null
            AND EmployeeID__c IN: empIdSet
            AND isActive = true
        ];
        return userList;
    }
    /**
    * @author : Sunil
    * @description : This method is used to query data for User object based on Employee id
    * Or Line manager Id.
    * @return : Map<User>
    * @param empIdSet
    */
    public static List<User> getUserRecordsForUtl(List<String> empIdSet){
        List<User> userList = new List<User>();
        userList = [
            SELECT Id, EmployeeID__c, DailySummaryDigestNotification__c,
            WeeklySummaryDigestNotification__c,DailySummaryDigestNotificationChannel__c,
            WeeklySummaryDigestNotificationChannel__c,
            LeaveNotificationChannel__c,LeaveNotification__c, TaskNotification__c,
            TaskNotificationChannel__c, CommunicationNotification__c,
            CommunicationNotificationChannel__c
            FROM User
            WHERE EmployeeID__c != null
            AND EmployeeID__c IN: empIdSet
            AND isActive = true
        ];
        return userList;
    }
    /**
    * @author : Daksh Madan
    * @description : This method is used to get user record for which campaign member
    * should be created or not.
    * @return : isCreate
    * @param empId
    */
    public static boolean checkWhetherToCreateCampMemRecd(String empId){
        List<User> userList = [
            SELECT Id
            FROM User
            WHERE EmployeeID__c =: empId
            AND LeaveNotification__c = true
            AND LeaveNotificationChannel__c includes ('Email')
        ];
        if(userList.isEmpty()) {
            return false;
        }
        return true;
    }

    /**
    * @author : Praveen Tiwari
    * @description : This method is used to perform DML on User object by "Updating".
    * @param userList
    */
    public static void updateUserList(List<User> userList){
        if(Schema.sObjectType.User.isUpdateable()){
            Database.update(userList);
        }
    }
    /**
    * @author : Amit Sharma
    * @description : This method is used to get List of user record based on employee Id
    * @return : List<User> - return all valid Users based on employee id
    * @param setEmployeeId - set of employee Id
    */
    public static List<User> getCatsUserList(Set<String> setEmployeeId){
        List<User> userList = [SELECT Id,EmployeeID__c
                 FROM User
                WHERE EmployeeID__c In: setEmployeeId AND TaskNotification__c =: true
                AND ReceiveTaskNotificationsFor__c INCLUDES('CATS') AND
                IsActive =: true];
        return userList;
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to get map of User Id and User
    * @return : Map<Id,User>
    * @param setOwnerId - set of user id
    */
    public static Map<Id,User> getUserIdAndUserRecord(set<Id> setOwnerId){
        Map<Id,User> mapUserIdAndUser = new Map<Id,User> ();
        for(User objUser :  [SELECT Id,ReceiveTaskNotificationsFor__c,
                              TaskNotificationChannel__c,TaskNotification__c
                            FROM User
                        Where Id in: setOwnerId AND TaskNotification__c =: true AND
                        TaskNotificationChannel__c INCLUDES ('Email') AND
                        IsActive =: true]){
            mapUserIdAndUser.put(objUser.id,objUser);               
        }
        return mapUserIdAndUser;
        
    }
     /**
    * @author : Sunil Kumar
    * @description : This method is used to query data for User object based on user name
    * @return : User
    * @param usrName
    */
    public static User searchUserByUserName(string usrName){
        return [
            SELECT Id, Name
            FROM User
            WHERE Username like:usrName+'%'
            Limit 1
        ];
    }
        
     /**
    * @author : Akshansh Jain   
    * @description : This method is used to query data for User object based on user Id
    * @return : List<User>
    * @param userId
    */
    public static List<User> getUsersProfile(List<Id> userId){
        return[
            select id,name,Profile.Name from user where Id IN: userId  
        ];
    }

    /**
    * @description This method is used to query User object based on Email.
    * @author Prathamesh Lad | 04-07-2021 
    * @param listEmail 
    * @return List<User> 
    **/
    public static List<User> getUserDetails(List<String> listEmail){
        List<User> listUsers=[Select id from User where Email IN:listEmail 
                              and isActive=true];
        return listUsers;
    }
    
    /**
    * @description This method is used to query Roles.
    * @author Monika Bisht
    * @param setuserIds 
    * @param setRoleNames 
    * @return List<User> 
    **/
    public static List<User> getUserBasedOnRoles(set<String> setuserIds,Set<string> setRoleNames){
        return [select id,name from user where UserRole.Name in:setRoleNames and Id in:setuserIds];
    }
    
}