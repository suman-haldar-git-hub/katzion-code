/**
* @description       : Test class for WPSCaseDetailController
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   14-09-2021   Akhil  Kumar     Initial Version
**/

@isTest
public class WPSCaseDetailControllerTest {
    private static final String USRNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
    
    @testSetup
    static void testSetup(){
        CommonTestDataFactory.buildTestUser();	
        CommonTestDataFactory.createTeamMember('P123456');
        CommonTestDataFactory.createCase();
    }
    
    @isTest
    private static void testWpsCaseDetail() {
        User selectedUser = fetchUser();
        
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        
        System.runAs(selectedUser){
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
            caseRecord.OwnerId = selectedUser.Id;
            caseRecord.Related_to_Existing_Case_Number__c = '';
            insert caseRecord;    
            
            Work_Requests__c workRequestRecord = new Work_Requests__c();
            workRequestRecord.Payroll_Number__c = 'P1234';
            workRequestRecord.Employment_Status__c = 'Contractor';
            workRequestRecord.Do_you_require_a_Chair__c = 'Yes';
            workRequestRecord.Do_you_require_a_Monitor__c = 'No';
            workRequestRecord.Do_you_require_a_Keyboard__c = 'No';
            workRequestRecord.Do_you_require_a_Wired_Headset__c = 'Yes';
            workRequestRecord.Case__c = caseRecord.Id;
            insert workRequestRecord;
            
            String fieldString = 'Do_you_require_a_Chair__c, Do_you_require_a_Monitor__c, ';
            
            Test.startTest();
            Case caseRec = WPSCaseDetailController.getCaseRecord(caseRecord.Id); 
            System.assertEquals('Request to clean floor', caseRec.Subject);
            Work_Requests__c workRequestRec = WPSCaseDetailController.getWorkRequestRecord(fieldString,caseRecord.Id);
            Test.stopTest();
        }    
    }
    
     @isTest
    private static void testWpsCaseDetailCatchBlock() {
        User selectedUser = fetchUser();
        
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        
        System.runAs(selectedUser){   
            
            String fieldString = 'Do_you_require_a_Chair__c, Do_you_require_a_Monitor__c, ';
            
            Test.startTest();
            Case caseRec = WPSCaseDetailController.getCaseRecord('1234'); 
            Work_Requests__c workRequestRec = WPSCaseDetailController.getWorkRequestRecord(fieldString,'12345');
            System.assertEquals(String.isNotBlank(USRNAME), true);
            Test.stopTest();
        }    
    }
    
    private static User fetchUser() {
        User usr = [SELECT Id,EmployeeNumber FROM User WHERE UserName =:USRNAME];
        usr.EmployeeNumber = 'P123456';
        update usr;
        return usr;
    }
}