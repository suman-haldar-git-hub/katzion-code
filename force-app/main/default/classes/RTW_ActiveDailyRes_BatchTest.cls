/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class RTW_ActiveDailyRes_BatchTest {
    @testSetup
    static void setupTestData(){
        List<RTW_Location__c> listLocations=new List<RTW_Location__c>();  
        RTW_Location__c locationObj1=new RTW_Location__c();
        locationObj1.RTW_Department__c='West 1';
        locationObj1.RTW_Office__c='Norwest';
        locationObj1.RTW_Seats__c=20;
        locationObj1.RTW_State__c='NSW';
        locationObj1.RTW_Sub_Department__c='Woolies X';
        listLocations.add(locationObj1);
        
        RTW_Location__c locationObj2=new RTW_Location__c();
        locationObj2.RTW_Department__c='West 2';
        locationObj2.RTW_Office__c='Norwest';
        locationObj2.RTW_Seats__c=20;
        locationObj2.RTW_State__c='NSW';
        locationObj2.RTW_Sub_Department__c='Exports';
        listLocations.add(locationObj2);
        
        RTW_Location__c locationObj3=new RTW_Location__c();
        locationObj3.RTW_Department__c='Level 1';
        locationObj3.RTW_Office__c='Yennora';
        locationObj3.RTW_Seats__c=20;
        locationObj3.RTW_State__c='Victoria';
        locationObj3.RTW_Sub_Department__c='IT';
        listLocations.add(locationObj3);
        
        RTW_Location__c locationObj4=new RTW_Location__c();
        locationObj4.RTW_Department__c='Level 1';
        locationObj4.RTW_Office__c='Yennora';
        locationObj4.RTW_Seats__c=20;
        locationObj4.RTW_State__c='Victoria';
        locationObj4.RTW_Sub_Department__c='Fraud';
        listLocations.add(locationObj4);
        
        RTW_Location__c locationObj5=new RTW_Location__c();
        locationObj5.RTW_Department__c='Level 1';
        locationObj5.RTW_Office__c='Yennora';
        locationObj5.RTW_Seats__c=20;
        locationObj5.RTW_State__c='Victoria';
        locationObj5.RTW_Sub_Department__c='BOC';
        listLocations.add(locationObj5);
        
        RTW_Location__c locationObj6=new RTW_Location__c();
        locationObj6.RTW_Department__c='Level 2';
        locationObj6.RTW_Office__c='FSS';
        locationObj6.RTW_Seats__c=20;
        locationObj6.RTW_State__c='South Australia';
        locationObj6.RTW_Sub_Department__c='IT';
        listLocations.add(locationObj6);
        
        insert listLocations;
        
        CommonTestDataFactory.createLocation();
        CommonTestDataFactory.createDailyReservation(System.today().addDays(9));
        
        Date todayDate=Date.today();
        Date startOfWeek=todayDate.toStartOfWeek();
        Date holidayDate1=startOfWeek.addDays(10);
        Date holidayDate2=startOfWeek.addDays(12);
        Date holidayDate3=startOfWeek.addDays(17);
        
        List<Public_Holidays__c> listHolidays=new List<Public_Holidays__c>();
        Public_Holidays__c holidaysObj1=new Public_Holidays__c(Name='PH1',Holiday_Date__c=holidayDate1,State__c='NSW');
        listHolidays.add(holidaysObj1);
        
        Public_Holidays__c holidaysObj2=new Public_Holidays__c(Name='PH2',Holiday_Date__c=holidayDate2,State__c='Victoria');
        listHolidays.add(holidaysObj2);
        
        Public_Holidays__c holidaysObj3=new Public_Holidays__c(Name='PH3',Holiday_Date__c=holidayDate3,State__c='Victoria');
        listHolidays.add(holidaysObj3);
        
        insert listHolidays;  
    }
    
    private static testmethod void testMethod1() {
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=Date.today());
        insert batchDetailsObj;
        
        Test.startTest();
        RTW_ActiveDailyRes_Batch obj=new RTW_ActiveDailyRes_Batch();
        Database.executeBatch(obj);
        Test.stopTest();
        
        List<RTW_Daily_Reservation__c> listDailyReservations=[Select id from RTW_Daily_Reservation__c where RTW_Office__c='Norwest'];
        system.assertEquals(true, listDailyReservations.size()>0);
        
        List<RTW_Daily_Reservation__c> listDailyReservations1=[Select id from RTW_Daily_Reservation__c where RTW_Office__c='Yennora'];
        system.assertEquals(true, listDailyReservations.size()>0);
        
        List<RTW_Daily_Reservation__c> listDailyReservations2=[Select id from RTW_Daily_Reservation__c where RTW_Office__c='FSS'];
        system.assertEquals(true, listDailyReservations.size()>0);
    }   
    
    private static testmethod void testMethod2() {
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch1');
        insert batchDetailsObj;
        
        Test.startTest();
        RTW_ActiveDailyRes_Batch obj=new RTW_ActiveDailyRes_Batch();
        Database.executeBatch(obj);
        Test.stopTest();
        
        System.assertEquals(String.isNotBlank(batchDetailsObj.Name), true);
    }  
}