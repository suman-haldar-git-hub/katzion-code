/**
* @author : Daksh
* @company : Cognizant
* @description : This class is to create Object_Field__c test data
*/
@isTest
public inherited sharing class ObjectFieldTestData {
    /**
* @author : Daksh
* @description : This methods create a Object_Field__c record
* @return : List<Object_Field__c>
* @param objectName
* @param fieldApiStr
*/
    public static List<Object_Field__c> createObjectFieldRecds(string objectName,
        String fieldApiStr){
            List<Object_Field__c> objectFieldList = new List<Object_Field__c>();
            List<String> lstOfFieldApi = (fieldApiStr).split(',');
            for(String fieldApiName : lstOfFieldApi){
                objectFieldList.add(new Object_Field__c(Name = objectName+'-'+fieldApiName,
                Field_API__c = fieldApiName, Field_Name__c = fieldApiName,
                Field_Web_Display__c = true, Field_Web_Label__c = fieldApiName,
                Object__c = objectName));
            }
            return objectFieldList;
    }
    /**
     * @author : Saurabh Bisht
     * @description : This method creates a test data for Category...
     * @return : List<Object_Field__c>
     * @param label
     * @param count
     * @param performDML
     */
    public static List<Object_Field__c> getObjectFieldData(
        String label,
        integer count,
        Boolean performDML
    ){
        List<Object_Field__c> returnData = new List<Object_Field__c>();
        for(integer i=0; i<count; i++){
            Object_Field__c obj = new Object_Field__c();
            if(label == 'Category'){
                obj.Field_Label__c = label;
                obj.Field_Name__c = 'Category';
                obj.Field_API__c = 'Category__c';
                obj.Field_Web_Label__c = 'Category';
                obj.Object__c = 'Case';
            }
            if(label == 'Sub Category'){
                obj.Field_Label__c = label;
                obj.Field_Name__c = 'Sub Category';
                obj.Field_API__c = 'Sub_Category__c';
                obj.Field_Web_Label__c = 'Sub Category';
                obj.Object__c = 'Case';
            }
            if(label == 'AttachmentType'){
                obj.Field_Label__c = label;
                obj.Field_Name__c = 'AttachmentType';
                obj.Field_Web_Label__c = 'AttachmentType';
                obj.Object__c = 'Case';
            }
            returnData.add(obj);
        }
        if(performDML){
            insert returnData;
        }
        return returnData;
    }
}