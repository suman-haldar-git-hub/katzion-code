/**
 * @description       : This Class is used to cancel reservations
 * @author            : Joginder Kumar
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Joginder Kumar
**/

public class RTW_CancelBookingsQueueable implements Queueable {
    
// invocable method used in flow to cancel bookings

    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param requests 
    **/
    @InvocableMethod(label='cancelBookingsForLocations' description='Cancel all the bookings for the deactivated site')
    public static void cancelBookingsForLocations(List<CancelBookingRequest> requests) {
        if(requests.size()>0){
            System.enqueueJob(new RTW_CancelBookingsQueueable(requests[0].office,requests[0].deactivationStartDate,requests[0].deactivationEndDate));
        }   
    }

    // Private variables
    private String office;
    private Date startDate;
    private Date endDate;


    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param office 
    * @param startDate 
    * @param endDate 
    **/

    //constructor 
    public RTW_CancelBookingsQueueable(String office, Date startDate, Date endDate){
        this.office = office;
        this.startDate = startDate;
        this.endDate = endDate;

    }

    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param context 
    **/
    public void execute(QueueableContext context) {
        try{
        // Query Appointments 
        String query;
         if(String.isBlank(String.valueOf(endDate))){
             query = 'SELECT Name, Id, RTW_First_Name__c,RTW_Last_Name__c,RTW_Department__c,RTW_Sub_Department__c, RTW_Email__c, RTW_Reservation_Date__r.RTW_Available_Date__c, RTW_Cancel_Booking__c, RTW_Office__c FROM RTW_Reservation__c where RTW_Office__c =:office AND RTW_Cancel_Booking__c = false AND  RTW_Reservation_Date__r.RTW_Available_Date__c >= :startDate';
         }else{
              query = 'SELECT Name, Id, RTW_First_Name__c,RTW_Last_Name__c,RTW_Department__c,RTW_Sub_Department__c, RTW_Email__c, RTW_Reservation_Date__r.RTW_Available_Date__c, RTW_Cancel_Booking__c, RTW_Office__c FROM RTW_Reservation__c where RTW_Office__c =:office AND RTW_Cancel_Booking__c = false AND  RTW_Reservation_Date__r.RTW_Available_Date__c >= :startDate AND RTW_Reservation_Date__r.RTW_Available_Date__c <= :endDate';
         }
         List<RTW_Reservation__c> reservationsTOCancel = Database.query(query);
         
        Map<String,String> emailAndDateMap  = new Map<String,String>();
        Map<String,RTW_Reservation__c> emailAssociatedWithReser  = new Map<String,RTW_Reservation__c>();
         for(RTW_Reservation__c reservation:reservationsTOCancel){
              reservation.RTW_Cancel_Booking__c=true;
              reservation.RTW_Cancellation_Reason__c = 'Deactivation';

              if(!emailAndDateMap.keyset().contains(reservation.RTW_Email__c)){
                Date d = reservation.RTW_Reservation_Date__r.RTW_Available_Date__c;
                String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('E dd MMM YYYY');
                emailAndDateMap.put(reservation.RTW_Email__c,String.valueOf(dt));
              }else{
                Date d = reservation.RTW_Reservation_Date__r.RTW_Available_Date__c;
                String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('E dd MMM YYYY');
                String dateToAppend =  emailAndDateMap.get(reservation.RTW_Email__c)+ ','+ String.valueOf(dt);
                emailAndDateMap.put(reservation.RTW_Email__c,dateToAppend);
              }

              if(!emailAssociatedWithReser.keyset().contains(reservation.RTW_Email__c)){
                emailAssociatedWithReser.put(reservation.RTW_Email__c,reservation);
              }

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
                workflowEmailObj.RTW_Reservation_Dates1__c = emailAndDateMap.get(reservationObj.RTW_Email__c);
                workflowEmailObj.RTW_Cancel_Booking__c = true;
                workFlowRecordstoInsert.add(workflowEmailObj);
            }
                Database.update(reservationsTOCancel,true);
                Database.insert(workFlowRecordstoInsert, true);
           }catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                    'RTW_CancelBookingsQueueable.cls on execute',
                    ex
                );
          }

    }    

    /**
     * @description       : This Class is used for parameters
     * @author            : Joginder Kumar
     * @group             : 
     * @last modified on  : 09-16-2021
     * @last modified by  : Joginder Kumar
    **/
    public class CancelBookingRequest {
        @InvocableVariable(required=true)
        public Date deactivationStartDate;

        @InvocableVariable
        public Date deactivationEndDate;
     
        @InvocableVariable(required=true)
        public String office;
  }
}