/**
 * @author : Ankit Singh
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of AccountTriggerHandler.
*/
public with sharing class AccountTriggerHandler extends TriggerHandler{
    /**
    * @author : Ankit Singh
    * @description : This trigger handler is used to handle after 
    * Insert events of AccountTriggerHandler.
    */
    public override void beforeInsert() {
        AccountService.populateAribaExternalId((List<Account>) Trigger.new);
    }
    /**
    * @author : Sunil Kumar
    * @description : This trigger handler is used to handle after 
    * Update events of AccountTriggerHandler.
    */
    public override void beforeUpdate() {
        AccountService.populateAribaExternalId((List<Account>) Trigger.new);
        AccountService.populateLeaveBalLastUpdated(
            (List<Account>) Trigger.new, (Map<Id,Account>) Trigger.oldMap
        );
    }
    
    /**
    * @author : Amit Sharma
    * @description : This trigger handler is used to handle after 
    * Update events of AccountService.
    */
    public override void afterUpdate() {
        //Cats functionlaity controlled by feature control
        if(FeatureControlDomain.getFeatureControlRecord('CATS').Active__c){
            AccountService.createCatsTask((List<Account>) Trigger.new,
                                                (Map<Id,Account>) Trigger.oldMap);
        }
        
    }
}