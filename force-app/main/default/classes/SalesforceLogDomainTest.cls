/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
 * SalesforceLogDomain class.
*/
@isTest(SeeAllData=false)
private class SalesforceLogDomainTest {
    /**
 * @author : Sunil
 * @description : This test method is used to cover positive and negative scenarios of
 * SalesforceLogDomain class.
*/
    @isTest
    static void setupSalesforceLogData() {
        list<SalesforceLog__c> objectsalesforce = SalesforceLogTestData.getExceptionSalesforceLog(
            RecordTypeDomain.getRecordTypeId(
                'SalesforceLog__c','Exception'
            )
        );
        Test.startTest();
        SalesforceLogDomain.insertSalesforceLog(objectsalesforce);
        Test.stopTest();
        System.assertEquals(objectsalesforce[0].ExceptionLineNumber__c, 32);
        System.assertEquals(objectsalesforce[0].ExceptionLineNumber__c, 32);
    }
    
}