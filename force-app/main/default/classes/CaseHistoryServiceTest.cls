/**
 * @description Test class for CaseHistoryService.cls
 * @author      Abhishek Setia
 */
@isTest
public class CaseHistoryServiceTest {

    public static List<Group> groups;
    
    @TestSetup
    static void makeData(){      
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;

        User usr=UserTestData.createUser('System Administrator');        

        ActionCentreTestData.setupSettings(
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId()
            );  
        ActionCentreTestData.myIncentiveCases(1,true);                 
    }

    @isTest
    static void testFillCaseDetailWrapper(){
        Test.startTest();
        Case caserec=[SELECT Id,OwnerId,Owner.Name FROM Case LIMIT 1]; 
        groups = [SELECT Id,DeveloperName,Name FROM Group
                                    WHERE Type='Queue' LIMIT 2];
        CaseHistoryDomain domain=(CaseHistoryDomain)MockRequestFactory.createMock(
            CaseHistoryDomain.class,
            MockRequestFactory.MockConstants.CASEHISTORYOBJECT
        );
        List<CaseHistory> listCH=domain.getOwnerChangeHistory(new Set<Id>{caserec.Id});
        List<PeoplePortalFlowController.CaseDetailWrapper> lst = 
            CaseHistoryService.historySetupPeoplePortal(caserec.Id,listCH);
        System.assert(!lst.isEmpty());

        List<PeoplePortalFlowController.CaseDetailWrapper> lst2 = 
            CaseHistoryService.historySetupPeoplePortal(caserec.Id);
        System.assert(lst2.isEmpty());

        CaseHistoryService.getCurrentTeamName(caserec); 
        Test.stopTest();
    }
}