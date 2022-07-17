/**
* @author : Sunil
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to query all StateTimeZoneMapping__mdt.
*/
public inherited sharing class StateTimezoneMappingDomain {
/**
* @author : Sunil
* @description : This method is used to query StateTimeZoneMapping__mdt.
* @return : List<StateTimeZoneMapping__mdt>
*/
    public static List<StateTimeZoneMapping__mdt> queryData() {
        return [SELECT State__c,
                TimezoneCode__c,
                Timezone__c FROM StateTimeZoneMapping__mdt];
    }
}