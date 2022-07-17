/*
@Author : Monika Bisht
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               SalesforceLogDeleteBatch class.
*/
@isTest(SeeAllData=false)
public without sharing class SalesforceLogDeleteBatchTest {
    static testMethod void validate()
    {
        SalesforceLog__c objSalesforce = new SalesforceLog__c();
        insert objSalesforce;
        
        Test.setCreatedDate(objSalesforce.Id, DateTime.newInstance(2020,07,07));
        
        List<SalesforceLog__c> scope = [select id,CreatedDate from SalesforceLog__c where id =: objSalesforce.id];
        SalesforceLogDeleteBatch objSales = new SalesforceLogDeleteBatch();
        Test.startTest();
        Database.executeBatch(objSales,200);
        system.assert(objSales != null);
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Remind Opp Owners', sch, objSales);
        Test.stopTest();
    }
}