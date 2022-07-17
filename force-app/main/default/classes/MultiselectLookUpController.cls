/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is used as Controller for MultiselectLookUp Lightning Web Component.
*/
public inherited sharing class MultiselectLookUpController {
    /**
     * @author : Sumit Banarji
     * @param paramsJson
     * @return List
     * @description : This method is invoked by LWC to Lookup results for the given object
    */
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String paramsJson) {
        ReqeustParam params = (ReqeustParam) JSON.deserialize(paramsJson, ReqeustParam.class);
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        System.debug(params);
        List<String> selectedRecId;
        if(params.selectedRecId == null){
            selectedRecId = new List<String>();
        }
        else {
            selectedRecId = params.selectedRecId;
        }

        if(String.isNotEmpty(params.value)) {
            String query = getQueryString(params);
            String likeCondition = ' LIKE \'%' + String.escapeSingleQuotes(params.value.trim()) + '%\'';

            for(sObject so : Database.Query(String.escapeSingleQuotes(query).replace('likeCondition', likeCondition))) {
                String fieldvalue = (String)so.get(params.fieldName);
                String idFieldValue = (String)so.get(String.isNotEmpty(params.idFieldName) ? params.idFieldName : params.fieldName);
                sObjectResultList.add(new SObjectResult(fieldvalue, idFieldValue));
            }
        }
        return sObjectResultList;
    }

    /**
     * @author : Sumit Banarji
     * @param params
     * @return String
     * @description : This method is to create query string
    */
    private static String getQueryString(ReqeustParam params){
        if(params != Null) {
            String query = 'Select ';
            
            if(String.isNotEmpty(params.idFieldName)){
                query += String.escapeSingleQuotes(params.idFieldName) + ',' ;
            }

            if(String.isNotEmpty(params.fieldName)){
                query += String.escapeSingleQuotes(params.fieldName);
            }
            query +=  ' FROM ' + String.escapeSingleQuotes(params.ObjectName);
            query +=  ' WHERE '+ String.escapeSingleQuotes(params.fieldName) + ' likeCondition ';

            if(String.isNotEmpty(params.idFieldName)){
                query += ' AND ' + String.escapeSingleQuotes(params.idFieldName) + ' NOT IN: selectedRecId';
            }
            else if(String.isNotEmpty(params.fieldName)){
                query += ' AND ' + String.escapeSingleQuotes(params.fieldName) + ' NOT IN: selectedRecId';
            }

            if(String.isNotEmpty(params.filterCondition)){
                query += ' AND ' + String.escapeSingleQuotes(params.filterCondition);
            }

            query += ' Limit 20';

            return query;
        }
        else {
            return Null;
        }
    }

    /**
     * @author : Sumit Banarji
     * @description : This is wrapper class for Request Parameter
    */
    public class ReqeustParam {
        public String objectName;
        public String fieldName; 
        public String idFieldName;
        public String filterCondition;
        public String value;
        public List<String> selectedRecId;
    }

    /**
     * @author : Sumit Banarji
     * @description : This is wrapper class for Results
    */
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public String recId;

        /**
         * @author : Sumit Banarji
         * @param recNameTemp
         * @param recIdTemp
         * @description : This constructor method is to initialize the Class Object
        */
        public SObJectResult(String recNameTemp, String recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }
}