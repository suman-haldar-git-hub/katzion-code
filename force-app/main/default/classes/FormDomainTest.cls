/**
 * @author      Abhishek Setia
 * @description Test class for 'FormDomain'
 */
@isTest
public class FormDomainTest {
    
    /**
     * author       Abhishek Setia
     * @description Test methods
     */
    @isTest
    static void testMethods(){
        List<Form__c> formData = FormTestData.getForm(1, false);
        formData[0].CaseCategory__c='Pay and the Basics';
        formData[0].ActionCentreIcon__c='test.svg';
        formData[0].FormTab__c='MyDevice';
        formData[0].FormType__c='ActionCentre';
        insert formData;
        System.assert(1==FormDomain.getFormsFromCategory(new Set<String>{'Pay and the Basics'}).size());
        System.assert(FormDomain.getFormDataBasedOnCategory('Pay and the Basics',true)!=null);
        System.assert(FormDomain.getFormDataOnLoad(formData[0].Id)!=null);
        System.assert(1==FormDomain.getFormBasedOnFormTab(new Set<String>{'MyDevice'}).size());
        System.assert(1==FormDomain.getFormDataOnLoad(new Set<String>{'ActionCentre'}).size());
        System.assert(FormDomain.getRecordByName('Test0')!=null);
    }
    
}