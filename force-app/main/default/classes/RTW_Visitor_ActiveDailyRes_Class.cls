/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 09-16-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
global without sharing class RTW_Visitor_ActiveDailyRes_Class{
    
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 09-15-2021 
    **/
    public static void execute() 
    {
    	List<RTW_Location__c> scope=[SELECT Id,Name,RTW_Department__c,RTW_Office__c,RTW_Seats__c,RTW_Sub_Department__c,RTW_State__c  FROM RTW_Location__c where RTW_Sub_Department__c = 'Visitors'];
    	Date todayDate=Date.today();
    	Date startOfWeek=todayDate.toStartOfWeek();
	    Date startOfCycle=startOfWeek.addDays(8);
    	Date endOfCycle=startOfWeek.addDays(19);
    	List<Date> datesBetweenStartEnd=new List<Date>();
    	while(startOfCycle <= endOfCycle) {
            DateTime startOfCycleDateTime = (DateTime) startOfCycle;
            String dayOfWeek = startOfCycleDateTime.format('E');
            if(dayOfWeek!='Sun' && dayOfWeek!='Sat' ){
                datesBetweenStartEnd.add(startOfCycle);
            }
            startOfCycle = startOfCycle.addDays(1);
        }
        System.debug('***datesBetweenStartEnd'+datesBetweenStartEnd);
        
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
        System.debug('***mapStateToPublicHolidays'+mapStateToPublicHolidays);
        
        List<RTW_Daily_Reservation__c> listInsertDailyReservations=new List<RTW_Daily_Reservation__c>();
        system.debug('scope'+scope);
        boolean alreadyExisting=false;
        for(RTW_Location__c locationObj :scope){
            alreadyExisting=false;
            //Logic For Guest User
            for(RTW_Daily_Reservation__c rev:listInsertDailyReservations)
            {
                if(rev.RTW_Office__c == locationObj.RTW_Office__c)
                {
                    alreadyExisting=true;
                	break;
                }
            }
            
            if(alreadyExisting==true)
            {
                continue;
            }
            //End 
            for(Date availableDate :datesBetweenStartEnd){
                Boolean flag=true;
                if(locationObj.RTW_State__c!=null && mapStateToPublicHolidays.get(locationObj.RTW_State__c)!=null){
                    Set<Date> setPublicHolidays=mapStateToPublicHolidays.get(locationObj.RTW_State__c);
                    if(setPublicHolidays.contains(availableDate)){
                        flag=false;
                    }
                }
                system.debug('flag'+flag);
                if(flag){
                    
                    RTW_Daily_Reservation__c dailyResObj=new RTW_Daily_Reservation__c();
                    Datetime availableDateTime = (DateTime)availableDate;
                    String availableDateStr = availableDateTime.format('dd MMM yyyy');
                    dailyResObj.Name=availableDateStr;
                    dailyResObj.RTW_Active__c=true;
                    dailyResObj.RTW_Available_Date__c=availableDate;
                    dailyResObj.RTW_Total_Seats__c=locationObj.RTW_Seats__c;
                    dailyResObj.RTW_Department__c=locationObj.RTW_Department__c;
                    dailyResObj.RTW_Office__c=locationObj.RTW_Office__c;
                    dailyResObj.RTW_Sub_Department__c=locationObj.RTW_Sub_Department__c;
                    listInsertDailyReservations.add(dailyResObj);
                }
            }
        }
        try{
            insert listInsertDailyReservations;
        }catch(Exception e){
            PublishLogEventService.publishExceptionEvent(
                'RTW_Visitor_ActiveDailyRes_Class.cls on execute',
                e
            );
            System.debug('***Exception Occured While inserting Daily Reservation records'+e); 
        }
    
    }
    
}