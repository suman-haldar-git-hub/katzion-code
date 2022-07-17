/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of LogWebCalloutEvent.
*/
public with sharing class LogWebCalloutEventTriggerHandler extends TriggerHandler {
    private List<LogWebCalloutEvent__e> triggerNew;
    /**
     * @author : Sunil
     * @description : constructor
    */
    public LogWebCalloutEventTriggerHandler() {
        this.triggerNew = (List<LogWebCalloutEvent__e>) Trigger.new;
    }
    /**
     * @author : Sunil
     * @description : This trigger handler is used to handle after Insert events of
                    LogWebCalloutEvent.
    */
    public override void afterInsert() {
        SalesforceLogService.logWebCallout(triggerNew);
    }

}