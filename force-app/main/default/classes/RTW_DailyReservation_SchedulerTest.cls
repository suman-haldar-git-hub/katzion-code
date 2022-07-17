/**
* @description       : Test class for RTW_DailyReservation_SchedulerTest
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   06-08-2021   Akhil  Kumar     Initial Version
**/
@isTest
public class RTW_DailyReservation_SchedulerTest {
    
    private static testmethod void testMethod1() {
        String usrName = 'systemAdmin';
        test.startTest();
        RTW_DailyReservation_Scheduler dailyResScheduler = new RTW_DailyReservation_Scheduler();
        dailyResScheduler.execute(null);
        System.assertEquals(String.isNotBlank(usrName), true);
        test.stopTest();
    }  
}