/**
@author : Saurabh Bisht
@company : SaasFocus
@description : This class creates the test data for "Picklist Field Value" object...
*/
@isTest
public class PicklistFieldValueTestData {
    /**
    @author : Saurabh Bisht
    @description : This method returns the data based on provided arguments...
    @return : List<Picklist_Field_Value__c>
    @param objectField
    @param count
    @param performDML
    */
    public static List<Picklist_Field_Value__c> getPicklistFieldValueData(
        String objectField,
        integer count,
        Boolean performDML
    ){
        List<Picklist_Field_Value__c> returnData = new List<Picklist_Field_Value__c>();
        for(integer i=0; i<count; i++){
            Picklist_Field_Value__c obj = new Picklist_Field_Value__c();
            obj.Picklist_Field_Value__c = 'test';
            obj.Object_Field__c = objectField;
            obj.Big_W_Web_Display__c = true;
            obj.Big_W_Record_Type__c = 'Big_W_Case';
            obj.Web_Display__c = true;
            obj.Web_Value__c = 'test';
            returnData.add(obj);
        }
        if(performDML){
            insert returnData;
        }
        return returnData;
    }

    /**
    * @author : Daksh
    * @description : This methods create a Picklist_Field_Value__c record
    * @return : List<Picklist_Field_Value__c>
    * @param objectFieldRecdId
    * @param count
    */
    public static List<Picklist_Field_Value__c> createPicklistFieldValueList(Id objectFieldRecdId,
    Integer count){
        List<Picklist_Field_Value__c> picklistFieldValueList = 
            new List<Picklist_Field_Value__c>();
        String nameStr = objectFieldRecdId+' Test ';
        for (Integer i = 0; i < count; i++) {
            picklistFieldValueList.add(new Picklist_Field_Value__c(Name = nameStr+i,
            Picklist_Field_Value__c = nameStr+i,Object_Field__c = objectFieldRecdId,
            Sequence_Number__c = i,Web_Display__c = true,Web_Value__c = nameStr+i,
            PrimaryUniqueKey__c = nameStr+i));
        }
        return picklistFieldValueList;
    }
}