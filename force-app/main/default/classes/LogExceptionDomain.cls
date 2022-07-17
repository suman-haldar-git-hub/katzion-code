/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This Domain Class is used to publish the LogEventService.
*/
public with sharing class LogExceptionDomain {
    /**
     * @author : Sunil
     * @param  objectLogExceptionEvent
     * @description : This method is used to publish the Log Exception Event .
    */
    public static void publishLogExceptionEvent(LogExceptionEvent__e objectLogExceptionEvent) {
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(objectLogExceptionEvent);
    }
    /**
     * @author : Sunil
     * @param  logExceptionEventData
     * @description : This method is used to publish the Log Exception Event list .
    */
    public static void publishLogExceptionEvent(List<LogExceptionEvent__e> logExceptionEventData) {
        // Call method to publish events
        Database.SaveResult [] sr = EventBus.publish(logExceptionEventData);
    }
}