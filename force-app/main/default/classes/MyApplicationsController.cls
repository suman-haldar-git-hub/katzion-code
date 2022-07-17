/**
 * @author      Abhishek Setia
 * @description Handle functions related to lwc 'myApplications'
 */
public with sharing class MyApplicationsController {
           
    /**
     * author       Abhishek Setia
     * @description Get LightningResponse object which contains records to be shown in 'My Applications' tab.
     *              Handles sorting 
     * @param       requestParameters - Parameter from UI.
     * @return      LightningResponse wrapper object    
     */
    @AuraEnabled
    public static LightningResponse getResponse(String requestParameters){        
        return MyApplicationsService.getResponseService(requestParameters);
    }

    /**
     * @author      Abhishek Setia
     * @description Parameters from UI deserializes into this wrapper class
     *              appTypes - Subcategory in case object
     *              keyword - Input value from Filter by keywords in MyApplications Tab
     *              sortColumn - column name to sort
     *              sortDirection - 'asc' for ascending order/ 'desc' for descending order
     *              rowOffSet - Offset used in query
     *              rowLimit - Records limit
     *              calculateTotalRecords - If true, calculate total number of records for myApplications Tab
     */
    public class RequestWrapper{
        public String appTypes;
        public String keyword;
        public String sortColumn;
        public String sortDirection;
        public Integer rowOffSet;
        public Integer rowLimit;
        public Boolean calculateTotalRecords;
    }


    /**
     * @author      Abhishek Setia
     * @description Response Wrapper for MyApplications Tab
     */
    public class ResponseWrapper{
        @AuraEnabled
        public List<DataRecord> dataSet;
        @AuraEnabled
        public Integer dataSize;
        @AuraEnabled
        public Map<String, String> reservationIdMap;
        @AuraEnabled
        public List<DataRecord> reservationDataSet;
        @AuraEnabled
        public Integer reservationDataSize;

        /**     
         * @description Initialize wrapper variables
         */
        public ResponseWrapper(){
            this.dataSet=new List<DataRecord>();
            this.dataSize=0;
            this.reservationIdMap=new Map<String, String>();
            this.reservationDataSet=new List<DataRecord>();
            this.reservationDataSize=0;
        }
    }


    /**
     * @author      Abhishek Setia
     * @description Represents a record
     */
    public class DataRecord{
        @AuraEnabled
        public Case record;
        @AuraEnabled
        public String imagename;
        @AuraEnabled
        public String type;
    }
}