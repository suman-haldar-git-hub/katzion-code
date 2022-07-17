/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is responsible for interacting with Lightning component.
 */
public with sharing class GenericSingleRelatedListController {
    
    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param requestParam
     * @return lightningResponse
    */
    @AuraEnabled
    public static lightningResponse getDataList(param requestParam){
        return GenericSingleRelatedListAdapter.getDataList(requestParam);
    }

    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This class is a wrapper class accept parameters from LWC.
     */
    public class Param {
        /**
         * @description : Record Id of record.
        */
        @AuraEnabled
        public string recordId {get;set;}
        /**
         * @description : Name of the Object.
        */
        @AuraEnabled
        public string sObjectName {get;set;}
        /**
         * @description : Comma saperated list of field api.
        */
        @AuraEnabled
        public string columns {get;set;}
        /**
         * @description : Field api name of realetd field.
        */
        @AuraEnabled
        public string relatedFieldAPI {get;set;}
        /**
         * @description : Limit the number of records to be fetched.
        */
        @AuraEnabled
        public string recordLimit {get;set;}
    }
}