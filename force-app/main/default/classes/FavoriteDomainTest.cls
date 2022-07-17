/**
 * @description Test class for FavoriteDomain.cls
 * @author      Abhishek Setia
 */

@isTest
private class FavoriteDomainTest {
    
    static Favorite__b getFavorite(){
        return new Favorite__b(Title__c='Test Title',
                        Description__c='Test Description',
                        FavoriteRecordId__c='aabbccddeeffgghhii',
                        FavoriteType__c='Test Type',
                        UserId__c=UserInfo.getUserId());                        
    }
    
    @isTest
    static void testMethods(){
        Test.startTest();
        FavoriteDomain fd=new FavoriteDomain();
        List<Favorite__b> favs = fd.queryFavBasedOnLoggedInUser(UserInfo.getUserId());
        System.assertEquals(true, favs.isEmpty());
        favs = fd.queryFavoriteRecord(UserInfo.getUserId(),new Set<String>());
        System.assertEquals(true, favs.isEmpty());
        favs = fd.queryFavBasedOnLoggedInUserAndFavRec('',UserInfo.getUserId());
        System.assertEquals(true, favs.isEmpty());
        favs = FavoriteDomain.queryFavBasedOnArticleIdSet(new Set<Id>(),UserInfo.getUserId());
        System.assertEquals(true, favs.isEmpty());
        Boolean fakeInserted = FavoriteDomain.insertFavorite(getFavorite());
        System.assertEquals(true, fakeInserted);
        Boolean fakeDeleted = FavoriteDomain.deleteFavorite(new List<Favorite__b>{getFavorite()});
        System.assertEquals(true, fakeDeleted);
        fakeInserted = FavoriteDomain.insertFavoriteList(new List<Favorite__b>{getFavorite()});
        System.assertEquals(true, fakeInserted);
        Test.stopTest();
    }
}