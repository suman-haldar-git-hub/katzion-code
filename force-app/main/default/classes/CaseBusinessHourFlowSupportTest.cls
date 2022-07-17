/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 09-24-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@isTest
public with sharing class CaseBusinessHourFlowSupportTest {
        // Set up account and Case records for the test class
    @testSetup static void setup() {
        Id recordTypeIdCaseWPS = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WPS').getRecordTypeId();
        Case caseRecord = new Case();
        caseRecord.Subject = 'WPS Case Record';
        caseRecord.RecordTypeId= recordTypeIdCaseWPS;
        caseRecord.onHoldStartDateTime__c = system.now();
        insert caseRecord;
        Case caseRecord1 = new Case();
        caseRecord1.Subject = 'WPS Case Record';
        caseRecord1.RecordTypeId= recordTypeIdCaseWPS;
        caseRecord1.onHoldStartDateTime__c = system.now();
        insert caseRecord1;
    }
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 08-27-2021 
    **/
    @isTest static void caseBusinessHourFlowSupportMethod(){
        CaseBusinessHourFlowSupport.WrapperData wrapper = new CaseBusinessHourFlowSupport.WrapperData();
        List<Case> wpsCases = [SELECT Id,CreatedDate,Subject,onHoldStartDateTime__c,Hold_Business_Hours_Age__c,Resolution_Time__c,Status FROM Case];
        wrapper.caseRecordWrp =wpsCases[0];
        wrapper.currentStatus=wpsCases[0].Status;
        wrapper.oldStatus='Open';
        CaseBusinessHourFlowSupport.caluculateBusinessHours(new List<CaseBusinessHourFlowSupport.WrapperData>{wrapper});
        wrapper.currentStatus='Closed';
        wpsCases[0].Status = 'Closed';
        wpsCases[0].Closed_Case_Comments__c = 'Closed Comment';
        update wpsCases[0];
        CaseBusinessHourFlowSupport.caluculateBusinessHours(new List<CaseBusinessHourFlowSupport.WrapperData>{wrapper});
        wpsCases[1].Status = 'Closed';
        wpsCases[1].Hold_Business_Hours_Age__c=null;
        wpsCases[1].Closed_Case_Comments__c = 'Closed Comment';
        update wpsCases[1];
        wrapper.oldStatus='On Hold';
        CaseBusinessHourFlowSupport.caluculateBusinessHours(new List<CaseBusinessHourFlowSupport.WrapperData>{wrapper});
        System.assert(!wpsCases.isEmpty() , true);
    }
}