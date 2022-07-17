/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This domain class is used to query on custom metadata.
*/
public inherited sharing class TriggerSwitchDomain {
    /** 
    * @author : Sunil
    * @description : This method is used to return trigger switch record as per developer Name.
    * @return : Map
    */
    public static Map<String, FeatureControl__mdt> getTriggerSwitch() {
        Map<String, FeatureControl__mdt> triggerSwitchData = new Map<String, FeatureControl__mdt>();
         //Pratheep: Added Limits as per Ticket CRM-16314.
        List<FeatureControl__mdt> triggerSwitch = [
            SELECT DeveloperName,Active__c
            FROM FeatureControl__mdt Limit 49999
        ];
        if(!triggerSwitch.isEmpty()) {
            for(FeatureControl__mdt t : triggerSwitch) {
                if(triggerSwitchData.get(t.DeveloperName) == null) {
                    triggerSwitchData.put(t.DeveloperName, t);
                }
            }
        }
        return triggerSwitchData;
    }
}