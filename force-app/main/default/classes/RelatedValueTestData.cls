/**
@author : Saurabh Bisht
@company : SaasFocus
@description : This class creates the test data for "Related Value" object...
*/
@isTest
public class RelatedValueTestData {
    /**
    @author : Saurabh Bisht
    @description : This method returns the data based on provided arguments...
    @return : List<Related_Value__c>
    @param dependentFieldValue
    @param topFieldValue
    @param performDML
    */
    public static List<Related_Value__c> getRelatedValueData(
        String dependentFieldValue,
        String topFieldValue,
        Boolean performDML
    ){
        List<Related_Value__c> returnData = new List<Related_Value__c>();
        for(integer i=0; i<1; i++){
            Related_Value__c obj = new Related_Value__c();
            obj.Dependant_Field_Value__c = dependentFieldValue;
            obj.Top_Field_Value__c = topFieldValue;
            obj.Big_W_Web_Display__c = true;
            obj.Web_Display__c = true;
            obj.VOC_Send_Survey__c = true;
            returnData.add(obj);
        }
        if(performDML){
            insert returnData;
        }
        return returnData;
    }

    /**
    * @author : Daksh
    * @description : This methods create a Related_Value__c record
    * @return : List<Related_Value__c>
    * @param topPicklistFieldId
    * @param dependPicklistFieldId
    * @param count
    */
    public static List<Related_Value__c> createRelatedValuedList(Id topPicklistFieldId,
    Id dependPicklistFieldId,Integer count){
        List<Related_Value__c> relatedValueList = 
            new List<Related_Value__c>();
        String nameStr = topPicklistFieldId+'-&&-'+dependPicklistFieldId;
        for (Integer i = 0; i < count; i++) {
            relatedValueList.add(new Related_Value__c(Name = nameStr,
            Top_Field_Value__c = topPicklistFieldId, 
            Dependant_Field_Value__c = dependPicklistFieldId,
            Sequence_Number__c = i));
        }
        return relatedValueList;
    }
}