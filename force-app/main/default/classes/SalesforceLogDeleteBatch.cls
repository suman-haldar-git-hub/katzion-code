/**
 * @Author:Sunil
 * @Company:Cognizant
 * @description :This is the batch class to auto delete the SalesforceLog__c records before a specified date.
*/
global class SalesforceLogDeleteBatch implements Database.Batchable<sObject>,Schedulable{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Sunil
    * @description : This method will query SalesforceLog__c object.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc){  
        Date logDate = Date.today().addDays(Integer.valueOf(labelToContentMap.get('SALESFORCELOGDAYS'))) ;
        String query = 'Select id, CreatedDate from SalesforceLog__c WHERE';
        query += ' CreatedDate <:logDate';
        return Database.getQueryLocator(query);
    }
    /**
    * @Author : Sunil
    * @description : This method will delete the SalesforceLog__c data.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<SalesforceLog__c> scope){  
        try{
            Database.delete(scope,false);
            
        }
        catch(Exception ex) 
        {
            System.debug('ex.getMessage()'+ex.getMessage());
        }     
    }
    /**
    * @Author : Sunil
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('finish block');
    }
    /**
    * @Author : Sunil
    * @description : This method will Schedule the batch.
    * @param sc
    */
    global void execute(SchedulableContext sc){
        SalesforceLogDeleteBatch obj = new SalesforceLogDeleteBatch();
        Database.executeBatch(obj ,200); 
    }        
}