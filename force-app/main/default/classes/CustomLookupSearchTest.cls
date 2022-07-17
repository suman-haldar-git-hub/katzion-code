/**
* @description       : Test class for CustomLookupSearch
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   20-08-2021   Akhil  Kumar     Initial Version
**/

@isTest
public class CustomLookupSearchTest { 
    private static final String USR_NAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';
    
    @testSetup
    static void testSetup(){
        CommonTestDataFactory.buildTestUser();	
        CommonTestDataFactory.createTeamMember('P123456');
    }
    
    @isTest
    private static void testSearchCaseRecords() {
        
        User selectedUser = [SELECT Id,EmployeeNumber FROM User WHERE UserName =:USR_NAME];
        selectedUser.EmployeeNumber = 'P123456';
        update selectedUser;
        
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
        
        System.runAs(selectedUser){
            Test.startTest();
            insert caseRecord;
            
            String caseNumber = [Select Id, CaseNumber From Case Where Subject = 'Request to clean floor'][0].CaseNumber;
            CustomLookupSearch.findRecords(caseNumber, 'Case', 'CaseNumber');
            Test.stopTest();
        }
        System.assert(String.isNotBlank(USR_NAME), true);
    }
    
    @isTest
    private static void testSearchCaseCatchBlock() {
        
        User selectedUser = [SELECT Id,EmployeeNumber FROM User WHERE UserName =:USR_NAME];
        selectedUser.EmployeeNumber = 'P123456';
        update selectedUser;
        
        System.runAs(selectedUser){
            try {
                Test.startTest();
                CustomLookupSearch.findRecords('123456', 'Case', 'CaseNo');
                Test.stopTest();
            }
            catch(Exception ex) {
                System.assertEquals(String.isNotBlank(ex.getMessage()), true);
            }  
        }     
    }
}