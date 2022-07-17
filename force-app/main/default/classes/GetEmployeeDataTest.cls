/**
@author : Sunil
@company : Cognizant
@description : This class is test class for GetEmployeeData.
*/
@isTest
private class GetEmployeeDataTest {
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test0';
        insert testUser;
    }
    @isTest static void testCallout1() {
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.runAs(userRecord){
            IntegrationConfig__c apiDetails = new IntegrationConfig__c(Name = 'LEARNINGAPIDETAILS');
            apiDetails.Active__c = true;
            apiDetails.Endpoint__c = '[XXX1][XXX2]';
            apiDetails.AccessToken__c = 'shdfhfdshfsaew';
            apiDetails.Method__c = 'POST';
            insert apiDetails;
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock.
            test.startTest();
            GetEmployeeData.getData();
            System.assertEquals(false, MockHttpResponseGenerator.isBadRequest);
            test.stopTest();
        }
    }
    @isTest static void testCallout2() {
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test0'];
        System.runAs(userRecord){
            IntegrationConfig__c apiDetails = new IntegrationConfig__c(Name = 'LEARNINGAPIDETAILS');
            apiDetails.Active__c = true;
            apiDetails.Endpoint__c = '[XXX1][XXX2]';
            apiDetails.AccessToken__c = 'shdfhfdshfsaew';
            apiDetails.Method__c = 'POST';
            insert apiDetails;
            // Set mock callout class
            MockHttpResponseGenerator.isBadRequest = true;
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock.
            test.startTest();
            GetEmployeeData.getData();
            System.assertEquals(true, MockHttpResponseGenerator.isBadRequest);
            test.stopTest();
        }
    }
}