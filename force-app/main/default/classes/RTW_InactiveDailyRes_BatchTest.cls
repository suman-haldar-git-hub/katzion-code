/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class RTW_InactiveDailyRes_BatchTest {
    @testSetup
    static void setupTestData(){
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=Date.today().addDays(2);
        dailyResObj1.RTW_Department__c='West 1'; 
        dailyResObj1.RTW_Office__c='Norwest';
        dailyResObj1.RTW_Sub_Department__c='Woolies X';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=Date.today().addDays(-2);
        dailyResObj2.RTW_Department__c='West 2';
        dailyResObj2.RTW_Office__c='Norwest';
        dailyResObj2.RTW_Sub_Department__c='Exports';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=Date.today().addDays(-2);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='IT';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=Date.today().addDays(-6);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='Fraud';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=Date.today().addDays(-6);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=Date.today().addDays(-6);
        dailyResObj6.RTW_Department__c='Level 2';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='IT';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        insert listDailyReservations;
    }
    
    private static testmethod void testMethod1() {
        test.startTest();
        RTW_InactiveDailyRes_Batch obj=new RTW_InactiveDailyRes_Batch();
        Database.executeBatch(obj);
        test.stopTest();
        
        List<RTW_Daily_Reservation__c> listDailyReservations=[Select id from RTW_Daily_Reservation__c where RTW_Active__c=true];
        system.assertEquals(1, listDailyReservations.size());        
    }
}