/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
TransferOwnershipController class.
*/
@isTest(SeeAllData=false)
public without sharing class TransferOwnershipControllerTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        List<User> lstUser = new List<User>();
        User lineManagerUser = UserTestData.getUser('Business Unit Admin', 'Test2');
        lineManagerUser.EmployeeID__c = 'Test111';
        lineManagerUser.UserName = 'testinguserAnkit@testorg.com';
        lineManagerUser.IsActive = true;
        lstUser.add(lineManagerUser);
        
        User testUser = UserTestData.getUser('Communication Team', 'Test2');
        testUser.EmployeeID__c = '111Test';
        testUser.UserName = 'testinguserMonika@testorg.com';
        testUser.IsActive = true;
        lstUser.add(testUser);
        insert lstUser; 
        
        List<DistributionList__c> distributionList = 
            DistributionListTestData.createDistributionListRecords(2);
        distributionList[0].ownerId = lstUser[0].id;
        insert distributionList;
    }
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test TransferOwnershipController method
    */
    @isTest
    static void testTransferOwnershipController()
    {
        Test.startTest();
        User userRecord = [
            SELECT Id,EmployeeID__c FROM User where EmployeeID__c = '111Test'
        ];
        List<DistributionList__c> distributionList = [
            select id,ownerId from DistributionList__c
        ];
        System.runAs(userRecord) {
            TransferOwnershipController.setMetadataMethod();
            System.assertNotEquals(
                null,
                TransferOwnershipController.transferOwnershipMethod('User', 'EmployeeID__c' ,'111T').isEmpty()
            );
            TransferOwnershipController.setOwnershipMethod('Testing',distributionList[0].id);
        }
        Test.stopTest();
    }
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test TransferOwnershipController method
    */
    @isTest
    static void testTransferOwnershipBUController()
    {
        Test.startTest();
        User userRecord = [
            SELECT Id,EmployeeID__c FROM User where EmployeeID__c = 'Test111'
        ];
        List<DistributionList__c> distributionList = [
            select id,ownerId from DistributionList__c
        ];
        System.runAs(userRecord) {
            TransferOwnershipController.setMetadataMethod();
            System.assertNotEquals(
                null,
                TransferOwnershipController.transferOwnershipMethod('User', 'EmployeeID__c' ,'Test').isEmpty()
            );
            TransferOwnershipController.setOwnershipMethod('Testing',distributionList[0].id);
        }
        Test.stopTest();
    }
}