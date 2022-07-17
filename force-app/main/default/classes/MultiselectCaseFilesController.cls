/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This Domain Class is used as Controller for MultiselectCaseFiles Lightning Component.
*/
public inherited sharing class MultiselectCaseFilesController {
    /**
     * @author : Sumit Banarji
     * @param caseIds
     * @param recordId
     * @return LightningResponse
     * @description : This method is invoked by LWC to Search for Files in the Cases
    */
    @AuraEnabled(cacheable=true)
    public static LightningResponse getFiles(List<String> caseIds, String recordId) {
        LightningResponse ltngResp = new LightningResponse();
        try{
            Set<String> caseIdSet = new Set<String>();
            caseIdSet.addAll(caseIds);
            ltngResp.payLoad = JSON.serialize(MultiselectCaseFilesAdapter.getFiles(caseIdSet, recordId));
        }
        catch(Exception e){
            ltngResp.isError = true;
            ltngResp.errorOrSuccessMessage = e.getMessage();
        }
        return ltngResp;
    }

    /**
     * @author : Sumit Banarji
     * @param contentDocIds
     * @param recordId
     * @return LightningResponse
     * @description : This method is invoked by LWC to Create Conetnt Document Link for the case
    */
    @AuraEnabled
    public static LightningResponse saveFiles(List<String> contentDocIds, String recordId) {
        LightningResponse ltngResp = new LightningResponse();
        try{
            Set<String> contentDocIdSet = new Set<String>();
            contentDocIdSet.addAll(contentDocIds);
            MultiselectCaseFilesAdapter.saveFiles(contentDocIdSet, recordId);
        }
        catch(Exception e){
            ltngResp.isError = true;
            ltngResp.errorOrSuccessMessage = e.getMessage();
        }
        return ltngResp;
    }
}