/**
* @author : Akshansh Jain
* @company : Cognizant
* @description : This test class will cover the PeopleInsightPortalRequestService class
*/
@isTest(SeeAllData=false)
public class PeopleInsightPortalRequestServiceTest {
    
    /**
    * @author : Akshansh Jain
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData() {
        //create account records
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
                'Individual Account').getRecordTypeId();
        List<Account> accountList =
            AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
            insert accountList;
        Account accountRecd = [Select Employee_ID__c From Account WHERE Id in: accountList];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c = 'Email',
            EmployeeID__c=accountList[0].Employee_ID__c);
        insert u;
        //create trailheadapp__Badge__c records
        trailheadapp__Badge__c badge = new trailheadapp__Badge__c();
        badge.trailheadapp__API_Name__c='get-started-with-people-data-and-insights';
        badge.trailheadapp__Description__c='A quick onboarding module.';
        badge.trailheadapp__Icon__c='test';
        badge.trailheadapp__Namespace__c='woolworthsgroup';
        badge.trailheadapp__URL__c='test';
        insert badge;
        
        List<Form__c> formData = FormTestData.getForm(1, false);
        formData[0].Name='People Dashboard Queries';
        formData[0].CaseCategory__c='Pay and the Basics';
        formData[0].ActionCentreIcon__c='test.svg';
        formData[0].FormTab__c='MyDevice';
        formData[0].FormType__c='ActionCentre';
        insert formData;
    }

     /**
    * @author : Akshansh Jain
    * @company : Cognizant
    * @description : This is the test getDataOnLoad method.
    */
    @isTest
    static void getDataOnLoadTest(){
        User selectedUser = [SELECT Id FROM User WHERE EmployeeID__c='Test0'];
        PeopleInsightPortalRequestService.PeopleInsightPortalWrapper wrapper 
            = new PeopleInsightPortalRequestService.PeopleInsightPortalWrapper();
        System.runAs(selectedUser){
            wrapper = PeopleInsightPortalRequestService.getDataOnLoad();
        }
        System.assertEquals(wrapper.mapMetadata.size()>0,true);
    }
}
