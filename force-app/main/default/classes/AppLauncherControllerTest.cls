/**
 * @description Test class for AppLauncherController.cls, AppLauncherService.cls
 * @author      Abhishek Setia
 */
@isTest
private class AppLauncherControllerTest {
    
    @TestSetup
    static void makeData(){
        List<ApplicationAndPortal__c> lst=new List<ApplicationAndPortal__c>();
        lst.addAll(AppLauncherTestData.createApplicationsForAppLauncher(5,false));
        lst.addAll(AppLauncherTestData.createPortalsForAppLauncher(5,false));
        if(!lst.isEmpty()){
            INSERT lst;
        }        
    }


    @isTest
    private static void testGetResponse(){
        Test.startTest();
        LightningResponse resp = AppLauncherController.getResponse('test record');
        System.assertEquals(false, resp.isError);
        System.assert(resp.payLoad!=null);        
        Test.stopTest();
    }

    @isTest
    private static void testFavoritesResponse(){
        Test.startTest();
        FavoriteDomain fd=(FavoriteDomain)FavoriteMockUtil.createMock(FavoriteDomain.class);
        List<LightningDataWrapper.LightningDataRow> listLDW = AppLauncherService.getSortedFavorites(fd);
        Boolean isEmpty = listLDW.isEmpty();
        Profile pr = ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
        List<ApplicationAndPortal__c> favs = AppLauncherService.getFavorites('Application',listLDW, pr.Name);
        System.assert(isEmpty==false);
        System.assertEquals(false, favs.isEmpty());
        Test.stopTest();
    }

    @isTest
    private static void testBookmarkUnbookmarkRecord(){
        Test.startTest();        
        ApplicationAndPortal__c ap=[SELECT Id, Name, Category__c, SubCategory__c, Description__c, ImageName__c, LogoName__c,
                                        LaunchURL__c, HelpArticleLink__c FROM ApplicationAndPortal__c WHERE Name = 'Application 1'];
        LightningResponse resp = AppLauncherController.bookmarkRecord(ap.Id);
        System.assertEquals(false, resp.isError);        
        LightningResponse resp2 = AppLauncherController.unbookmarkRecord(ap.Id);
        System.assertEquals(false, resp2.isError);
        Test.stopTest();
    }
    
}