/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This batch class is used to sync user detail from Account.
*/
public inherited sharing class SyncUserFromAccountBatchService {
    private static String areaPrefix = 'Area - ';
    
    /**
* @author : Ankit Singh
* @description : This method update permission set for user
* @param userList
* @param employeeIdToAccountMap
*/
    public static void handlePermissionSetAssignment(
        List<User> userList,
        Map<String, Account> employeeIdToAccountMap
    ) {
        try{
            List<PermissionSetAssignment> deletePermissionSet = new List<PermissionSetAssignment>();
            List<PermissionSetAssignment> insertNewPermission = new List<PermissionSetAssignment>();
            Map<String, Id> permssionSetNameToId = new Map<String, Id>();
            Map<String, Id> permssionSetApiNameToId = new Map<String, Id>();
            Map<String, DataCategoryPermissionSetMapping__mdt> primaryKeyToPermissionSetApiMap = new
                Map<String, DataCategoryPermissionSetMapping__mdt>();
            Map<String, Map<String, Id>> permissionSetMapping = new Map<String, Map<String, Id>>();
            permissionSetMapping = getPermissionSetNameToIdMap();
            permssionSetNameToId = DataCategoryMappingService.getPermissionNameToId(
                'Label',
                permissionSetMapping,
                permssionSetNameToId
            );
            permssionSetApiNameToId = DataCategoryMappingService.getPermissionNameToId(
                'ApiName',
                permissionSetMapping,
                permssionSetApiNameToId
            );
            primaryKeyToPermissionSetApiMap = DataCategoryMappingService.getMappingFromMetadeta();
            for(User eachUser : userList) {
                // deletion of existing permission set assignment of TM
                deletePermissionSet = getDeletedPermissionSet(eachUser, deletePermissionSet);
                // creation of new Permission Set Assignment for TM
                Account objAccount = employeeIdToAccountMap.get(eachUser.EmployeeID__c);
                if(
                    objAccount != null
                    &&
                    permssionSetNameToId != null
                    &&
                    !permssionSetNameToId.isEmpty()
                ) {
                    Map<String, sobject> mapOfSobjectNameToSobject = new Map<String, sobject>();
                    mapOfSobjectNameToSobject.put('Account', objAccount);
                    mapOfSobjectNameToSobject.put('User', eachUser);
                    mapOfSobjectNameToSobject = DataCategoryMappingService.getDatacategoryMap(
                        objAccount,
                        primaryKeyToPermissionSetApiMap,
                        mapOfSobjectNameToSobject
                    );
                    // Area
                    insertNewPermission =
                        SyncUserFromAccountBatchServiceHelper.insertPermissionSetAssignmentForArea(
                            mapOfSobjectNameToSobject,
                            insertNewPermission,
                            permssionSetApiNameToId
                        );
                    // Location
                    insertNewPermission =
                        SyncUserFromAccountBatchServiceHelper.insertPermissionSetAssignmentForLocation(
                            mapOfSobjectNameToSobject,
                            insertNewPermission,
                            permssionSetNameToId
                        );
                    // Job Info
                    insertNewPermission =
                        SyncUserFromAccountBatchServiceHelper.insertPermissionSetAssignmentForJobInfo(
                            mapOfSobjectNameToSobject,
                            insertNewPermission,
                            permssionSetNameToId
                        );
                    // Team Member Group
                    if(String.isNotBlank(objAccount.TeamMemberIdentifier__c)){
                        insertNewPermission =
                        SyncUserFromAccountBatchServiceHelper.insertPermissionSetAssignmentForTeams(
                            mapOfSobjectNameToSobject,
                            insertNewPermission,
                            permssionSetApiNameToId
                        );
                    }
                }
            }
            // delete and insert new Assignment for All user.
            updateUserAssignment(deletePermissionSet, insertNewPermission);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'SyncUserFromAccountBatchService.cls on handlePermissionSetAssignment',
                ex
            );
        }
    }

    /**
* @author : Ankit Singh
* @description : This method is used to get permission set name to id map
* @return : labelOrNameToMap
*/
    @testVisible
    private static Map<String, Map<String, Id>> getPermissionSetNameToIdMap() {
        Map<String, Map<String, Id>> labelOrNameToMap = new Map<String, Map<String, Id>>();
        for(PermissionSet eachPermissionSet : [
            SELECT Id, Name, Description, Label
            FROM PermissionSet
            WHERE Description =: Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES
        	OR Description =: Label.PERMISSIONSETDESCRIPTIONBASELINE]
           ) {
               if(!labelOrNameToMap.containsKey('Label')){
                   labelOrNameToMap.put('Label', new Map<String, Id>());
               }
               if(!labelOrNameToMap.containsKey('ApiName')){
                   labelOrNameToMap.put('ApiName', new Map<String, Id>());
               }
               labelOrNameToMap.get('Label').put(eachPermissionSet.Label, eachPermissionSet.Id);
               labelOrNameToMap.get('ApiName').put(eachPermissionSet.Name, eachPermissionSet.Id);
           }
        return labelOrNameToMap;
    }
    
    /**
* @author : Ankit Singh
* @description : This method is used to get permission set Assignment which need to be deleted.
* @return : List<PermissionSetAssignment>
* @param eachUser
* @param deletePermissionSet
*/
    @testVisible
    private static List<PermissionSetAssignment> getDeletedPermissionSet(
        User eachUser,
        List<PermissionSetAssignment> deletePermissionSet
    ) {
        if(
                eachUser.Profile.Name == Label.PROFILETEAMMEMBER
                &&
                eachUser.PermissionSetAssignments != null
                &&
                !eachUser.PermissionSetAssignments.isEmpty()
        ) {
            deletePermissionSet.addAll(eachUser.PermissionSetAssignments);
        }
        return deletePermissionSet;
    }
    
    /**
* @author : Ankit Singh
* @description : This method delete and create new permission set for each user.
* @param deletePermissionSet
* @param insertNewPermission
*/
    private static void updateUserAssignment(
        List<PermissionSetAssignment> deletePermissionSet,
        List<PermissionSetAssignment> insertNewPermission
    ) {
        // delete deletePermissionSet
        if(deletePermissionSet != null && !deletePermissionSet.isEmpty()) {
            Database.delete(deletePermissionSet, false);
        }
        // insert new permissionSet
        if(insertNewPermission != null && !insertNewPermission.isEmpty()) {
            Database.insert(insertNewPermission, false);
        }
    }
}