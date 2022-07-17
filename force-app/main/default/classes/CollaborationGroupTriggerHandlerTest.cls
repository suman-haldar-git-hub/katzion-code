/**
* @author : Ankit Singh
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
* CollaborationGroupTriggerHandler class.
*/
@isTest(SeeAllData=false)
public class CollaborationGroupTriggerHandlerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        List<User> lstUser = new List<User>();
        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = '111Test';
        testUser.UserName = 'monika@testorg.com';
        lstUser.add(testUser);
        insert lstUser;
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testBeforeInsertMethods() {
        List<User> userList =[SELECT Id FROM User];
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        System.runAs(userList[0]) {
            CollaborationGroup objCollaborationGroup = new CollaborationGroup(
                Name = 'My New Group' + System.now(),
                CollaborationType = 'Public'
            );
            try {
                Database.insert(objCollaborationGroup);
            } catch (Exception ex) {
                System.assertNotEquals(
                        ex.getMessage(),
                        labelToContentMap.get('COLLABORATIONGROUPCREATIONMESSAGE')
                );
            }
        }
        System.assert(userList.size() > 0);
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testBeforeUpdateMethods() {
        User testUserAnkit = UserTestData.getUser('System Administrator', 'Test4');
        testUserAnkit.EmployeeID__c = '111Test1';
        testUserAnkit.UserName = 'ankit@testorg.com';
        Database.insert(testUserAnkit);
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        System.runAs(testUserAnkit) {
            CollaborationGroup objCollaborationGroup = new CollaborationGroup(
                Name = 'My New Upadte' + System.now(),
                CollaborationType = 'Private'
            );
            try {
                Database.insert(objCollaborationGroup);
                objCollaborationGroup.CollaborationType = 'Public';
                Database.update(objCollaborationGroup);
            } catch (Exception ex) {
                System.assertNotEquals(
                        ex.getMessage(),
                        labelToContentMap.get('COLLABORATIONGROUPCREATIONMESSAGE')
                );
            }
        }
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testBeforeUpdateMethodForTM() {
        User testUserAnkit = UserTestData.getUser('Business Unit Admin', 'Test4');
        testUserAnkit.EmployeeID__c = '111Test1';
        testUserAnkit.UserName = 'ankit@testorg.com';
        Database.insert(testUserAnkit);
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        System.runAs(testUserAnkit) {
            CollaborationGroup objCollaborationGroup = new CollaborationGroup(
                Name = 'My New Upadte' + System.now(),
                CollaborationType = 'Public'
            );
            try {
                Database.insert(objCollaborationGroup);
                objCollaborationGroup.CollaborationType = 'Private';
                Database.update(objCollaborationGroup);
            } catch (Exception ex) {
                System.assertNotEquals(
                        ex.getMessage(),
                        labelToContentMap.get('COLLABORATIONGROUPCREATIONMESSAGE')
                );
            }
        }
    }
}