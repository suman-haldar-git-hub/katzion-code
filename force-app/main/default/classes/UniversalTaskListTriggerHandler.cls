/**
 * @author : Monika Bisht
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of UniversalTaskListTrigger.
 * @Modified: As part of TH-4637 On Feb-2022
*/
public with sharing class UniversalTaskListTriggerHandler extends TriggerHandler {
    /**
     * @author : Monika Bisht
     * @description : This trigger handler is used to handle after Insert events of UniversalTaskListTrigger.
     * @Modified: As part of TH-4637
    */
    public override void beforeInsert() {

        UniversalTaskListService.populateTaskApproval(
            (List<UniversalTaskList__c>) Trigger.new,
            (boolean) Trigger.isInsert,
            (map<id,UniversalTaskList__c>) Trigger.oldMap
        );
    }
    /**
     * @author : Monika Bisht
     * @description : This trigger handler is used to handle after Update events of UniversalTaskListTrigger.
     * @Modified: As part of TH-4637
    */
    public override void beforeupdate() {
        UniversalTaskListService.populateTaskApproval(
            (List<UniversalTaskList__c>) Trigger.new,
            (boolean) Trigger.isInsert,
            (map<id,UniversalTaskList__c>) Trigger.oldMap
        );
    }

    /**
    * @author : Ankit Singh
    * @description : This trigger handler is used to handle after Update events of
    * UniversalTaskListTrigger.
    * @Modified: As part of TH-4637
    */
    public override void afterInsert() {
        UniversalTaskListService.fireUniversalTaskListPlatformEvent(
            (List<UniversalTaskList__c>) Trigger.new,
            (Map<id,UniversalTaskList__c>) Trigger.oldMap,
            (Boolean) Trigger.isInsert
        );
    }

    /**
    * @author : Ankit Singh
    * @description : This trigger handler is used to handle after Update events of
    * UniversalTaskListTrigger.
    * @Modified: As part of TH-4637
    */
    public override void afterUpdate() {
        UniversalTaskListService.fireUniversalTaskListPlatformEvent(
            (List<UniversalTaskList__c>) Trigger.new,
            (Map<id,UniversalTaskList__c>) Trigger.oldMap,
            (Boolean) Trigger.isInsert
        );
    }
}