/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 09-27-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
public with sharing class CaseBusinessHourFlowSupport {
    private static final String CASE_CLOSED_STATUS = 'Closed';
    private static final String CASE_REJECTED_STATUS = 'Rejected';
    private static final String CASE_HOLD_STATUS = 'On Hold';
    private static final String WPS_BUSINESS_HOURS = 'WPS Business hour';
    public class WrapperData{
        @invocablevariable
        public Case caseRecordWrp; // Case Record
        @invocablevariable
        public String currentStatus; // New Case Status
        @invocablevariable
        public String oldStatus; // Old Case Status
    }
    @InvocableMethod(
        label='Calcualte Businness hours for hold'
        description='Calcualte Businness hours for hold.'
        category='Calcualte hours'
    )
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 08-26-2021 
    * @param  caseList 
    * @return List<Case> 
    **/
    public static List<Case> caluculateBusinessHours(List<WrapperData> WrapperDataList) {
        Case caseRecordTemp =WrapperDataList[0].caseRecordWrp;
        List<Case> caseList = new List<Case>();
        caseList.add(caseRecordTemp);
        String currentStatus = WrapperDataList[0].currentStatus;
        String oldStatus = WrapperDataList[0].oldStatus;
        List<Case> caseListToReturn = new List<Case>();
        Case caseRecordQuery;
        try{
            If(String.isNotBlank(caseList[0].Id)){
                caseRecordQuery = [SELECT Id,Entitlement.BusinessHoursId FROM Case WHERE Id =: caseList[0].Id];
            }
            Id businessHourId;
            if(caseRecordQuery != null && String.isNotBlank(caseRecordQuery.Entitlement.BusinessHoursId)){
                businessHourId = caseRecordQuery.Entitlement.BusinessHoursId;
            }else{
                businessHourId = [SELECT Id FROM BusinessHours WHERE Name =: WPS_BUSINESS_HOURS].Id;
            }
            
            for(Case caseRecord :caseList){
                if(caseRecord.Status != CASE_CLOSED_STATUS && caseRecord.Status != CASE_REJECTED_STATUS && String.isNotBlank(String.valueOf(caseRecord.onHoldStartDateTime__c))){
                    Long difference = BusinessHours.diff(businessHourId, caseRecord.onHoldStartDateTime__c, system.now());
                    Decimal differenceDecimal = Decimal.valueOf(difference);
                    Decimal hours = differenceDecimal.divide(3600000, 3);
                    if(String.isNotBlank(String.valueOf(caseRecord.Hold_Business_Hours_Age__c))){
                        caseRecord.Hold_Business_Hours_Age__c = caseRecord.Hold_Business_Hours_Age__c + hours;
                    }else{
                        caseRecord.Hold_Business_Hours_Age__c = hours;
                    }
                    caseListToReturn.add(caseRecord);  
                }else{
                    Long difference = BusinessHours.diff(businessHourId, caseRecord.CreatedDate,system.now());
                    Decimal differenceDecimal = Decimal.valueOf(difference);
                    Decimal hours = differenceDecimal.divide(3600000, 3);
                    if(oldStatus == CASE_HOLD_STATUS && String.isNotBlank(String.valueOf(caseRecord.onHoldStartDateTime__c))){
                        Long differenceHold = BusinessHours.diff(businessHourId, caseRecord.onHoldStartDateTime__c, system.now());
                        Decimal differenceDecimalHold = Decimal.valueOf(differenceHold);
                        Decimal hoursHold = differenceDecimalHold.divide(3600000, 3);
                        if(String.isNotBlank(String.valueOf(caseRecord.Hold_Business_Hours_Age__c))){
                            caseRecord.Hold_Business_Hours_Age__c = caseRecord.Hold_Business_Hours_Age__c + hoursHold;
                        }else{
                            caseRecord.Hold_Business_Hours_Age__c = hoursHold;
                        }
                    }
                    if(String.isNotBlank(String.valueOf(caseRecord.Hold_Business_Hours_Age__c))){
                        caseRecord.Resolution_Time__c = hours-caseRecord.Hold_Business_Hours_Age__c;
                    }else{
                        caseRecord.Resolution_Time__c = hours;
                    }
                    caseListToReturn.add(caseRecord); 
                }
            }
            return caseListToReturn;
        }catch(Exception e){
            PublishLogEventService.publishExceptionEvent(
                'CaseBusinessHourFlowSupport.cls on caluculateBusinessHours',
                e
            );
            return caseListToReturn;
        }
    }
}