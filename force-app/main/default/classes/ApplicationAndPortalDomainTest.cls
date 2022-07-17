/**
 * @description Test class for ApplicationAndPortalDomain.cls
 * @author      Abhishek Setia
 */
@isTest
private class ApplicationAndPortalDomainTest {
    
    @TestSetup
    static void makeData(){        
        AppLauncherTestData.createApplicationsForAppLauncher(5,true);
    }

    @isTest
    static void testMethods(){
        Test.startTest();
        Profile pr = ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
        List<ApplicationAndPortal__c> lst =ApplicationAndPortalDomain.dataCriteriaAvailableInLauncher(true,'Application',pr.Name);
        System.assertEquals(false,lst.isEmpty());
        List<ApplicationAndPortal__c> lst2 = ApplicationAndPortalDomain.criteriaAvailableInLauncherRecIdKeyword(
            true,
            new Set<Id>{lst[0].Id},
            'Application', pr.Name);
        System.assertEquals(false,lst2.isEmpty());
        Test.stopTest();
    }
}