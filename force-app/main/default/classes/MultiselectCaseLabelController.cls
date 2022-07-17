/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is responsible for interacting with Lightning component.
 */
public with sharing class MultiselectCaseLabelController {
    
    /**
     * @author : Sumit Banarji
     * @description : This method get case label...
     * @param caseId
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse getCaseLabels(string caseId){
        return MultiselectCaseLabelAdapter.getCaseLabels(caseId);
    } 
    /**
     * @author : Sumit Banarji
     * @description : This method update case label...
     * @param caseId
     * @param caseLabels
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse updateCaseLabels(string caseId, List<string> caseLabels){
        return MultiselectCaseLabelAdapter.updateCaseLabels(caseId, caseLabels);
    }
}
