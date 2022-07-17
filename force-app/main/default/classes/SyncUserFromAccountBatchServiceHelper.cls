/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is helper of SyncUserFromAccountBatchService.
*/
public inherited sharing class SyncUserFromAccountBatchServiceHelper {
    /**
* @author : Ankit Singh
* @description : This method is used to get permission set name for Job info.
* @return : List<PermissionSetAssignment>
* @param mapOfSobjectNameToSobject
* @param insertNewPermission
* @param permssionSetApiNameToId
*/
    public static List<PermissionSetAssignment> insertPermissionSetAssignmentForArea(
        Map<String, sobject> mapOfSobjectNameToSobject,
        List<PermissionSetAssignment> insertNewPermission,
        Map<String, Id> permssionSetApiNameToId
    ) {
        Account objAccount = (Account) mapOfSobjectNameToSobject.get('Account');
        User eachUser = (User) mapOfSobjectNameToSobject.get('User');
        DataCategoryPermissionSetMapping__mdt mapping =
            (DataCategoryPermissionSetMapping__mdt)
            mapOfSobjectNameToSobject.get(
                'DataCategoryPermissionSetMapping__mdt'
            );
        if(
            mapping != null
            &&
            mapping.PermissionSetApiName__c != null
            &&
            permssionSetApiNameToId.containsKey(mapping.PermissionSetApiName__c)
            &&
            permssionSetApiNameToId.get(mapping.PermissionSetApiName__c) != null
        ) {
            PermissionSetAssignment eachPermissionSetAss = new PermissionSetAssignment(
                PermissionSetId = permssionSetApiNameToId.get(mapping.PermissionSetApiName__c),
                AssigneeId = eachUser.Id
            );
            insertNewPermission.add(eachPermissionSetAss);
        }
        return insertNewPermission;
    }
    /**
* @author : Ankit Singh
* @description : This method is used to get permission set name for Job info.
* @return : List<PermissionSetAssignment>
* @param mapOfSobjectNameToSobject
* @param insertNewPermission
* @param permssionSetNameToId
*/
    public static List<PermissionSetAssignment> insertPermissionSetAssignmentForLocation(
        Map<String, sobject> mapOfSobjectNameToSobject,
        List<PermissionSetAssignment> insertNewPermission,
        Map<String, Id> permssionSetNameToId
    ) {
        Account objAccount = (Account) mapOfSobjectNameToSobject.get('Account');
        User eachUser = (User) mapOfSobjectNameToSobject.get('User');
        if(
            objAccount.Country__c != null
            &&
            permssionSetNameToId.containsKey(objAccount.Country__c)
            &&
            permssionSetNameToId.get(objAccount.Country__c) != null
        ) {
            PermissionSetAssignment eachPermissionSetAss = new PermissionSetAssignment(
                PermissionSetId = permssionSetNameToId.get(
                    objAccount.Country__c
                ),
                AssigneeId = eachUser.Id
            );
            insertNewPermission.add(eachPermissionSetAss);
        }
        return insertNewPermission;
    }
    /**
* @author : Ankit Singh
* @description : This method is used to get permission set name for Job info.
* @return : List<PermissionSetAssignment>
* @param mapOfSobjectNameToSobject
* @param insertNewPermission
* @param permssionSetNameToId
*/
    public static List<PermissionSetAssignment> insertPermissionSetAssignmentForJobInfo(
        Map<String, sobject> mapOfSobjectNameToSobject,
        List<PermissionSetAssignment> insertNewPermission,
        Map<String, Id> permssionSetNameToId
    ) {
        Account objAccount = (Account) mapOfSobjectNameToSobject.get('Account');
        User eachUser = (User) mapOfSobjectNameToSobject.get('User');
        if(
            objAccount.IsLineManager__c != null
            &&
            objAccount.HasDOA__c != null
            &&
            objAccount.CareerLevel__c != null
        ) {
            String permissionSetName = getJobInfoPermissionSetName(objAccount);
            if(
                String.isNotBlank(permissionSetName)
                &&
                permssionSetNameToId.containsKey(permissionSetName)
                &&
                permssionSetNameToId.get(permissionSetName) != null
            ) {
                PermissionSetAssignment eachPermissionSetAss = new PermissionSetAssignment(
                    PermissionSetId = permssionSetNameToId.get(permissionSetName),
                    AssigneeId = eachUser.Id
                );
                insertNewPermission.add(eachPermissionSetAss);
            }
        }
        return insertNewPermission;
    }
    /**
* @author : Ankit Singh
* @description : This method is used to get permission set name for Job info.
* @return : String
* @param objAccount
*/
    private static String getJobInfoPermissionSetName(Account objAccount) {
        String permissionName = '';
        permissionName += objAccount.IsLineManager__c == 'true' ? 'Line Manager '
            : 'Not Line Manager ';
        permissionName += objAccount.HasDOA__c == 'true' ? 'DOA '
            : 'Not DOA ';
        permissionName += objAccount.CareerLevel__c;
        return permissionName;
    }
     /**
* @author : Praveen Tiwari
* @description : This method is used to get permission set name for Teams.
* @return : List<PermissionSetAssignment>
* @param mapOfSobjectNameToSobject
* @param insertNewPermission
* @param permssionSetNameToId
*/
    public static List<PermissionSetAssignment> insertPermissionSetAssignmentForTeams(
        Map<String, sobject> mapOfSobjectNameToSobject,
        List<PermissionSetAssignment> insertNewPermission,
        Map<String, Id> permssionSetApiNameToId
    ) {
        Account objAccount = (Account)mapOfSobjectNameToSobject.get('Account');
        User eachUser = (User)mapOfSobjectNameToSobject.get('User');
        List<String> teamIdentifierList = objAccount.TeamMemberIdentifier__c.split(';');

        for(String identifier: teamIdentifierList){
            if(permssionSetApiNameToId.containsKey(identifier)){
                PermissionSetAssignment eachPermissionSetAss = new PermissionSetAssignment();
                eachPermissionSetAss.PermissionSetId = permssionSetApiNameToId.get(identifier);
                eachPermissionSetAss.AssigneeId = eachUser.Id;
                insertNewPermission.add(eachPermissionSetAss);
            }
        }
        return insertNewPermission;
    }
}