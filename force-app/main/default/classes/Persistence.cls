/**
* @author : Sunil
* @company : Cognizant
* @description : .
*/
public with sharing class Persistence {
     /**
    * @author : Sunil
    * @description : This method will be used to insert sharing records
    * @param shareString
    */
    @future
    public static void persistSharing(String shareString) {
        CaseShare[] reasons = (CaseShare[])JSON.deserialize(shareString, CaseShare[].class);
        for(CaseShare reason: reasons){
            reason.Id = null;
            }
        Database.insert(reasons, false);
    }
}