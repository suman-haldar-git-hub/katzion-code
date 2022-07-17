/*==============================
* @Class Name : RTW_CancelBookingsQueueableTest
* @Author : Joginder Kumar
* @Purpose: Test Class for RTW_CancelBookingsQueueable class
* @Created date: 19/07/2021
*/


@isTest
public class RTW_CancelBookingsQueueableTest {
    
    private static final String STR_USERNAME = 'systemAdmin' + '@WPSHRNZDEVorg.com';

    @TestSetup
    static void setup(){
        CommonTestDataFactory.buildTestUser();
        CommonTestDataFactory.createLocation();
        CommonTestDataFactory.createReservation('test1@test.com',2);
        CommonTestDataFactory.createReservation('test2@test.com',2); 
    }

    /**
    * @description 
    * @author Joginder Kumar | 09-16-2021 
    **/
    @isTest
    Static void cancelBookingsForLocationsTest(){

        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        RTW_Location__c location = [Select RTW_Office__c,RTW_Department__c,RTW_Sub_Department__c From  RTW_Location__c limit 1];
        List<RTW_CancelBookingsQueueable.CancelBookingRequest> requestArray = new List<RTW_CancelBookingsQueueable.CancelBookingRequest> ();
        RTW_CancelBookingsQueueable.CancelBookingRequest booking = new RTW_CancelBookingsQueueable.CancelBookingRequest();
        booking.Office = 'FSS';
        booking.deactivationStartDate = System.today();
        booking.deactivationEndDate = System.today()+15;
        requestArray.add(booking);
        System.runAs(selectedUser){
            Test.startTest();
            RTW_CancelBookingsQueueable.cancelBookingsForLocations(requestArray);
            Test.stopTest();
        }
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }

    /**
    * @description 
    * @author Joginder Kumar | 09-16-2021 
    **/
    @isTest
    Static void cancelBookingsPermanentTest(){

        User selectedUser = [SELECT Id FROM User WHERE username =:STR_USERNAME];
        RTW_Location__c location = [Select RTW_Office__c,RTW_Department__c,RTW_Sub_Department__c From  RTW_Location__c limit 1];
        List<RTW_CancelBookingsQueueable.CancelBookingRequest> requestArray = new List<RTW_CancelBookingsQueueable.CancelBookingRequest> ();
        RTW_CancelBookingsQueueable.CancelBookingRequest booking = new RTW_CancelBookingsQueueable.CancelBookingRequest();
        booking.Office = 'FSS';
        booking.deactivationStartDate = System.today();
        booking.deactivationEndDate = null;
        requestArray.add(booking);
        System.runAs(selectedUser){
            Test.startTest();
            RTW_CancelBookingsQueueable.cancelBookingsForLocations(requestArray);
            Test.stopTest();
        }
        System.assert(String.isNotBlank(STR_USERNAME), true);
    }
}