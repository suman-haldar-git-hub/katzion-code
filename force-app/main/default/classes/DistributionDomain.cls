/**
* @author : Monika Bisht
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLs for Distribution object
*/
public with sharing class DistributionDomain {
    /**
* @author : Monika Bisht
* @description : This method is used to query Distribution object based on passed record id.
* @return : DistributionList__c
* @param recordId
*/
    public static DistributionList__c getDistributionByRecordId(Id recordId) {
        return [select id,ownerId,createdbyid,
                (select id,Communication__c,Communication__r.ScheduledDate__c from Audiences__r)
                from DistributionList__c 
                where id =: recordId];
    }
    /**
* @author : Monika Bisht
* @description : This method is used to query Distribution object based on passed record id.
* @return : DistributionList__c
* @param distributionId
*/
    public static DistributionList__c getDistributionById(Id distributionId) {
        return [select id,ownerId,createdbyid,owner.name
                from DistributionList__c 
                where id =: distributionId];
    }
    
    /**
    * @author : Monika Bisht
    * @description : This method is used to query Distribution object based on passed record id.
    * @return : DistributionList__c
    * @param query
    */
    public static DistributionList__c getDistributionRecordById(String query) {
        return Database.query(query);
    }
}