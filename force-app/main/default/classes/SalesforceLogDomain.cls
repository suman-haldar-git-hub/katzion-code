/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This Domain Class is used to insert data in salesforce log.
*/
public with sharing class SalesforceLogDomain {
    
    /**
    * @author : Sunil
    * @description : This method is used to insert salesforce log .
    * @param  salesforceLogs
    */
    public static void insertSalesforceLog(list<SalesforceLog__c> salesforceLogs) {
     
        if(!salesforceLogs.isEmpty()) {
            insert salesforceLogs;
        }
    }
}