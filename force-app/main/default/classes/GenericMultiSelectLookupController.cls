/**
* @Author : Daksh Madan
* @Company : Cognizant
* @description : This controller class contains and manage all server-side methods.
*/
public with sharing class GenericMultiSelectLookupController {
    public static Map<Id,String> mapOfRecdTypeIdVsDevName;
    /**
* @Author : Daksh Madan
* @description : This method is used to fetch all the lookup records on load.
* @return : LightningResponse
*/
    public static LightningResponse fetchKnowledgeRecdTypes(){
        mapOfRecdTypeIdVsDevName = new Map<Id,String>();
        LightningResponse response = new LightningResponse();
        try{
            for(RecordType singleRecdType : [select Id,DeveloperName 
                                             from RecordType 
                                             where sObjectType='Knowledge__kav'])
            {
                mapOfRecdTypeIdVsDevName.put(singleRecdType.Id,
                                             singleRecdType.DeveloperName);
            }
            GenericMultiSelectLookupController.InitDataWrapper initDataWrap = 
                new GenericMultiSelectLookupController.InitDataWrapper();
            initDataWrap.mapOfRecdTypeIdVsDevName = mapOfRecdTypeIdVsDevName;
            response.payLoad = JSON.serialize(initDataWrap);
        }
        catch (Exception ex) {
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'GenericMultiSelectLookupController.cls on fetchKnowledgeRecdTypes',
                ex
            );
        }
        return response;
    }
    /**
* @Author : Daksh Madan
* @description : This method is used to fetch all the lookup records on load.
* @return : List<sObject>
* @param jsonString
*/
    public static List <sObject> fetchLookUpValues(String jsonString) {
        List <sObject> returnList = new List <sObject> ();
        try{
            Id eventRecdTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Event').getRecordTypeId();
            Id articleRecdTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Article').getRecordTypeId();
            //deserialize jsonString
            GenericMultiSelectLookupController.DataWrapper dataWrapObj = 
                (GenericMultiSelectLookupController.DataWrapper)
                System.JSON.deserialize(jsonString, GenericMultiSelectLookupController.DataWrapper.class);
            String searchKeyWord = dataWrapObj.searchKeyWord;
            String objectName = dataWrapObj.objectName;
            List<Id> excludeItemsList = dataWrapObj.excludeItemsIds;
            String fieldsString = dataWrapObj.fieldsString;
            String filter = dataWrapObj.filter;
            Boolean isArticle = dataWrapObj.isArticle;
            
            String searchKey = '%' + searchKeyWord + '%';
            String sQuery = '';
            List<Id> lstExcludeitems = new List<Id>();
            
            if(excludeItemsList != null){
                for(Id item : excludeItemsList ){
                    lstExcludeitems.add(item);
                }
            }
            if(isArticle){
                DateTime dateTimeFilterForArticle = dataWrapObj.dateTimeFilterForArticle;
                if(dateTimeFilterForArticle != null){
                    Date dateFilter = date.newinstance(dateTimeFilterForArticle.year(),
                                                       dateTimeFilterForArticle.month(),
                                                       dateTimeFilterForArticle.day()
                                                      );
                    // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records
                    sQuery =  'select id ' +fieldsString+ ' from ' + objectName + ' where '+ filter + ' LIKE: searchKey AND PublishStatus = \'Online\' AND(((DateOfExpiry__c >=: dateFilter OR DateOfExpiry__c = null) AND RecordTypeId =:articleRecdTypeId) OR (StartDate__c >=: dateTimeFilterForArticle AND RecordTypeId =:eventRecdTypeId)) AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
                }
                else{
                    // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
                    sQuery =  'select id ' +fieldsString+ ' from ' + objectName + ' where '+ filter + ' LIKE: searchKey AND PublishStatus = \'Online\' AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
                }
            }
            else{
                sQuery = 'select Id ' +fieldsString+ ' from ' +objectName + ' where '+ filter + ' LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
            }
            String sQueryUpdated = sQuery;
            List <sObject> lstOfRecords = Database.query(sQueryUpdated);
            if(lstOfRecords != null){
                for (sObject obj: lstOfRecords) {
                    returnList.add(obj);
                }
                return returnList;
            }
            else{
                return returnList;
            }
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'GenericMultiSelectLookupController.cls on fetchLookUpValues',
                ex
            );
            return returnList;
        }//return returnList;
    }
    /**
* @author : Daksh Madan
* @description : This class will act as wrapper for jsonString.
*/
    public class DataWrapper{
        //wrapper variables
        public String searchKeyWord;
        public String objectName;
        public List<Id> excludeItemsIds;
        public String fieldsString;
        public String filter;
        public DateTime dateTimeFilterForArticle;
        public Boolean isArticle;
    }
    /**
* @author : Daksh Madan
* @description : This class will act as wrapper to fetch data on load.
*/
    public class InitDataWrapper{
        //wrapper variables
        @auraEnabled
        public Map<Id,String> mapOfRecdTypeIdVsDevName;
    }
}