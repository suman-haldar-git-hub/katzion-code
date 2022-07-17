/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is an Adapter Class for GenericSingleRelatedListController Class
 */
public with sharing class GenericSingleRelatedListAdapter {

    public static final String CLASS_NAME = 'GenericSingleRelatedListAdapter';
    public static final String METHOD_GETDATALIST = 'getDataList';

    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param requestParam
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse getDataList(GenericSingleRelatedListController.param requestParam){
        lightningResponse response = new lightningResponse();
        try{
            response.isError = false;
            String recordId = requestParam.recordId;
            String queryString = createQuery(requestParam);
            
            List<Column> cols = getColumns(requestParam);
            List<SObject> dataList = Database.query(queryString);
            
            map<String,object> payload = new map<String,object>();
            payload.put('data', dataList);
            payload.put('colums', cols);
            payload.put('permissions', getPermissions(requestParam));

            response.payLoad = JSON.serialize(payload);
        }
        catch(Exception e){
            response.isError = true;
            response.errorType = e.getTypeName();
            response.errorOrSuccessMessage = e.getMessage();

            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error';
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.Source__c = CLASS_NAME;
            logExceptionEvent.SourceFunction__c = METHOD_GETDATALIST;
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent);
        }
        return response;
    }

    private static String createQuery(GenericSingleRelatedListController.param requestParam) {
        String query = 'SELECT Id, ';
        query += requestParam.columns;
        query += ' FROM ' + requestParam.sObjectName;
        query += ' WHERE ' + requestParam.relatedFieldAPI + ' = : recordId';
        query += ' ORDER BY CreatedDate DESC ';
        
        if(String.isNotEmpty(requestParam.recordLimit)){
            query += ' LIMIT ' + requestParam.recordLimit;
        }

        return query;
    }

    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param requestParam
     * @return lightningResponse
     */
    private static List<Column> getColumns(GenericSingleRelatedListController.param requestParam){

        List<Column> columns = new List<Column>();
        String[] fields = requestParam.columns.split(',');

        SObjectType sobj = ((SObject)(Type.forName('Schema.'+requestParam.sObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult descResult = sobj.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = descResult.fields.getMap();

        for(String fieldName : fields){
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();

            Column col = new Column();
            col.fieldName = fieldName;
            col.label = fieldDescribe.getLabel();

            Schema.DisplayType dType = fieldDescribe.getType();
            col.type = dType.name();
            if(col.type == 'DATETIME'){
                col.type = 'date';
                col.typeAttributes = new map<String,object>();
                col.typeAttributes.put('day', 'numeric');
                col.typeAttributes.put('month', 'short');
                col.typeAttributes.put('year', 'numeric');
                col.typeAttributes.put('hour', '2-digit');
                col.typeAttributes.put('minute', '2-digit');
                col.typeAttributes.put('hour12', 'true');
            }
            else if (col.type == 'DATE') {
                col.type = 'date';
            }
            else if(col.type == 'TEXTAREA'){
                col.type = 'richText';
            }
            else if(col.type.contains('TEXT')){
                col.type = 'text';
            }
            
            col.wrapText = true;

            columns.add(col);
        }

        return columns;
    }

    /**
     * @author : Sumit Banarji
     * @description : This method to get Single Related list Data
     * @param requestParam
     * @return lightningResponse
     */
    private static Permissions getPermissions(GenericSingleRelatedListController.param requestParam){

        SObjectType sobj = ((SObject)(Type.forName('Schema.'+requestParam.sObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult descResult = sobj.getDescribe();

        Permissions perm = new Permissions();
        
        perm.isUpdatable = descResult.isUpdateable();
        perm.isDeletable = descResult.isDeletable();

        return perm;
    }
    

    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This class is a wrapper class construct column data.
     */
    public class Column {
        public string label;
        public string fieldName;
        public string type;
        public Boolean wrapText;
        public Integer initialwidth;
        public map<String,object> typeAttributes;
    }


    /**
     * @author : Sumit Banarji
     * @company : Cognizant
     * @description : This class is a wrapper class for permissions.
     */
    public class Permissions {
        public Boolean isDeletable;
        public Boolean isUpdatable;
    }
}