/**
 * @author      Abhishek Setia
 * @description Handle logic related to SObject 'Form__c'
 */
public with sharing class FormService {
    
    /**
     * @author      Abhishek Setia
     * @description Returns mapping of casecategory to ActioncentreIcon
     * @param       casecategories
     * @return      Map<String,String>
     */
    public static Map<String,String> casecategoryActioncentreIconMapping(Set<String> casecategories){
        Map<String,String> mapCasecategoryActioncentreIcon=new Map<String,String>();
        for(Form__c form:FormDomain.getFormsFromCategory(casecategories)){
            mapCasecategoryActioncentreIcon.put(form.CaseCategory__c.toUpperCase(), form.ActionCentreIcon__c);
        }
        return mapCasecategoryActioncentreIcon;
    }
}