/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of LogExceptionEvent.
*/
public with sharing class LogExceptionEventTriggerHandler extends TriggerHandler {
    private List<LogExceptionEvent__e> triggerNew;
    /**
     * @author : Sunil
     * @description : Constructor.
    */
    public LogExceptionEventTriggerHandler() {
        this.triggerNew = (List<LogExceptionEvent__e>) Trigger.new;
    }
    /**
     * @author : Sunil
     * @description : This trigger handler is used to handle after Insert events of LogExceptionEvent.
    */
    public override void afterInsert() {
        SalesforceLogService.logException(triggerNew);
    }
}