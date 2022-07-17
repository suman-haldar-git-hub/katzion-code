/**
* @Author : Akshansh
* @Company : Cognizant
* @description : This Class has logic for CFC timeline related to NST Form ClockIn/Out.
*/
public with sharing class ClockinClockoutCFCService {
    
    public static List<NSTRequest__c> yesterdayCFC = new List<NSTRequest__c>();
    public static List<NSTRequest__c> dayBeforeYesterdayCFC = new List<NSTRequest__c>();
    public static Map<String,String> mapMetadata = new Map<String,String>();
    
   /**
    * @Author : Akshansh
    * @description :This method returns the List of NSTRequestWrapper based on CFC Clock In.
    * @param lstNst
    * @param objWrapper
    * @return List<NSTRequestWrapper>
    */
   public static List<NSTRequestWrapper> calculateCFCTimeline(
       List<NSTRequest__c> lstNst, 
       NSTFormService.NSTWrapper objWrapper
   ) {
       List<NSTRequestWrapper> lstWrap = new List<NSTRequestWrapper>();
       For(NSTRequest__c obj : lstNst){
           
           if(checkWhenNSTNotExist(obj)){
               continue;
           }                  
           NSTRequestWrapper objWrap = new NSTRequestWrapper();
           if(obj.Status__c == mapMetadata.get('NSTSTATUSPENDING')){
               conditionalCFCChecks(objWrapper, objWrap, obj);
           }
           else if(obj.Status__c == mapMetadata.get('NSTSTATUSCOMPLETED') &&
                obj.VisitedDate_End__c >= Date.today().addDays(-1)
           ){
               objWrap.title= mapMetadata.get('NSTCLOCKOUT');
               objWrapper.timezone = String.isEmpty(objWrapper.timezone)?obj.Timezone__c:objWrapper.timezone;
               objWrap.visitTime= obj.VisitedDate_End__c.format('MMM d, hh:mm a',  objWrapper.timezone);
               objWrap.dateGroup = obj.VisitedDate_End__c;
               objWrap.param1= mapMetadata.get('NSTLABELBREAKDURATION');
               objWrap.value1= obj.Break_Duration__c+' min';
               objWrap.param2= mapMetadata.get('NSTLABELCOMMENTS');
               objWrap.value2= obj.Comments__c;
               objWrap.icn= mapMetadata.get('NSTICNCLOCK');
               objWrapper.isCheckoutComplete = true;
           }
           lstWrap.add(objWrap);    
       }
       return lstWrap;
   }

   
   /**
    * @Author : Akshansh
    * @description :This method populates the values of NST records in NSTRequestWrapper.
    * @param objWrapper
    * @param objWrap
    * @param obj
    */
   private static Void conditionalCFCChecks(
    NSTFormService.NSTWrapper objWrapper, 
    NSTRequestWrapper objWrap,
       NSTRequest__c obj
   ) {
    if(checkCFCForLast2Days(obj)) {
        createClockInWrapper(objWrapper, objWrap, obj);
    }
    else if(checkWhenCFCExistForLast1NotLast2(obj)) {
        createClockInWrapper(objWrapper, objWrap, obj);
    }
    else if(checkWhenCFCNotExistForLast1(obj)) {
        createClockInWrapper(objWrapper, objWrap, obj);
    }
   }

   /**
    * @Author : Akshansh
    * @description :This method checks if NST records exists for today.
    * @param obj
    * @return Boolean
    */
   private static Boolean checkWhenNSTNotExist(NSTRequest__c obj) {
       Boolean hasCondition = false;
       if(
           yesterdayCFC.isEmpty() && 
           dayBeforeYesterdayCFC.isEmpty() && 
           obj.VisitedDate_Start__c.Date() != Date.today()
       ) {
           hasCondition = true;
       }
       return hasCondition;
   }

   /**
    * @Author : Akshansh
    * @description :This method checks if CFC records not exists for last 2 days.
    * @param obj
    * @return Boolean
    */
   private static Boolean checkCFCForLast2Days(NSTRequest__c obj) {
       Boolean hasCondition = false;
       if(
           (
               (yesterdayCFC.isEmpty() && 
               dayBeforeYesterdayCFC.isEmpty())
               ||
               (!yesterdayCFC.isEmpty() && 
               !dayBeforeYesterdayCFC.isEmpty())
           ) &&
           obj.VisitedDate_Start__c.Date() == Date.today()

       ) {
           hasCondition = true;
       }
       return hasCondition;
   }

   /**
    * @Author : Akshansh
    * @description :This method checks if CFC records exists yesterday but not 2nd day
    * @description :then display all NST records from yesterday.
    * @param obj
    * @return Boolean
    */
   private static Boolean checkWhenCFCExistForLast1NotLast2(NSTRequest__c obj) {
       Boolean hasCondition = false;
       if(
           !yesterdayCFC.isEmpty() && 
           dayBeforeYesterdayCFC.isEmpty() && 
           obj.VisitedDate_Start__c.Date() >= Date.today().addDays(-1)
       ) {
           hasCondition = true;
       }
       return hasCondition;
   }

   /**
    * @Author : Akshansh
    * @description :This method checks if no CFC exist for yesterday then show only todays NST.
    * @param obj
    * @return Boolean
    */
   private static Boolean checkWhenCFCNotExistForLast1(NSTRequest__c obj) {
       Boolean hasCondition = false;
       if(
           yesterdayCFC.isEmpty() && 
           obj.VisitedDate_Start__c.Date() == Date.today()
       ) {
           hasCondition = true;
       }
       return hasCondition;
   }

   /**
     * @Author : Sunil
     * @description :This method returns the all reqyured picklist values  of NSTRequest__c
     * @param objWrapper
     * @param objWrap
     * @param obj 
     */
    @AuraEnabled(cacheable=true)
    public static void  createClockInWrapper(NSTFormService.NSTWrapper objWrapper,
    NSTRequestWrapper objWrap, NSTRequest__c obj)
    {   
                    objWrapper.timezone = String.isEmpty(objWrapper.timezone)?obj.Timezone__c:objWrapper.timezone;
                    objWrapper.isRecFound = true;
                    if(obj.EntryType__c == mapMetadata.get('NSTENTRYTYPECOACH')){
                        objWrap.title= mapMetadata.get('NSTCLOCKINCOACH');
                        objWrap.visitTime= obj.VisitedDate_Start__c.format('MMM d, hh:mm a', objWrapper.timezone);//obj.VisitedStartTimeBackend__c;
                        objWrap.dateGroup = obj.VisitedDate_Start__c;
                        objWrap.param1= mapMetadata.get('NSTLABELSTATE');
                        objWrap.value1= obj.State__c;
                        if(obj.Time_Travel__c !=null){
                            objWrap.param2= mapMetadata.get('NSTLABELCARTRAVEL');
                            objWrap.value2= mapMetadata.get('NSTONEWAY');
                            objWrap.param3= mapMetadata.get('NSTLABELCARTRAVETIME');
                            objWrap.value3= String.valueOf(obj.Time_Travel__c) +' min';
                            objWrap.param4= mapMetadata.get('NSTLABELCARTRAVELDIST');
                            objWrap.value4= String.valueOf(obj.Distance_Travelled__c)+' km';
                        }
                        objWrap.icn= mapMetadata.get('NSTICNCAR');
                    }
                    else
                    if(obj.EntryType__c == mapMetadata.get('NSTENTRYTYPESTORE')){
                        objWrap.title= mapMetadata.get('NSTCLOCKINSTORE');
                        objWrap.visitTime= obj.VisitedDate_Start__c.format('MMM d, hh:mm a', objWrapper.timezone);//obj.VisitedStartTimeBackend__c;
                        objWrap.dateGroup = obj.VisitedDate_Start__c;
                        objWrap.param1= mapMetadata.get('NSTLABELSTATE');
                        objWrap.value1= obj.State__c;
                        objWrap.param2= mapMetadata.get('NSTLABELBANNER');
                        objWrap.value2= obj.Store__r.Store_Type__c;
                        objWrap.param3= mapMetadata.get('NSTLABELSTORE');
                        objWrap.value3= obj.Store__r.Store_Number__c+' ' +obj.StoreName__c;
                        objWrap.param4= mapMetadata.get('NSTLABELMANAGER');
                        objWrap.value4= obj.ManagerName__c;
                        if(obj.Time_Travel__c !=null){
                            objWrap.param5= mapMetadata.get('NSTLABELCARTRAVETIME');
                            objWrap.value5= String.valueOf(obj.Time_Travel__c) +' min';
                            objWrap.param6= mapMetadata.get('NSTLABELCARTRAVELDIST');
                            objWrap.value6= String.valueOf(obj.Distance_Travelled__c)+' km';
                        }
                        objWrap.icn= mapMetadata.get('NSTICNSTORE');
                    }
                    if(String.isnotEmpty(obj.ManagerUser__c)){
                        objWrapper.managerUser = obj.ManagerUser__c;
                    }
    }
}