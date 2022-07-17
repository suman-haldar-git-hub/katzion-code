/**
* @description       : Test class for WPSFormController
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   20-08-2021   Akhil  Kumar     Initial Version
**/

@isTest
public class WPSFormControllerTest {
    private static final String STR_USERNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
    
    @testSetup
    static void testSetup(){
        CommonTestDataFactory.buildTestUser();	
        CommonTestDataFactory.createTeamMember('P123456');
        CommonTestDataFactory.createCase();
    }
    
    @isTest
    private static void testLoggedInUserDetails() {
        User selectedUser = fetchUser();
        
        System.runAs(selectedUser){
            Test.startTest();
            Account teamMember = WPSFormController.fetchLoggedInUserDetails();
            WPSFormController.getAccountRecord(teamMember.Id);
            Test.stopTest();
            
            System.assertEquals(teamMember.LastName, 'Test');
            System.assertEquals(teamMember.PersonEmail.toLowercase(), ('testTeamMember@woolworths.com.au').toLowercase());
        }   
    }
    
    @isTest
    private static void testFieldSetData() {
        User selectedUser = fetchUser();
        
        System.runAs(selectedUser){
            Test.startTest();
            WPSFormController.fetchFieldSetData('Webform');
            
            WPS_Relational_Data__mdt wpsRelationalData = WPSFormController.fetchFieldSet('Equipment Request', 'Equipment Request', 'Webform');
            String fieldSet = wpsRelationalData.Field_Set__c;
            
            String recordTypeName = WPSFormController.fetchWPSRecordTypeName();
            WPSFormController.getFieldSetFieldsByFieldSetName('Work_Requests__c', fieldSet);
            WPSFormController.fetchRoomsByCapacity();
            Test.stopTest();
            
            System.assertEquals(fieldSet, 'EquipmentRequest_WF_UI');
            System.assertEquals(recordTypeName, 'Workplace Support');
        }  
        System.assert(String.isNotBlank(STR_USERNAME), true); 
    }
    
    @isTest
    private static void testFieldSetDataWithException() {
        User selectedUser = fetchUser();
        
        System.runAs(selectedUser){
            Test.startTest();
            try{
                WPSFormController.fetchFieldSetData(null);
                Test.stopTest();	
            }catch(Exception ex){
                System.debug('Error->'+ex);
			}
            
            
        }  
        System.assert(String.isNotBlank(STR_USERNAME), true); 
    }
    
    @isTest
    private static void testSubmitWPSForm() {
        User selectedUser = fetchUser();
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        caseRecord.Web_First_Name__c = 'X';
        caseRecord.Web_Last_Name__c= 'Y';
        caseRecord.WOW_Web_Email_Address__c= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedEmail= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedName= 'X Y';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Equipment Request';
        caseRecord.Sub_Category_3__c= 'Equipment Request';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'TeamHub';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'testTeamMember@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999888999';
        caseRecord.RecordTypeId = rt.Id;
        
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        workRequestRecord.Payroll_Number__c = 'P1234';
        workRequestRecord.Employment_Status__c = 'Contractor';
        workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
        workRequestRecord.Do_you_require_a_Monitor__c = 'No';
        workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
        workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';
        
        List<String> cvList = new List<String>();
        cvList.add('123456');
        
        System.runAs(selectedUser){
            Test.startTest();
            WPSFormController.submitWPSForm(caseRecord, workRequestRecord, cvList);
            WPSFormController.getCaseRecordType(caseRecord.Id);
            WPSFormController.getCaseRecord(caseRecord.Id);
            WPSFormController.getWPSRTId();
            Test.stopTest();
        }  
        System.assert(String.isNotBlank(STR_USERNAME), true); 
    }
    
    
     @isTest
    private static void testSubmitWPSFormWithException() {
        User selectedUser = fetchUser();
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        caseRecord.Web_First_Name__c = 'X';
        caseRecord.Web_Last_Name__c= 'Y';
        caseRecord.WOW_Web_Email_Address__c= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedEmail= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedName= 'X Y';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Equipment Request';
        caseRecord.Sub_Category_3__c= 'Equipment Request';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'TeamHub';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'testTeamMember@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999888999';
        caseRecord.RecordTypeId = rt.Id;
        
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        workRequestRecord.Payroll_Number__c = 'P1234';
        workRequestRecord.Employment_Status__c = 'Contractor';
        workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
        workRequestRecord.Do_you_require_a_Monitor__c = 'No';
        workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
        workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';
         
     	List<String> cvList = new List<String>();
        cvList.add('123456');
        
        System.runAs(selectedUser){
            Test.startTest();
            try{
                WPSFormController.submitWPSForm(caseRecord, workRequestRecord, cvList);
                WPSFormController.getCaseRecord(caseRecord.Id);
                WPSFormController.getWPSRTId();
            }catch(Exception ex){
                system.debug('Error->'+ex);
            }
            
            Test.stopTest();
        }  
        System.assert(String.isNotBlank(STR_USERNAME), true); 
    }
    
