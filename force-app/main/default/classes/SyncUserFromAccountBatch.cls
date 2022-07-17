/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This batch class is used to sync user detail from Account.
*/
global class SyncUserFromAccountBatch implements Database.batchable<sobject>,Database.Stateful {
    private Boolean isCommFeatureEnabled = false;
    Private Boolean isEnableAccountUpdate = false;

    /**
    * @author : Ankit Singh
    * @description : This method get all the Account record which is created or modified today.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        isCommFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
            labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableCommsBatches__c;

        String query= 'SELECT Id, Area_Dept_Name__c, OpsSupport__c, Employee_ID__c, Position__c,Location_Name__c, Region__c,IsLineManager__c,TeamMemberIdentifier__c,' 
                        +'PersonMobilePhone, HasDOA__c, CareerLevel__c,Line_Manager__c, CompanyCode__c, GroupCode__c, BrandCode__c, Country__c FROM Account';

        isEnableAccountUpdate = FeatureControlDomain.getFeatureControlRecord('ENABLEACCOUNTUPDATE').Active__c;
        if(isEnableAccountUpdate)
        {
            query += ' WHERE Employee_ID__c != null' ;
        }
        else
        {
            query += ' WHERE Employee_ID__c != null AND (CreatedDate = TODAY OR LastModifiedDate = TODAY)' ;
        }

        return Database.getQueryLocator(query);
    }

    /**
    * @author : Ankit Singh
    +* @description : This method Sync user from Account record.
    * @param info
    * @param scope
    */
    global void execute(Database.BatchableContext info, List<Account> scope) {
        try{
            List<User> userList = new List<User>();
            Set<String> setOfEmployeeId = new Set<String>();
            Map<String, Account> employeeIdToAccountMap = new Map<String, Account>();
            List<User> updateUserList = new List<User>();
            if(isCommFeatureEnabled) {
                for(Account eachAccount : scope) {
                    setOfEmployeeId.add(eachAccount.Employee_ID__c);
                    employeeIdToAccountMap.put(eachAccount.Employee_ID__c, eachAccount);
                }
            }
            if(
                setOfEmployeeId != null
                &&
                !setOfEmployeeId.isEmpty()
            ) {
                userList = UserDomain.queryUserFromEmployeeIdSet(setOfEmployeeId);
            }
            updateUserList = updateUser(userList, employeeIdToAccountMap, updateUserList);
            if(
                updateUserList != null
                &&
                !updateUserList.isEmpty()
            ) {
                Database.update(updateUserList, false);
            }
            // Added by Ankit Singh on 1 July for TH-574
            updatepermissionSetAssignment(userList, employeeIdToAccountMap);
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent
            ('SyncUserFromAccountBatch.cls on execute',ex);}
    }
    
    /**
* @author : Ankit Singh
* @description : This method check if user sync is required or not by comparing the appropriate
*                field and then it map the value to user
* @return : List<User>
* @param userList
* @param employeeIdToAccountMap
* @param updateUserList
*/
    private List<User> updateUser(
        List<User> userList,
        Map<String, Account> employeeIdToAccountMap,
        List<User> updateUserList
    ) {
        if(
            userList != null
            &&
            !userList.isEmpty()
            &&
            employeeIdToAccountMap != null
            &&
            !employeeIdToAccountMap.isEmpty()
        ) {
            for(User eachUser : userList) {
                Account objAccount = employeeIdToAccountMap.get(eachUser.EmployeeID__c);
                if(
                    objAccount != null
                    &&
                    validforUserSync(eachUser, objAccount)
                ) {
                    eachUser.Area__c = objAccount.Area_Dept_Name__c;
                    eachUser.Department__c = objAccount.OpsSupport__c;
                    eachUser.JobTitle__c = objAccount.Position__c;
                    eachUser.Location__c = objAccount.Location_Name__c;
                    eachUser.Region__c = objAccount.Region__c;
                    eachUser.LineManager__c = objAccount.Line_Manager__c;
                    eachUser.MobilePhone = objAccount.PersonMobilePhone;
                    updateUserList.add(eachUser);
                }
            }
        }
        return updateUserList;
    }
    
    /**
* @author : Ankit Singh
* @description : This method check if user sync is required or not by comparing the appropriate
* field
* @return : Boolean
* @param eachUser
* @param objAccount
*/
    private Boolean validforUserSync(User eachUser, Account objAccount) {
        if(
            
            eachUser.Area__c != objAccount.Area_Dept_Name__c
            ||
            eachUser.Department__c != objAccount.OpsSupport__c
            ||
            eachUser.JobTitle__c != objAccount.Position__c
            ||
            eachUser.Location__c != objAccount.Location_Name__c
            ||
            eachUser.Region__c != objAccount.Region__c
            ||
            eachUser.LineManager__c != objAccount.Line_Manager__c
        ) {
            return true;
        }
        return false;
    }
    
    /**
* @author : Ankit Singh
* @description : This method update permission set for user
* @param userList
* @param employeeIdToAccountMap
*/
    private void updatepermissionSetAssignment(
        List<User> userList,
        Map<String,Account> employeeIdToAccountMap
    ) {
        if(
            userList != null
            &&
            !userList.isEmpty()
            &&
            employeeIdToAccountMap != null
            &&
            !employeeIdToAccountMap.isEmpty()
        ) {
            SyncUserFromAccountBatchService.handlePermissionSetAssignment(
                userList,
                employeeIdToAccountMap
            );
        }
    }
    
    /**
* @author : Ankit Singh
* @description : This method is user to perform any task post execution
* @param info
*/
    global void finish(Database.BatchableContext info) {
        System.debug('*****' + info);
    }
}