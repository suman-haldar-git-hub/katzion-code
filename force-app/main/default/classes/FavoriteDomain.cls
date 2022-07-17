/**
* @Author : Praveen Tiwari
* @Company : Cognizant
* @description : This class is utlity class for all the SOQL for Favorite big object.
*/
public with sharing class FavoriteDomain {
    
    /**
    * @Author : Praveen Tiwari
    * @description : This method is used to query favorite object specific to logged in user
    * @return List<Favorite__b>
    * @param loggedInUser
    */
    public List<Favorite__b> queryFavBasedOnLoggedInUser(Id loggedInUser) {
        String qry = 'Select Id, Title__c, Summary__c, FavoriteRecordId__c, UserId__c, FavoriteType__c, CreatedDate From Favorite__b Where UserId__c =: loggedInUser';
        return Database.query(qry);
    }
    
    /**
* @Author : Praveen Tiwari
* @description : This method is used to query favorite object specific to logged in user
* @return List<Favorite__b>
* @param loggedInUser
* @param favoriteArticleIds
*/
    public List<Favorite__b> queryFavoriteRecord(Id loggedInUser, Set<String> favoriteArticleIds) {
        String qry = 'Select Id, Title__c, Summary__c, FavoriteRecordId__c, UserId__c, FavoriteType__c From Favorite__b Where UserId__c =: loggedInUser AND FavoriteRecordId__c IN :favoriteArticleIds';
        return Database.query(qry);
    }
    
    /**
* @Author : Praveen Tiwari
* @description : This method is used to query favorite object to get specific favorite record for a logged-in user.
* @return List<Favorite__b>
* @param favRecordId
* @param loggedInUser
*/
    public List<Favorite__b> queryFavBasedOnLoggedInUserAndFavRec(String favRecordId, Id loggedInUser) {
        //Important Note : Please do not add any new field in the Select part as these are all indexed fields.
        String qry = 'Select UserId__c,FavoriteRecordId__c From Favorite__b Where UserId__c =: loggedInUser AND FavoriteRecordId__c =:favRecordId';
        return Database.query(qry);
    }
    /**
* @Author : Praveen Tiwari
* @description : This method is used to query favorite object to get favorite records for a logged-in user.
* @return List<Favorite__b>
* @param favRecordIdSet
* @param loggedInUser
*/
    public static List<Favorite__b> queryFavBasedOnArticleIdSet(Set<Id> favRecordIdSet, Id loggedInUser) {
        //Important Note : Please do not add any new field in the Select part as these are all indexed fields.
        String qry = 'Select UserId__c,FavoriteRecordId__c From Favorite__b Where UserId__c =: loggedInUser AND FavoriteRecordId__c IN :favRecordIdSet';
        return Database.query(qry);
    }

    /**
* @Author : Praveen Tiwari
* @description : This method insert the Favorite record
* @return Boolean
* @param favRecord
*/
    public static Boolean insertFavorite(Favorite__b favRecord){
        Boolean isInserted = false;
        if(Schema.sObjectType.Favorite__b.isCreateable()){
            if(!test.isRunningTest()){
            	database.insertImmediate(favRecord);
            }
            isInserted = true;
        }
        return isInserted;
    }
    /**
* @Author : Praveen Tiwari
* @description : This method insert the Favorite record
* @return Boolean
* @param favRecordList
*/
    public static Boolean deleteFavorite(list<Favorite__b> favRecordList){
        Boolean isDeleted = false;
        if(Schema.sObjectType.Favorite__b.isDeletable()){
            if(!test.isRunningTest()){
            	database.deleteImmediate(favRecordList);
            }
            isDeleted = true;
        }
        return isDeleted;
    }


    /**
     * author       Abhishek Setia
     * @description Inserts List<Favorite__b> objects
     * @param       favRecords - List<Favorite__b>
     * @return      Boolean
     */
    public static Boolean insertFavoriteList(List<Favorite__b> favRecords){
        Boolean flag = true;
        if(!Test.isRunningTest() && Schema.sObjectType.Favorite__b.isCreateable()){            
            Database.SaveResult[] srList = Database.insertImmediate(favRecords);
            for(Database.SaveResult sr:srList){
                if(!sr.isSuccess()){
                    flag=false;
                }
            }            
        }
        return flag;
    }
    
}