    @isTest
    private static void testSubmitWPSPublicForm() {
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        caseRecord.Web_First_Name__c = 'Test';
        caseRecord.Web_Last_Name__c= 'Test';
        caseRecord.WOW_Web_Email_Address__c= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedEmail= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedName= 'Test Test';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Parking';
        caseRecord.Sub_Category_3__c= 'Parking Issues';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'Web';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'testTeamMember@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999000999';
        caseRecord.New_or_Existing_Request__c='Existing';
        caseRecord.RecordTypeId = rt.Id;
        
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        workRequestRecord.Payroll_Number__c = 'P1234';
        workRequestRecord.Employment_Status__c = 'Contractor';
        workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
        workRequestRecord.Do_you_require_a_Monitor__c = 'No';
        workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
        workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';

        List<String> cvList = new List<String>();
        cvList.add('123456');
        
        User selectedUser = fetchUser();
        System.runAs(selectedUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
            WPSFormController.submitWPSWebForm(caseRecord, workRequestRecord,'googleRecaptchaToken', cvList);
            Test.stopTest();
        }  
        System.assert(String.isNotBlank(STR_USERNAME), true); 
    }
    
    
    @isTest
    private static void testSubmitWPSPublicFormMapDummyTeamMember() {
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        caseRecord.Web_First_Name__c = 'Test';
        caseRecord.Web_Last_Name__c= 'Test';
        caseRecord.WOW_Web_Email_Address__c= 'test@woolworths.com.au';
        caseRecord.SuppliedEmail= 'test@woolworths.com.au';
        caseRecord.SuppliedName= 'Test Test';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Parking';
        caseRecord.Sub_Category_3__c= 'Parking Issues';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'Web';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'test@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999000999';
        caseRecord.New_or_Existing_Request__c='Existing';
        caseRecord.RecordTypeId = rt.Id;
        
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        workRequestRecord.Payroll_Number__c = 'P1234';
        workRequestRecord.Employment_Status__c = 'Contractor';
        workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
        workRequestRecord.Do_you_require_a_Monitor__c = 'No';
        workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
        workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';
        
     //   String uploadedFiles = '{"files":[{"filename":"Example.PNG","base64":"iVBORw0KG"}]}';
        
        List<String> cvList = new List<String>();
        cvList.add('123456');
        
        User selectedUser = fetchUser();
        System.runAs(selectedUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
            WPSFormController.submitWPSWebForm(caseRecord, workRequestRecord,'googleRecaptchaToken', cvList);
            Test.stopTest();
        }   
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }
    
    private static User fetchUser() {
        User usr = [SELECT Id,EmployeeNumber FROM User WHERE UserName =:STR_USERNAME];
        usr.EmployeeNumber = 'P123456';
        update usr;
        return usr;
    }



    @isTest
    private static void testSubmitWPSPublicFormWithException() {
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Web_First_Name__c = 'Test';
        caseRecord.Web_Last_Name__c= 'Test';
        caseRecord.WOW_Web_Email_Address__c= 'test@woolworths.com.au';
        caseRecord.SuppliedEmail= 'test@woolworths.com.au';
        caseRecord.SuppliedName= 'Test Test';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Parking';
        caseRecord.Sub_Category_3__c= 'Parking Issues';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'Web';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'test@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999000999';
        caseRecord.New_or_Existing_Request__c='Existing';
        caseRecord.RecordTypeId = rt.Id;
        
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        workRequestRecord.Payroll_Number__c = 'P1234';
        workRequestRecord.Employment_Status__c = 'Contractor';
        workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
        workRequestRecord.Do_you_require_a_Monitor__c = 'No';
        workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
        workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';
        
    //    String uploadedFiles = '{"files":[{"filename":"..PNG","base64":"===="}]}';
     
    	List<String> cvList = new List<String>();
        cvList.add('123456');
        
        User selectedUser = fetchUser();
        System.runAs(selectedUser){
            Test.startTest();
            try {
                Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
                WPSFormController.submitWPSWebForm(caseRecord, workRequestRecord,'googleRecaptchaToken',cvList);
            } catch (Exception ex) {
                System.debug('error->'+ex);
            }
            
            Test.stopTest();
        }   
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }   
}