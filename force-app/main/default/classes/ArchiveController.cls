/**
 * @author      Abhishek Setia
 * @description Handle functions related to lwc 'Archive Tab'
 */
public with sharing class ArchiveController {

    
    /**
     * author       Abhishek Setia
     * @description Get LightningResponse object which contains records to be shown in 'Archive' tab.
     *              Handles sorting 
     * @param       requestParameters - Value from JScript. Records with criteria to pick from database.
     * @return      LightningResponse wrapper object    
     */
    @AuraEnabled
    public static LightningResponse getArchiveRecords(String requestParameters){
        return ArchiveService.getArchiveRecordsService(requestParameters);
    }


    /**
     * @author      Abhishek Setia
     * @description Wrapper used for columns mapping in lwc 'Archive Tab'.
     *              
     */
    public class ArchiveWrapper{
        @AuraEnabled
        public String key;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Datetime completionDate;
        @AuraEnabled
        public String originSystem;
        @AuraEnabled
        public String requestor;
        @AuraEnabled
        public String recordTypeName;
        @AuraEnabled
        public String typeOfDevice;
        @AuraEnabled
        public String imagename;
        @AuraEnabled
        public String actionUrl;
    }


    /**
     * @author      Abhishek Setia
     * @description Response Wrapper for Archive Tab
     */
    public class ResponseWrapper{
        @AuraEnabled
        public List<ArchiveWrapper> dataSet;
        @AuraEnabled
        public Integer utlDataSize;
        @AuraEnabled
        public Integer caseDataSize;
        @AuraEnabled
        public Integer reservationDataSize;
        @AuraEnabled
        public Integer dataSize;
        @AuraEnabled
        public Map<String, String> reservationIdMap;

        /**     
         * @description Initialize wrapper variables
         */
        public ResponseWrapper(){
            this.dataSet=new List<ArchiveWrapper>();
            this.utlDataSize=0;
            this.caseDataSize=0;
            this.reservationDataSize=0;
            this.dataSize=0;
            this.reservationIdMap = new Map<String, String>();
        }
    }


    /**
     * @author      Abhishek Setia
     * @description Parameters from UI deserializes into this wrapper class
     *              types - Subcategory in case object
     *              keyword - Input value from Filter by keywords in MyApplications Tab
     *              sortColumn - column name to sort
     *              sortDirection - 'asc' for ascending order/ 'desc' for descending order
     *              utlRowOffSet,caseRowOffSet - Offset used in query
     *              rowLimit - Records limit
     *              calculateTotalRecords - If true, calculate total number of records for myApplications Tab
     */
    public class RequestWrapper{
        public String types;
        public String keyword;
        public String sortColumn;
        public String sortDirection;
        public Integer utlRowOffSet;
        public Integer caseRowOffSet;
        public Integer reservationRowOffSet;
        public Integer rowLimit;
        public Boolean calculateTotalRecords;
    }
}