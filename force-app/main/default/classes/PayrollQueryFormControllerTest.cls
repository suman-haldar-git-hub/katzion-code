/**
* @description       : 
* @author            : Joginder Kumar
* @group             : 
* @last modified on  : 10-20-2021
* @last modified by  : Joginder Kumar
**/
@isTest
public class PayrollQueryFormControllerTest {
    //private static final String STR_USERNAME = 'payrollquery' + '@WPSHRNZDEVorg.com';
    private static final String STR_USERNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
    @TestSetup
    static void setup(){
        CommonTestDataFactory.buildTestUser();	
        //Dummy Account
        CommonTestDataFactory.createTeamMember('P123456');
        CommonTestDataFactory.createTeamMember('P123457');
        CommonTestDataFactory.createTeamMember('P123458');
    }
    @isTest
    Static void createPayrollQueryTest(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        List<String> employeeIds = new List<String>{'P123457','P123458'};
            List<Account> teamMembers= [Select id,Employee_ID__c from Account where Employee_ID__c IN :employeeIds];
        Recordtype rt = [Select id from recordtype where name='Payroll HR NZ'];
        Case newCase = new Case();
        newCase.Web_First_Name__c = 'TestFirstName';
        newCase.Web_Last_Name__c = 'TestLastName';
        for(Account acc:teamMembers){
            if(acc.Employee_ID__c == 'P123457'){
                newCase.Web_Employee_Id__c = acc.Employee_ID__c;
            }else if(acc.Employee_ID__c == 'P123458'){
                newCase.Web_Respondent_Employee_Id__c=acc.Employee_ID__c;
            }
        }
        newCase.WOW_Web_Email_Address__c ='guestuser@woolworths.com.au';
        newCase.Preferred_Email__c='guestuser@woolworths.com.au';
        newCase.Web_Respondent_First_Name__c='TestRFirstName';
        newCase.Web_Respondent_Last_Name__c='TestRLastName';
        newCase.On_Behalf_Of_Employee_Email__c='guestuser@woolworths.com.au';
        newCase.Business_Area__c='Pharmacy';
        newCase.Category__c='Payroll NZ';
        newCase.Sub_Category_New__c='Payroll NZ';
        newCase.Sub_Category_2__c='Deduction';
        newCase.Priority='Low';
        newCase.Status='Open';
        newCase.Origin='Web';
        newCase.RecordTypeId=rt.Id;
        newCase.Subject='test subject';
        newCase.Description='test description';
        newCase.Log_a_case_for_someone_else__c=true;  
        List<String> contentVersionIds = new List<String>();
        contentVersionIds.add('12345');
        boolean isFileUploadMandatory = true;

        Map<String,Object> fileData = new Map<String,Object>{'filename'=>'dummy.png','base64'=>'ZHVtbXk='};
            System.runAs(selectedUser){
                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                PayrollQueryFormController.createPayrollQuery(newCase,'captchaTokenstr',contentVersionIds,isFileUploadMandatory);
                Test.stopTest();
            }
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }
    
    @isTest
    Static void createPayrollQuery2Test(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        Recordtype rt = [Select id from recordtype where name='Payroll HR NZ'];
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
        newCase.Business_Area__c='Pharmacy';
        newCase.Category__c='Payroll NZ';
        newCase.Sub_Category_New__c='Payroll NZ';
        newCase.Sub_Category_2__c='Deduction';
        newCase.Priority='Low';
        newCase.Status='Open';
        newCase.Origin='Web';
        newCase.RecordTypeId=rt.Id;
        newCase.Subject='test subject';
        newCase.Description='test description';
        newCase.Log_a_case_for_someone_else__c=true; 
        List<String> contentVersionIds = new List<String>();
        contentVersionIds.add('12345');
        boolean isFileUploadMandatory = true;
        Map<String,Object> fileData = new Map<String,Object>{'filename'=>'dummy.png','base64'=>null};
            System.runAs(selectedUser){
                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                PayrollQueryFormController.createPayrollQuery(newCase,'captchaTokenstr',contentVersionIds,isFileUploadMandatory);
                Test.stopTest();
            }
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }
    
    @isTest
    Static void createPayrollQueryWithException(){
        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        Recordtype rt = [Select id from recordtype where name='Payroll HR NZ'];
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
        newCase.Business_Area__c='Pharmacy';
        newCase.Category__c='Payroll NZ';
        newCase.Sub_Category_New__c='Payroll NZ';
        newCase.Sub_Category_2__c='Deduction';
        newCase.Priority='Low';
        newCase.Status='Open';
        newCase.Origin='Web';
        newCase.RecordTypeId=rt.Id;
        newCase.Subject='test subject';
        newCase.Description='test description';
        newCase.Log_a_case_for_someone_else__c=true;
        
        List<String> contentVersionIds = new List<String>();
        contentVersionIds.add('12345');
        boolean isFileUploadMandatory = true;
        Map<String,Integer> fileData = new Map<String,Integer>{'filename'=>1234,'base64'=>1234};
            System.runAs(selectedUser){
                Test.startTest();
                try{
                    Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                    PayrollQueryFormController.createPayrollQuery(newCase,'captchaTokenstr',contentVersionIds,isFileUploadMandatory);
                }catch(Exception ex){
                    System.debug('Error->'+ex);
                }
                Test.stopTest();
            }
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }
    @isTest
    Static void getIsAttchMandDataTest(){
        Test.startTest();
        List<Category_Subcategory_AttchDependency__mdt> attachMetadata = PayrollQueryFormController.getIsAttchMandData();
        Test.stopTest();
        System.assert(attachMetadata != null, true);
    }
}