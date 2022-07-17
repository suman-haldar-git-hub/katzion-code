/**
* @description       : 
* @author            : Meghna Bhargava
* @group             : 
* @last modified on  : 09-16-2021
* @last modified by  : Meghna Bhargava
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
global class RTW_ActiveDailyRes_Batch implements Database.Batchable<sObject>{
    
    global final String query='SELECT Id,Name,RTW_Department__c,RTW_Office__c,RTW_Seats__c,'+
        'RTW_Sub_Department__c,RTW_State__c,RTW_DeactivationStartDate__c, RTW_DeactivationEndDate__c, Rolling_Weeks__c FROM RTW_Location__c where RTW_Sub_Department__c !=  \'Visitors\'';
    
    
    /**
* @description 
* @author Meghna Bhargava | 09-15-2021 
* @param bc 
* @return Database.QueryLocator 
**/
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    /**
* @description 
* @author Meghna Bhargava | 09-15-2021 
* @param bc 
* @param scope 
**/
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        
        List<RTW_Daily_Reservation__c> listInsertDailyReservations = new List<RTW_Daily_Reservation__c>();
        List<RTW_Daily_Reservation__c> listUpdateDailyReservations = new List<RTW_Daily_Reservation__c>();
        Date todayDate = Date.today(); 
        Date startOfWeek = todayDate.toStartOfWeek();
        Date startOfCycle = Date.today();
        Date week1StartOfCycle = startOfWeek.addDays(8);
        
        List<RTW_Daily_Reservation__c> dailyResList = [SELECT Name, RTW_Office__c,RTW_Department__c,
                                                       RTW_Sub_Department__c,RTW_Available_Date__c,RTW_Active__c
                                                       FROM RTW_Daily_Reservation__c 
                                                       WHERE RTW_Available_Date__c >= :startOfCycle
                                                       AND RTW_Active__c = true];
        
        List<RTW_Daily_Reservation__c> inactiveDailyResList = [SELECT Name, RTW_Office__c,RTW_Department__c,
                                                               RTW_Sub_Department__c,RTW_Available_Date__c,RTW_Active__c
                                                               FROM RTW_Daily_Reservation__c 
                                                               WHERE RTW_Available_Date__c >= :startOfCycle
                                                               AND RTW_Active__c = false];
        
        
        Map<String,Set<Date>> mapLocationToDailyRes = new Map<String,Set<Date>>();
        Map<String, List<RTW_Daily_Reservation__c>> mapLocationToInactiveRes = new Map<String, List<RTW_Daily_Reservation__c>>();
        
        for(sobject obj :scope){
            RTW_Location__c locationObj = (RTW_Location__c)obj;
            
            mapLocationToDailyRes.put(locationObj.Id,new Set<Date>());
            
            // Map location to active daily reservations
            for (RTW_Daily_Reservation__c dailyReservation :dailyResList) {
                if(locationObj.RTW_Office__c == dailyReservation.RTW_Office__c && 
                   locationObj.RTW_Department__c == dailyReservation.RTW_Department__c &&
                   locationObj.RTW_Sub_Department__c == dailyReservation.RTW_Sub_Department__c) {
                       
                       Set<Date> dailyReservationDates = new Set<Date>();
                       if(mapLocationToDailyRes.containsKey(locationObj.Id)) {
                           dailyReservationDates = mapLocationToDailyRes.get(locationObj.Id);
                       }
                       dailyReservationDates.add(dailyReservation.RTW_Available_Date__c);
                       mapLocationToDailyRes.put(locationObj.Id,dailyReservationDates);
                       
                   }
            }
            
            //Map location to inactive daily reservations
            List<RTW_Daily_Reservation__c> inactiveRTWDailyResList = new List<RTW_Daily_Reservation__c>();
            for (RTW_Daily_Reservation__c inactiveDailyRes :inactiveDailyResList) {
                if(locationObj.RTW_Office__c == inactiveDailyRes.RTW_Office__c && 
                   locationObj.RTW_Department__c == inactiveDailyRes.RTW_Department__c &&
                   locationObj.RTW_Sub_Department__c == inactiveDailyRes.RTW_Sub_Department__c) {
                       inactiveRTWDailyResList.add(inactiveDailyRes);
                   }
            }
            mapLocationToInactiveRes.put(locationObj.Id,inactiveRTWDailyResList);    
        }
        
        List<Public_Holidays__c> listPublicHolidays=new List<Public_Holidays__c>();
        listPublicHolidays=[Select Id, Name, Holiday_Date__c,State__c from Public_Holidays__c];
        Map<String,Set<Date>> mapStateToPublicHolidays=new Map<String,Set<Date>>();
        if(listPublicHolidays!=null && listPublicHolidays.size()>0){
            for(Public_Holidays__c publicHoildaysObj :listPublicHolidays){
                Set<Date> tempSet=new Set<Date>();
                if(mapStateToPublicHolidays.containsKey(publicHoildaysObj.State__c)){
                    tempSet=mapStateToPublicHolidays.get(publicHoildaysObj.State__c);
                }
                tempSet.add(publicHoildaysObj.Holiday_Date__c);
                mapStateToPublicHolidays.put(publicHoildaysObj.State__c,tempSet);
            }
        }
        
        for(sobject obj :scope){
            RTW_Location__c locationObj = (RTW_Location__c)obj;
            Decimal rollingWeeks;
            rollingWeeks = locationObj.Rolling_Weeks__c;
            
            //If rolling weeks is not defined then consider 4 rolling weeks by default
            if (rollingWeeks == null) {
                rollingWeeks = 4;
            }
            Decimal rollingDays;
            rollingDays = rollingWeeks*7;
            
            // Cycle starts on monday and ends on Sunday 
            Date newStartOfCycle = startOfCycle;
            
            Date endOfCycle = week1StartOfCycle.addDays(Integer.valueOf(rollingDays) - 1);
            List<Date> datesBetweenStartEnd = new List<Date>();
            
            while(newStartOfCycle <= endOfCycle) {
                DateTime startOfCycleDateTime = (DateTime) newStartOfCycle;
                datesBetweenStartEnd.add(newStartOfCycle);
                newStartOfCycle = newStartOfCycle.addDays(1);
            }
            
            for(Date availableDate :datesBetweenStartEnd){
                
                Boolean publicHoliday = false;
                if(locationObj.RTW_State__c!=null && mapStateToPublicHolidays.get(locationObj.RTW_State__c)!=null){
                    Set<Date> setPublicHolidays = mapStateToPublicHolidays.get(locationObj.RTW_State__c);
                    if(setPublicHolidays.contains(availableDate)){
                        publicHoliday = true;
                    }
                }
                
                //Activate daily reservation if site is active
                List<RTW_Daily_Reservation__c> inactiveDailyReservList = mapLocationToInactiveRes.get(locationObj.Id);
                Boolean isSiteActive = true;
                
                if(locationObj.RTW_DeactivationStartDate__c <= availableDate && locationObj.RTW_DeactivationEndDate__c >= availableDate) {
                    isSiteActive = false; 
                }
                
                if(!publicHoliday && inactiveDailyReservList.size() > 0 && isSiteActive) {
                    
                    List<RTW_Daily_Reservation__c> dailyResUpdatedList = new List<RTW_Daily_Reservation__c>();
                    for(RTW_Daily_Reservation__c inactiveDailyRes :inactiveDailyReservList) {
                        if(inactiveDailyRes.RTW_Available_Date__c == availableDate) {
                            inactiveDailyRes.RTW_Active__c = true;
                            listUpdateDailyReservations.add(inactiveDailyRes);
                        }
                    }
                }
                
                else {                
                    if (mapLocationToDailyRes != null && mapLocationToDailyRes.get(locationObj.Id) != null) {
                        Set<Date> dailyReservationSet = mapLocationToDailyRes.get(locationObj.Id);
                        
                        if(!publicHoliday && !dailyReservationSet.contains(availableDate) && inactiveDailyReservList.size() == 0) {
                            
                            RTW_Daily_Reservation__c dailyResObj = new RTW_Daily_Reservation__c();
                            Datetime availableDateTime = (DateTime)availableDate;
                            String availableDateStr = availableDateTime.format('dd MMM yyyy');
                            dailyResObj.Name = availableDateStr;
                            
                            if(locationObj.RTW_DeactivationStartDate__c <= availableDate && locationObj.RTW_DeactivationEndDate__c >= availableDate) {
                                dailyResObj.RTW_Active__c = false; 
                            }
                            else {
                                dailyResObj.RTW_Active__c = true; 
                            }
                            
                            dailyResObj.RTW_Available_Date__c = availableDate;
                            dailyResObj.RTW_Total_Seats__c = locationObj.RTW_Seats__c;
                            dailyResObj.RTW_Department__c = locationObj.RTW_Department__c;
                            dailyResObj.RTW_Office__c = locationObj.RTW_Office__c;
                            dailyResObj.RTW_Sub_Department__c = locationObj.RTW_Sub_Department__c;
                            listInsertDailyReservations.add(dailyResObj);
                        }
                    }
                }
            }
            
        }
        
        try{
            insert listInsertDailyReservations;
            update listUpdateDailyReservations;
        }catch(Exception e){
            System.debug('***Exception Occured While inserting Daily Reservation records'+e); 
            PublishLogEventService.publishExceptionEvent('RTW_ActiveDailyRes_Batch.cls on execute',e);
        }    
        
    }
    
    /**
* @description 
* @author Meghna Bhargava | 09-15-2021 
* @param bc 
**/
    global void finish(Database.BatchableContext bc){
        List<RTW_Batch_Details__c> listBatchDetails=[Select id,BatchDate__c from RTW_Batch_Details__c
                                                     where Name='Batch' limit 1];
        if(listBatchDetails!=null && listBatchDetails.size()>0){
            listBatchDetails[0].BatchDate__c=Date.today();
            try{
                update listBatchDetails;    
            }catch(Exception e){
                System.debug('***Exception Occured While updating Return work Form Batch Details'+e); 
                PublishLogEventService.publishExceptionEvent('RTW_ActiveDailyRes_Batch.cls on finish',e);
            }
        }else{
            RTW_Batch_Details__c batchDetailsObj=new RTW_Batch_Details__c(Name='Batch',BatchDate__c=Date.today());
            try{
                insert batchDetailsObj;
            }catch(Exception e){
                System.debug('***Exception Occured While inserting Return work Form Batch Details'+e); 
                PublishLogEventService.publishExceptionEvent('RTW_ActiveDailyRes_Batch.cls on finish',e);
            }
        }
    }    
}