/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for "RelatedValueDomain" class...
 */
@isTest
public class RelatedValueDomainTest {
    @TestSetup
    static void makeData(){
        List<Object_Field__c> categoryData = ObjectFieldTestData.getObjectFieldData(
            'Category',
            1,
            true
        );
        List<Object_Field__c> subCategoryData = ObjectFieldTestData.getObjectFieldData(
            'Sub Category',
            1,
            true
        );
        List<Picklist_Field_Value__c> pfvCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            categoryData[0].Id,
            1,
            true
        );
        List<Picklist_Field_Value__c> pfvSubCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            subCategoryData[0].Id,
            1,
            true
        );
        ////this creates only 1 test record...
        List<Related_Value__c> categoryRelatedData = RelatedValueTestData.getRelatedValueData(
            pfvSubCategoryInstance[0].Id,
            pfvCategoryInstance[0].Id,
            true
        );
        
        RelatedValueDomain.getMapOfRelatedValueRecords(new Set<Id>{pfvCategoryInstance[0].Id});
    }
    @isTest
    static void getDataTest(){
        List<Related_Value__c> resp = RelatedValueDomain.getData();
        RelatedValueDomain.getDataForPS();
        system.assertEquals(resp!=null, true);
        
    }
}