/**
 * @author      Abhishek Setia
 * @description Test data for Action Centre
 */
@isTest
public class ActionCentreTestData {


    /**
     * @author      Abhishek Setia
     * @description Setup custom settings data
     * @param       caseRecTypeId
     */
    public static void setupSettings(Id caseRecTypeId){
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();
        caseRecTypeCS.Transaction_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.WOW_NZ_ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.Query_Case__c = String.valueOf(caseRecTypeId);
        insert caseRecTypeCS;        
    }


    /**
     * @author      Abhishek Setia
     * @description Creates Accounts
     * @param       count
     * @param       insertData
     * @return      List<Account>
     */
    public static List<Account> getAccounts(Integer count, Boolean insertData){
        Id accountRT=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        List<Account> accounts=AccountTestData.createAccountRecords(count, accountRT);
        if(insertData && !accounts.isEmpty()){
            INSERT accounts;
        }
        return accounts;
    }

    /**
     * @author      Abhishek Setia
     * @description Creates case with minimum values
     * @param       recTypeId
     * @return      Case
     */
    public static Case createWithMinFields(Id recTypeId){
        Case cs=new Case();
        cs.RecordTypeId=recTypeId;
        cs.Origin='TeamHub';
        cs.Priority='Low';
        cs.Status='Open';
        return cs;
    }

    /**
     * @author      Abhishek Setia
     * @description Creates MyIncentive Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> myIncentiveCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
			Case cs=createWithMinFields(queryCaseRT);            
            cs.Subject='MyIncentive Test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Superannuation Processing';
            cs.TypeofDevice__c='Laptop';
            cs.TeamHubApplicationType__c='SalarySacrifice';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    
    /**
     * @author      Abhishek Setia
     * @description Salary Sacrifice Mobile Phone Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> salarySacrificeMobileCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
			Case cs=createWithMinFields(queryCaseRT);            
            cs.Subject='Mobile Phone Test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Salary Sacrifice';
            cs.TypeofDevice__c='Mobile Phone';
            cs.TeamHubApplicationType__c='SalarySacrifice';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    /**
     * @author      Abhishek Setia
     * @description Salary Sacrifice Smartwatch Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> salarySacrificeSmartwatchCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
			Case cs=createWithMinFields(queryCaseRT);            
            cs.Subject='Smartwatch Test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Salary Sacrifice';
            cs.TypeofDevice__c='Smartwatch';
            cs.TeamHubApplicationType__c='SalarySacrifice';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    /**
     * @author      Abhishek Setia
     * @description Salary Sacrifice Tablet Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> salarySacrificeTabletCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
			Case cs=createWithMinFields(queryCaseRT);            
            cs.Subject='Tablet Test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Salary Sacrifice';
            cs.TypeofDevice__c='Tablet';
            cs.TeamHubApplicationType__c='SalarySacrifice';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    /**
     * @author      Abhishek Setia
     * @description Creates Request Cases with no sub category
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> requestCaseWithNoSubcat(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
			Case cs=createWithMinFields(queryCaseRT);            
            cs.Subject='Test request case with no subcategory';
            cs.Category__c='SuccessFactors - System Permissions';
            cs.TeamHubApplicationType__c='PeopleServices';            
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    
    /**
     * @author      Abhishek Setia
     * @description Creates Request type Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> requestCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
            Case cs=createWithMinFields(queryCaseRT);
            cs.Subject='Request case test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Employee Relations';
            cs.TeamHubApplicationType__c='PeopleServices';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }


    /**
     * @author      Abhishek Setia
     * @description Creates Approvals
     * @param       count
     * @param       insertData
     * @return      List<UniversalTaskList__c>
     */
    public static List<UniversalTaskList__c> getApprovals(Integer count, Boolean insertData){
        List<UniversalTaskList__c> tas=new List<UniversalTaskList__c>();
        Id approvalRT=Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByDeveloperName().get('Approval').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
            UniversalTaskList__c ta=new UniversalTaskList__c();
            ta.RecordTypeId=approvalRT;
            ta.Title__c='Approval Record Test';
            ta.Status__c='approved';
            ta.CompletedDate__c=System.now();            
            ta.OriginatingSystem__c='TeamHub';
            tas.add(ta);
        }
        if(insertData && !tas.isEmpty()){
            INSERT tas;
        }
        return tas;
    }
    
    /**
     * @author      Akshansh Jain
     * @description Creates Leave type Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> requestCasesForLeave(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
            Case cs=createWithMinFields(queryCaseRT);
            cs.Subject='Request case test';
            cs.Category__c='Pay and the Basics';
            cs.Sub_Category__c='Leave Forms';
            cs.TeamHubApplicationType__c='Leave';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }

    /**
     * @author      Akhil Kumar
     * @description Create WPS type Cases
     * @param       count
     * @param       insertData
     * @return      List<Case>
     */
    public static List<Case> requestWPSCases(Integer count, Boolean insertData){        
        List<Case> cases=new List<Case>();
        Id queryCaseRT=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WPS').getRecordTypeId();
        for(Integer i=1;i<=count;i++){
            Case cs=createWithMinFields(queryCaseRT);
            cs.Subject='WPS case test';
            cs.Category__c='WPS';
            cs.Sub_Category__c='WPS';
            cs.TeamHubApplicationType__c='WorkplaceSupportRequest';
            cs.Closed_Case_Comments__c = 'Closed Comment';
            cases.add(cs);
        }
        if(insertData && !cases.isEmpty()){
            INSERT cases;
        }
        return cases;
    }
    
    /**
     * @author      Akhil Kumar
     * @description Create reservation of type booking
     * @param       count
     * @return      List<RTW_Reservation__c>
     */
    public static List<RTW_Reservation__c> requestReservationRecords(Integer count, Date reserveDate){
        List<RTW_Reservation__c> resList = new List<RTW_Reservation__c>();
        for(Integer i=0;i<count;i++){
            RTW_Reservation__c obj = new RTW_Reservation__c();
            obj.RTW_First_Name__c = 'Test'+i;
            obj.RTW_Last_Name__c = 'Test'+i;
            obj.RTW_Office__c  = 'FSS';
            obj.RTW_Department__c = 'East 1';
            obj.RTW_Sub_Department__c = 'Legal';
            obj.RTW_Payroll_Number__c = '89879';
            obj.RTW_Email__c = 'testParent@woolworths.com';
            obj.RTW_Cancel_Booking__c = false;
            obj.Type__c = 'Booking';
            obj.RTW_Reservation_Date__c = createDailyReservation(reserveDate+i).Id;
            resList.add(obj);
        }
        insert resList;
        return resList;
    }
    
    /**
     * @author      Akhil Kumar
     * @description Create daily reservation record
     * @param       reserve Date
     * @return      RTW_Daily_Reservation__c
     */
    public static RTW_Daily_Reservation__c createDailyReservation(Date reservDate) {
        RTW_Daily_Reservation__c obj = new RTW_Daily_Reservation__c();
        obj.RTW_Active__c = true;
        obj.RTW_Available_Date__c = reservDate;
        obj.RTW_Office__c  = 'FSS';
        obj.RTW_Department__c = 'East 1';
        obj.RTW_Sub_Department__c = 'Legal';
        obj.RTW_Total_Seats__c = 6;
        insert obj;
        return obj;
    }
}