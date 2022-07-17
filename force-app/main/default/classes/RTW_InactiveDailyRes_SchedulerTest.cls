/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class RTW_InactiveDailyRes_SchedulerTest {
    @testSetup
    static void setupTestData(){
        Date todayDate=Date.today();
        Date batchDate=todayDate.addDays(-14);
        RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',Batchdate__c=batchDate);
        insert batchDetailsObj;
    }
    
    private static testmethod void testMethod1() {
        test.startTest();
        RTW_InactiveDailyRes_Scheduler obj=new RTW_InactiveDailyRes_Scheduler();
        obj.execute(null);
        List<RTW_Batch_Details__c> listBatchDetails=[Select id,BatchDate__c from RTW_Batch_Details__c
                                                     where Name='Batch' limit 1];
        System.assertEquals(listBatchDetails.size(), 1);                                             
        test.stopTest(); 
    }
}