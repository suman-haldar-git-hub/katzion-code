@isTest
public class RTW_ActiveDailyRes_SchedulerTest {
    @testSetup
    static void setupTestData(){
        Date todayDate=Date.today();
        Date batchDate=todayDate.addDays(-14);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
    }
    
    private static testmethod void testMethod1() {
        test.startTest();
        RTW_ActiveDailyRes_Scheduler obj=new RTW_ActiveDailyRes_Scheduler();
        obj.execute(null);
        test.stopTest();
    }
}