/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for Leave__c object.
*/
public with sharing class LeaveTestData {
    /**
* @description : This will create the Leave__c records.
* @return : List<Leave__c>
* @param count
* @param recordTypeId
*/
    public static List<Leave__c> createLeaveRecds(Integer count, String recordTypeId){
        List<Leave__c> leaveList = new List<Leave__c>();
        for (Integer i = 0; i < count; i++) {
            Leave__c leaveRecd = new Leave__c();
            leaveRecd.PersonalLeaveBal__c = 60;
            leaveRecd.AnnualLeaveBal__c = 30;
            leaveRecd.PurchasedLeaveBal__c = 20;
            leaveRecd.LongServiceLeaveBal__c = 10;
            leaveRecd.LeaveTo__c = System.now().addDays(1);
            leaveRecd.LeaveFrom__c = System.now().addDays(10);
            leaveList.add(leaveRecd);
        }
        return leaveList;
    }
}