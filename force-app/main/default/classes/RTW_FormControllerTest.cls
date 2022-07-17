/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class RTW_FormControllerTest {
    @testSetup
    static void setupTestData(){
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='Return Work Form Profile'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'Australia/Sydney';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'firstname';
        user.LastName = 'lastname';
        user.Username = 'guestUsertest@woolworths.com.au';   
        user.CommunityNickname = 'testUser';
        user.Alias = 't1';
        user.Email = 'guestUsertest@woolworths.com.au';
        user.IsActive = true;
        user.EmployeeNumber = '123';
        insert user;
        
        User loggedInUser = [Select id,name,EmployeeNumber from User where id =: userinfo.getUserId()];
        
        Account acc = new Account();
        acc.FirstName = 'X';
        acc.LastName = 'Y';
        acc.Employee_ID__c = loggedInUser.EmployeeNumber;
        acc.PersonEmail = 'xyz@email.com';
        insert acc;
        
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
        locationObj3.RTW_State__c='NSW';
        locationObj3.RTW_Sub_Department__c='IT';
        locationObj3.RTW_Days_Per_Week__c=2;
        listLocations.add(locationObj3);
        
        RTW_Location__c locationObj4=new RTW_Location__c();
        locationObj4.RTW_Department__c='Level 1';
        locationObj4.RTW_Office__c='Yennora';
        locationObj4.RTW_Seats__c=20;
        locationObj4.RTW_State__c='NSW';
        locationObj4.RTW_Sub_Department__c='Fraud';
        locationObj4.RTW_Days_Per_Week__c=2;
        listLocations.add(locationObj4);
        
        RTW_Location__c locationObj5=new RTW_Location__c();
        locationObj5.RTW_Department__c='Level 1';
        locationObj5.RTW_Office__c='Yennora';
        locationObj5.RTW_Seats__c=20;
        locationObj5.RTW_State__c='NSW';
        locationObj5.RTW_Sub_Department__c='BOC';
        locationObj5.RTW_Days_Per_Week__c=2;
        listLocations.add(locationObj5);
        
        RTW_Location__c locationObj6=new RTW_Location__c();
        locationObj6.RTW_Department__c='Level 2';
        locationObj6.RTW_Office__c='Yennora';
        locationObj6.RTW_Seats__c=20;
        locationObj6.RTW_State__c='NSW';
        locationObj6.RTW_Sub_Department__c='IT';
        locationObj6.RTW_Days_Per_Week__c=2;
        listLocations.add(locationObj6);
        
        insert listLocations;
    }
    
    private static testmethod void testGetPicklistMap() {
        test.startTest();
        Map<String,List<RTW_FormController.PicklistWrapper>> returnMap=RTW_FormController.getPicklistMap();
        test.stopTest();
        
        List<RTW_FormController.PicklistWrapper> listPicklistWrapper= returnMap.get('Norwest');   
        system.assertEquals(2, listPicklistWrapper.size());
        for(RTW_FormController.PicklistWrapper picklistWrapperObj :listPicklistWrapper){
            if(picklistWrapperObj.department=='West 1'){
                system.assertEquals(true, picklistWrapperObj.listSubDepartments.contains('Woolies X'));
            }
            else{
                system.assertEquals(true, picklistWrapperObj.listSubDepartments.contains('Exports'));
            }
        }
        
        List<RTW_FormController.PicklistWrapper> listPicklistWrapper1= returnMap.get('Yennora');   
        system.assertEquals(2, listPicklistWrapper1.size());
        for(RTW_FormController.PicklistWrapper picklistWrapperObj :listPicklistWrapper1){
            if(picklistWrapperObj.department=='Level 1'){
                system.assertEquals(3, picklistWrapperObj.listSubDepartments.size());
            }else{
                system.assertEquals(1, picklistWrapperObj.listSubDepartments.size());
            }
        }        
    }
    
    private static testmethod void testCheckFormAvailability1() {
        test.startTest();
        Date todayDate=Date.today();
        Date batchDate=todayDate.addDays(-14);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        RTW_FormController.FormAvailablityDetail returnFlag=RTW_FormController.checkFormAvailability();
        system.assertEquals(false, returnFlag.isAvailable);
        test.stopTest();
    }
    
    private static testmethod void testCheckFormAvailability2() {
        test.startTest();
        Date todayDate=Date.today();
        Date batchDate=todayDate.addDays(-12);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        RTW_FormController.FormAvailablityDetail returnFlag=RTW_FormController.checkFormAvailability();
        system.assertEquals(true, returnFlag.isAvailable);
        test.stopTest();
    }
    
    private static testmethod void testGetEmailDomains() {
        RTW_Email_Domains__c emailDomainsObj=new RTW_Email_Domains__c(Name='@woolworths');
        insert emailDomainsObj;
        
        test.startTest();
        List<RTW_Email_Domains__c> listEmailDomains=RTW_FormController.getEmailDomains();
        system.assertEquals('@woolworths', listEmailDomains[0].Name);
        test.stopTest();        
    }
    
    //Get Available Dates without reservation records
    private static testmethod void testGetAvailableDates1() {
        Date batchDate=Date.today();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=1;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj=new RTW_Reservation__c();
        resObj.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        test.startTest();
        Map<String,list<RTW_FormController.AvailableDateOption>> retMap=RTW_FormController.getAvailableDates('Yennora','Level 1','BOC',resObj);
        list<RTW_FormController.AvailableDateOption> l1=retMap.get('Week1');
        system.assertEquals(3, l1.size());
        list<RTW_FormController.AvailableDateOption> l2=retMap.get('Week2');
        system.assertEquals(3, l2.size());
        RTW_FormController.fetchTeamMember('xyz@email.com');
        test.stopTest();
    }
    
    //Get Available Dates with the reservation record
    private static testmethod void testGetAvailableDates2() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date reservedDate=batchWeekStart.addDays(15);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=1;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj1=new RTW_Reservation__c();
        resObj1.RTW_Cancel_Booking__c=false;
        resObj1.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj1.RTW_First_Name__c='firstname';
        resObj1.RTW_Department__c='Level 1';
        resObj1.RTW_Last_Name__c='lastname';
        resObj1.RTW_Office__c='Yennora';
        resObj1.RTW_Payroll_Number__c='PN12345';
        resObj1.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate][0].Id;
        resObj1.RTW_Sub_Department__c='It';
        insert resObj1;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        test.startTest();
        Map<String,list<RTW_FormController.AvailableDateOption>> retMap=RTW_FormController.getAvailableDates('Yennora','Level 1','BOC',resObj2);
        list<RTW_FormController.AvailableDateOption> l=retMap.get('Week2');
        system.assertEquals(3, l.size());
        for(RTW_FormController.AvailableDateOption obj :l){
            if(obj.reservedAlready){
                Date availableOptionDate=Date.valueOf(obj.value);
                system.assertEquals(reservedDate, availableOptionDate);
            }
        }
        test.stopTest();
    } 
    
    //Get Available Dates with zero available seats 
    private static testmethod void testGetAvailableDates3() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=1;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=0;//zero available seats 
        listDailyReservations.add(dailyResObj7);
        insert listDailyReservations;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        test.startTest();
        Map<String,list<RTW_FormController.AvailableDateOption>> retMap=RTW_FormController.getAvailableDates('Yennora','Level 1','BOC',resObj2);
        list<RTW_FormController.AvailableDateOption> l=retMap.get('Week2');
        system.assertEquals(3, l.size());
        test.stopTest();
    } 
    
    //Get Available Dates with Available Date is yesterday's Date 
    /*private static testmethod void testGetAvailableDates4() {
Date batchDate=Date.today().addDays(-5);
Date batchWeekStart=batchDate.toStartOfWeek();
RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
insert batchDetailsObj;

Date week1Start=batchWeekStart.addDays(7);
Date week1End=batchWeekStart.addDays(13);
Date week2Start=batchWeekStart.addDays(14);
Date week2End=batchWeekStart.addDays(20);

List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
dailyResObj1.RTW_Active__c=true;
dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
dailyResObj1.RTW_Department__c='Level 1';
dailyResObj1.RTW_Office__c='Yennora';
dailyResObj1.RTW_Sub_Department__c='BOC';
dailyResObj1.RTW_Total_Seats__c=20;        
listDailyReservations.add(dailyResObj1);

RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
dailyResObj2.RTW_Active__c=true;
dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
dailyResObj2.RTW_Department__c='Level 1';
dailyResObj2.RTW_Office__c='Yennora';
dailyResObj2.RTW_Sub_Department__c='BOC';
dailyResObj2.RTW_Total_Seats__c=20;        
listDailyReservations.add(dailyResObj2);

RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
dailyResObj3.RTW_Active__c=true;
dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
dailyResObj3.RTW_Department__c='Level 1';
dailyResObj3.RTW_Office__c='Yennora';
dailyResObj3.RTW_Sub_Department__c='BOC';
dailyResObj3.RTW_Total_Seats__c=20;        
listDailyReservations.add(dailyResObj3);

RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
dailyResObj4.RTW_Active__c=true;
dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(15);
dailyResObj4.RTW_Department__c='Level 1';
dailyResObj4.RTW_Office__c='Yennora';
dailyResObj4.RTW_Sub_Department__c='BOC';
dailyResObj4.RTW_Total_Seats__c=20;        
listDailyReservations.add(dailyResObj4);

RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
dailyResObj5.RTW_Active__c=true;
dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(16);
dailyResObj5.RTW_Department__c='Level 1';
dailyResObj5.RTW_Office__c='Yennora';
dailyResObj5.RTW_Sub_Department__c='BOC';
dailyResObj5.RTW_Total_Seats__c=1;        
listDailyReservations.add(dailyResObj5);

RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
dailyResObj6.RTW_Active__c=true;
dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(17);
dailyResObj6.RTW_Department__c='Level 1';
dailyResObj6.RTW_Office__c='Yennora';
dailyResObj6.RTW_Sub_Department__c='BOC';
dailyResObj6.RTW_Total_Seats__c=20;        
listDailyReservations.add(dailyResObj6);

RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
dailyResObj7.RTW_Active__c=true;
dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(7);//PastDate
dailyResObj7.RTW_Department__c='Level 1';
dailyResObj7.RTW_Office__c='Yennora';
dailyResObj7.RTW_Sub_Department__c='BOC';
dailyResObj7.RTW_Total_Seats__c=0;//zero available seats 
listDailyReservations.add(dailyResObj7);
insert listDailyReservations;

RTW_Reservation__c resObj2=new RTW_Reservation__c();
resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';

test.startTest();
Map<String,list<RTW_FormController.AvailableDateOption>> retMap=RTW_FormController.getAvailableDates('Yennora','Level 1','BOC',resObj2);
list<RTW_FormController.AvailableDateOption> l=retMap.get('Week1');
system.assertEquals(1, l.size());
test.stopTest();
} */
    
    
    //Repatcha Coverage	    
    private static testmethod void testSubmitForm1() {
        
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c(); 
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=Date.today();
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        insert dailyResObj1;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RTWGoogleReCaptcha_MockHttpRespGenerator());
        
        Date dt1=Date.today().addDays(8);
        String dt1Str=String.valueOf(dt1);
        Date dt2=Date.today().addDays(14);
        String dt2Str=String.valueOf(dt2);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        List<String> cancelReservationList=new List<String>();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj2,listDates,cancelReservationList,'captchaTokenstr');
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SubmitForm for NONVIP Member with zero already existing reservation records(Existing reservation records is zero)
    private static testmethod void testSubmitForm2() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=1;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=System.today();
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Test.startTest();
        Date dt1=batchWeekStart.addDays(8);
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(15);
        String dt3Str=String.valueOf(dt3);
        Date dt4=batchWeekStart.addDays(16);
        String dt4Str=String.valueOf(dt4);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        listDates.add(dt4Str);
        List<String> cancelReservationList=new List<String>();
        
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj2,listDates,cancelReservationList, null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SubmitForm for VIP Member (Existing reservation records is zero)
    private static testmethod void testSubmitForm3() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=1;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        RTW_Daily_Reservation__c dailyResObj11=new RTW_Daily_Reservation__c();
        dailyResObj11.RTW_Active__c=true;
        dailyResObj11.RTW_Available_Date__c=System.today();
        dailyResObj11.RTW_Department__c='Level 1';
        dailyResObj11.RTW_Office__c='Yennora';
        dailyResObj11.RTW_Sub_Department__c='BOC';
        dailyResObj11.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj11);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Test.startTest();
        Date dt1=batchWeekStart.addDays(8);
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(10);
        String dt3Str=String.valueOf(dt3);
        Date dt4=batchWeekStart.addDays(11);
        String dt4Str=String.valueOf(dt4);
        Date dt5=batchWeekStart.addDays(12);
        String dt5Str=String.valueOf(dt5);
        Date dt6=batchWeekStart.addDays(15);
        String dt6Str=String.valueOf(dt6);
        Date dt7=batchWeekStart.addDays(16);
        String dt7Str=String.valueOf(dt7);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        listDates.add(dt4Str);
        listDates.add(dt5Str);
        listDates.add(dt6Str);
        listDates.add(dt7Str);
        
        List<String> cancelReservationList=new List<String>();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj2,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SubmitForm for VIP Member with zero available seats for few daily reservation records and less than five success reservation records(Existing reservation records is zero)
    private static testmethod void testSubmitForm4() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        RTW_Daily_Reservation__c dailyResObj11=new RTW_Daily_Reservation__c();
        dailyResObj11.RTW_Active__c=true;
        dailyResObj11.RTW_Available_Date__c=System.today();
        dailyResObj11.RTW_Department__c='Level 1';
        dailyResObj11.RTW_Office__c='Yennora';
        dailyResObj11.RTW_Sub_Department__c='BOC';
        dailyResObj11.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj11);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Test.startTest();
        Date dt1=batchWeekStart.addDays(8);
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(10);
        String dt3Str=String.valueOf(dt3);
        Date dt4=batchWeekStart.addDays(11);
        String dt4Str=String.valueOf(dt4);
        Date dt5=batchWeekStart.addDays(12);
        String dt5Str=String.valueOf(dt5);
        Date dt6=batchWeekStart.addDays(15);
        String dt6Str=String.valueOf(dt6);
        Date dt7=batchWeekStart.addDays(16);
        String dt7Str=String.valueOf(dt7);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        listDates.add(dt4Str);
        listDates.add(dt5Str);
        listDates.add(dt6Str);
        listDates.add(dt7Str);
        List<String> cancelReservationList=new List<String>();
        
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj2,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SubmitForm for VIP Member with zero available seats for few daily reservation records and more than five success reservation records(Existing reservation records is zero)
    private static testmethod void testSubmitForm5() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=0;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        RTW_Daily_Reservation__c dailyResObj11=new RTW_Daily_Reservation__c();
        dailyResObj11.RTW_Active__c=true;
        dailyResObj11.RTW_Available_Date__c=System.today();
        dailyResObj11.RTW_Department__c='Level 1';
        dailyResObj11.RTW_Office__c='Yennora';
        dailyResObj11.RTW_Sub_Department__c='BOC';
        dailyResObj11.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj11);
        
        insert listDailyReservations;
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Test.startTest();
        Date dt1=batchWeekStart.addDays(8);
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(10);
        String dt3Str=String.valueOf(dt3);
        Date dt4=batchWeekStart.addDays(11);
        String dt4Str=String.valueOf(dt4);
        Date dt5=batchWeekStart.addDays(12);
        String dt5Str=String.valueOf(dt5);
        Date dt6=batchWeekStart.addDays(15);
        String dt6Str=String.valueOf(dt6);
        Date dt7=batchWeekStart.addDays(16);
        String dt7Str=String.valueOf(dt7);
        Date dt8=batchWeekStart.addDays(17);
        String dt8Str=String.valueOf(dt8);
        Date dt9=batchWeekStart.addDays(18);
        String dt9Str=String.valueOf(dt9);
        Date dt10=batchWeekStart.addDays(19);
        String dt10Str=String.valueOf(dt10);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        listDates.add(dt4Str);
        listDates.add(dt5Str);
        listDates.add(dt6Str);
        listDates.add(dt7Str);
        listDates.add(dt8Str);
        listDates.add(dt9Str);
        listDates.add(dt10Str);
        List<String> cancelReservationList=new List<String>();
        
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj2,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SCENARIO for Label.RTW_Selected_Date_Already_Reserved
    private static testmethod void testSubmitForm6() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date reservedDate1=batchWeekStart.addDays(8);
        Date reservedDate2=batchWeekStart.addDays(9);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        insert listDailyReservations;
        
        List<RTW_Reservation__c> listRes=new List<RTW_Reservation__c>();
        RTW_Reservation__c resObj1=new RTW_Reservation__c();
        resObj1.RTW_Cancel_Booking__c=false;
        resObj1.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj1.RTW_First_Name__c='firstname';
        resObj1.RTW_Department__c='Level 1';
        resObj1.RTW_Last_Name__c='lastname';
        resObj1.RTW_Office__c='Yennora';
        resObj1.RTW_Payroll_Number__c='PN12345';
        resObj1.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate1][0].Id;
        resObj1.RTW_Sub_Department__c='It';
        listRes.add(resObj1);
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Cancel_Booking__c=false;
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj2.RTW_First_Name__c='firstname';
        resObj2.RTW_Department__c='Level 1';
        resObj2.RTW_Last_Name__c='lastname';
        resObj2.RTW_Office__c='Yennora';
        resObj2.RTW_Payroll_Number__c='PN12345';
        resObj2.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate2][0].Id;
        resObj2.RTW_Sub_Department__c='It';
        listRes.add(resObj2);
        insert listRes;
        
        RTW_Reservation__c resObj=new RTW_Reservation__c();
        resObj.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Date dt1=batchWeekStart.addDays(8);//Already Reserved records
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);//Already Reserved records
        String dt2Str=String.valueOf(dt2);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        List<String> cancelReservationList=new List<String>();
        
        Test.startTest();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SCENARIO FOR RTW_Week1_NONVIP_Already_Reserved_Error 
    private static testmethod void testSubmitForm7() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date reservedDate1=batchWeekStart.addDays(8);
        Date reservedDate2=batchWeekStart.addDays(9);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        insert listDailyReservations;
        
        List<RTW_Reservation__c> listRes=new List<RTW_Reservation__c>();
        RTW_Reservation__c resObj1=new RTW_Reservation__c();
        resObj1.RTW_Cancel_Booking__c=false;
        resObj1.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj1.RTW_First_Name__c='firstname';
        resObj1.RTW_Department__c='Level 1';
        resObj1.RTW_Last_Name__c='lastname';
        resObj1.RTW_Office__c='Yennora';
        resObj1.RTW_Payroll_Number__c='PN12345';
        resObj1.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate1][0].Id;
        resObj1.RTW_Sub_Department__c='It';
        listRes.add(resObj1);
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Cancel_Booking__c=false;
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj2.RTW_First_Name__c='firstname';
        resObj2.RTW_Department__c='Level 1';
        resObj2.RTW_Last_Name__c='lastname';
        resObj2.RTW_Office__c='Yennora';
        resObj2.RTW_Payroll_Number__c='PN12345';
        resObj2.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate2][0].Id;
        resObj2.RTW_Sub_Department__c='It';
        listRes.add(resObj2);
        insert listRes;
        
        RTW_Reservation__c resObj=new RTW_Reservation__c();
        resObj.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Date dt1=batchWeekStart.addDays(8);//Already Reserved records
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(9);//Already Reserved records
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(10);
        String dt3Str=String.valueOf(dt3);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        List<String> cancelReservationList=new List<String>();
        
        Test.startTest();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SCENARIO FOR RTW_Week2_NONVIP_Already_Reserved_Error 
    private static testmethod void testSubmitForm8() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date reservedDate1=batchWeekStart.addDays(15);
        Date reservedDate2=batchWeekStart.addDays(16);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        insert listDailyReservations;
        
        List<RTW_Reservation__c> listRes=new List<RTW_Reservation__c>();
        RTW_Reservation__c resObj1=new RTW_Reservation__c();
        resObj1.RTW_Cancel_Booking__c=false;
        resObj1.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj1.RTW_First_Name__c='firstname';
        resObj1.RTW_Department__c='Level 1';
        resObj1.RTW_Last_Name__c='lastname';
        resObj1.RTW_Office__c='Yennora';
        resObj1.RTW_Payroll_Number__c='PN12345';
        resObj1.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate1][0].Id;
        resObj1.RTW_Sub_Department__c='It';
        listRes.add(resObj1);
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Cancel_Booking__c=false;
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj2.RTW_First_Name__c='firstname';
        resObj2.RTW_Department__c='Level 1';
        resObj2.RTW_Last_Name__c='lastname';
        resObj2.RTW_Office__c='Yennora';
        resObj2.RTW_Payroll_Number__c='PN12345';
        resObj2.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate2][0].Id;
        resObj2.RTW_Sub_Department__c='It';
        listRes.add(resObj2);
        insert listRes;
        
        RTW_Reservation__c resObj=new RTW_Reservation__c();
        resObj.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Date dt1=batchWeekStart.addDays(15);//Already Reserved records
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(16);//Already Reserved records
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(17);
        String dt3Str=String.valueOf(dt3);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        List<String> cancelReservationList=new List<String>();
        
        Test.startTest();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
    //SCENARIO Where Valid request and Invalid Request 
    private static testmethod void testSubmitForm9() {
        Date batchDate=Date.today();
        Date batchWeekStart=batchDate.toStartOfWeek();
        Date reservedDate1=batchWeekStart.addDays(8);
        Date reservedDate2=batchWeekStart.addDays(16);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
        
        Date week1Start=batchWeekStart.addDays(7);
        Date week1End=batchWeekStart.addDays(13);
        Date week2Start=batchWeekStart.addDays(14);
        Date week2End=batchWeekStart.addDays(20);
        
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>(); 
        RTW_Daily_Reservation__c dailyResObj1=new RTW_Daily_Reservation__c();
        dailyResObj1.RTW_Active__c=true;
        dailyResObj1.RTW_Available_Date__c=batchWeekStart.addDays(8);
        dailyResObj1.RTW_Department__c='Level 1';
        dailyResObj1.RTW_Office__c='Yennora';
        dailyResObj1.RTW_Sub_Department__c='BOC';
        dailyResObj1.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj1);
        
        RTW_Daily_Reservation__c dailyResObj2=new RTW_Daily_Reservation__c();
        dailyResObj2.RTW_Active__c=true;
        dailyResObj2.RTW_Available_Date__c=batchWeekStart.addDays(9);
        dailyResObj2.RTW_Department__c='Level 1';
        dailyResObj2.RTW_Office__c='Yennora';
        dailyResObj2.RTW_Sub_Department__c='BOC';
        dailyResObj2.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj2);
        
        RTW_Daily_Reservation__c dailyResObj3=new RTW_Daily_Reservation__c();
        dailyResObj3.RTW_Active__c=true;
        dailyResObj3.RTW_Available_Date__c=batchWeekStart.addDays(10);
        dailyResObj3.RTW_Department__c='Level 1';
        dailyResObj3.RTW_Office__c='Yennora';
        dailyResObj3.RTW_Sub_Department__c='BOC';
        dailyResObj3.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj3);
        
        RTW_Daily_Reservation__c dailyResObj4=new RTW_Daily_Reservation__c();
        dailyResObj4.RTW_Active__c=true;
        dailyResObj4.RTW_Available_Date__c=batchWeekStart.addDays(11);
        dailyResObj4.RTW_Department__c='Level 1';
        dailyResObj4.RTW_Office__c='Yennora';
        dailyResObj4.RTW_Sub_Department__c='BOC';
        dailyResObj4.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj4);
        
        RTW_Daily_Reservation__c dailyResObj5=new RTW_Daily_Reservation__c();
        dailyResObj5.RTW_Active__c=true;
        dailyResObj5.RTW_Available_Date__c=batchWeekStart.addDays(12);
        dailyResObj5.RTW_Department__c='Level 1';
        dailyResObj5.RTW_Office__c='Yennora';
        dailyResObj5.RTW_Sub_Department__c='BOC';
        dailyResObj5.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj5);
        
        RTW_Daily_Reservation__c dailyResObj6=new RTW_Daily_Reservation__c();
        dailyResObj6.RTW_Active__c=true;
        dailyResObj6.RTW_Available_Date__c=batchWeekStart.addDays(15);
        dailyResObj6.RTW_Department__c='Level 1';
        dailyResObj6.RTW_Office__c='Yennora';
        dailyResObj6.RTW_Sub_Department__c='BOC';
        dailyResObj6.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj6);
        
        RTW_Daily_Reservation__c dailyResObj7=new RTW_Daily_Reservation__c();
        dailyResObj7.RTW_Active__c=true;
        dailyResObj7.RTW_Available_Date__c=batchWeekStart.addDays(16);
        dailyResObj7.RTW_Department__c='Level 1';
        dailyResObj7.RTW_Office__c='Yennora';
        dailyResObj7.RTW_Sub_Department__c='BOC';
        dailyResObj7.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj7);
        
        RTW_Daily_Reservation__c dailyResObj8=new RTW_Daily_Reservation__c();
        dailyResObj8.RTW_Active__c=true;
        dailyResObj8.RTW_Available_Date__c=batchWeekStart.addDays(17);
        dailyResObj8.RTW_Department__c='Level 1';
        dailyResObj8.RTW_Office__c='Yennora';
        dailyResObj8.RTW_Sub_Department__c='BOC';
        dailyResObj8.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj8);
        
        RTW_Daily_Reservation__c dailyResObj9=new RTW_Daily_Reservation__c();
        dailyResObj9.RTW_Active__c=true;
        dailyResObj9.RTW_Available_Date__c=batchWeekStart.addDays(18);
        dailyResObj9.RTW_Department__c='Level 1';
        dailyResObj9.RTW_Office__c='Yennora';
        dailyResObj9.RTW_Sub_Department__c='BOC';
        dailyResObj9.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj9);
        
        RTW_Daily_Reservation__c dailyResObj10=new RTW_Daily_Reservation__c();
        dailyResObj10.RTW_Active__c=true;
        dailyResObj10.RTW_Available_Date__c=batchWeekStart.addDays(19);
        dailyResObj10.RTW_Department__c='Level 1';
        dailyResObj10.RTW_Office__c='Yennora';
        dailyResObj10.RTW_Sub_Department__c='BOC';
        dailyResObj10.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj10);
        
        RTW_Daily_Reservation__c dailyResObj11=new RTW_Daily_Reservation__c();
        dailyResObj11.RTW_Active__c=true;
        dailyResObj11.RTW_Available_Date__c=System.today();
        dailyResObj11.RTW_Department__c='Level 1';
        dailyResObj11.RTW_Office__c='Yennora';
        dailyResObj11.RTW_Sub_Department__c='BOC';
        dailyResObj11.RTW_Total_Seats__c=20;        
        listDailyReservations.add(dailyResObj11);
        
        insert listDailyReservations;
        
        List<RTW_Reservation__c> listRes=new List<RTW_Reservation__c>();
        RTW_Reservation__c resObj1=new RTW_Reservation__c();
        resObj1.RTW_Cancel_Booking__c=false;
        resObj1.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj1.RTW_First_Name__c='firstname';
        resObj1.RTW_Department__c='Level 1';
        resObj1.RTW_Last_Name__c='lastname';
        resObj1.RTW_Office__c='Yennora';
        resObj1.RTW_Payroll_Number__c='PN12345';
        resObj1.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate1][0].Id;
        resObj1.RTW_Sub_Department__c='It';
        listRes.add(resObj1);
        
        RTW_Reservation__c resObj2=new RTW_Reservation__c();
        resObj2.RTW_Cancel_Booking__c=false;
        resObj2.RTW_Email__c='guestUsertest@woolworths.com.au';
        resObj2.RTW_First_Name__c='firstname';
        resObj2.RTW_Department__c='Level 1';
        resObj2.RTW_Last_Name__c='lastname';
        resObj2.RTW_Office__c='Yennora';
        resObj2.RTW_Payroll_Number__c='PN12345';
        resObj2.RTW_Reservation_Date__c=[Select id from RTW_Daily_Reservation__c where RTW_Available_Date__c=:reservedDate2][0].Id;
        resObj2.RTW_Sub_Department__c='It';
        listRes.add(resObj2);
        insert listRes;
        
        RTW_Reservation__c resObj=new RTW_Reservation__c();
        resObj.RTW_Email__c='guestUsertest@woolworths.com.au';
        
        Date dt1=batchWeekStart.addDays(8);//Already Reserved records
        String dt1Str=String.valueOf(dt1);
        Date dt2=batchWeekStart.addDays(16);//Already Reserved records
        String dt2Str=String.valueOf(dt2);
        Date dt3=batchWeekStart.addDays(9);
        String dt3Str=String.valueOf(dt3);
        Date dt4=batchWeekStart.addDays(17);
        String dt4Str=String.valueOf(dt4);
        List<String> listDates=new List<String>();
        listDates.add(dt1Str);
        listDates.add(dt2Str);
        listDates.add(dt3Str);
        listDates.add(dt4Str);
        List<String> cancelReservationList=new List<String>();
        cancelReservationList.add(resObj2.Id);
        
        Test.startTest();
        RTW_FormController.submitForm('Yennora','Level 1','BOC',resObj,listDates,cancelReservationList,null);
        System.assertEquals(String.isNotBlank(dailyResObj1.RTW_Department__c), true);
        Test.stopTest();
    }
    
}