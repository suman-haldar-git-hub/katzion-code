/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 09-24-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@SuppressWarnings('PMD.ApexSharingViolations,PMD.ClassNamingConventions,PMD.LocalVariableNamingConventions')

global class myMilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {  
    global static final String WPS_BUSINESS_HOURS = 'WPS Business hour'; 
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 09-17-2021 
    * @param caseId 
    * @param milestoneTypeId 
    * @return Integer 
    **/
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        decimal hours = 0;
        Long difference = 0;
        String mileStoneName = [SELECT Name from MilestoneType WHERE Id=:milestoneTypeId]?.Name;
        Integer Milestonetime = Integer.valueOf([SELECT Value__c from MilestoneMetadata__mdt WHERE Label =:mileStoneName]?.Value__c);
        Case c = [SELECT Id,CreatedDate,Hold_Business_Hours_Age__c,SLA_Milestone__c,Entitlement.BusinessHoursId FROM Case WHERE Id=:caseId];
        if(String.isNotBlank(String.valueOf(c.Hold_Business_Hours_Age__c))){
            Id businessHourId;
            if(String.isNotBlank(c.Entitlement.BusinessHoursId)){
                businessHourId = c.Entitlement.BusinessHoursId;
            }else{
                businessHourId = [SELECT Id FROM BusinessHours WHERE Name =: WPS_BUSINESS_HOURS].Id;
            }
            difference = BusinessHours.diff(businessHourId, c.CreatedDate, system.now());
            Decimal differenceDecimal = Decimal.valueOf(difference);
            Decimal inMinut = differenceDecimal.divide(60000, 3);
            hours = Milestonetime-(inMinut-(c.Hold_Business_Hours_Age__c*60));
            Milestonetime = Integer.valueOf(hours);
            
        }
        return (Milestonetime);            
    }
}