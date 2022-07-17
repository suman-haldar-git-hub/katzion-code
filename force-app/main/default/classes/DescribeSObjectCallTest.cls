/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This test class will cover the CampaignDomain
*/
@isTest
public class DescribeSObjectCallTest{
    
    /**
    * @author : Sunil Kumar
    * @company : Cognizant
    * @description : This is test all methods of classes.
    */
    @isTest static void testAllCampaignDomainMethods() {
        Id devRecordTypeId = Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByName().get('Task').getRecordTypeId();
        system.assertEquals(devRecordTypeId!=null, true);
        DescribeSObjectCall.getDescribeSObjectResultInstance('Account');
        DescribeSObjectCall.getRecordTypeIdByDeveloperName('UniversalTaskList__c','Task');
        DescribeSObjectCall.getPicklistValues('Account','HasDOA__c');
        DescribeSObjectCall.getPicklistValues('Case', 'Status', new Set<String>{'Open'});
        DescribeSObjectCall.getRecordTypeDeveloperNameById('UniversalTaskList__c',devRecordTypeId);
         DescribeSObjectCall.getRecordTypeLabelNameById('UniversalTaskList__c',devRecordTypeId);
    }
}