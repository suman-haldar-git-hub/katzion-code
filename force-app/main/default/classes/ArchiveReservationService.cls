/**
* @description       : Get reservation data to be displayed in archive tab
* @author            : Akhil Kumar
* @group             : 
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   09-09-2021   Akhil  Kumar     Initial Version
**/
@SuppressWarnings('PMD.ExcessiveParameterList')
public without sharing class ArchiveReservationService {
    private static Map<String,String> customMetadataMap;
    private static Map<String,String> mapCasesColumns=new Map<String,String>{
        'description' => 'Subject',
            'status' => 'CaseApproved__c',
            'type' => 'Sub_Category__c',
            'completionDate' => 'ClosedDate'        
            }; 
                
      /**
     * @author      Akhil Kumar
     * @description Get CustomMetadata mappings
     * @return      Map<String,String>
     */            
    private static Map<String,String> getCustomMetadata(){
        Set<String> developerNames=new Set<String>{'CASESTATUSCLOSED',
            'CASEREJECTED','CASEAPPROVED','ARCHIVE','REQUESTTYPEARCHIVE','SUPPORTOFFICEBOOKING'};
        return CommunityContentInfoService.getCommunityContentInfoMapping(developerNames);
    }
    

    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param reqWrap 
    * @param respWrap 
    * @return ArchiveReservationWrapper 
    **/
    public static ArchiveReservationWrapper getRecords(ArchiveController.RequestWrapper reqWrap, ArchiveController.ResponseWrapper respWrap){
        customMetadataMap = getCustomMetadata();   
        ArchiveReservationWrapper arWrapper=new ArchiveReservationWrapper(); 
        
        try{
          if(String.isNotBlank(reqWrap.types) && reqWrap.types.contains('SupportOfficeBooking')){
              ParameterWrapper pw = getParameterWrapper(reqWrap);
              if(pw.strList3!=null && !pw.strList3.isEmpty()){
                  List<Case> reservationRecords = getReservationRecords(pw,reqWrap,respWrap,arWrapper);
                
                  fillArchiveReservationWrapper(reservationRecords,arWrapper,pw);
              }
          }
        } 
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'ArchiveReservationService.cls on getRecords',
                ex
            );
        }
        return arWrapper;   
    }
    
     /**
     * @author      Akhil Kumar
     * @description Initialize values in ParameterWrapper object
     * @param       reqWrap - Type 'ArchiveController.RequestWrapper'
     * @return      ParameterWrapper object  
     */
    private static ParameterWrapper getParameterWrapper(ArchiveController.RequestWrapper reqWrap){
        ParameterWrapper pw=new ParameterWrapper();
        User usr = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        if(usr != null && String.isNotBlank(usr.EmployeeID__c)){
            for(Account acc:AccountDomain.getAccounts(usr.EmployeeID__c)){
                pw.idSet1.add(acc.Id);//Set of Account id's
            }
        }
        if(!pw.idSet1.isEmpty()){
            pw.str1 = mapCasesColumns.containsKey(reqWrap.sortColumn)?mapCasesColumns.get(reqWrap.sortColumn):'';
            pw.str2 = reqWrap.sortDirection;    
            pw.str3 = reqWrap.keyword; 
            pw.str4 = customMetadataMap.get('ARCHIVE');
            //Used to compare CaseApproved__c field
            pw.strList2.add(customMetadataMap.get('CASEAPPROVED'));
            pw.strList2.add(customMetadataMap.get('CASEREJECTED'));
            pw.int1 = reqWrap.rowLimit/3;
            pw.int2 = reqWrap.reservationRowOffSet;
            //Used to compare Sub_Category__c field
            pw.strList3 = String.isNotBlank(reqWrap.types)?reqWrap.types.split(','):new List<String>(); 
            pw.mapString1 = DescribeSObjectCall.picklistValueToLabelMap('Case','TeamHubApplicationType__c');
            pw.strSet1=CommunityContentInfoService.communityContents(
                new Set<String>{'REQUESTS'},
                ','
            );
        }
        return pw;
    }
    

    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param pw 
    * @param reqWrap 
    * @param respWrap 
    * @param arWrapper 
    * @return List<Case> 
    **/
    private static List<Case> getReservationRecords(ParameterWrapper pw, ArchiveController.RequestWrapper reqWrap, ArchiveController.ResponseWrapper respWrap, ArchiveReservationWrapper arWrapper) {
        List<Case> reservationCaseList = new List<Case>();
        Set<String> appString = new Set<String>(pw.strList3);
        Map<String, String> reservationIdMap = new Map<String, String>();

        if(appString.contains('SupportOfficeBooking')){
                String userId = UserInfo.getUserId();
                Date todayDate = System.today(); 
                String selectReservationQuery = 'SELECT Id, Name, RTW_Reservation_Date_Formula__c, LastModifiedDate'
                    + ' FROM RTW_Reservation__c WHERE Type__c = \'Booking\' AND RTW_Cancel_Booking__c = false'
                    + ' AND CreatedById =: userId AND RTW_Reservation_Date_Formula__c < :todayDate';
                
                String limitReservationQuery = '';
                if(pw.str3 == null || String.isBlank(pw.str3)) {
                    limitReservationQuery = ' LIMIT '+pw.int1+' OFFSET '+pw.int2;
                }
                
                String reservationQuery = selectReservationQuery + limitReservationQuery;

                List<RTW_Reservation__c> reservationList = System.Database.query(reservationQuery);
                
                arWrapper.recordCount=reservationList.size();
                
                if(reqWrap.calculateTotalRecords) {
                  List<RTW_Reservation__c> totalReservationList = System.Database.query(selectReservationQuery);
                  arWrapper.totalCount = totalReservationList.size();
                }
                
                for(RTW_Reservation__c res : reservationList) {
                    reservationIdMap.put('Booking Tool - '+res.Name, res.Id);
                    
                    //Create a case record consisting of reservation record details
                    Case reservationCaseRecord = new Case();
                    reservationCaseRecord.Subject = 'Booking Tool - '+res.Name;
                    reservationCaseRecord.CaseApproved__c = 'Submitted';
                    reservationCaseRecord.Origin = 'TeamHub';
                    reservationCaseRecord.Sub_Category__c = 'SupportOfficeBooking';
                    reservationCaseRecord.LastModifiedDate = res.LastModifiedDate;
                    reservationCaseRecord.CreatedDate = res.RTW_Reservation_Date_Formula__c;
                    reservationCaseRecord.ClosedDate = res.RTW_Reservation_Date_Formula__c;
                    
                    if(pw.str3 == null || String.isBlank(pw.str3) || (String.isNotBlank(pw.str3) && (reservationCaseRecord.Subject.toLowercase()).contains(pw.str3.toLowercase()))) {
                    reservationCaseList.add(reservationCaseRecord);
                    }
                }
                respWrap.reservationIdMap = reservationIdMap;
        }
        return reservationCaseList;
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param listCases 
    * @param arWrapper 
    * @param pw 
    **/
    private static void fillArchiveReservationWrapper(List<Case> listCases, ArchiveReservationWrapper arWrapper, ParameterWrapper pw){
        Map<String,List<ArchiveController.ArchiveWrapper>> mCasecategoryRec = new Map<String,List<ArchiveController.ArchiveWrapper>>();   
        
        for(Case cs:listCases){
            
            ArchiveController.ArchiveWrapper archiveWrap = new ArchiveController.ArchiveWrapper();            
            archiveWrap.key = cs.Id;
            archiveWrap.description = cs.Subject;            
            archiveWrap.completionDate = cs.ClosedDate;
            archiveWrap.type = customMetadataMap.get('SUPPORTOFFICEBOOKING');
            archiveWrap.status = customMetadataMap.get('CASESTATUSCLOSED');
            archiveWrap.requestor = UserInfo.getName();
            archiveWrap.originSystem = cs.Origin;
            archiveWrap.imagename = 'booking-tool-app.svg';
            arWrapper.records.add(archiveWrap);
        }
    }
    
    /**
     * @author       Akhil Kumar
     * @description  Response wrapper for this class
    */
    public class ArchiveReservationWrapper{
        public List<ArchiveController.ArchiveWrapper> records;
        public Integer recordCount;
        public Integer totalCount;
        
        /**
         * @author       Akhil Kumar
         * @description  Constructor to initialize variables
        */
        public ArchiveReservationWrapper(){
            records=new List<ArchiveController.ArchiveWrapper>();
            recordCount=0;
            totalCount=0;
        }
    }
}