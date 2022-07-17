/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
AutomaticDataCategoryAssignmentService class.
*/
@isTest(SeeAllData=false)
public class AutomaticDataCategoryAsgmtServiceTest{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : create set up data
*/
    @testSetUp
    static void setUpData() {
        DataCategoryPermissionSetMapping__mdt objPermissionMetadata = [select id,PermissionSetApiName__c,DataCategoryName__c,DataCategoryGroupName__c
                                                                        from DataCategoryPermissionSetMapping__mdt
                                                                        where PermissionSetApiName__c ='OpsSupportCEOSupport'];
         KnowledgeTestData knowledgeArticleObj = new KnowledgeTestData();
         List<knowledge__kav> knowledgeArticleList = knowledgeArticleObj.create(4, true);
    }
    /**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : Test AutomaticDataCategoryAssignmentService method
*/
    @isTest
    static void automaticDataCategoryAssignmentServiceMethod()
    {
        list<knowledge__kav> knowledgeArticleRecd = [
            Select Id From Knowledge__kav Where PublishStatus = 'Online'];
        DataCategoryPermissionSetMapping__mdt objPermissionMetadata = [select id,PermissionSetApiName__c,DataCategoryName__c,DataCategoryGroupName__c
                                                                    from DataCategoryPermissionSetMapping__mdt
                                                                    where PermissionSetApiName__c ='OpsSupportCEOSupport'];
        Set<String> permissionSetApiName = new set<string>{'OpsSupportCEOSupport','OpsSupportCorporateStrategy','OpsSupportFinance'};
        Map<String, DataCategoryPermissionSetMapping__mdt> permissionSetApiNameToDataCategoryName = new map<string,DataCategoryPermissionSetMapping__mdt>();
        permissionSetApiNameToDataCategoryName.put('OpsSupportCEOSupport',objPermissionMetadata);
        System.assert(!knowledgeArticleRecd.isEmpty());
        Test.startTest();
            AutomaticDataCategoryAssignmentService.assignDefaultDataCategoryToArticle(knowledgeArticleRecd);
            AutomaticDataCategoryAssignmentService.insertKnowledgeDataCategorySelection(permissionSetApiName,permissionSetApiNameToDataCategoryName,knowledgeArticleRecd);
        Test.stopTest();
    }
}