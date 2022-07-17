/**
 * @author      Abhishek Setia
 * @description Handle logic detail for controller class 'MyApplicationsController'
 */
public with sharing class MyApplicationsService {       

    private static Map<String,String> customMetadataMap; 

    /**
     * @author      Abhishek Setia
     * @description Logic for getResponse method.
     * @param       requestParameters - Parameter passed from MyApplicationsController.getResponse
     * @return      LightningResponse wrapper object  
     */
    public static LightningResponse getResponseService(String requestParameters){
        LightningResponse resp=new LightningResponse();
        try {
            customMetadataMap=getResponseServiceCustomMetadata();
            MyApplicationsController.RequestWrapper reqWrap = (MyApplicationsController.RequestWrapper)JSON.deserialize(requestParameters,MyApplicationsController.RequestWrapper.class);
            MyApplicationsController.ResponseWrapper respWrap=new MyApplicationsController.ResponseWrapper();
            ParameterWrapper pw = getParameterWrapper(reqWrap);
            if(!pw.idSet1.isEmpty()){
                
                if(!(pw.strList3.size() == 1 && reqWrap.appTypes.contains(customMetadataMap.get('SUPPORTOFFICEBOOKING')))) {
                respWrap.dataSet=getDataSet(CaseDomain.salarySacrificeCasesOnAccount(pw,customMetadataMap),pw);
                }
                
                 if(reqWrap.appTypes.contains(customMetadataMap.get('SUPPORTOFFICEBOOKING'))){
                    respWrap.reservationDataSet = getDataSet(getReservationRecords(pw, respWrap),pw);
                    respWrap.dataSet.addAll(respWrap.reservationDataSet);
                }
                
                if(reqWrap.calculateTotalRecords){
                    if (!(pw.strList3.size() == 1 && reqWrap.appTypes.contains(customMetadataMap.get('SUPPORTOFFICEBOOKING')))) {
                    respWrap.dataSize = CaseDomain.countCases(pw,customMetadataMap) + respWrap.reservationDataSize;
                    }
                    else {
                       respWrap.dataSize =  respWrap.reservationDataSize;
                    }
                }                                
                resp.payLoad = JSON.serialize(respWrap,true);                                                                           
            }
            
        }catch(Exception e){
            resp.payLoad = e.getMessage();
            resp.isError = true;
        }
        return resp;
    }


    /**
     * @author      Abhishek Setia
     * @description Get CustomMetadata mappings
     * @return      Map<String,String>
     */
    private static Map<String,String> getResponseServiceCustomMetadata(){
        Set<String> developerNames=new Set<String>{'MYAPPLICATIONS','CASEAPPROVEDPENDING',
        'SALARYSACRIFICEREQUESTTYPE','LEAVEREQUESTTYPE','REQUESTSTYPE','CASESTATUSCLOSED',
        'ARCHIVE','CASEORIGINTEAMHUB','CASEORIGINTEAMSPACE','LAPTOPDEVICE','MOBILEPHONEDEVICE','TABLETDEVICE',
        'SMARTWATCHDEVICE','CASESUBCATSALARYSACRIFICE','CASERECORDTYPENAMEQUERYCASE',
        'TEAMHUBAPPLICATIONTYPELEAVE','TEAMHUBAPPLICATIONTYPESALARYSACRIFICE','TEAMHUBAPPLICATIONTYPEWPS',
        'WPSREQUESTTYPE','SUPPORTOFFICEBOOKING','REQUESTS'};
        return CommunityContentInfoService.getCommunityContentInfoMapping(developerNames);
    }
    

    /**
     * @author      Abhishek Setia
     * @description Prepare List of records to be shown for 'My Applications' Tab
     * @param       cases
     * @param       pw
     * @return      List<MyApplicationsController.DataRecord>
     */
    private static List<MyApplicationsController.DataRecord> getDataSet(List<Case> cases,ParameterWrapper pw){
        List<MyApplicationsController.DataRecord> records=new List<MyApplicationsController.DataRecord>();
        Map<String,List<MyApplicationsController.DataRecord>> mCasecategoryRec=
            new Map<String,List<MyApplicationsController.DataRecord>>();
        for(Case cs:cases){
            MyApplicationsController.DataRecord rec=new MyApplicationsController.DataRecord();
            rec.record=cs;
            
            if(String.isNotBlank(cs.Sub_Category__c) && cs.Sub_Category__c == customMetadataMap.get('SUPPORTOFFICEBOOKING')){
                rec.type=customMetadataMap.get('SUPPORTOFFICEBOOKING');
            }
            else {
            rec.type=getDisplayType(cs.TeamHubApplicationType__c,pw);
            }
            rec.imagename=getImageName(rec);
            if(rec.imagename==null && String.isNotBlank(cs.Category__c)){
                if(mCasecategoryRec.containsKey(cs.Category__c)){
                    mCasecategoryRec.get(cs.Category__c).add(rec);
                }else{
                    mCasecategoryRec.put(cs.Category__c,new List<MyApplicationsController.DataRecord>{rec});
                }                
            }            
            records.add(rec);
        }
        if(!mCasecategoryRec.isEmpty()){
            assignImageNameDynamically(mCasecategoryRec);            
        }        
        return records;
    }


    /**
     * @author      Abhishek Setia
     * @description Get static image names based on conditions
     * @param       rec
     * @return      String
     */
    private static String getImageName(MyApplicationsController.DataRecord rec){
        Case cs=rec.record;
        if(String.isNotBlank(cs.TypeofDevice__c)){
            switch on cs.TypeofDevice__c{
                when 'Laptop'{
                    return 'newcomputing.svg';
                }
                when 'Mobile Phone'{
                    return 'mobile.svg';
                }
                when 'Tablet'{
                    return 'tablet.svg';
                }
                when 'Smartwatch'{
                    return 'smartwatch.svg';
                }
            }            
        }else if(rec.type==customMetadataMap.get('CASESUBCATSALARYSACRIFICE') &&
                cs.RecordType.Name==customMetadataMap.get('CASERECORDTYPENAMEQUERYCASE') 
            && cs.Origin==customMetadataMap.get('CASEORIGINTEAMSPACE')){
                return 'Superannuation.svg';
        }else if(rec.type==customMetadataMap.get('LEAVEREQUESTTYPE') &&
                cs.RecordType.Name==customMetadataMap.get('CASERECORDTYPENAMEQUERYCASE')
            && cs.Origin==customMetadataMap.get('CASEORIGINTEAMSPACE')) {
                return 'purchase-app.svg';
        }
        else if(rec.type==customMetadataMap.get('SUPPORTOFFICEBOOKING')
                && cs.Origin==customMetadataMap.get('CASEORIGINTEAMSPACE')) {
                    return 'booking-tool-app.svg';
                }
        else if(rec.type==customMetadataMap.get('WPSREQUESTTYPE')
                && cs.Origin==customMetadataMap.get('CASEORIGINTEAMSPACE')) {
                    return 'workplace-app.svg';
                }
        return null;
    }


    /**
     * @author      Abhishek Setia
     * @description Assign dynamic image names from Form__c object
     * @param       mCasecategoryRec
     */
    private static void assignImageNameDynamically(
            Map<String,List<MyApplicationsController.DataRecord>> mCasecategoryRec
        ){

            Set<String> caseCategories = new Set<String>(mCasecategoryRec.keySet());
            caseCategories.add('DEFAULT');
            Map<String,String> mapCasecategoryActioncentreIcon=
                FormService.casecategoryActioncentreIconMapping(caseCategories);  
            for(String casecategory:mCasecategoryRec.keySet()){
                for(MyApplicationsController.DataRecord rec:mCasecategoryRec.get(casecategory)){
                    rec.imagename=(mapCasecategoryActioncentreIcon.containsKey(casecategory.toUpperCase()))?
                        mapCasecategoryActioncentreIcon.get(casecategory.toUpperCase()):
                        mapCasecategoryActioncentreIcon.get('DEFAULT');
                }
            }
        }    

    /**
     * @author      Abhishek Setia
     * @description Initialize values in ParameterWrapper object
     * @param       reqWrap - Type 'MyApplicationsController.RequestWrapper'
     * @return      ParameterWrapper object  
     */
    private static ParameterWrapper getParameterWrapper(MyApplicationsController.RequestWrapper reqWrap){
        ParameterWrapper pw=new ParameterWrapper();
        User usr = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        if(usr != null && String.isNotBlank(usr.EmployeeID__c)){
            for(Account acc:AccountDomain.getAccounts(usr.EmployeeID__c)){
                pw.idSet1.add(acc.Id);//Set of Account id's
            }
        }
        if(!pw.idSet1.isEmpty()){
            pw.str1 = reqWrap.sortColumn;
            pw.str2 = reqWrap.sortDirection;    
            pw.str3 = reqWrap.keyword; 
            pw.str4 = customMetadataMap.get('MYAPPLICATIONS');
            //Used to compare CaseApproved__c field
            pw.strList2.add(customMetadataMap.get('CASEAPPROVEDPENDING'));
            pw.int1 = reqWrap.rowLimit;
            pw.int2 = reqWrap.rowOffSet;            
            //Used to compare Sub_Category__c field
            pw.strList3 = String.isNotBlank(reqWrap.appTypes)?reqWrap.appTypes.split(','):new List<String>();
            pw.mapString1 = DescribeSObjectCall.picklistValueToLabelMap('Case','TeamHubApplicationType__c');
            pw.strSet1=CommunityContentInfoService.communityContents(
                new Set<String>{'REQUESTS'},
                ','
            );
        }
        return pw;
    }


    /**
     * @author      Abhishek Setia
     * @description Get Type to be displayed in Action Centre
     * @param       teamHubApplicationType
     * @param       pw
     * @return      String
     */
    private static String getDisplayType(String teamHubApplicationType,ParameterWrapper pw){
        if(pw.strSet1!=null && pw.strSet1.contains(teamHubApplicationType)){
            return customMetadataMap.get('REQUESTSTYPE');
        }else if(pw.mapString1.containsKey(teamHubApplicationType)){
                return pw.mapString1.get(teamHubApplicationType);
            }
        return '';    
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param pw 
    * @param respWrap 
    * @return List<Case> 
    **/
    private static List<Case> getReservationRecords(ParameterWrapper pw, MyApplicationsController.ResponseWrapper respWrap) {
        List<Case> reservationCaseList = new List<Case>();
        Set<String> appString = new Set<String>(pw.strList3);
        Map<String, String> reservationIdMap = new Map<String, String>();
        
        if(appString.contains('SupportOfficeBooking')){
                String userId = UserInfo.getUserId();
                Date todayDate = System.today();
                String reservationQuery = 'SELECT Id, Name, RTW_Reservation_Date_Formula__c, LastModifiedDate'
                    + ' FROM RTW_Reservation__c WHERE Type__c = \'Booking\''
                    + ' AND RTW_Cancel_Booking__c = false AND CreatedById =: userId'
                    + ' AND RTW_Reservation_Date_Formula__c >= :todayDate';

                if(String.isNotBlank(pw.str1) && String.isNotBlank(pw.str2)){
                    reservationQuery += ' ORDER BY '+String.escapeSingleQuotes(pw.str1)+' '+String.escapeSingleQuotes(pw.str2);
                }
                
                List<RTW_Reservation__c> reservationList = System.Database.query(reservationQuery);
            
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
                    
                    if(pw.str3 == null || String.isBlank(pw.str3) || (String.isNotBlank(pw.str3) && (reservationCaseRecord.Subject.toLowercase()).contains(pw.str3.toLowercase()))) {
                    reservationCaseList.add(reservationCaseRecord);
                    }
                }
                respWrap.reservationDataSize = reservationCaseList.size();
                respWrap.reservationIdMap = reservationIdMap;
        }
        return reservationCaseList;
    }
    
}