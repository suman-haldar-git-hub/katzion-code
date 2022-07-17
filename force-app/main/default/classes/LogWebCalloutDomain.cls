/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This Class is used for publish the LogWebCalloutEvents.
*/
public with sharing class LogWebCalloutDomain {

     /**
     * @author : Sunil
     * @param  objectLogWebCalloutEvent
     * @description : This method is used to publish the Log WebCallout Event .
    */
    public static void publishLogWebCalloutEventEvent(
        LogWebCalloutEvent__e objectLogWebCalloutEvent
    ) {
        // Call method to publish events
        Database.SaveResult sr = EventBus.publish(objectLogWebCalloutEvent);
    }
}