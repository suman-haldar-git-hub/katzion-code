/*
@Author : Dudi Manohara
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@              DistributionListPreviewService
*/
@isTest(SeeAllData=false)
public class DistributionListPreviewServiceTest {
    static Map<String, String> mapPicklist = 
    CreateCommunicationAudienceService.createPicklistMap();
    static testMethod void validate()
    {
        List<DistributionList__c> listDL = DistributionListTestData.createDistributionListRecords(1);
        insert listDL;
        System.assert(listDL.size() > 0);
        Test.startTest();
        DistributionListPreviewController.getReportData(listDL[0].Id);
        DistributionListPreviewService.Wrapper objClass = new DistributionListPreviewService.Wrapper('test','equals','test1');
        Test.stopTest();
    }
}