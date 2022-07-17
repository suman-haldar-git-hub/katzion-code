/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is acts as a connector between Controller, Service and domain classes.
 */
public with sharing class MultiselectCaseLabelAdapter {
    
    /**
     * @author : Sumit Banarji
     * @description : This method get case label...
     * @param caseId
     * @return lightningResponse
     */
    public static lightningResponse getCaseLabels(string caseId) {
        
        lightningResponse ltngResp = new lightningResponse();
        List<MultiselectLookUpController.SObjectResult> labels = new List<MultiselectLookUpController.SObjectResult>();
        
        try {
            List<String> caselabels = getLabels(caseId);
            if (caselabels != null ){
                for(String label : caselabels){
                    labels.add(new MultiselectLookUpController.SObjectResult(label, label));
                }
            }
            ltngResp.payLoad = json.serialize(labels);
            ltngResp.errorOrSuccessMessage = '';
            ltngResp.isError = false;
            return ltngResp;
        }
        catch(Exception ex) {
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = ex.getMessage();
            ltngResp.isError = True;
            return ltngResp;        
        }
    }

    /**
     * @author : Sumit Banarji
     * @description : This method get case label...
     * @param caseId
     * @return List<String>
     */
    public static List<String> getLabels(string caseId){
        Set<String> caseIds = new Set<String>{caseId};
        list<Case> cases = casedomain.queryCases(caseIds);
        if (!cases.isempty() && string.isNotEmpty(cases[0].labels__c)){
            return cases[0].labels__c.split(',');
        }
        else {
            return null;
        }
    }

    /**
     * @author : Sumit Banarji
     * @description : This method update case label...
     * @param caseId
     * @param caseLabels
     * @return lightningResponse
     */
    public static lightningResponse updateCaseLabels(string caseId, List<string> caseLabels){
        
        lightningResponse ltngResp = new lightningResponse();
        try {

            list<case> cases = new list<case>();
            String caseLabel;
            if(caseLabels != null && caseLabels.size() > 0){
                caseLabel = String.join(caseLabels, ',');
            }
            
            Case caseObj = new Case(Id = caseId);
            caseObj.labels__c = caseLabel;

            cases.add(caseObj);
            casedomain.updateCases(cases);

            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = '';
            ltngResp.isError = false;
            return ltngResp;
        }
        catch(Exception ex) {

            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = ex.getMessage();
            ltngResp.isError = True;
            return ltngResp;        
        }
    }
}
