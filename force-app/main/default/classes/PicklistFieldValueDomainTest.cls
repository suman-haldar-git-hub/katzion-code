/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for "PicklistFieldValueDomain" class...
 */
@isTest
public class PicklistFieldValueDomainTest {
    @TestSetup
    static void makeData(){
        List<Object_Field__c> categoryData = ObjectFieldTestData.getObjectFieldData(
            'Category',
            1,
            true
        );
        List<Picklist_Field_Value__c> pfvCategoryInstance = PicklistFieldValueTestData.getPicklistFieldValueData(
            categoryData[0].Id,
            1,
            true
        );
    }
    @isTest
    static void getDataTest(){
        List<Picklist_Field_Value__c> resp = PicklistFieldValueDomain.getData('Case','Category');
        PicklistFieldValueDomain.getAttachmentData();
        PicklistFieldValueDomain.getValues('Case','Category');
        PicklistFieldValueDomain.getMandatorySetting('People Dashboard Queries','Category');
        PicklistFieldValueDomain.getDataForBigWRecordType('People Dashboard Queries','Category');
        PicklistFieldValueDomain.getPickListValue('Account','HasDOA__c');
        system.assertEquals(resp!=null, true);
    }
}