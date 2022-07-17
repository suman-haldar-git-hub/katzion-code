/**
* @Author : Sunil
* @Company : Cognizant
* @description : This Class is used for all logic related to NSTRequest__c creation
*/
public with Sharing class NSTFormService {
   
    static Map<String,String> mapMetadata = getContentFromMetadata();
        
     /**
     * @Author : Sunil
     * @description :This method returns the existing NSTRequest__c for logged-in user
     * @return LightningResponse
     */
     @AuraEnabled(cacheable=true)
     public static LightningResponse getNSTRequestDetail()
     {
        List<Date> createdDateNST = new List<Date>();
        LightningResponse response = new LightningResponse();
         try{
             List<NSTRequestWrapper> lstWrap = new List<NSTRequestWrapper>();
             User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
             List<Account> acctList = new List<Account>();
             if(String.isNotBlank(userDetail.EmployeeID__c)){
                 acctList = AccountDomain.queryAccountWithNstReq(userDetail.EmployeeID__c);
             }
             NSTWrapper objWrapper = new NSTWrapper();  
             objWrapper.userLocale = userDetail.TimeZoneSidKey;
             objWrapper.accId = acctList[0].Id;
             lstWrap = getrequestWrapper(acctList[0].NSTRequest__r, objWrapper);
             Map<String, List<NSTRequestWrapper>> mapNSTReqWrap = new Map<String, List<NSTRequestWrapper>>();
             List<String> dateString = new List<String>();
             for(NSTRequestWrapper obj : lstWrap) {
                 if(obj.visittime == null) {
                    continue;
                 }
                String timeZ = objWrapper.timezone;
                String strDate = obj.dateGroup.format('E d MMM', timeZ);
                if(!mapNSTReqWrap.containsKey(strDate)) {
                    dateString.add(strDate);
                    mapNSTReqWrap.put(strDate, new List<NSTRequestWrapper>{obj});
                 }
                 else {
                     mapNSTReqWrap.get(strDate).add(obj);
                 }
             }
             List<DateWrapper> lstDateWrap = new List<DateWrapper>();
             for(String str : dateString) {
                DateWrapper obj = new DateWrapper();
                obj.dateGroup = str;
                if(!mapNSTReqWrap.isEmpty() && mapNSTReqWrap.containsKey(str)) {
                    obj.lstRequest = mapNSTReqWrap.get(str);
                }
                lstDateWrap.add(obj);
             }
             objWrapper.lstRequestDateGroup = lstDateWrap;
             objWrapper.mapMetadata = mapMetadata;   
             response.isError = false;
             response.errorOrSuccessMessage = 'Success'; 
             response.payLoad = JSON.serialize(objWrapper);
             return response;
         }          
         catch(Exception ex)
         {
             response.isError=true;
             response.errorOrSuccessMessage = ex.getMessage();
             PublishLogEventService.publishExceptionEvent(
                 'NSTFormService on getNSTRequestDetail',
                 ex
             );
             system.debug('==ex=='+ex);
         return response; 
         }                        
     }

     /**
     * @Author : Akshansh
     * @description :This method finds all CFC records for last 2 days.
     * @param lstNst
     * @param objWrapper
     * @return List<NSTRequestWrapper>
     */
    public static List<NSTRequestWrapper> getrequestWrapper(
        List<NSTRequest__c> lstNst, 
        NSTFormService.NSTWrapper objWrapper
    ) {
        List<NSTRequest__c> dayBeforeYesterdayCFC = new List<NSTRequest__c>();
        List<NSTRequest__c> yesterdayCFC = new List<NSTRequest__c>();
        List<NSTRequestWrapper> lstWrap = new List<NSTRequestWrapper>();         
        For(NSTRequest__c obj : lstNst) {
           if( 
               obj.VisitedDate_Start__c.Date() == Date.today().addDays(-1) && 
               obj.Banner__c == 'CFC' && obj.Status__c == mapMetadata.get('NSTSTATUSPENDING')
           ) {
               yesterdayCFC.add(obj);                       
           }
           else if(
               obj.VisitedDate_Start__c.Date() == Date.today().addDays(-2) && 
               obj.Banner__c == 'CFC' && obj.Status__c == mapMetadata.get('NSTSTATUSPENDING')
           ) {
               dayBeforeYesterdayCFC.add(obj);
           }
       }
       ClockinClockoutCFCService.yesterdayCFC = yesterdayCFC;
       ClockinClockoutCFCService.dayBeforeYesterdayCFC = dayBeforeYesterdayCFC;
       ClockinClockoutCFCService.mapMetadata = mapMetadata;
       lstWrap = ClockinClockoutCFCService.calculateCFCTimeline(lstNst, objWrapper);
       return lstWrap;
   }

     /**
     * @Author : Sunil
     * @description :This method returns the all reqyured picklist values  of NSTRequest__c
     * @return List<AllPicklistValue>
     */
     @AuraEnabled(cacheable=true)
     public static List<AllPicklistValue> getAllPicklIstValue()
     {
         List<AllPicklistValue> allpicklistval=new List<AllPicklistValue>();
         AllPicklistValue picklistvalue1=new AllPicklistValue();
         picklistvalue1.picklistName='State';
         picklistvalue1.picklistvalue=getPickListValue('Store__c','State__c');
         allpicklistval.add(picklistvalue1);
         
         AllPicklistValue picklistvalue2=new AllPicklistValue();
         picklistvalue2.picklistName='Store Type';
         picklistvalue2.picklistvalue=getPickListValue('Store__c','Store_Type__c');
         allpicklistval.add(picklistvalue2);
         
         AllPicklistValue picklistvalue3=new AllPicklistValue();
         picklistvalue3.picklistName='Break duration';
         picklistvalue3.picklistvalue=getPickListValue('NSTRequest__c','Break_Duration__c');
         allpicklistval.add(picklistvalue3);
 
         AllPicklistValue picklistvalue4=new AllPicklistValue();
         picklistvalue4.picklistName='Timezone';
         picklistvalue4.picklistvalue=getPickListValue('NSTRequest__c','Timezone__c');
         allpicklistval.add(picklistvalue4);
         
         List<StateTimeZoneMapping__mdt> mapping=StateTimezoneMappingDomain.queryData();
         PicklistValue picklistvalobj;
         List<PicklistValue> pickListValuesList = new List<PicklistValue>();
         for(StateTimeZoneMapping__mdt mapdata: mapping)
         {
             picklistvalobj=new PicklistValue();
             picklistvalobj.label=mapdata.State__c;
             picklistvalobj.value=mapdata.Timezone__c;
             pickListValuesList.add(picklistvalobj);
         }
         
         AllPicklistValue picklistvalue5=new AllPicklistValue();
         picklistvalue5.picklistName='TimeZoneMapping';
         picklistvalue5.picklistvalue=pickListValuesList;
         allpicklistval.add(picklistvalue5);
         return allpicklistval;
     }
    
     /**
     * @Author : Sunil
     * @Company : Cognizant
     * @description : This Class is wrapper for picklist values
     */
     public class PicklistValue{
         @AuraEnabled
         public String label;
         @AuraEnabled
         public String value;
     }
     
     /**
     * @Author : Sunil
     * @Company : Cognizant
     * @description : This Class is wrapper for all picklist values
     */
     public class AllPicklistValue{
         @AuraEnabled
         public String picklistName;
         @AuraEnabled
         public List<PicklistValue> picklistvalue;
     }
     
     /**
     * @Author : Sunil
     * @description :This method returns the all required picklist values  using DescribeSObject call
     * @return List<PicklistValue>
     * @param  objApiName
     * @param  fieldName
     */
     public static List<PicklistValue> getPickListValue(String objApiName, String fieldName)
     {
         PicklistValue picklistvalobj;
         List<PicklistValue> pickListValuesList = new List<PicklistValue>();
         schema.SObjectType convertType = Schema.getGlobalDescribe().get(objApiName);
         Sobject objectName = convertType.newSObject();
         Schema.SObjectType objType=objectName.getSObjectType();
         Schema.DescribeSObjectResult objDesc= objType.getDescribe();
         Map<String,Schema.SObjectField> fldMap=objDesc.fields.getMap();
         List<Schema.PicklistEntry> pickList=fldMap.get(fieldName).getDescribe().getPickListValues();
         for( Schema.PicklistEntry pickListVal : pickList){
             picklistvalobj=new PicklistValue();
             picklistvalobj.label=pickListVal.getLabel();
             picklistvalobj.value=pickListVal.getValue();   
             pickListValuesList.add(picklistvalobj);
         }
         return pickListValuesList;    
     }
      /**
     * @author : Sunil Kumar
     * @description : This method is used to return list of custom metadata 
     * @return : List<CommunityContentInfo__mdt>
     */
     private static Map<String,String> getContentFromMetadata(){
         Map<String,String> mapMetadata = new Map<String,String>();
         Set<String> setDeveloperName = new Set<String> {'NSTLABELBREAKDURATION',
         'NSTICNSTORE','NSTLABELSTORE','NSTAFFIRMATIONSTORE','NSTCLOCKINSTORE',
         'NSTCLOCKOUTSUCCESS','NSTLABELBANNER','NSTLABELMANAGER','NSTCLOCKOUT',
         'NSTLABELCARTRAVEL','NSTICNCAR','NSTCLOCKINCOACH','NSTLABELCARTRAVETIME',
         'NSTONEWAY','NSTLABELCARTRAVELDIST','NSTENTRYTYPESTORE','NSTCLOCKINSUCCESS',
         'NSTICNCLOCK','NSTLABELSTATE','NSTAFFIRMATIONCLOCKOUT','NSTLABELCOMMENTS',
         'NSTAFFIRMATIONCOACH','NSTENTRYTYPECOACH','NSTSTATUSPENDING','NSTSTATUSCOMPLETED',
         'NSTACTIVITYMSG','NSTERRORMESSAGE','NSTHOMEURL','BANNERCFC','NSTAFFIRMATIONSTORECFC',
         'NSTERRORMESSAGECLOCKOUT'};
         for(CommunityContentInfo__mdt obj : 
             CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName)){
             mapMetadata.put(obj.DeveloperName, obj.Content__c);
         }
         
         return mapMetadata;
     }
     
     /**
     * @Author : Sunil
     * @Company : Cognizant
     * @description : This Class is wrapper for LightningResponse payload
     */
     public class NSTWrapper{
         @AuraEnabled
         public String accId;
         @AuraEnabled
         public String managerUser;
         @AuraEnabled
         public boolean isRecFound = false;
         @AuraEnabled
         public boolean isCheckoutComplete = false;
         @AuraEnabled
         public String timezone;
         @AuraEnabled
         public Map<String, String> mapMetadata;
         @AuraEnabled
         public List<DateWrapper> lstRequestDateGroup;
         @AuraEnabled
         public String userLocale;
     }
     
     /**
     * @Author : Akshansh
     * @Company : Cognizant
     * @description : This Class is wrapper for NST records grouped with Date
     */
    public class DateWrapper{
        @AuraEnabled
        public String dateGroup;
        @AuraEnabled
        public List<NSTRequestWrapper> lstRequest;
    }
 }