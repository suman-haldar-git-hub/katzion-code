/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This class is acts as a connector between Controller, Service and domain classes.
 */
public with sharing class CaselabelViewerAdapter {
    /**
     * @author : Shubham Shukla
     * @description : This method get case label...
     * @param caseId
     * @return lightningResponse
     */
    public static lightningResponse getCaseLabels(string caseId)
    {
        lightningResponse ltngResp = new lightningResponse();
        List<labelWrapper> labelsWraps;
        Try{  
            List<String> labels = MultiselectCaseLabelAdapter.getLabels(caseId);
            if (labels != null && !labels.isempty() ){
                labelsWraps = new list<labelWrapper>();
                for (Label_Master__c lblMaster:labelMasterDomain.getLabelMaster(labels)){
                    labelWrapper labelsWrap = new labelWrapper();
                    labelsWrap.labelName = lblMaster.Label_Name__c;
                    labelsWrap.hexaValue = lblMaster.Label_Color__c;
                    labelsWrap.isDeleted = false;
                    labelsWraps.add(labelsWrap);
                }
            }
            ltngResp.payLoad = json.serialize(labelsWraps);
            ltngResp.errorOrSuccessMessage = '';
            ltngResp.isError = false;
            return ltngResp;
        }catch(Exception ex) {
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = ex.getMessage();
            ltngResp.isError = True;
            return ltngResp;        
        }
    }
/**
     * @author : Shubham Shukla
     * @description : This method update case label...
     * @param caseId
     * @param caselabel
     * @return lightningResponse
     */
    public static lightningResponse deleteCaseLabels(string caseId,string caselabel){
        Set<String> caseIds = new Set<String>{caseId};
        string lablevalues = '';
        lightningResponse ltngResp = new lightningResponse();
        try{
            list<case> cases = casedomain.queryCases(caseIds);
            List<String> labels = cases[0].labels__c.split(',');
            for(string label :labels){
                if (label != caselabel && lablevalues ==''){
                    lablevalues = label;
                }else if (label != caselabel && lablevalues !=''){
                    lablevalues = lablevalues+','+ label;
                }
            }
            cases[0].labels__c =lablevalues; 
            casedomain.updateCases(cases);
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = '';
            ltngResp.isError = false;
            return ltngResp;
        }catch(Exception ex) {
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = ex.getMessage();
            ltngResp.isError = True;
            return ltngResp;        
        }
    }
/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This class is acts as a connector between Controller, Service and domain classes.
 */
    public with sharing class LabelWrapper{
        @AuraEnabled
        public String labelName ='';
        @AuraEnabled
        public String hexaValue = '';
        @AuraEnabled
        public Boolean isDeleted = false;
    }    
}
