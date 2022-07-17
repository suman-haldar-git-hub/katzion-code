/**
* @Author		:		Suman Nandy
* @Date		:		03-Sep-2020
* @Desc		:		This class will be used by national stockakeform
* */

/**
* @description StoreController
*/

public with sharing class NSTController {
    
    /**
* @description searchStore
* @return Store
*/
    @AuraEnabled(cacheable=true)
    public static List<Object> LookUpSearch(String object_api_name, String searchStr, String search_field_api_Names, String return_fields_api_Names, String staticFilters, String recordid, String specialcaseName)
    {
        List<String> search_field_api_Names_lst = search_field_api_Names.split(',');
        List<String> return_fields_api_Names_lst = return_fields_api_Names.split(',');
        try{
            searchStr = '%'+  searchStr + '%'; 
            //****************Prepare Query :SELECT Field Names **************************/ 
            String query='SELECT Id,';
            Integer i=0;
            for(String fieldname : return_fields_api_Names_lst){
                query= query + fieldname;
                i=i+1;
                if(i<return_fields_api_Names_lst.size())
                {
                    query= query + ',';
                }
            }  
            System.debug('query after SELECT'+query);
            //****************Prepare Query :From Object Name **************************/ 
            query= query + ' FROM ' + object_api_name + ' WHERE ';
            
            //****************Prepare Query :Add Static Filter **************************/
            
            System.debug('query after Static Clause'+query);
            
            if(recordid!='')
            {
                query= query + 'Id =' + '\'' + recordid + '\'';
            }
            else 
            {
                if(searchStr == '' && staticFilters != '')
                {
                    query= query + staticFilters;
                }
                else 
                {
                    if(staticFilters != '')
                    {
                        query= query + staticFilters + ' AND (';
                    }
                    
                    //****************Prepare Query :Filter Clause **************************/ 
                    Integer j=0;
                    for(String fieldname : search_field_api_Names_lst){
                        j=j+1;
                        query= query + fieldname;
                        query= query + ' LIKE \'' + searchStr + '\'';
                        if(j<search_field_api_Names_lst.size())
                        {
                            query= query + ' OR ';
                        }
                    } 
                    
                    //**Prepare Query :If Static Filter is present then Bracket need to be closed **************************/
                    if(staticFilters != '')
                    {
                        query= query + ')';
                    }
                }
            }
            
            System.debug('query after Filter'+query);
            //*********************** Execute Query ******************************
            List<Object> searchResult=Database.query(query);

            //*********************** SPECIAL Case FOR STORE  ********************/
            if(specialcaseName == 'NODATAFOUND')
            {
            	if(searchResult==null || searchResult.size()==0 && object_api_name == 'Store__C')
            	{
                	//List<Object> storeResult=[SELECT Store_Name__c,State__c,Postal_Code__c FROM Store__C WHERE Store_Name__c LIKE '%No Store found%']; 
                	List<Object> storeResult=[SELECT Store_Name__c,State__c FROM Store__C WHERE Store_Name__c LIKE '%No Store found%']; 
                	return storeResult;
            	}
            }

            System.debug('Final Data'+searchResult);
            return searchResult ;
        }
        catch(Exception ex)
        {
            throw createAuraHandledException.createException('Unhandled Exception at NSTController --> searchStore'); 
        }
    }
    
    /**
* @description searchEmployee
* @return Employee
*/
    @AuraEnabled
    public static Account searchEmployee(String payrollId,String birthDay)
    {	
        try{
            System.debug('payrollId'+payrollId+'birthDay'+birthDay);
            //empType = empType + '%';      
            //List<Account> listAccount= [SELECT FIRSTName,LastName,PersonEmail,Employee_ID__c From Account WHERE Area_Dept_Name__c like :empType and Employee_ID__c = :payrollId and Birthdate_text__c=:birthDay];
            //return JSON.serialize(listAccount) ;
            
            List<Account> listAccount= [SELECT Id,FIRSTName,LastName,PersonEmail,Employee_ID__c,Area_Dept_Name__c From Account WHERE  Employee_ID__c = :payrollId and Birthdate_text__c=:birthDay];
            //return JSON.serialize(listAccount) ;
            return listAccount[0];
            
        }
        catch(Exception ex)
        {
            throw createAuraHandledException.createException('Unhandled Exception at StoreController --> searchEmployee'); 
        }
    }
    /**
* @description saveCheckinDetail
*/
    @AuraEnabled
    public static void saveCheckinDetail(String payrollId,String storeId, String managerId,Integer traveltime, Integer distance, String timezone, String token)
    {
        //system.debug('token'+token);
        Boolean captchaValidationResult = GoogleRecaptchaAPI.captchaValidationResult(token);
        if(!captchaValidationResult){
            throw createAuraHandledException.createException('reCaptcha verification failed. Please contact to your System Administrator.');
        }
        try{
            NSTRequest__c ntReq =new NSTRequest__c();
            ntReq.PayrollID__c=payrollId;
            ntReq.Store__c=storeId;
            ntReq.ManagerUser__c=managerId;
            ntReq.Time_Travel__c=traveltime;
            ntReq.Distance_Travelled__c=distance;
            ntReq.VisitedDate_Start__c=System.Now();
            ntReq.Timezone__c=timezone;
            insert ntReq;
        }          
        catch(Exception ex)
        {
            throw createAuraHandledException.createException('Unhandled Exception at NSTController --> saveCheckinDetail'+ex); 
        }
    }
    
    
    
  /*@description getPickListValue
* @return Picklist values
*/
    @AuraEnabled(cacheable=true)
    public static List<AllPicklistValue>  getAllPicklIstValue()
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
        
        
        List<StateTimeZoneMapping__mdt> mapping=[SELECT State__c,TimezoneCode__c,Timezone__c FROM StateTimeZoneMapping__mdt];
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
    
    public class PicklistValue{
        @AuraEnabled
        public string label{get;set;}
        @AuraEnabled
        public string value{get;set;}
    }
    
    
    public class AllPicklistValue{
        @AuraEnabled
        public string picklistName{get;set;}
        @AuraEnabled
        public List<PicklistValue> picklistvalue{get;set;}
    }
    
    
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
        System.debug('Values are: '+pickListValuesList);
        return pickListValuesList;
        
    }
    
    
}