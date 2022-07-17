/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : Test class for SyncUserFromAccountBatchService
*/
@isTest(SeeAllData=false)
public without sharing class SyncUserFromAccountBatchServiceTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser(Label.PROFILETEAMMEMBER, 'Test');
        testUser.EmployeeID__c = 'Test0';
        insert testUser;
        User usr = UserTestData.getUser('System Administrator', 'Test');
        usr.userName = 'testinguser1@testorg.com';
        usr.EmployeeID__c = 'Test1';
        insert usr;
        system.runAs(usr)
        {
            Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                Label.INDIVIDUALACCOUNT).getRecordTypeId();
            
            List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            acctList[0].Area_Dept_Name__c = 'Test';
            acctList[0].Location_Name__c = 'Test';
            acctList[0].IsLineManager__c = 'true';
            acctList[0].HasDOA__c = 'true';
            acctList[0].CareerLevel__c = 'Test';
            acctList[0].CompanyCode__c = '1000';
            acctList[0].GroupCode__c = '10000003';
            acctList[0].BrandCode__c = '11000003';
            acctList[0].OpsSupport__c = 'Corporate & Public Affair';
            acctList[0].Country__c = 'Test 34';
            acctList[0].TeamMemberIdentifier__c = 'PeopleTeam';
            insert acctList;
        }
        
        List<PermissionSet> insertPermissionSet = new List<PermissionSet>();
        PermissionSet areaPermissionSet = new PermissionSet(
            Label = 'Area - Test',
            Name = 'Area_Test',
            Description = Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES);
        insertPermissionSet.add(areaPermissionSet);
        PermissionSet loactionPermissionSet = new PermissionSet(
            Label = 'Test 34',
            Name = 'Test34',
            Description = Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES);
        insertPermissionSet.add(loactionPermissionSet);
        PermissionSet jobInfoPermissionSet = new PermissionSet(
            Label = 'Line Manager DOA Test',
            Name = 'LineManager_DOA_Test',
            Description = Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES);
        insertPermissionSet.add(jobInfoPermissionSet);
        insert insertPermissionSet;
        List<PermissionSetAssignment> lstPermissionSetAssignment = new
            List<PermissionSetAssignment>();
        for(PermissionSet eachPermissionSet : insertPermissionSet) {
            lstPermissionSetAssignment.add(new PermissionSetAssignment(
                AssigneeId = testUser.Id,
                PermissionSetId = eachPermissionSet.id
            )
                                          );
        }
        insert lstPermissionSetAssignment;
        system.debug('lstPermissionSetAssignment==>'+lstPermissionSetAssignment);
    }
    
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test SyncUserFromAccountBatchService method
    */
    @isTest
    static void testSyncUserFromAccountBatchService()
    {
        Test.startTest();

        List<User> lstUser = [
            SELECT Id, Area__c, Department__c, EmployeeID__c, JobTitle__c, Location__c,
            Region__c, Profile.Name,
            (
                SELECT Id, PermissionSetId, PermissionSet.Name,
                AssigneeId, PermissionSet.Description
                FROM PermissionSetAssignments
                WHERE PermissionSet.Description =:
                Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES LIMIT 49999
            )
            FROM User where EmployeeID__c = 'Test0'
        ];
        System.assert(!lstUser.isEmpty());

        Map<String, Account> employeeIdToAccountMap = new Map<String, Account>();
        for(Account eachAccount : [
            SELECT Id, Area_Dept_Name__c, OpsSupport__c,GroupCode__c,
            Employee_ID__c, Position__c,CompanyCode__c,BrandCode__c,
            Location_Name__c, Region__c, IsLineManager__c,
            HasDOA__c, CareerLevel__c, Country__c, TeamMemberIdentifier__c
            FROM Account WHERE Employee_ID__c = 'Test0']
           ) {
               employeeIdToAccountMap.put(eachAccount.Employee_ID__c, eachAccount);
           }

        System.assert(!employeeIdToAccountMap.keyset().isEmpty());
        try 
        {
            SyncUserFromAccountBatchService.handlePermissionSetAssignment(lstUser, employeeIdToAccountMap);
        }
        catch(Exception ex) {
            System.debug('*********' + ex);
        }
        Test.stopTest();
    }
}