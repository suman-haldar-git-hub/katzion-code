/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This Service Class is used to query FeatureControl__mdt
*/
public with sharing class FeatureControlService {
    /**
    * @Author : Ankit Singh
    * @description :This method returns the FeatureControl__mdt details
    * @return masterLabelToFeatureControlRecord
    * @param setOfMasterLabel
    */
    public static Map<String, FeatureControl__mdt> getFeatureControlRecord(
        Set<String> setOfMasterLabel
    ) {
        Map<String, FeatureControl__mdt> masterLabelToFeatureControlRecord = new
            Map<String, FeatureControl__mdt>();
        for(FeatureControl__mdt obj : FeatureControlDomain.getFeatureControlRecord(setOfMasterLabel)) {
            masterLabelToFeatureControlRecord.put(obj.MasterLabel, obj);
        }
        return masterLabelToFeatureControlRecord;
    }

    /**
    * @Author : Ankit Singh
    * @description :This method returns the Map of Walkthrough details
    * @return walkthroughMap
    */
    public static Map<String, Map<Integer, Walkthrough__mdt>> getWalkthroughRecord() {
        Map<String, Map<Integer, Walkthrough__mdt>> walkthroughMap = new
            Map<String, Map<Integer, Walkthrough__mdt>>();
        List<FeatureControl__mdt> lstFeatureControl = new List<FeatureControl__mdt>();
        lstFeatureControl = FeatureControlDomain.getFeatureControlWithWalkthroughRecord();
        if(
                lstFeatureControl != null
                &&
                !lstFeatureControl.isEmpty()
        ) {
            for(FeatureControl__mdt featureContObj : lstFeatureControl) {
                if(featureContObj.Walkthroughs__r != null) {
                    Map<Integer, Walkthrough__mdt> sequenceNumberToWalkthrough = new
                        Map<Integer, Walkthrough__mdt>();
                    for(Walkthrough__mdt obj : featureContObj.Walkthroughs__r) {
                        sequenceNumberToWalkthrough.put((Integer)obj.SequenceNumber__c, obj);
                    }
                    walkthroughMap.put(
                            featureContObj.ModuleName__c, sequenceNumberToWalkthrough
                    );
                }
            }
        }
        return walkthroughMap;
    }

}