/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is to create Form object test data
*/
@isTest(SeeAllData=false)
public class FormTestData {
/**
* @author : Praveen Tiwari
* @description : This methods create a Form record
* @return : List<Form__c>
* @param count
* @param performDML
*/
    public static List<Form__c> getForm(Integer count, Boolean performDML){
        List<Form__c> formLst = new List<Form__c>();
        for(integer i=0; i<count; i++){
            Form__c form = new Form__c();
            form.Name = 'Test'+i;
            form.StartDate__c = System.today()-10;
            form.EndDate__c = System.today()+10;
            form.ExhaustionofQuotaCSS__c = 'ExhaustionofQuotaCSS'+i;
            form.FormEligibilityHeader__c = 'FormEligibilityHeader'+i;
            form.EligibilityHeaderCSS__c = 'EligibilityHeaderCSS'+i;
            form.ContentCSS__c = 'ContentCSS'+i;
            form.RedirectUrl__c = 'RedirectUrl'+i;
            form.FormIconName__c = 'FormIconName'+i;
            form.Active__c = true;
            form.ExhaustionofQuotaText__c = 'ExhaustionofQuotaText'+i;
            formLst.add(form);
        }
        return formLst;
    }
}