/*
Description   A utility class to build test data used in all test class methods
Author        Joginder Kumar 19/07/2021
History       Initial creation
*/
@IsTest(SeeAllData=false)
public class CommonTestDataFactory {
      
    /*
    * Method Name : buildTestUser
    * Description : Helper method to create a test user record
    * Parameters  : None
    * Return Type : User
    */
    public static User buildTestUser(){
        String uniqueUserName = 'systemAdmin' + '@WPSHRNZDEVorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='systemAdmin@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing',Firstname='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles',Phone='8888888888',   
                          UserName=uniqueUserName);  
        insert u; 
        return u;
    }
    
    /*
* Method Name : createLocation
* Description : Helper method to create a RTW_Location record
* Parameters  : None
* Return Type : RTW_Location__c
*/
    public static RTW_Location__c createLocation() {
        RTW_Location__c obj = new RTW_Location__c();
        obj.RTW_Office__c  = 'FSS';
        obj.RTW_Department__c = 'East 1';
        obj.RTW_Sub_Department__c = 'Legal';
        obj.RTW_State__c = 'Tasmania';
        obj.RTW_Seats__c = 4;
        insert obj;
        return obj;
    }
    
    /*
* Method Name : createDailyReservation
* Description : Helper method to create a RTW_Daily_Reservation__c record
* Parameters  : reservDate(Date)
* Return Type : RTW_Daily_Reservation__c
*/
    
    public static RTW_Daily_Reservation__c createDailyReservation(Date reservDate) {
        System.debug('reservDate->'+reservDate);
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
    
    /*
* Method Name : createReservation
* Description : Helper method to create a RTW_Reservation__c record
* Parameters  : email(String) and numberOfReservations (Integer)
* Return Type : list of RTW_Reservation__c
*/
    public static List<RTW_Reservation__c> createReservation(String email,Integer numberOfReservations) {
        List<RTW_Reservation__c> resList = new List<RTW_Reservation__c>();
        for(Integer i=0;i<numberOfReservations;i++){
            RTW_Reservation__c obj = new RTW_Reservation__c();
            obj.RTW_First_Name__c = 'Test'+i;
            obj.RTW_Last_Name__c = 'Test'+i;
            obj.RTW_Office__c  = 'FSS';
            obj.RTW_Department__c = 'East 1';
            obj.RTW_Sub_Department__c = 'Legal';
            obj.RTW_Payroll_Number__c = '89879';
            obj.RTW_Email__c = email;
            obj.RTW_Cancel_Booking__c = false;
            obj.RTW_Reservation_Date__c = createDailyReservation(System.today()+i).Id;
            System.debug('obj-'+obj.RTW_Reservation_Date__r.RTW_Available_Date__c);
            resList.add(obj);
        }
        insert resList;
        return resList;
    }
    
    /*
* Method Name : createReservation
* Description : Helper method to create a parent RTW_Reservation__c record
* Parameters  : email(String) and numberOfReservations (Integer)
* Return Type : list of RTW_Reservation__c
*/
    public static List<RTW_Reservation__c> createParentReservation(String email, integer numberOfReservations) {
        List<RTW_Reservation__c> resList = new List<RTW_Reservation__c>();
        for(Integer i=0;i<numberOfReservations;i++){
            RTW_Reservation__c obj = new RTW_Reservation__c();
            obj.RTW_First_Name__c = 'TestParent'+i;
            obj.RTW_Last_Name__c = 'TestParent'+i;
            obj.RTW_Office__c  = 'FSS';
            obj.RTW_Department__c = 'East 1';
            obj.RTW_Sub_Department__c = 'Legal';
            obj.RTW_Payroll_Number__c = '89879';
            obj.RTW_Email__c = email;
            obj.RTW_Cancel_Booking__c = false;
            obj.RTW_Reservation_Date__c = createDailyReservation(System.today()).Id;
            obj.Type__c = 'Booking';
            resList.add(obj);
        }
        insert resList;
        return resList;
    }
    
     /*
* Method Name : createTeamMember
* Description : Helper method to create a parent RTW_Reservation__c record
* Parameters  : email(String), employeeId(String)
* Return Type : None
*/
    public static void createTeamMember(string employeeId) {
        Recordtype rt = [Select id from recordtype where name= 'Individual Account'];
        
        Account teamMember = new Account();
        teamMember.RecordTypeId = rt.id;
        teamMember.PersonEmail = 'testTeamMember@woolworths.com.au';
        teamMember.Employee_Class__c = 'F';
        teamMember.Employee_ID__c = employeeId;
        teamMember.LastName = 'Test';
        insert teamMember;
    }


       /*
* Method Name : createCase
* Description : Helper method to create a case record
* Parameters  : None
* Return Type : None
*/

    public static void createCase(){
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        insert caseRecord;
    }
    
    
    
    public static void createThreashold(){
        PC_Primary_Connect_Setting__c setting = new PC_Primary_Connect_Setting__c();
        setting.PC_reCaptcha_Threshold_Score__c = 0.6;
        insert setting;
    }

}