/**
 * @description Test class for CaseHistoryDomain
 * @author      Abhishek Setia
 */
@isTest
private class CaseHistoryDomainTest {


    @TestSetup
    static void makeData(){      
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;
        ActionCentreTestData.setupSettings(
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId()
            );  
        ActionCentreTestData.myIncentiveCases(1,true);        
    }
    
    @isTest
    static void testMethods(){
        Test.startTest();
        List<Case> cases=[SELECT Id FROM Case];        
        CaseHistoryDomain domain=new CaseHistoryDomain();
        List<CaseHistory> casehistories;
        casehistories=domain.getOwnerChangeHistory(new Set<Id>{cases[0].Id});
        System.assert(casehistories.isEmpty());
        casehistories=domain.getCaseOwnerHistory(new Set<Id>{cases[0].Id});
        System.assert(casehistories.isEmpty());
        Test.stopTest();
    }
}