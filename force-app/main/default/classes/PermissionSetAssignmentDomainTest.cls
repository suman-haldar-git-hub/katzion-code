/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
PermissionSetAssignmentDomain class.
*/
@isTest(SeeAllData=false)
public class PermissionSetAssignmentDomainTest {
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test LeaveDomain method
    */
    @isTest
    static void permissionSetAssignmentDomainMethod() {
        Test.startTest();
        System.assertEquals(false,PermissionSetAssignmentDomain.getKnowledgeDetailsForPublishController().isEmpty());
        Test.stopTest();
    }
}