/**
* @author : Amit Sharma
* @company : SaaSFocus A Cognizant Company
* @description : This class is utility class for CommunityContentInfo__mdt.
*/
public with sharing class ScheduleDomain {
/**
* @author : Amit Sharma
* @description : This method is used to query Schedule__c.
* @return : List<Schedule__c>
* @param  empId - current user id
* @param  weekStart - week start date time
* @param  endDateOfSchedule - end date time of schedule
*/
   public static List<Schedule__c> queryScheduleData(String empId, 
                            DateTime weekStart, DateTime endDateOfSchedule) {
        List<Schedule__c> lstSchedule = [Select Id, PayCode__c,PayrollID__c,
                ScheduleDate__c,ScheduleDay__c,Store__c,Store__r.Store_Name__c,
                Store__r.Store_Number__c,Store__r.Store_Type__c,Manager__c,
                Manager__r.FirstName,Manager__r.LastName,TeamMember__c,TeamMemberName__c,
                ManagerName__c,Comments__c,Lastmodifieddate,EstimatedScheduleHours__c
            From Schedule__c 
            WHERE PayrollID__c =: empId AND ScheduleDate__c >=: weekStart
            AND ScheduleDate__c <=: endDateOfSchedule
            ORDER by ScheduleDate__c ASC,Lastmodifieddate ASC];
        
        return lstSchedule;
    }
}