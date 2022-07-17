/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class will be used to communicate backend and controller GenericMultiSelectLookup
*/
public class GenericMultiSelectLookupService {
    /**
* @author : Daksh Madan
* @description : This method is used to fetch all the lookup records on load.
* @return : LightningResponse
*/
    @AuraEnabled
    public static LightningResponse fetchKnowledgeRecdTypes() {
        return GenericMultiSelectLookupController.fetchKnowledgeRecdTypes();
    }
    /**
* @author : Daksh Madan
* @description : This method is used to fetch all the lookup records on load.
* @return : List<sObject>
* @param jsonString
*/
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String jsonString) {
        return GenericMultiSelectLookupController.fetchLookUpValues(jsonString);
    }
}