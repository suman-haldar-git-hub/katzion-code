/**
*@author : Sunil Kumar
*@company : Cognizant
*@description : This is test data builder class for Audience__c object.
*/
@isTest
public class AudienceTestData {
    /** 
    *@author : Sunil Kumar
    *@company : Cognizant
    *@description : This will create the Audience__c record.
    *@return :List<Audience__c>
    *@param count
    *@param conId
    *@param comId
    */
    public static List<Audience__c> create(Integer count,String conId,String comId) {
    
        // List Intilization
        List<Audience__c> audienceList = new List<Audience__c>();
        for (Integer i = 0; i < count; i++) {
            Audience__c obj = new Audience__c(
            //Name = 'testAudience'+i,                             // Audience Name
            Communication__c = comId,     // Communication
            Contact__c = conId,           // Contact
            DistributionList__c = null  // Distribution List
            );
            audienceList.add(obj);
        }
        return audienceList;
    }
}