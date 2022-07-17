/**
* @author : Sumit Banarji
* @company : Cognizant
* @description : This class is utility class for all SOQL for for Org Wide Email Address object
*/
public with sharing class OrgWideEmailAddressDomain {
    
    /**
     * @author : Sumit Banarji
     * @param emails
     * @return List
     * @description : This method is to query on OrgWideEmailAddress matching with Email
    */
    public static list<OrgWideEmailAddress> getOrgWideAddress(Set<String> emails) {
        return [SELECT Id, Address 
                FROM OrgWideEmailAddress 
                WHERE Address IN :emails];
    }
}
