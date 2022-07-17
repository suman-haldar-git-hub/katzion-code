/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This domain class is used to return recordtype information.
*/
public inherited sharing class RecordTypeDomain {
    public static Map<String, Map<String, Id>> objectRecordTypeToId =
       new Map<String, Map<String, Id>>();
    /** 
    * @author : Sunil
    * @description : This method will return recordtype id.
    * @return : Id
    * @param  objectAPIName
    * @param  developerName
    */
    public static Id getRecordTypeId(String objectAPIName, String developerName) {

        if(!objectRecordTypeToId.containsKey(objectAPIName)) {
            objectRecordTypeToId.put(
                objectAPIName,
                queryRecordTypes(objectAPIName, developerName)
            );
        }
        return objectRecordTypeToId.get(objectAPIName).get(developerName);
    }
    /** 
    * @author : Sunil
    * @description : This method will return recordtype map with developer name and id.
    * @return : Map
    * @param  objectAPIName
    * @param  developerName
    */
    public static Map<String, Id> queryRecordTypes(String objectAPIName, String developerName){
        Map<String, Id> developerNameToId = new Map<String, Id>();
        for( RecordType rtObj : [
                SELECT Id, DeveloperName
                FROM RecordType
                WHERE SObjectType = :objectAPIName
            ]) {
                developerNameToId.put(rtObj.DeveloperName, rtObj.Id);
        }
        return developerNameToId;
    }
}