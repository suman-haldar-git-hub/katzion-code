/*
@Author : Monika
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               BookmarkComponentController class.
*/
@isTest(SeeAllData=false)
public class BookmarkComponentControllerTest {
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        testUser.UserPermissionsKnowledgeUser = true;
        insert testUser;
        System.runAs(testUser) {
            //Creating Knowledge articles
            KnowledgeTestData knowledgeTestDataInst = new KnowledgeTestData();
            List<Knowledge__kav> listKnowledgeArticles = knowledgeTestDataInst.create(2,True);
            //Creating Accounts
            List<Account> accList = AccountTestData.createAccountRecords(1, '');
            insert accList;
            //Creating Contacts
            List<Contact> conList = ContactTestData.createContactRecords(1, accList[0].Id);
            insert conList;
        }
    }
    static testMethod void validate(){
        User userRecord = [Select Id,EmployeeID__c
                           From User
                           Where EmployeeID__c ='Test007'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Knowledge__kav objKav = [
                select Id,Title,UrlName
                from Knowledge__kav
                where PublishStatus = 'Online' AND IsLatestVersion = true limit 1
            ];
            Favorite__b fav = new Favorite__b();
            Test.startTest();
            FavoriteDomain  mockDH = (FavoriteDomain)MockUtil.createMock(FavoriteDomain.class);
            Bookmarkcomponentcontroller objec = new Bookmarkcomponentcontroller();
            objec.getAllBookmarks();
            objec.getLatestPublishedArticles(mockDH);
            objec.createDeleteBookmarkHelper(mockDH, objKav.Id);
            BookmarkComponentController.createOrDeleteBookmark(objKav.Id);
            BookmarkComponentController.checkIfFavoriteExists(fav.Id);
            Test.stopTest();
            List<Favorite__b> favList = new List<Favorite__b>();
            favList = [Select Id from Favorite__b Where UserId__c =: UserInfo.getUserId()];
            System.assertEquals(0, favList.size());
        }
    }
}