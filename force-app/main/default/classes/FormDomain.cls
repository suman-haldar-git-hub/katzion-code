/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLS for Form__c object
*/
public with sharing class FormDomain {
    /**
    * @author : Sunil Kumar
    * @description : This method is used to query Form__c records on page load.
    * @param formTypes
    * @return List<Form__c>
    */
     public static List<Form__c> getFormDataOnLoad(Set<String> formTypes) {
        Return [Select id, Name, Active__c, ArticleText__c, FormDisabledIconName__c,
                    ArticleUrl__c, EligibilityHeaderCSS__c, FormDescription__c,
                    FormEligibilityHeader__c, FormIconName__c, Sequence__c,
                    ContentCSS__c, IconFormula__c, FormType__c, FormTab__c,IsExternalApp__c,
                    MaximumDeviceEligibility__c, RedirectUrl__c,ExhaustionofQuotaText__c,
                    ExhaustionofQuotaHeaderCSS__c,ExhaustionofQuotaCSS__c,StartDate__c,EndDate__c,
                    Category__c, CaseCategory__c, DisplayOnDesktop__c, DisplayOnMobile__c
                From Form__c
                WHERE Active__c = true
                AND FormType__c IN :formTypes
                ORDER BY Sequence__c ASC];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query Form__c records based on form tab.
    * @param formTab
    * @return List<Form__c>
    */
    public static List<Form__c> getFormBasedOnFormTab(Set<String> formTab){
        return [Select id, Name, Active__c, ArticleText__c, FormDisabledIconName__c,
                    ArticleUrl__c, EligibilityHeaderCSS__c, FormDescription__c,
                    FormEligibilityHeader__c, FormIconName__c, Sequence__c,
                    ContentCSS__c, IconFormula__c, FormType__c, FormTab__c,
                    MaximumDeviceEligibility__c, RedirectUrl__c,ExhaustionofQuotaText__c,
                    ExhaustionofQuotaHeaderCSS__c,ExhaustionofQuotaCSS__c,StartDate__c,EndDate__c
                From Form__c
                WHERE Active__c = true
                AND FormTab__c IN :formTab
               ];
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to query Form__c records on page load.
    * @param formId
    * @return Form__c
    */
    public static Form__c getFormDataOnLoad(String formId) {
        Return [Select id, Name, CategoryDescription__c, CaseCategory__c
                From Form__c
                WHERE Id =: formId AND Active__c = true LIMIT 1
        ];
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to query Form__c record
    * @param caseCategory
    * @param isActive
    * @return List<Form__c>
    */
    public static List<Form__c> getFormDataBasedOnCategory(String caseCategory, Boolean isActive) {
        Return [Select Id,CaseCategory__c,FormIconName__c,IconFormula__c,
                ApplicationDetailIcon__c
             FROM Form__c Where CaseCategory__c=: caseCategory And
             Active__c =: isActive limit 1];
    }


    /**
     * @author      Abhishek Setia
     * @description Get List<Form__c> from case category
     * @param       casecategories
     * @return      Set<Form__c>
     */
    public static List<Form__c> getFormsFromCategory(Set<String> casecategories){
        return [SELECT Id,ActionCentreIcon__c,CaseCategory__c FROM Form__c
                WHERE CaseCategory__c IN:casecategories AND ActionCentreIcon__c<>null];
    }


    /**
     * @author      Abhishek Setia
     * @description Get Form__c record by record name
     * @param       recordName
     * @return      Form__c
     * @modification Fixes done by Harshad for resolving null pointer exeption
     */
    public static Form__c getRecordByName(String recordName){
       Form__c objForm = new Form__c();
       objForm = [SELECT Id, RedirectUrl__c FROM Form__c WHERE Name=:recordName Limit 1];
       return objForm;
    }
}