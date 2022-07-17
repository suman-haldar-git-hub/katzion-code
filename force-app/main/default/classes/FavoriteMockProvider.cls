/**
 * @description Define the behavior of the stub class by implementing
 *              the System.StubProvider interface.
 * @author      Abhishek Setia
 */
@isTest
public class FavoriteMockProvider implements System.StubProvider{
    
    /**
    * @author       Abhishek Setia
    * @description  This method is used to create mock.
    * @return       List<Object>
    * @param        stubbedObject
    * @param        stubbedMethodName
    * @param        returnType
    * @param        listOfParamTypes
    * @param        listOfParamNames
    * @param        listOfArgs
    */
    public List<Object> handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
            if(stubbedMethodName=='queryFavBasedOnLoggedInUser' || stubbedMethodName=='queryFavBasedOnLoggedInUserAndFavRec'){
                List<ApplicationAndPortal__c> lstAP = [SELECT Id, Name, Description__c FROM ApplicationAndPortal__c];
                List<Favorite__b> listFav=new List<Favorite__b>();
                for(ApplicationAndPortal__c ap:lstAP){
                    Favorite__b fav=new Favorite__b();
                    fav.Title__c=ap.Name;
                    fav.Description__c=ap.Description__c;
                    fav.FavoriteRecordId__c=ap.Id;
                    fav.FavoriteType__c='ApplicationAndPortal__c';
                    fav.UserId__c=UserInfo.getUserId();
                    listFav.add(fav);                    
                }
                return listFav;
            }
            return null;
        }
}