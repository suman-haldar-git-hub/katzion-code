/*
 * @Author : Sunil
 * @Company : SaaSFocus
 * @Description : This trigger is used to handle all events of LogWebCalloutEvent platform Event.
*/
trigger LogWebCalloutEventTrigger on LogWebCalloutEvent__e (after insert) {
    new LogWebCalloutEventTriggerHandler().run('WebCalloutEventTrigger');
}