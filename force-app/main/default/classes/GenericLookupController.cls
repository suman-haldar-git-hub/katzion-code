/**
* @Author : Daksh Madan
* @Company : Cognizant
* @description : This controller class contains and manage all server-side methods.
*/
public with sharing class GenericLookupController {
    /**
* @Author : Daksh Madan
* @description : This method is used to fetch all the lookup records.
* @return : List<sObject>
* @param searchKeyWord
* @param filterCondition
*/
    public static List<sObject> fetchLookUpValues(String searchKeyWord,String filterCondition) {
        List <sObject> lstOfRecords = new List<sObject>();
        try{
            String searchKey = '%' + String.escapeSingleQuotes(searchKeyWord) + '%';
            String sQuery = String.escapeSingleQuotes(filterCondition);
            lstOfRecords = Database.query(sQuery.replace('\\',''));
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'GenericLookupController.cls on fetchLookUpValues',
                ex
            );
        }
        return lstOfRecords;
    }
}