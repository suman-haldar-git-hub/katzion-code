/**
 * @author      Abhishek Setia
 * @description Handles describe calls. Store DescribeSObjectResult object in single transaction 
 */
public without sharing class DescribeSObjectCall {
    
    private static Map<String,Schema.DescribeSObjectResult> mObjectnameDescribeResult=new Map<String,Schema.DescribeSObjectResult>();
    

    /**
     * @author      Abhishek Setia
     * @description Get DescribeSObjectResult instance from object name
     * @param       objectName - Object name in String
     * @return      Schema.DescribeSObjectResult object
     */
    @TestVisible
    private static Schema.DescribeSObjectResult getDescribeSObjectResultInstance(String objectName){
        if(String.isNotBlank(objectName)){
            String lCaseObjName = objectName.toLowerCase();
            if(!mObjectnameDescribeResult.containsKey(lCaseObjName)){
                mObjectnameDescribeResult.put(lCaseObjName,Schema.getGlobalDescribe().get(lCaseObjName).getDescribe());
            }
            return mObjectnameDescribeResult.get(lCaseObjName);
        }
        return null;  
    }


    /**
     * @author      Abhishek Setia
     * @description Get RecordType DeveloperName By Id
     * @param       objectName - Object name in String
     * @param       recordTypeId - String
     * @return      String - RecordType DeveloperName
     */
    public static String getRecordTypeDeveloperNameById(String objectName,String recordTypeId){
        Schema.DescribeSObjectResult result = getDescribeSObjectResultInstance(objectName);
        if(result != null){
            return result.getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
        }
        return null;
    }


    /**
     * @author      Abhishek Setia
     * @description Get RecordType Name By Id
     * @param       objectName - Object name in String
     * @param       recordTypeId - String
     * @return      RecordType Name
     */
    public static String getRecordTypeLabelNameById(String objectName,String recordTypeId){
        Schema.DescribeSObjectResult result = getDescribeSObjectResultInstance(objectName);
        if(result != null){
            return result.getRecordTypeInfosById().get(recordTypeId).getName();
        }
        return null;
    }


    /**
     * @author      Abhishek Setia
     * @description Get RecordType Id By Developer Name
     * @param       objectName - Object name in String
     * @param       developerName - DeveloperName of RecordType
     * @return      Record Type Id
     */
    public static Id getRecordTypeIdByDeveloperName(String objectName,String developerName){
        Schema.DescribeSObjectResult result = getDescribeSObjectResultInstance(objectName);
        if(result != null){
            return result.getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();
        }
        return null;
    }


    /**
     * @author      Abhishek Setia
     * @description Get picklist values
     * @param       objectName - Object name in String
     * @param       picklistfield - picklist field api name
     * @return      Set<String>
     */
    public static Set<String> getPicklistValues(String objectName, String picklistfield){
        Schema.DescribeSObjectResult result = getDescribeSObjectResultInstance(objectName);
        if(result != null){
            Set<String> pickListValues=new Set<String>();
            List<Schema.PicklistEntry> ple = result.fields.getMap().get(picklistfield).getDescribe().getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValues.add(pickListVal.getValue());
            }     
            return pickListValues;
        }
        return null;
    }


    /**
     * @author      Abhishek Setia
     * @description Get picklist values excluding set 'valuesToExclude'
     * @param       objectName - Object name in String
     * @param       picklistfield - picklist field api name
     * @param       valuesToExclude
     * @return      Set<String>
     */
    public static Set<String> getPicklistValues(String objectName, String picklistfield, Set<String> valuesToExclude){
        Set<String> setValues = getPicklistValues(objectName,picklistfield);
        if(!valuesToExclude.isEmpty()){
            setValues.removeAll(valuesToExclude);
        }
        return setValues;
    }


    /**
     * @author      Abhishek Setia
     * @description Gets picklist value to label map
     * @param       objectName - Object name in String
     * @param       picklistfield - picklist field api name
     * @return      Map<String,String>
     */
    public static Map<String,String> picklistValueToLabelMap(String objectName, String picklistfield){
        Schema.DescribeSObjectResult result = getDescribeSObjectResultInstance(objectName);
        if(result != null){
            Map<String,String> valueToLabelMap=new Map<String,String>();
            List<Schema.PicklistEntry> ple = result.fields.getMap().get(picklistfield).getDescribe().getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                valueToLabelMap.put(pickListVal.getValue(),pickListVal.getLabel());
            }     
            return valueToLabelMap;
        }
        return null;
    }
}