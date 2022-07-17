/**
* @description       : This controller class is used to get the details of WPS case
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   26-08-2021   Akhil  Kumar     Initial Version
**/
public without sharing class WPSCaseDetailController { 
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param  caseObjId 
    * @return Case 
    **/
    @AuraEnabled 
    public static Case getCaseRecord(String caseObjId) {
        Case wpsCaseDetail = new Case();
        try{
          if(caseObjId != null && String.isNotBlank(caseObjId)) {
              wpsCaseDetail = [SELECT Id, CaseNumber, Status, Owner.Name, Subject, Sub_Category_2__c, 
                              Sub_Category_3__c, Description, Related_to_Existing_Case_Number__c,
                              (SELECT Id, Comment__c,CreatedDate From Case_Comments__r
                               WHERE Type__c =: 'External')
                               FROM Case WHERE Id =:caseObjId LIMIT 1];
          }
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSCaseDetailController.cls on getCaseRecord',
                ex
            );
        }
        return wpsCaseDetail;
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param  fieldStr 
    * @param  caseId 
    * @return Work_Requests__c 
    **/
    @AuraEnabled 
    public static Work_Requests__c getWorkRequestRecord(String fieldStr, String caseId) {
        Work_Requests__c workRequestRecord = new Work_Requests__c();
        try{
        String workReqQuery = 'SELECT ' +fieldStr + 'Id FROM Work_Requests__c WHERE Case__c =: caseId LIMIT 1';
        String workRequestQuery = String.escapeSingleQuotes(workReqQuery); 
        workRequestRecord = Database.Query(workRequestQuery);
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSCaseDetailController.cls on getWorkRequestRecord',
                ex
            );
        }
        return workRequestRecord;
    }
}