/**
* @description       : This is controller class for Booking Tool form
* @author            : Prathamesh Lad
* @group             : 
* @last modified on  : 09-16-2021
* @last modified by  : Meghna Bhargava
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   06-10-2021   Prathamesh Lad   Initial Version
**/ 
@SuppressWarnings('PMD.ExcessivePublicCount, PMD.ExcessiveParameterList, PMD.AvoidDeeplyNestedIfStmts')

public without sharing class RTW_FormController {
    //Declaring global variables
    public static List<RTW_Reservation__c> listInsert;
    public static Integer counter=1;
    public static String reservedDates1,reservedDates2,reservedDates3,reservedDates4;
    
    
    public static Date week1Start;
    public static Date week1End;
    public static Date week2Start;
    public static Date week2End;
    public static Date week3Start;
    public static Date week3End;
    public static Date week4Start;
    public static Date week4End;
    public static Date lastWeekStart;
    public static Date lastWeekEnd;
    public static Date batchWeekStart;
    public static Date recordFetchStart;
    public static RTW_Location__c currentLocation = new RTW_Location__c();
    public static RTW_Reservation__c masterResObj = new RTW_Reservation__c();
    public static Date rollingWeekEndDate;
    public static Account loggedInUserAcc;
    
    /**
* @description This function will return the reservation allocation type. 
* @author Prathamesh Lad | 06-10-2021 
* @return boolean 
**/
    private static boolean isFloorWiseAllocation(){
        string rTWIsFloorLabelAllocation=Label.RTW_IsFloor_Label_Allocation; 
        if( rTWIsFloorLabelAllocation.toUpperCase() == 'TRUE'){
            
            return true;
        }
        else{
            return false;
        }
    }
    
    /**
* @description This function will return Available Dates
* @author Prathamesh Lad | 06-10-2021 
* @param office 
* @param department 
* @param subDepartment 
* @param resObj 
* @return Map<String, list<AvailableDateOption>> 
**/
    @AuraEnabled 
    public static Map<String,list<AvailableDateOption>> getAvailableDates(String office, String department, String subDepartment,RTW_Reservation__c resObj) {
        Boolean floorWiseAllocation = isFloorWiseAllocation();
        //Fetch Batch Details
        
        currentLocation = [SELECT Rolling_Weeks__c FROM RTW_Location__c
                           WHERE RTW_Office__c =:office
                           AND RTW_Department__c =:department
                           AND RTW_Sub_Department__c =:subDepartment][0];
        
        calculateDates();
        Date todayDate = date.today();
        //todayDate = todayDate.addDays(6);
        //Fetch Daily Reservation Records
        //Current week Changes : WeekStart Date Changes
        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>();
            String query='Select Id,Name,RTW_Available_Date__c,RTW_Available_Seats__c,RTW_Active__c from RTW_Daily_Reservation__c'+ 
            ' where RTW_Available_Date__c>=:recordFetchStart AND RTW_Active__c=true'+
            ' AND RTW_Office__c=:office AND RTW_Department__c=:department';
        if(subDepartment!=null && floorWiseAllocation==false){
            query = query + ' AND RTW_Sub_Department__c=:subDepartment';
        }
        query+=' order by RTW_Available_Date__c asc';
        System.debug('***query'+query);
        String rtwQuery = String.escapeSingleQuotes(query);
        listDailyReservations = Database.query(rtwQuery);
        System.debug('***listDailyReservations'+listDailyReservations);
        
        
        Map<String,list<AvailableDateOption>> retMap=new Map<String,list<AvailableDateOption>>();       
        if(listDailyReservations!=null && listDailyReservations.size()>0){
            //Create Set of Reserved date for User on the basis of Email 
            List<Date> listAvailableDates=new List<Date>();
            for(RTW_Daily_Reservation__c dailyResObj :listDailyReservations){
                listAvailableDates.add(dailyResObj.RTW_Available_Date__c);
            }    
            System.debug('***listAvailableDates'+listAvailableDates);
            String emailAddress=resObj.RTW_Email__c;
            List<RTW_Reservation__c> listReservations=new List<RTW_Reservation__c>();
            
            listReservations=[Select Id,RTW_Reservation_Date_Formula__c,RTW_Technical_Work__c from RTW_Reservation__c 
                              where RTW_Office__c=:office And /*RTW_Department__c=:department 
And RTW_Sub_Department__c=:subDepartment And*/ RTW_Email__c=:emailAddress 
                              And RTW_Reservation_Date_Formula__c IN:listAvailableDates
                              And RTW_Cancel_Booking__c=false];
            
            Set<Date> setReservedDates=new Set<Date>();
            Set<Date> setTechnicalWorkDates=new Set<Date>();
            for(RTW_Reservation__c reservationObj :listReservations){
                setReservedDates.add(reservationObj.RTW_Reservation_Date_Formula__c);
                if (reservationObj.RTW_Technical_Work__c){
                    setTechnicalWorkDates.add(reservationObj.RTW_Reservation_Date_Formula__c);    
                }
            }	
            System.debug('***setReservedDates'+setReservedDates);
            
            //Create Week1 and Week2 options
            list<AvailableDateOption> listWeek1Options = new list<AvailableDateOption>();
            list<AvailableDateOption> listWeek2Options = new list<AvailableDateOption>();
            list<AvailableDateOption> listWeek3Options = new list<AvailableDateOption>();
            list<AvailableDateOption> listWeek4Options = new list<AvailableDateOption>();
            
            // Current week Changes
            list<AvailableDateOption> listCurrentWeekOptions = new list<AvailableDateOption>();
            
            list<String> uniqueData=new LIst<String>();
            for(RTW_Daily_Reservation__c dailyResObj :listDailyReservations){
                Datetime dt = (DateTime)dailyResObj.RTW_Available_Date__c;
                String availableDate = dt.format('dd MMM yyyy');
                if(uniqueData.contains(availableDate) == true)
                {
                    continue;
                }
                
                String dayOfWeek = dt.format('E');
                AvailableDateOption availableDateOptionObj=new AvailableDateOption();
                availableDateOptionObj.label=dayOfWeek+' '+availableDate;
                availableDateOptionObj.value=String.valueOf(dailyResObj.RTW_Available_Date__c);
                if(currentLocation != null && currentLocation.Rolling_Weeks__c != null){
                    availableDateOptionObj.rollingWeeks = currentLocation.Rolling_Weeks__c;
                }
                else {
                    availableDateOptionObj.rollingWeeks = 4;
                }
                
                Boolean availableSeatFlag=true;
                if(setReservedDates.contains(dailyResObj.RTW_Available_Date__c)){
                    availableDateOptionObj.reservedAlready=true;
                    if (setTechnicalWorkDates.contains(dailyResObj.RTW_Available_Date__c)){
                        availableDateOptionObj.technicalWork = true;
                    }
                    availableSeatFlag=true;
                }else{
                    availableDateOptionObj.reservedAlready=false;
                    if(dailyResObj.RTW_Available_Seats__c>0 && dailyResObj.RTW_Available_Date__c>=todayDate){
                        availableSeatFlag=true;
                    }else{
                        availableSeatFlag=false;
                    }
                    availableDateOptionObj.technicalWork = false;
                }
                
                
                if(availableSeatFlag && dailyResObj.RTW_Available_Date__c>=week1Start && dailyResObj.RTW_Available_Date__c<=week1End && rollingWeekEndDate >=week1End && dailyResObj.RTW_Active__c){
                    listWeek1Options.add(availableDateOptionObj);
                    uniqueData.add(availableDate);
                }
                if(availableSeatFlag && dailyResObj.RTW_Available_Date__c>=week2Start && dailyResObj.RTW_Available_Date__c<=week2End && rollingWeekEndDate >=week2End && dailyResObj.RTW_Active__c){
                    listWeek2Options.add(availableDateOptionObj); 
                    uniqueData.add(availableDate);
                } 
                if(availableSeatFlag && dailyResObj.RTW_Available_Date__c>=week3Start && dailyResObj.RTW_Available_Date__c<=week3End && rollingWeekEndDate >=week3End && dailyResObj.RTW_Active__c){
                    listWeek3Options.add(availableDateOptionObj); 
                    uniqueData.add(availableDate);
                } 
                if(availableSeatFlag && dailyResObj.RTW_Available_Date__c>=week4Start && dailyResObj.RTW_Available_Date__c<=week4End && rollingWeekEndDate >=week4End && dailyResObj.RTW_Active__c){
                    listWeek4Options.add(availableDateOptionObj); 
                    uniqueData.add(availableDate);
                } 
                //Start : Current week Changes
                if(availableSeatFlag && dailyResObj.RTW_Available_Date__c>=LastWeekStart && dailyResObj.RTW_Available_Date__c<=LastWeekEnd && dailyResObj.RTW_Active__c){
                    listCurrentWeekOptions.add(availableDateOptionObj); 
                    uniqueData.add(availableDate);
                }
                //End : Current week Changes
                
            }
            System.debug('***listWeek1Options'+listWeek1Options);
            System.debug('***listWeek2Options'+listWeek2Options);
            retMap.put('Week1',listWeek1Options);
            retMap.put('Week2',listWeek2Options);
            retMap.put('Week3',listWeek3Options);
            retMap.put('Week4',listWeek4Options);
            //Current week Changes
            retMap.put('CurrentWeek',listCurrentWeekOptions);
        }
        system.debug('***'+retMap);
        return retMap;
    }
    
    
    /**
* @description This function will check Team member or not
* @author Prathamesh Lad | 06-10-2021 
* @param emailAddress 
* @return boolean 
**/
    @AuraEnabled 
    public static boolean checkTeamMember(String emailAddress) {
        List<Contact> listContacts=new List<Contact>();
        listContacts=[Select id from Contact 
                      where recordType.Name=:Label.RTW_Contact_RecordType
                      AND email=:emailAddress];
        system.debug('***listContacts'+listContacts);
        if(listContacts!=null && listContacts.size()>0){
            
            return true;
            
        }       
        return false;
    }
    
    
    /**
* @description This function will handle submit form activities
* @author Prathamesh Lad | 06-10-2021 
* @param office 
* @param department 
* @param subDepartment 
* @param resObj 
* @param listReservedDatesStr 
* @param reservationsToCancel
* @param captchaToken 
* @return String 
**/
    @AuraEnabled 
    public static String submitForm(String office, String department, String subDepartment, 
                                    RTW_Reservation__c resObj,List<String> listReservedDatesStr, List<string> reservationsToCancel,String captchaToken) {      
                                        List<RTW_Reservation__c> resList = new List<RTW_Reservation__c>();
                                        loggedInUserAcc=fetchLoggedInUserDetails();
                                        //************************ ReCaptcha Check ****************************  
                                        
                                        if(System.Label.isCaptachEnabled == 'true' && captchaToken != null && captchaToken != ''){
                                            Boolean captchaValidationResult = GoogleRecaptchaAPI.rtwCaptchaValidationResult(captchaToken);
                                            if(!captchaValidationResult)
                                            {
                                                return Label.RTW_Exception_Recaptcha; 
                                            }
                                            System.debug('captchaValidationResult->'+captchaValidationResult);
                                        }
                                        
                                        
                                        //***********************Converting List of Strings to list of Dates***********************
                                        //listReservedDates : SUer input dates for reservation
                                        Boolean floorWiseAllocation=isFloorWiseAllocation();
                                        List<Date> listReservedDates=new List<Date>();
                                        for(String reservedDate :listReservedDatesStr){
                                            Date dt=date.valueOf(reservedDate);
                                            listReservedDates.add(dt);
                                        }
                                        
                                        //Check whether user have already reserved dates or not
                                        //If Yes, show error message for duplicate dates and insert valid dates
                                        String email=resObj.RTW_Email__c;
                                        List<RTW_Reservation__c> listReservations=new List<RTW_Reservation__c>();
                                        listReservations=[Select Id,RTW_Reservation_Date_Formula__c from RTW_Reservation__c 
                                                          where RTW_Office__c=:office and RTW_Email__c=:email 
                                                          And RTW_Cancel_booking__c=false and RTW_Technical_Work__c != true];
                                        
                                        List<Date> listInValidRequestDates=new List<Date>();
                                        List<Date> listValidRequestDates=new List<Date>();
                                        
                                        if(listReservations!=null && listReservations.size()>0){
                                            List<Date> listReservedRequestDate=new List<Date>();
                                            listReservedRequestDate.addAll(listReservedDates);
                                            Set<Date> setReservedDates=new Set<Date>();
                                            for(RTW_Reservation__c reservationObj :listReservations){
                                                setReservedDates.add(reservationObj.RTW_Reservation_Date_Formula__c);
                                            }
                                            
                                            //listReservedDates : User input dates for reservation  
                                            //listReservedRequestDate : User input dates for reservation                               
                                            for(Date requestedDate: listReservedRequestDate){
                                                if(setReservedDates.contains(requestedDate)){
                                                    listInValidRequestDates.add(requestedDate);
                                                }else{
                                                    listValidRequestDates.add(requestedDate);
                                                }
                                            }
                                            system.debug('***listInValidRequestDates'+listInValidRequestDates);
                                            system.debug('***listValidRequestDates'+listValidRequestDates);
                                            //***************End  : Check whether user have already reserved dates or not***********************
                                            
                                            
                                            if(listValidRequestDates!=null && listValidRequestDates.size()>0){
                                                
                                                //*********************Start - Fetch : Week Start Date and Week End Data **************************
                                                //Start : Current week Changes
                                                Date todayDate = date.today();
                                                calculateDates();
                                                //End : Current week Changes
                                                //*********************End :  Fetch : Week Start Date and Week End Data **************************/
                                                
                                                /************************** Strat : Find Total Reservation count for Each Week ***********************/
                                                //Start : Change for the WeekEnd
                                                Date week1EndWeekDays=week1End.addDays(-2);
                                                Date week2EndWeekDays=week2End.addDays(-2);
                                                Date week3EndWeekDays=week3End.addDays(-2);
                                                Date week4EndWeekDays=week4End.addDays(-2);
                                                Date lastWeekEndWeekDays=LastWeekEnd.addDays(-2);
                                                //End : Change for the WeekEnd
                                                Integer week1ReservedCounter=0,week2ReservedCounter=0,week3ReservedCounter=0,week4ReservedCounter=0,currentWeekReservedCounter=0;
                                                for(Date reservedDate:setReservedDates){
                                                    if(week1Start<=reservedDate && week1EndWeekDays>=reservedDate){
                                                        week1ReservedCounter++;
                                                    }
                                                    if(week2Start<=reservedDate && week2EndWeekDays>=reservedDate){
                                                        week2ReservedCounter++;
                                                    }
                                                    if(week3Start<=reservedDate && week3EndWeekDays>=reservedDate){
                                                        week3ReservedCounter++;
                                                    }
                                                    if(week4Start<=reservedDate && week4EndWeekDays>=reservedDate){
                                                        week4ReservedCounter++;
                                                    }
                                                    //Current Week
                                                    if(LastWeekStart<=reservedDate && lastWeekEndWeekDays>=reservedDate){
                                                        currentWeekReservedCounter++;
                                                    }
                                                }
                                                
                                                Integer week1RequestedCounter=0,week2RequestedCounter=0,week3RequestedCounter=0,week4RequestedCounter=0,currentWeekRequestedCounter=0;
                                                if (resObj.RTW_Technical_Work__c != true){ //added by shubham shukla on 9/NOv/2020
                                                    for(Date validRequestDate :listValidRequestDates){
                                                        if(week1Start<=validRequestDate && week1EndWeekDays>=validRequestDate){
                                                            week1RequestedCounter++;
                                                        }
                                                        if(week2Start<=validRequestDate && week2EndWeekDays>=validRequestDate){
                                                            week2RequestedCounter++;
                                                        }
                                                        if(week3Start<=validRequestDate && week3EndWeekDays>=validRequestDate){
                                                            week3RequestedCounter++;
                                                        }
                                                        if(week4Start<=validRequestDate && week4EndWeekDays>=validRequestDate){
                                                            week4RequestedCounter++;
                                                        }
                                                        //Current Week
                                                        if(LastWeekStart<=validRequestDate && lastWeekEndWeekDays>=validRequestDate){
                                                            currentWeekRequestedCounter++;
                                                        }
                                                    }
                                                }
                                                
                                                Integer week1TotalCounter=week1ReservedCounter+week1RequestedCounter;
                                                Integer week2TotalCounter=week2ReservedCounter+week2RequestedCounter;
                                                Integer week3TotalCounter=week3ReservedCounter+week3RequestedCounter;
                                                Integer week4TotalCounter=week4ReservedCounter+week4RequestedCounter;
                                                Integer currentWeekTotalCounter=currentWeekReservedCounter+currentWeekRequestedCounter;
                                                System.debug('***week1TotalCounter'+week1TotalCounter);
                                                System.debug('***week2TotalCounter'+week2TotalCounter);
                                                System.debug('***currentWeekTotalCounter'+currentWeekTotalCounter);
                                                
                                                /**************************End : Find Total Reservation count for Each Week ***********************/
                                                
                                                /************************ Start : Return Error Message If Reserve Day count is more tha 5 ********/
                                                Boolean isVIP=checkTeamMember(email);
                                                System.debug('***isVIP'+isVIP);
                                                
                                                if(isVIP){                                                           
                                                    if(week1TotalCounter>5){
                                                        return Label.RTW_Week1_VIP_Already_Reserved_Error;
                                                    }
                                                    if(week2TotalCounter>5){
                                                        return Label.RTW_Week2_VIP_Already_Reserved_Error;
                                                    }
                                                    if(week3TotalCounter>5){
                                                        return Label.RTW_Week2_VIP_Already_Reserved_Error;
                                                    }
                                                    if(week4TotalCounter>5){
                                                        return Label.RTW_Week2_VIP_Already_Reserved_Error;
                                                    }
                                                    //Current Week
                                                    if(currentWeekTotalCounter>5){
                                                        return Label.RTW_CurrentWeek_VIP_Already_Reserved_Error;
                                                    }
                                                }else{
                                                    Decimal daysPerWeek=getDaysPerWeek(office);
                                                    if(week1TotalCounter>daysPerWeek){
                                                        return Label.RTW_Week1_NONVIP_Already_Reserved_Error1+' '+daysPerWeek+' '+Label.RTW_Week1_NONVIP_Already_Reserved_Error2;
                                                    }
                                                    if(week2TotalCounter>daysPerWeek){
                                                        return Label.RTW_Week2_NONVIP_Already_Reserved_Error1+' '+daysPerWeek+' '+Label.RTW_Week2_NONVIP_Already_Reserved_Error2;
                                                    } 
                                                    if(week3TotalCounter>daysPerWeek){
                                                        return Label.RTW_Week2_NONVIP_Already_Reserved_Error1+' '+daysPerWeek+' '+Label.RTW_Week2_NONVIP_Already_Reserved_Error2;
                                                    } 
                                                    if(week4TotalCounter>daysPerWeek){
                                                        return Label.RTW_Week2_NONVIP_Already_Reserved_Error1+' '+daysPerWeek+' '+Label.RTW_Week2_NONVIP_Already_Reserved_Error2;
                                                    } 
                                                    //Current Week
                                                    if(currentWeekTotalCounter>daysPerWeek){
                                                        return Label.RTW_CurrentWeek_NONVIP_Already_Reserved_Error1+' '+daysPerWeek+' '+Label.RTW_Week1_NONVIP_Already_Reserved_Error2;
                                                    } 
                                                }
                                                /************************ End : Return Error Message If Reserve Day count is more tha 5 ********/
                                                
                                                //************** Prepare a list for Valid Requested days *********************/
                                                listReservedDates=new List<Date>();
                                                for(Date dt: listValidRequestDates){
                                                    listReservedDates.add(dt);
                                                }
                                                system.debug('***listReservedDates Second Check'+listReservedDates);
                                            }
                                            else
                                            {
                                                return Label.RTW_Selected_Date_Already_Reserved;
                                            }
                                        }
                                        
                                        
                                        //Fetch DailyReservations records related to list of ReservedDates
                                        //listReservedDates : Valid days for reservation
                                        List<RTW_Daily_Reservation__c> listDailyReservations=new List<RTW_Daily_Reservation__c>();
                                        listDailyReservations=[Select id,RTW_Available_Date__c,RTW_Available_Seats__c,Name from RTW_Daily_Reservation__c
                                                               where RTW_Available_Date__c IN:listReservedDates
                                                               AND RTW_Department__c=:department AND RTW_Office__c=:office 
                                                               AND RTW_Sub_Department__c=:subDepartment AND RTW_Active__c=true];
                                        
                                        //Put list of Daily reservations into Map
                                        //mapAvailableDateToId : Map of ValidDate, Reservation Object
                                        Map<Date,RTW_Daily_Reservation__c> mapAvailableDateToId=new Map<Date,RTW_Daily_Reservation__c>();
                                        for(RTW_Daily_Reservation__c dailyResObj :listDailyReservations){
                                            mapAvailableDateToId.put(dailyResObj.RTW_Available_Date__c,dailyResObj); 
                                        }
                                        
                                        system.debug('***mapAvailableDateToId'+mapAvailableDateToId);
                                        
                                        //Create Reservation records related to list of ReservedDates using above Map
                                        List<Date> listNotReservedDates=new List<Date>();
                                        listInsert=new List<RTW_Reservation__c>();
                                        Map<Date,RTW_Daily_Reservation__c> availableDateFromOtherTeam=new Map<Date,RTW_Daily_Reservation__c>();
                                        
                                        //If Floor Allocation is selected the We need to kept the next team available reservation data                                
                                        if(floorWiseAllocation==true)
                                        {
                                            List<RTW_Daily_Reservation__c> dailyRevForTheFloor=new List<RTW_Daily_Reservation__c>();
                                            /**
* @description added RTW_Sub_Department__c field in the below query as part of user story-3 for wpshrnz
* @author Purva Mittal | 15-7-2021  
**/
                                            dailyRevForTheFloor=[Select id,RTW_Sub_Department__c,RTW_Available_Date__c,RTW_Available_Seats__c,Name from RTW_Daily_Reservation__c
                                                                 where RTW_Available_Date__c IN :listReservedDates and RTW_Available_Seats__c>0 
                                                                 AND RTW_Department__c=:department AND RTW_Office__c=:office 
                                                                 AND RTW_Active__c=true ORDER BY RTW_Available_Seats__c desc];
                                            
                                            if(dailyRevForTheFloor!=null){
                                                for(RTW_Daily_Reservation__c dailyResObj :dailyRevForTheFloor){
                                                    if(!AvailableDateFromOtherTeam.keySet().contains(dailyResObj.RTW_Available_Date__c))
                                                    {
                                                        AvailableDateFromOtherTeam.put(dailyResObj.RTW_Available_Date__c,dailyResObj); 
                                                        system.debug('****dailyResObj'+dailyResObj);
                                                        system.debug('****AvailableDateFromOtherTeam'+AvailableDateFromOtherTeam);
                                                    }
                                                }
                                            }
                                        }
                                        //******************** End : If Floor Allocation is selected the We need to kept the next team available reservation data  
                                        //listReservedDates : Valid days for reservation
                                        RTW_Reservation__c masterreservationObj=new RTW_Reservation__c();
                                        masterreservationObj.RTW_First_Name__c=resObj.RTW_First_Name__c;
                                        masterreservationObj.RTW_Last_Name__c=resObj.RTW_Last_Name__c;
                                        masterreservationObj.RTW_Email__c=resObj.RTW_Email__c;
                                        masterreservationObj.RTW_Payroll_Number__c=resObj.RTW_Payroll_Number__c;
                                        RTW_Daily_Reservation__c dailyresRecord=[select id,name,RTW_Available_Date__c from RTW_Daily_Reservation__c where RTW_Available_Date__c=:Date.today() limit 1];
                                        System.debug('dailyresRecord'+dailyresRecord);       
                                        if(dailyresRecord!=null){
                                            masterreservationObj.RTW_Reservation_Date__c=dailyresRecord.id;
                                        }
                                        masterreservationObj.Type__c='Booking';
                                        
                                        try{
                                            
                                            insert masterreservationObj;
                                            masterResObj = [SELECT id,name from RTW_Reservation__c where id =: masterreservationObj.id];
                                        }
                                        catch(Exception e){
                                            system.debug('***Exception Occured***'+e);
                                            PublishLogEventService.publishExceptionEvent('RTW_FormController.cls on submitForm',e);
                                            return 'EXCEPTION: '+e.getMessage();   
                                        }
                                        
                                        System.debug('masterreservationObj'+masterreservationObj);
                                        
                                        
                                        String domainName=RTW_FormController.getDomainName(resObj.RTW_Email__c);
                                        for(Date reservedDate :listReservedDates){
                                            if(mapAvailableDateToId.get(reservedDate)!=null && 
                                               mapAvailableDateToId.get(reservedDate).RTW_Available_Seats__c!=null &&
                                               mapAvailableDateToId.get(reservedDate).RTW_Available_Seats__c > 0){
                                                   
                                                   //Add Reservation object data if Available set Exist for the team.
                                                   Id reqID=mapAvailableDateToId.get(reservedDate).Id;
                                                   String name=mapAvailableDateToId.get(reservedDate).Name;
                                                   submitReservation(reservedDate,office, department, subDepartment,reqID,resObj,masterreservationObj,name);
                                                   
                                                   
                                               }
                                            else if(floorWiseAllocation==true)
                                            {
                                                //************************ If Floor Wise Allocation is selected *******************************
                                                if(AvailableDateFromOtherTeam.get(reservedDate)!=null){
                                                    RTW_Daily_Reservation__c dailyReservation=AvailableDateFromOtherTeam.get(reservedDate);
                                                    Id reqID=dailyReservation.Id;
                                                    /**
* @description fetching the compatible team name as part of user story-3 for wpshrnz
* @author Purva Mittal | 15-7-2021  
**/
                                                    String subDepartment1=dailyreservation.RTW_Sub_Department__c;
                                                    String name=dailyReservation.Name;
                                                    
                                                    submitReservation(reservedDate,office, department, subDepartment1,reqID,resObj,masterreservationObj,name);
                                                    
                                                }
                                                else
                                                {
                                                    listNotReservedDates.add(reservedDate);
                                                }
                                            }
                                            else
                                            {
                                                listNotReservedDates.add(reservedDate);
                                            }
                                        }
                                        system.debug('***listInsert'+listInsert);
                                        
                                        system.debug('***listNotReservedDates'+listNotReservedDates);
                                        
                                        /**********************Start :  Save the Data into the Object***********************/
                                        try{
                                            Database.SaveResult[] srList = Database.insert(listInsert, true);
                                            system.debug('srListPM'+srList);
                                            
                                            String datesToCancel;
                                            Map<String,RTW_Reservation__c> emailAssociatedWithReser  = new Map<String,RTW_Reservation__c>();
                                            if(reservationsToCancel.size() > 0){
                                                for(RTW_Reservation__c res : [Select Id,RTW_First_Name__c, RTW_Last_Name__c, RTW_Email__c, RTW_Office__c, RTW_Department__c, 
                                                                              RTW_Sub_Department__c, RTW_Cancel_Booking__c, RTW_Reservation_Date__r.RTW_Available_Date__c
                                                                              From RTW_Reservation__c Where Id in: reservationsToCancel]){
                                                                                  
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
                                                
                                                if(resList.size() > 0){
                                                    update resList;
                                                    insert workFlowRecordstoInsert;
                                                }
                                            }
                                        }catch(Exception e){
                                            system.debug('***Exception Occured***'+e);
                                            PublishLogEventService.publishExceptionEvent('RTW_FormController.cls on submitForm',e);
                                            return 'EXCEPTION: '+e.getMessage();                                             
                                        }
                                        /**********************End : Save the Data into the Object***********************/                                
                                        
                                        //Email Notifications
                                        
                                        if(listInsert!=null && listInsert.size()>0){
                                            PCM_Workflow_Emails__c workflowEmailObj = new PCM_Workflow_Emails__c();
                                            for(RTW_Reservation__c reservationObj: listInsert){
                                                workflowEmailObj.Name = 'Res-'+reservationObj.RTW_First_Name__c+' '+reservationObj.RTW_Last_Name__c;
                                                workflowEmailObj.RTW_Reservation_Name__c =reservationObj.RTW_First_Name__c;
                                                workflowEmailObj.RTW_Reservation_Email__c = reservationObj.RTW_Email__c;
                                                workflowEmailObj.RTW_Reservation_Office__c=reservationObj.RTW_Office__c;
                                                workflowEmailObj.RTW_Reservation_Department__c = reservationObj.RTW_Department__c;
                                                //workflowEmailObj.RTW_Reservation_SubDepartment__c = reservationObj.RTW_Sub_Department__c;     
                                                
                                                if(loggedInUserAcc != null){
                                                    workflowEmailObj.RTW_Reservation_LoggedIn_User_Email__c=loggedInUserAcc.PersonEmail;
                                                }
                                                workflowEmailObj.RTW_Reservation_Dates1__c = reservedDates1;
                                                workflowEmailObj.RTW_Reservation_Dates2__c = reservedDates2;
                                                workflowEmailObj.RTW_Reservation_Dates3__c = reservedDates3;
                                                workflowEmailObj.RTW_Reservation_Dates4__c = reservedDates4;       
                                            }    
                                            String htmlBody = '';
                                            //  htmlBody = 'Booking Refference Nos : '+masterResObj.name;
                                            htmlBody = htmlBody +'<table border="1" style="border-collapse: collapse"><h2>Reservation Details \n</h2>Booking Reference Nos : '+masterResObj.name+'<h4></h4><tr><th  width="100px">Reservation Date</th><th  width="350px">Location</th></tr>';
                                            //iterate over list and output columns/data into table rows...
                                            for(RTW_Reservation__c reservationObj: listInsert){
                                                
                                                String reservationDate = reservationObj.Reservation_Date_Text__c;
                                                String team = reservationObj.RTW_Office__c+', '+reservationObj.RTW_Department__c +', '+reservationObj.RTW_Sub_Department__c;
                                                htmlBody += '<tr><th  width="100px">' + ReservationDate + '</th><th  width="350px">' + Team + '</th></tr>';
                                                
                                            }
                                            //close table...
                                            htmlBody += '</table>';
                                            workflowEmailObj.Reservation_Details_HTML__c=htmlBody;
                                            try{
                                                Database.insert(workflowEmailObj, true);
                                            }catch(Exception e){
                                                system.debug('***Exception Occured***'+e);
                                                PublishLogEventService.publishExceptionEvent('RTW_FormController.cls on submitForm',e);
                                                return 'EXCEPTION: '+e.getMessage();                                             
                                            }
                                        }
                                        
                                        //Create NotReservedDates Message
                                        if((listNotReservedDates!=null && listNotReservedDates.size()>0)|| (listInValidRequestDates!=null && listInValidRequestDates.size()>0))
                                        {
                                            String notReservedDates,inValidRequestDates;
                                            if(listNotReservedDates!=null && listNotReservedDates.size()>0){
                                                for(Date notReservedDate :listNotReservedDates){
                                                    Datetime notReservedDateTime = (DateTime)notReservedDate;
                                                    String notReservedDateStr = notReservedDateTime.format('dd MMM yyyy');
                                                    if(notReservedDates==null){
                                                        notReservedDates=notReservedDateStr;
                                                    }
                                                    else{
                                                        notReservedDates=notReservedDates+', '+notReservedDateStr; 
                                                    }
                                                }    
                                            }
                                            if(listInValidRequestDates!=null && listInValidRequestDates.size()>0){
                                                for(Date inValidRequestDate :listInValidRequestDates){
                                                    Datetime inValidRequestDateTime = (DateTime)inValidRequestDate;
                                                    String inValidRequestDateStr = inValidRequestDateTime.format('dd MMM yyyy');
                                                    if(inValidRequestDates==null){
                                                        inValidRequestDates=inValidRequestDateStr;
                                                    }
                                                    else{
                                                        inValidRequestDates=inValidRequestDates+', '+inValidRequestDateStr; 
                                                    }
                                                } 
                                            }                                               
                                            
                                            String returnMsg='';
                                            if(listInsert!=null && listInsert.size()>0){
                                                if(reservedDates2==null){
                                                    returnMsg=Label.RTW_Success_Msg+reservedDates1+'.';
                                                }
                                                else{
                                                    returnMsg=Label.RTW_Success_Msg+reservedDates1+', '+reservedDates2+'.';
                                                }
                                            }
                                            if(listNotReservedDates!=null && listNotReservedDates.size()>0){
                                                returnMsg=returnMsg+Label.RTW_NotReservedDates_Msg+notReservedDates+'.';
                                            }
                                            if(listInValidRequestDates!=null && listInValidRequestDates.size()>0){
                                                returnMsg=returnMsg+Label.RTW_NotRequestDates_Msg+inValidRequestDates+'.';
                                            }
                                            return returnMsg;
                                        }
                                        if(reservedDates2==null){
                                            return 'SUCCESS*'+reservedDates1+'*'+''+'*'+masterResObj.name;
                                        }
                                        else{
                                            return 'SUCCESS*'+reservedDates1+'*'+reservedDates2+'*'+masterResObj.name;
                                        }
                                    }
    
    
    
    /**
* @description This function will be used for submit reservation request
* @author Prathamesh Lad | 06-10-2021 
* @param reservedDate 
* @param office 
* @param department 
* @param subDepartment 
* @param reqID 
* @param resObj 
* @param masterObj
* @param name
**/
    private static void  submitReservation(Datetime reservedDate,
                                           String office, String department, 
                                           String subDepartment,Id reqID, 
                                           RTW_Reservation__c resObj,RTW_Reservation__c masterObj,String name)
    {
        
        Datetime reservedDateTime = (DateTime)reservedDate;
        String reservedDateStr = reservedDateTime.format('dd MMM yyyy');
        String dayOfWeek = reservedDateTime.format('E');
        
        if(counter<=6)
        {
            if(reservedDates1==null){
                reservedDates1=dayOfWeek+' '+reservedDateStr;
            }
            else{
                reservedDates1=reservedDates1+', '+dayOfWeek+' '+reservedDateStr;
            }
        }
        else
        {
            if(reservedDates2==null){
                reservedDates2=dayOfWeek+' '+reservedDateStr;
            }
            else{
                reservedDates2=reservedDates2+', '+dayOfWeek+' '+reservedDateStr;  
            }
        }
        RTW_Reservation__c reservationObj=new RTW_Reservation__c();
        reservationObj.RTW_Reservation_Date__c=reqID;
        reservationObj.RTW_Office__c=office;
        reservationObj.RTW_Department__c=department;
        reservationObj.RTW_Sub_Department__c=subDepartment;
        reservationObj.RTW_First_Name__c=resObj.RTW_First_Name__c;
        reservationObj.RTW_Last_Name__c=resObj.RTW_Last_Name__c;
        reservationObj.Type__c='Reservation';
        reservationObj.Reservation__c=masterObj.id;
        reservationObj.Reservation_Date_Text__c=name;
        String domainName=RTW_FormController.getDomainName(resObj.RTW_Email__c);
        Boolean checkEGL=RTW_FormController.matchDomain(domainName);
        String payRollNumber=RTW_FormController.validatePayroll(checkEGL,resObj.RTW_Payroll_Number__c);
        reservationObj.RTW_Payroll_Number__c=payRollNumber;
        reservationObj.Are_you_an_EGL_team_member__c
            =resObj.Are_you_an_EGL_team_member__c ? resObj.Are_you_an_EGL_team_member__c:checkEGL;    
        reservationObj.RTW_Email__c=resObj.RTW_Email__c;
        reservationObj.RTW_Technical_Work__c=resObj.RTW_Technical_Work__c; //added by shubham shukla on 10/Nov/2020
        
        /* if (loggedInUserAcc != null && loggedInUserAcc.PersonEmail != null && loggedInUserAcc.PersonEmail != reservationObj.RTW_Email__c) {
reservationObj.RTW_LoggedIn_User_Email__c = loggedInUserAcc.PersonEmail;
}*/
        listInsert.add(reservationObj);
        counter=counter+1;
    }
    
    /**
* @description This function will return form availability
* @author Prathamesh Lad | 06-10-2021 
* @return FormAvailablityDetail 
**/
    @AuraEnabled 
    public static FormAvailablityDetail checkFormAvailability() {
        //Fetch Batch Details
        FormAvailablityDetail detail=new FormAvailablityDetail();
        system.debug('detail'+detail);
        List<RTW_Batch_Details__c> listRTWBatchDetailsObj=[Select id,Batchdate__c from RTW_Batch_Details__c limit 1];
        if(listRTWBatchDetailsObj!=null && listRTWBatchDetailsObj.size()>0){
            Date batchDate=listRTWBatchDetailsObj[0].Batchdate__c;
            Datetime dt=batchDate.addDays(14);
            String lastDateDays=Label.RTW_LastDateDays;
            
            Integer lastDateDaysInt=Integer.valueOf(lastDateDays);
            Date formlastDate=batchDate.addDays(lastDateDaysInt);
            Date todayDate=Date.today();
            
            String datatoPrint= dt.format('EEEE dd MMMMM YYYY');
            if(formlastDate<todayDate){
                detail.isAvailable=false;
                detail.availableFormDate = datatoPrint;
                return detail; 
            }
        }
        detail.isAvailable=true;
        return detail;
    }
    
    /**
* @description This function will return accpted email domains
* @author Prathamesh Lad | 06-10-2021 
* @return List<RTW_Email_Domains__c> 
**/
    @AuraEnabled 
    public static List<RTW_Email_Domains__c> getEmailDomains() {
        //Fetch Batch Details
        List<RTW_Email_Domains__c> listEmailDomains=[Select id,Name from RTW_Email_Domains__c];
        system.debug('listEmailDomains'+listEmailDomains);
        return listEmailDomains;
    }
    
    /**
* @description This function will return picklist values
* @author Prathamesh Lad | 06-10-2021 
* @return Map<String, List<PicklistWrapper>> 
**/
    @AuraEnabled 
    public static Map<String,List<PicklistWrapper>> getPicklistMap() {
        
        List<RTW_Location__c> listAllLocations=new List<RTW_Location__c>();
        listAllLocations=[Select Id, RTW_Office__c, RTW_Department__c, 
                          RTW_Sub_Department__c from RTW_Location__c
                          where RTW_Seats__c>0 and RTW_Sub_Department__c!='Visitors' and RTW_Status__c='Active'
                          order by RTW_Office__c, RTW_Department__c, RTW_Sub_Department__c];
        system.debug('listAllLocations'+listAllLocations);
        Map<String,List<PicklistWrapper>> returnMap=new Map<String,List<PicklistWrapper>>();
        
        if(listAllLocations!=null && listAllLocations.size()>0){
            Map<String,List<RTW_Location__c>> mapOfficeToLocations=new Map<String,List<RTW_Location__c>>();
            for(RTW_Location__c locationObj :listAllLocations){
                if(locationObj.RTW_Office__c!=null){
                    List<RTW_Location__c> tempList=new List<RTW_Location__c>();
                    if(mapOfficeToLocations.containsKey(locationObj.RTW_Office__c)){
                        tempList=mapOfficeToLocations.get(locationObj.RTW_Office__c);
                        system.debug('tempList'+tempList);
                    }
                    tempList.add(locationObj);
                    mapOfficeToLocations.put(locationObj.RTW_Office__c,tempList);
                }
            }            
            system.debug('***mapOfficeToLocations'+mapOfficeToLocations);
            
            if(mapOfficeToLocations!=null && mapOfficeToLocations.keyset()!=null && mapOfficeToLocations.keySet().size()>0){
                Map<String,Map<String,Set<String>>> picklistMap=new Map<String,Map<String,Set<String>>>(); 
                for(String office :mapOfficeToLocations.keySet()){
                    List<RTW_Location__c> listLocations=mapOfficeToLocations.get(office);
                    Map<String,Set<String>> mapDeptToSetSubDept=new Map<String,Set<String>>();
                    if(listLocations!=null && listLocations.size()>0){
                        for(RTW_Location__c locationObj :listLocations){
                            if(locationObj.RTW_Department__c!=null){
                                Set<String> setSubDept=new Set<String>();
                                if(mapDeptToSetSubDept.containsKey(locationObj.RTW_Department__c)){
                                    setSubDept=mapDeptToSetSubDept.get(locationObj.RTW_Department__c);
                                }
                                if(locationObj.RTW_Sub_Department__c!=null){
                                    setSubDept.add(locationObj.RTW_Sub_Department__c);
                                } 
                                mapDeptToSetSubDept.put(locationObj.RTW_Department__c,setSubDept);
                            }
                        }
                    }
                    picklistMap.put(office,mapDeptToSetSubDept);
                }
                //    system.debug('mapDeptToSetSubDept'+mapDeptToSetSubDept);
                system.debug('***picklistMap'+picklistMap);
                
                if(picklistMap!=null && picklistMap.keySet()!=null && picklistMap.keySet().size()>0){
                    for(String office :picklistMap.keySet()){
                        List<PicklistWrapper> listPicklistWrapper=new List<PicklistWrapper>();
                        Map<String,Set<String>> mapDeptToSetSubDept=picklistMap.get(office);
                        if(mapDeptToSetSubDept!=null && mapDeptToSetSubDept.keySet()!=null && mapDeptToSetSubDept.keySet().size()>0){
                            for(String dept :mapDeptToSetSubDept.keySet()){
                                PicklistWrapper wrapObj=new PicklistWrapper();
                                wrapObj.department=dept;
                                wrapObj.listSubDepartments=mapDeptToSetSubDept.get(dept);
                                listPicklistWrapper.add(wrapObj);
                            }
                        }
                        returnMap.put(office,listPicklistWrapper);
                    }
                }
            }
        }
        system.debug('***'+returnMap);
        return returnMap;
    }
    
    /**
* @description This function will return Days per week
* @author Prathamesh Lad | 06-10-2021 
* @param selectedOffice 
* @return Decimal 
**/
    @AuraEnabled 
    public static Decimal getDaysPerWeek(String selectedOffice) {
        List<RTW_Location__c> listLocations=[Select id,RTW_Days_Per_Week__c from RTW_Location__c  
                                             where RTW_Office__c=:selectedOffice and RTW_Days_Per_Week__c!=null 
                                             and RTW_Sub_Department__c!='Visitors'];
        system.debug('listLocations'+listLocations);
        if(listLocations!=null){
            return listLocations[0].RTW_Days_Per_Week__c;
        }
        else{
            return 0;
        }
    }
    
    /**
* @description This function will return the logged in user's details from account object
* @author Meghna Bhargava | 14-7-2021 
* @return Account 
**/
    @AuraEnabled 
    public static Account fetchLoggedInUserDetails() {
        Account acc = new Account();
        User loggedInUser = [Select id,name,EmployeeNumber  from User where id =: userinfo.getUserId()];
        if(loggedInUser.EmployeeNumber != '' && loggedInUser.EmployeeNumber != null){
            acc = [SELECT Id, FirstName, LastName, Employee_ID__c,PersonEmail  
                   FROM Account 
                   WHERE Employee_ID__c  =: loggedInUser.EmployeeNumber 
                   AND PersonEmail != '' 
                   AND Employee_ID__c != '' limit 1];
        }
        return acc;
    }
    
    /**
* @description This function will return the all employee records from account
* @author Meghna Bhargava | 14-7-2021 
* @return Map<emailId,Account> 
**/
    @AuraEnabled 
    public static Account fetchTeamMember(String emailAdd) {
        Account acc = new Account();
        DateTime dt = DateTime.newInstance(1965, 01,01);
        
        List<Account> accList = [SELECT Id, FirstName, LastName, Employee_ID__c,PersonEmail, LastModifiedDate 
                             FROM Account 
                             WHERE PersonEmail =: emailAdd];
        for(account a : accList){
            if(a.LastModifiedDate > dt){
                dt = a.LastModifiedDate;
                acc = a;
            }
        }
        return acc;
    }
    
    /**
* @description This method will calculate dates
* @author Prathamesh Lad | 06-10-2021 
**/
    private static void calculateDates(){
        //*********************Start - Fetch : Week Start Date and Week End Data **************************
        Decimal rollingWeeks = 0;
        if(currentLocation != null && currentLocation.Rolling_Weeks__c != null){
            rollingWeeks = currentLocation.Rolling_Weeks__c;
        }
        else{
            rollingWeeks = 4;
        }
        RTW_Batch_Details__c rTWBatchDetailsObj=[Select id,Batchdate__c from RTW_Batch_Details__c limit 1];
        Date batchDate=RTWBatchDetailsObj.Batchdate__c;
        
        //Create Week 1 and Week2 Start and End dates
        batchWeekStart=batchDate.toStartOfWeek();
        week1Start=batchWeekStart.addDays(8);
        week1End=batchWeekStart.addDays(14);
        week2Start=batchWeekStart.addDays(15);
        week2End=batchWeekStart.addDays(21);
        week3Start=batchWeekStart.addDays(22);
        week3End=batchWeekStart.addDays(28);
        week4Start=batchWeekStart.addDays(29);
        week4End=batchWeekStart.addDays(35);
        rollingWeekEndDate = week1Start.addDays(Integer.valueOf(rollingWeeks) * 7 - 1);
        
        //Start : Current week Changes
        Date todayDate = date.today();
        LastWeekStart=batchDate.toStartOfWeek()+1;
        LastWeekEnd=LastWeekStart.addDays(6);
        //Important Date for Batch JOb
        recordFetchStart=week1Start;
        if(todayDate < LastWeekEnd)
        {
            //LastWeekStart=batchDate.toStartOfWeek();
            //LastWeekEnd=LastWeekStart.addDays(7);
            //Important Date for Batch JOb
            recordFetchStart=LastWeekStart;
        }
    }
    
    private static String getDomainName(string email){
        String domain; 
        if(email.split('@')!=null){    
            domain=email.split('@').get(1);
        }
        return domain;
    }
    
    private static Boolean matchDomain(string domainName){
        List<Domain_Master__mdt> domainMasters=[SELECT Id,Label FROM Domain_Master__mdt];
        Set<String> setDomains=new Set<String>();
        for(Domain_Master__mdt domObj :domainMasters){
            setDomains.add(domObj.Label);            
        }
        if(domainName!=null && setDomains.size()>0 && setDomains.contains(domainName)){
            return true;
        }
        return false;
    }
    
    private static String validatePayroll(Boolean matchDomain, String payrollNumber){
        if(matchDomain){
            payrollNumber=null;
        }
        return payrollNumber;
    }
    
    
    /**
* @description PicklistWrapper
* @author Prathamesh Lad | 06-10-2021 
**/
    public class PicklistWrapper {
        /**
* @description department
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled
        public string department { get; set; }
        /**
* @description listSubDepartments
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled
        public Set<String> listSubDepartments { get; set; }
    }
    /**
* @description FormAvailablityDetail
* @author Prathamesh Lad | 06-10-2021 
**/
    public class FormAvailablityDetail{
        /**
* @description availableFormDate
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public String availableFormDate {get; set;}
        /**
* @description isAvailable
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public Boolean isAvailable {get; set;} 
    }
    /**
* @description AvailableDateOption
* @author Prathamesh Lad | 06-10-2021 
**/
    public class AvailableDateOption{
        /**
* @description label
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public String label {get; set;} 
        /**
* @description value
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public String value {get; set;} 
        /**
* @description reservedAlready
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public Boolean reservedAlready {get; set;}
        /**
* @description technicalWork
* @author Prathamesh Lad | 06-10-2021 
**/
        @AuraEnabled public Boolean technicalWork {get; set;}
        /**
* @description rollingWeeks
* @author Akhil Kumar | 26-07-2021 
**/   
        @AuraEnabled public Decimal rollingWeeks {get; set;}
    }
}