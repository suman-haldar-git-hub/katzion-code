/**
* @description       : This is controller class for cancelling Booking Tool form
* @author            : Akhil Kumar
* @group             : 
* @last modified on  : 09-15-2021
* @last modified by  : Akhil Kumar
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   30-07-2021   Akhil  Kumar     Initial Version
* 1.0	31-07-2021	 Meghna Bhargava  Added cancelBooking method
**/
public with sharing class RTW_ReservationDetailsController {
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param recordId 
    * @return LightningResponse 
    **/
    @AuraEnabled
    public static LightningResponse getReservationDetails(String recordId) {
        LightningResponse response = new LightningResponse();
        
        try {
            RTW_Reservation__c parentReservation = [SELECT Id, Name, RTW_First_Name__c, RTW_Last_Name__c, RTW_Payroll_Number__c, RTW_Email__c, RTW_Technical_Work__c,RTW_Reservation_Date_Formula__c
                                                    FROM RTW_Reservation__c
                                                    WHERE Id =:recordId][0];
            
            List<RTW_Reservation__c> childReservations = [SELECT Id,RTW_Office__c, RTW_Sub_Department__c, RTW_Department__c, RTW_Reservation_Date_Formula_Text__c
                                                          FROM RTW_Reservation__c
                                                          WHERE Reservation__c =:parentReservation.Id AND RTW_Cancel_Booking__c = false];
            
            ReservationWrapper resWrap = new ReservationWrapper();
            resWrap.referenceNumber = parentReservation.Name;
            resWrap.firstName = parentReservation.RTW_First_Name__c;
            resWrap.lastName = parentReservation.RTW_Last_Name__c;
            resWrap.payrollNumber = parentReservation.RTW_Payroll_Number__c;
            resWrap.email = parentReservation.RTW_Email__c;
            resWrap.technicalWork = parentReservation.RTW_Technical_Work__c;
            resWrap.childReservations = childReservations;
            resWrap.modifyReservationDetails = parentReservation.RTW_Reservation_Date_Formula__c >= System.today() ? true : false;
            
            response.isError = false;
            response.errorOrSuccessMessage = 'Success';
            response.payLoad = JSON.serialize(resWrap);
        }
        
        catch (Exception ex) {
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'RTW_ReservationDetailsController.cls on getReservationDetails',
                ex
            );
        }
        
        return response;
    }
    
 
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param datesToCancelList 
    **/
    @AuraEnabled
    public static void cancelBooking(List<String> datesToCancelList){
        Account loggedInUserAcc = RTW_FormController.fetchLoggedInUserDetails();
        List<RTW_Reservation__c> resList = new List<RTW_Reservation__c>();
        String datesToCancel;
        Map<String,RTW_Reservation__c> emailAssociatedWithReser  = new Map<String,RTW_Reservation__c>();
        for(RTW_Reservation__c res : [Select Id,RTW_First_Name__c, RTW_Last_Name__c, RTW_Email__c, RTW_Office__c, RTW_Department__c, 
                                      RTW_Sub_Department__c, RTW_Cancel_Booking__c, RTW_Reservation_Date__r.RTW_Available_Date__c
                                      FROM RTW_Reservation__c WHERE Id in: datesToCancelList]){
                                          
                                          Date cancelDate = res.RTW_Reservation_Date__r.RTW_Available_Date__c;
                                          String cancelDateString = DateTime.newInstance(cancelDate.year(),cancelDate.month(),cancelDate.day()).format('E dd MMM YYYY');
                                          if (datesToCancel == null) {
                                              datesToCancel = String.valueOf(cancelDateString);
                                          }
                                          else {
                                              datesToCancel = datesToCancel +','+ String.valueOf(cancelDateString);
                                          }
                                          
                                          if(!emailAssociatedWithReser.keyset().contains(res.RTW_Email__c)){
                                              emailAssociatedWithReser.put(res.RTW_Email__c,res);
                                          }                              
                                          res.RTW_Cancel_Booking__c = true;
                                          res.RTW_Cancellation_Reason__c = 'Deactivation';
                                          resList.add(res);
                                      }
        
        List<PCM_Workflow_Emails__c> workFlowRecordstoInsert = new List<PCM_Workflow_Emails__c>();
        for(RTW_Reservation__c reservationObj: emailAssociatedWithReser.values()){
            PCM_Workflow_Emails__c workflowEmailObj = new PCM_Workflow_Emails__c();
            workflowEmailObj.Name = 'Can-'+reservationObj.RTW_First_Name__c+' '+reservationObj.RTW_Last_Name__c;
            workflowEmailObj.RTW_Reservation_Name__c=reservationObj.RTW_First_Name__c;
            workflowEmailObj.RTW_Reservation_Email__c = reservationObj.RTW_Email__c;
            workflowEmailObj.RTW_Reservation_Office__c=reservationObj.RTW_Office__c;
            workflowEmailObj.RTW_Reservation_Department__c = reservationObj.RTW_Department__c;
            workflowEmailObj.RTW_Reservation_SubDepartment__c = reservationObj.RTW_Sub_Department__c;
            workflowEmailObj.RTW_Reservation_Dates1__c = datesToCancel;
            workflowEmailObj.RTW_Cancel_Booking__c = true;
            
            if (loggedInUserAcc != null && loggedInUserAcc.PersonEmail != null && loggedInUserAcc.PersonEmail != reservationObj.RTW_Email__c) {
                workflowEmailObj.RTW_Reservation_LoggedIn_User_Email__c = loggedInUserAcc.PersonEmail;
            }
            
            workFlowRecordstoInsert.add(workflowEmailObj);
        }
        try {
          if(resList.size() > 0){
             update resList;
             insert workFlowRecordstoInsert;
           }
       }
       catch(Exception ex) {
        PublishLogEventService.publishExceptionEvent(
                'RTW_ReservationDetailsController.cls on cancelBooking',
                ex
            );
       }
    }
    
     /**
         * @author       Akhil Kumar
         * @description  Reservation Wrapper
        */
    public class ReservationWrapper{
        String referenceNumber;
        String firstName;
        String lastName;
        String payrollNumber;
        String email;
        Boolean technicalWork;
        Boolean modifyReservationDetails;
        List<RTW_Reservation__c> childReservations = new List<RTW_Reservation__c>();
    }
    
}