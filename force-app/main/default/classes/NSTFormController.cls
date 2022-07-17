/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This class is used as a controller class for NST form
*/
public with sharing class NSTFormController {


    /**
    * @author : Akshansh Jain
    * @description : This method is used to query KPI Link for MyInfo URL.
    * @return : String
    */
    @AuraEnabled
    public static String getMyInfoLink() {
        String strLink = '';
        User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        if(userDetail.EmployeeID__c != null) {
            Account accountDetail = AccountDomain.queryAccountBasedOnEmpId(userDetail.EmployeeID__c);
            if(accountDetail.Store_Id_Cost_Centre__c != null) {
                List<Store__C> storeResult = [SELECT Store_Number__c, KPI_Link__c FROM Store__C WHERE Store_Number__c =: accountDetail.Store_Id_Cost_Centre__c];
                if(!storeResult.isEmpty() && String.isNotEmpty(storeResult[0].KPI_Link__c)) {
                    strLink = storeResult[0].KPI_Link__c;
                }
            }
        }
        if(strLink == '' || strLink == null) {            
            FeatureControl__mdt obj = FeatureControlDomain.getFeatureControlRecordByDN('DEFAULTLINK');
            strLink = obj.Content__c;
        }
        return strLink;
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to return list of custom metadata 
    * @return : List<CommunityContentInfo__mdt>
    */
    @AuraEnabled
    public static List<CommunityContentInfo__mdt> getContentFromMetadata(){
        Set<String> setDeveloperName = new Set<String> {'NSTTHINGSTOKNOW1',
                        'NSTTHINGSTOKNOW2','NSTTHINGSTOKNOW3','NSTTHINGSTOKNOW4',
                        'NSTTHINGSTOKNOW5','NSTTHINGSTOKNOW6'};
        List<CommunityContentInfo__mdt> lstAllCommContentData = 
                CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName); 
        
        return lstAllCommContentData;
    }
        
    /**
    * @author : Amit Sharma
    * @description : This method is used to return list of wrapper class with data
    * @return : ContainerWrapperClass
    */
    @AuraEnabled(cacheable=true)
    public static List<ContainerWrapperClass> getScheduleDataCurrentWeek(){
        
        List<ContainerWrapperClass> lstContainerClass = 
                                                   new List<ContainerWrapperClass>();
        List<ScheduleDataWrapper> lstDataWrapper = new List<ScheduleDataWrapper>();
        Map<String, Schedule__c> mapStringToSchedule=new Map<String, Schedule__c>();
        Map<String,DateTime> mapStringAndDate = new Map<String,DateTime>();
        Map<String,DateTime> mapStringAndEndDate = new Map<String,DateTime>();
        ScheduleDataWrapper objDataWrapper; 
        ContainerWrapperClass objContainerClass;
        String titleValue ;
        Integer scheduleDetailDayes = Integer.ValueOf(Label.Schedule_Detail_Days); //27    
        
        User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        Date weekStartDate;
        Date myDate = Date.today(); 
        Datetime dt = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        if(dayOfWeek == 'Sunday'){
           weekStartDate =  myDate.toStartofWeek().addDays(-6);
        }
        else {
            weekStartDate = myDate.toStartofWeek().addDays(1);
        }
        
        Time myTime = Time.newInstance(0, 0, 0, 0);
        DateTime weekStart = DateTime.newInstanceGMT(weekStartDate, myTime);

        Date endDateOfDataDate = weekStartDate.addDays(scheduleDetailDayes);
        Time myTime1 = Time.newInstance(23, 59, 59, 0);
        DateTime endDateOfData = DateTime.newInstanceGMT(
                                    endDateOfDataDate, myTime1);
        for(Integer i=0;  i<=scheduleDetailDayes;  i++){  
            DateTime weekStartNew = weekStart.addDays(i);
            Date weekStartNewInDate = Date.valueof(weekStartNew);
            
            String strDateFormat = String.ValueOf(weekStartNewInDate).remove('-');
            
            mapStringToSchedule.put(strDateFormat,New Schedule__c());
            mapStringAndDate.put(strDateFormat,weekStartNew);
            mapStringAndEndDate.put(strDateFormat,weekStartNew.addDays(6));
        }
        if(String.isNotBlank(userDetail.EmployeeID__c)){
            
            List<Schedule__c> lstScheduleData = ScheduleDomain.queryScheduleData(
                              userDetail.EmployeeID__c,weekStart,endDateOfData);
           
            mapStringToSchedule = getMapOfStringAndSchedule(lstScheduleData,mapStringToSchedule);
            
            Integer count = 0;
            Integer countForTitle = 0;
            for(String scheduleDate : mapStringToSchedule.keySet()){
                DateTime dateValue = mapStringAndDate.get(scheduleDate);
                DateTime endDateValue = mapStringAndEndDate.get(scheduleDate);
                String strStart = dateValue.format('dd/MM');
                String strEnd = endDateValue.format('dd/MM');
                
                titleValue = getTitleValue(countForTitle,strStart,strEnd);
                
                Schedule__c objSchedule  = mapStringToSchedule.get(scheduleDate);
                                    
                If(count >= 0 && count <= 6){
                    if(count == 0){
                        objContainerClass = new ContainerWrapperClass();
                        objContainerClass.title = titleValue;
                    }
                    String scheduleDay = dateValue.format('EEE');
                    DateTime scheduleDate1 = mapStringAndDate.get(scheduleDate);
                    //Initialize ScheduleDataWrapper class
                    
                    objDataWrapper = new ScheduleDataWrapper();
                    //put the values of parameters in wrapper class
                    ParameterWrapperClass parameterWrapCls = new ParameterWrapperClass();
                    parameterWrapCls.objSchedule = objSchedule;
                    parameterWrapCls.scheduleDayValue = scheduleDay;
                    parameterWrapCls.scheduleDate = scheduleDate1;
                                        
                    objDataWrapper = getScheduleWrapperData(parameterWrapCls,objDataWrapper);
                   
                    lstDataWrapper.add(objDataWrapper);
                    if(count == 6){
                        objContainerClass.lstScheduleWrapper = lstDataWrapper; 
                        lstContainerClass.add(objContainerClass);
                        lstDataWrapper = new List<ScheduleDataWrapper>();
                        count = -1;
                    }
                } 
                count++;
                countForTitle ++;
            }
        }
        return lstContainerClass;
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return map of String and Schedule
    * @return : Map<String, Schedule__c>
    * @param  lstScheduleData - contains the list of Schedule object
    * @param  mapStringToSchedule - contains the map of string and schedule object
    */
    private static Map<String, Schedule__c> getMapOfStringAndSchedule(
                                             List<Schedule__c> lstScheduleData,
                                             Map<String, Schedule__c> mapStringToSchedule)
    {
        for(Schedule__c objSchedule : lstScheduleData)
        {
            String scheduleDateFormat = String.ValueOf(
                     Date.ValueOf(objSchedule.ScheduleDate__c)).remove('-');
            if(mapStringToSchedule.containsKey(scheduleDateFormat)){
                mapStringToSchedule.put(scheduleDateFormat,objSchedule);
            }
        }
        
        return mapStringToSchedule;
        
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return string title
    * @return : String title value
    * @param  countForTitle - This integer used for range
    * @param  strStart - this string is used to get the start value of the week
    * @param  strEnd - this string is used to get the end value of the week
    */
    
    private static String getTitleValue(Integer countForTitle,String strStart,String strEnd){
        String title;
        if(countForTitle >= 0 && countForTitle <= 6){
        
            title = 'This Week';
        }
        else{
            title = strStart + ' - ' + strEnd;
        }
        
        return title;
    }
        
    /**
    * @author : Amit Sharma
    * @description : This method is used to return ScheduleDataWrapper class data 
    * @return : ScheduleDataWrapper
    * @param  parameterWrapCls - this wrapper class contains Schedule object and variables
    * @param  objDataWrapper - this parameter contains the instace of ScheduleDataWrapper
    */
    
    private Static ScheduleDataWrapper getScheduleWrapperData(
                       ParameterWrapperClass parameterWrapCls,
                       ScheduleDataWrapper objDataWrapper )
    {
    
        objDataWrapper.scheduleDay = parameterWrapCls.scheduleDayValue;
        objDataWrapper.scheduleDate = parameterWrapCls.scheduleDate;
        if(parameterWrapCls.objSchedule.id != null){
            objDataWrapper.scheduleID = parameterWrapCls.objSchedule.id;
            
            objDataWrapper.storeName = setStoreValue(parameterWrapCls);
           
            objDataWrapper.managerName = setManagerName(parameterWrapCls);
        
            objDataWrapper.paycode = String.isNotEmpty(parameterWrapCls.objSchedule.PayCode__c)?
                                        parameterWrapCls.objSchedule.PayCode__c:'N/A';
            objDataWrapper.note = String.isNotEmpty(parameterWrapCls.objSchedule.Comments__c)?
                                   parameterWrapCls.objSchedule.Comments__c.left(50):'N/A';
            objDataWrapper.estWorkHour = 
                parameterWrapCls.objSchedule.EstimatedScheduleHours__c != null ? 
            String.ValueOf(parameterWrapCls.objSchedule.EstimatedScheduleHours__c)+' Hrs' : 'N/A';
        }
        else {
            objDataWrapper.displayNullValue = 'N/A';
        }
        return objDataWrapper;
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to return string value
    * @return : String
    * @param  parameterWrapCls - this wrapper class contains Schedule object and variables
    */
    public static String setStoreValue(ParameterWrapperClass parameterWrapCls){
        String storeValue = '';
        if(String.IsNotBlank(parameterWrapCls.objSchedule.Store__r.Store_Number__c) || 
            String.IsNotBlank(parameterWrapCls.objSchedule.Store__r.Store_Name__c) ||
            String.IsNotBlank(parameterWrapCls.objSchedule.Store__r.Store_Type__c)){
            storeValue = parameterWrapCls.objSchedule.Store__r.Store_Number__c 
                        + ' '+ parameterWrapCls.objSchedule.Store__r.Store_Name__c
                        + ' '+ parameterWrapCls.objSchedule.Store__r.Store_Type__c;
    }
        else {
            storeValue = 'N/A';
        }

        return storeValue;
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to return manager name
    * @return : String
    * @param  parameterWrapCls - this wrapper class contains Schedule object and variables
    */
    public static String setManagerName(ParameterWrapperClass parameterWrapCls){
        String managerName = '';
        if(String.IsNotBlank(parameterWrapCls.objSchedule.Manager__r.FirstName) || 
               String.IsNotBlank(parameterWrapCls.objSchedule.Manager__r.LastName)
        ){
            managerName = parameterWrapCls.objSchedule.Manager__r.FirstName 
                          +' '+ parameterWrapCls.objSchedule.Manager__r.LastName;
        }
        else {
            managerName = 'N/A';
        }

        return managerName;
    }
        
    /**
    * @author :Amit Sharma
    * @description : wrapper class for method parameter
    */
    public class ParameterWrapperClass{
        @AuraEnabled
        public Schedule__c objSchedule;
        @AuraEnabled
        public String scheduleDayValue;
        @AuraEnabled
        public DateTime scheduleDate;
    }
    /**
    * @author :Amit Sharma
    * @description : wrapper class for Week title and list of ScheduleDataWrapper
    */
    public class ContainerWrapperClass{
        @AuraEnabled
        public String title;
        @AuraEnabled
        public List<ScheduleDataWrapper> lstScheduleWrapper;
        @AuraEnabled
        public String homeurl;
    }
    
    /**
    * @author :Amit Sharma
    * @description : wrapper class for Schedule data
    */
    public class ScheduleDataWrapper {
        @AuraEnabled
        public ID scheduleID;
        @AuraEnabled
        public String storeName;
        @AuraEnabled
        public String managerName;
        @AuraEnabled
        public String paycode;
        @AuraEnabled
        public DateTime scheduleDate;
        @AuraEnabled
        public String scheduleDay;
        @AuraEnabled
        public String note;
        @AuraEnabled
        public String estWorkHour;
        @AuraEnabled
        public String displayNullValue;
    }
}