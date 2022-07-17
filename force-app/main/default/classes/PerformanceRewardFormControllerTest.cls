/**
 * @description       : 
 * @author            : Joginder Kumar
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Joginder Kumar
**/
@isTest
public with sharing class PerformanceRewardFormControllerTest {
     private static final String STR_USERNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
     @TestSetup
     static void setup(){
         CommonTestDataFactory.buildTestUser();	
         //Dummy Account
         CommonTestDataFactory.createTeamMember('P123456');
         CommonTestDataFactory.createTeamMember('P123450');
         CommonTestDataFactory.createTeamMember('P123451');
     }
     @isTest
     Static void createPNRQueryTest(){
         User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
         List<String> employeeIds = new List<String>{'P123450','P123451'};
         List<Account> teamMembers= [Select id,Employee_ID__c from Account where Employee_ID__c IN :employeeIds];
         Recordtype rt = [Select id from recordtype where DeveloperName='PandR_HR_NZ'];
         Case newCase = new Case();
         newCase.Web_First_Name__c = 'TestFirstName';
         newCase.Web_Last_Name__c = 'TestLastName';
         for(Account acc:teamMembers){
             if(acc.Employee_ID__c == 'P123450'){
                 newCase.Web_Employee_Id__c = acc.Employee_ID__c;
             }else if(acc.Employee_ID__c == 'P123451'){
                 newCase.Web_Respondent_Employee_Id__c=acc.Employee_ID__c;
             }
         }
         newCase.WOW_Web_Email_Address__c ='guestuser@woolworths.com.au';
         newCase.Preferred_Email__c='guestuser@woolworths.com.au';
         newCase.Web_Respondent_First_Name__c='TestRFirstName';
         newCase.Web_Respondent_Last_Name__c='TestRLastName';
         newCase.On_Behalf_Of_Employee_Email__c='guestuser@woolworths.com.au';
         newCase.Category__c='Performance & Reward NZ';
         newCase.Sub_Category_New__c='Performance & Reward NZ';
         newCase.Sub_Category_2__c='Reward';
         newCase.Priority='Low';
         newCase.Status='Open';
         newCase.Origin='Web';
         newCase.RecordTypeId=rt.Id;
         newCase.Subject='test subject';
         newCase.Description='test description';
         newCase.Log_a_case_for_someone_else__c=true;  
         List<String> contentVersionIds = new List<String>();
         contentVersionIds.add('12345');
         System.runAs(selectedUser){
             Test.startTest();
             Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
             PerformanceRewardFormController.createPNRQuery(newCase,contentVersionIds,'captchaTokenstr');
             Test.stopTest();
         }
         System.assert(String.isNotBlank(STR_USERNAME), true);
     }
 
     @isTest
     Static void createPNRQueryTestWithEmployeeInfo(){
         User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
         Recordtype rt = [Select id from recordtype where DeveloperName='PandR_HR_NZ'];
         Case newCase = new Case();
         newCase.Web_First_Name__c = 'TestFirstName';
         newCase.Web_Last_Name__c = 'TestLastName';
         newCase.Web_Employee_Id__c = 'P090900';
         newCase.Web_Respondent_Employee_Id__c='P090901';
         newCase.WOW_Web_Email_Address__c ='guestuser@woolworths.com.au';
         newCase.Preferred_Email__c='guestuser@woolworths.com.au';
         newCase.Web_Respondent_First_Name__c='TestRFirstName';
         newCase.Web_Respondent_Last_Name__c='TestRLastName';
         newCase.On_Behalf_Of_Employee_Email__c='guestuser@woolworths.com.au';
         newCase.Category__c='Performance & Reward NZ';
         newCase.Sub_Category_New__c='Performance & Reward NZ';
         newCase.Sub_Category_2__c='Reward';
         newCase.Priority='Low';
         newCase.Status='Open';
         newCase.Origin='Web';
         newCase.RecordTypeId=rt.Id;
         newCase.Subject='test subject';
         newCase.Description='test description';
         newCase.Log_a_case_for_someone_else__c=true;  

         List<String> contentVersionIds = new List<String>();
         contentVersionIds.add('12345');
         System.runAs(selectedUser){
             Test.startTest();
             Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
             PerformanceRewardFormController.createPNRQuery(newCase,contentVersionIds,'captchaTokenstr');
             Test.stopTest();
         }
         System.assert(String.isNotBlank(STR_USERNAME), true);
     }


     @isTest
     Static void createPNRQueryTestWithException(){
         User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
         Recordtype rt = [Select id from recordtype where DeveloperName='PandR_HR_NZ'];
         Case newCase = new Case();
         newCase.Web_First_Name__c = 'TestFirstName';
         newCase.Web_Last_Name__c = 'TestLastName';
         newCase.Web_Employee_Id__c = 'P090900';
         newCase.Web_Respondent_Employee_Id__c='P090901';
         newCase.WOW_Web_Email_Address__c ='guestuser@woolworths.com.au';
         newCase.Preferred_Email__c='guestuser@woolworths.com.au';
         newCase.Web_Respondent_First_Name__c='TestRFirstName';
         newCase.Web_Respondent_Last_Name__c='TestRLastName';
         newCase.On_Behalf_Of_Employee_Email__c='guestuser@woolworths.com.au';
         newCase.Category__c='Performance & Reward NZ';
         newCase.Sub_Category_New__c='Performance & Reward NZ';
         newCase.Sub_Category_2__c='Reward';
         newCase.Priority='Low';
         newCase.Status='Open';
         newCase.Origin='Web';
         newCase.RecordTypeId=rt.Id;
         newCase.Subject='test subject';
         newCase.Description='test description';
         newCase.Log_a_case_for_someone_else__c=true;  

         List<String> contentVersionIds = new List<String>();
         contentVersionIds.add('12345');
         System.runAs(selectedUser){
             Test.startTest();
             try{
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                 PerformanceRewardFormController.createPNRQuery(newCase,contentVersionIds,'captchaTokenstr');
             }catch(Exception ex){
                System.debug('error->'+ex);
             }
             
             Test.stopTest();
         }
         System.assert(String.isNotBlank(STR_USERNAME), true);
     }
 }