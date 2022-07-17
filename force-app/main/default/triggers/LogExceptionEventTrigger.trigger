/*
 * @Author : Sunil
 * @Company : SaaSFocus
 * @Description : This trigger is used to handle all events of Log Exception Event platform Event.
*/
trigger LogExceptionEventTrigger on LogExceptionEvent__e (after insert) {
    new LogExceptionEventTriggerHandler().run('ExceptionEventTrigger');
}