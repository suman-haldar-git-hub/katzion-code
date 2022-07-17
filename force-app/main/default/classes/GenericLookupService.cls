/**
* @Author : Daksh Madan
* @Company : Cognizant
* @description : This class will be used to communicate backend and controller GenericLookup
*/
public class GenericLookupService {
    /**
* @Author : Daksh Madan
* @description : This method is used to call fetchLookUpValues method of GenericLookupController
                 class to fetch lookup records.
* @return : List<sObject>
* @param searchKeyWord
* @param filterCondition
*/
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord,String filterCondition) {
        return GenericLookupController.fetchLookUpValues(searchKeyWord,filterCondition);
    }
}