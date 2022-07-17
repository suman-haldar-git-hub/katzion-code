/**
@author : Sunil Kumar
@company : Cognizant
@description : This is test data builder class for NSTRequest__c object.
*/
@isTest
public class NSTTestData {
/**
* @author : Praveen Tiwari
* @description : This will create the Campaign record.
* @return : List<NSTRequest__c>
* @param count
*/
    public static List<NSTRequest__c> create(Integer count) {
    
        // List Intilization
        List<NSTRequest__c > nstList = new List<NSTRequest__c >();
        for (Integer i = 0; i < count; i++) {
            NSTRequest__c obj = new NSTRequest__c();
            obj.EntryType__c = 'Coach';
            obj.Distance_Travelled__c = 10;
            obj.Time_Travel__c = 10;
            obj.VisitedDate_Start__c = System.now();
            nstList.add(obj);
        }
        return nstList;
    }
}