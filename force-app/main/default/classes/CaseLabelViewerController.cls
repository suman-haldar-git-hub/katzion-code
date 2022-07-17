/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This class is responsible for interacting with Lightning component.
 */
public with sharing class CaseLabelViewerController {
/**
     * @author : Shubham Shukla
     * @description : This method get case label...
     * @param caseId
     * @return lightningResponse
     */
    @AuraEnabled(cacheable=true)
    public static lightningResponse getCaseLabels(string caseId){
        return CaselabelViewerAdapter.getCaseLabels(caseId);
    } 
    /**
     * @author : Shubham Shukla
     * @description : This method update case label...
     * @param caseId
     * @param caselabel
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse deleteCaseLabels(string caseId,string caselabel){
        return CaselabelViewerAdapter.deleteCaseLabels(caseId,caselabel);
    }
}
