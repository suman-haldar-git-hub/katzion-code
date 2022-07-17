/**
@Author : Daksh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
UserDomain class.
*/
@isTest(SeeAllData=false)
public without sharing class UserDomainTest {
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        User testUser1 = UserTestData.getUser('System Administrator', 'Test2');
        testUser1.EmployeeID__c = 'Test001';
        testUser1.UserName = 'daksh1@testorg.com';
        testUser1.IsActive = true;
        insert testUser1;

        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = '123456';
        testUser.UserName = 'daksh@testorg.com';
        testUser.ManagerId = testUser1.Id;
        testUser.IsActive = true;
        testUser.SalarySacrificeNotification__c = true;
        testUser.SalarySacrificeNotificationChannel__c = 'Email';
        insert testUser;

        PermissionSet permissionSetRecd = new PermissionSet(
            Label = 'Area - Test',
            Name = 'Area_Test',
            Description = Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES);
        insert permissionSetRecd;

        PermissionSetAssignment permissionSetAssignmentRecd = new PermissionSetAssignment();
        permissionSetAssignmentRecd.AssigneeId = testUser1.Id;
        permissionSetAssignmentRecd.PermissionSetId = permissionSetRecd.Id;
    }
    /**
@Author : Daksh Madan
@Company : SaasFocus A Cognizant Company
@description : Test UserDomain all methods
*/
    @isTest
    static void testUserDomain(){
        FeatureControl__mdt obj = new FeatureControl__mdt();
        obj = FeatureControlDomain.getFeatureControlRecord('CATS');
        
        User userRecord = [
            SELECT Id, Area__c, Department__c, EmployeeID__c,
            JobTitle__c, Location__c,LeaveNotification__c,
            Region__c, Profile.Name,LeaveNotificationChannel__c,
            (
                SELECT Id, PermissionSetId, PermissionSet.Name,
                AssigneeId, PermissionSet.Description
                FROM PermissionSetAssignments
                WHERE PermissionSet.Description =:
                Label.PERMISSIONSETDESCRIPTIONDATACATEGORIES
            )
            FROM User
            WHERE EmployeeID__c ='123456'
        ];
        User userRecord2 = [
            SELECT Id,EmployeeID__c,ManagerId
            FROM User
            WHERE EmployeeID__c ='Test001'
        ];
        Set<String> setOfEmpId = new Set<String>();
        setOfEmpId.add(userRecord.EmployeeID__c);
        setOfEmpId.add(userRecord2.EmployeeID__c);
        
        UserDomain.getCatsUserList(setOfEmpId);
        UserDomain.getUserIdAndUserRecord(new Set<Id> {userRecord.id});

        list<String> lstOfEmpId = new List<String>();
        lstOfEmpId.add(userRecord.EmployeeID__c);
        lstOfEmpId.add(userRecord2.EmployeeID__c);
        Test.startTest();
        User userRecd = UserDomain.queryUserBasedOnId(userRecord.Id);
        System.assert(userRecd != null);
        //List<User> userListRecd = UserDomain.queryUserListFromManagerId(userRecord2.Id);
        List<User> userListRecd2 = UserDomain.queryUserListFromLineManager(userRecord.Id);
        List<User> userListRecd3 = UserDomain.getUserRecords(setOfEmpId);
        List<User> userListRecd4 = UserDomain.queryUserFromEmployeeIdSet(setOfEmpId);
        UserDomain.searchCTorBUAdminUser('Testing');
        UserDomain.queryLoggedInUserProfileName();
        UserDomain.userEmpIdMatchesWithAccEmpId(setOfEmpId);
        UserDomain.getUserRecordsForComm(lstOfEmpId,
                                         new Set<String>{'Approved'},
                                         new Set<String>{'LeaveBalance'});
        UserDomain.getUserRecordsForUtl(lstOfEmpId);
        System.assertEquals(
            UserDomain.checkWhetherToCreateCampMemRecd(userRecord.EmployeeID__c),
            false
        );
        UserDomain.updateUserList(new List<User> {userRecd});
        Test.stopTest();
    }
}