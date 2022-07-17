/**
@author : Praveen Tiwari
@company : Cognizant
@description : This is test data builder class for Communication__c object.
*/
@isTest
public class CommunicationTestData{
/**
* @author : Praveen Tiwari
* @description : This will create the Communication__c record.
* @return : List<Communication__c>
* @param count
* @param campaignId
*/
    public static List<Communication__c> create(Integer count, String campaignId) {
    
        // List Intilization
        List<Communication__c> communicationList = new List<Communication__c>();
        for (Integer i = 0; i < count; i++) {
            Communication__c comm = new Communication__c();
            comm.Campaign__c = campaignId;
            comm.Active__c = true;
            comm.ScheduledDate__c = System.now()+5;
            communicationList.add(comm);
        }
        return communicationList;
    }
}