/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class will be used to communicate backend and controller SendCommunication.
*/
public class SendCommunicationService{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Monika Bisht
    * @description : This method is used to fetch recordId, checkbox and cancel reason on edit.
    * @return : map<string,string>
    * @param recordId
    * @param isActive
    * @param cancelComment
    */
    @AuraEnabled
    public static map<string,string> updateCommunicationRecords(
        String recordId,
        Boolean isActive,
        String cancelComment
    ){
        return SendCommunicationController.updateCommunicationRecords(
                recordId,
                isActive,
                cancelComment
        );
    }

    /**
    * @author : Daksh Madan
    * @description : This method is used to call insertCommunicationRelatedRecords method of 
    * SendCommunicationController class to insert related records of communication.
    * @return : String
    * @param jsonString
    */
    @auraEnabled
    public static String insertCommunicationRelatedRecords(String jsonString){
        return SendCommunicationController.insertCommunicationRelatedRecords(
            jsonString,
            labelToContentMap
        );
    }

    /**
    * @author : Ankit Singh
    * @description : get Wrap Data
    * @param recordId
    * @return : WrapperData
    */
    @AuraEnabled
    public static WrapperData getWrapData(String recordId) {
        WrapperData objWrap = new WrapperData();
        objWrap.fieldLabelToFieldApi = LeaveService.getPicklistValues(
                labelToContentMap.get('COMMUNICATION'),
                labelToContentMap.get('SYSTEMTOACTIONOBJECTAPINAME')
        );
        objWrap.typeLabelToFieldApi = LeaveService.getPicklistValues(
                labelToContentMap.get('COMMUNICATION'),
                labelToContentMap.get('TYPEOBJECTAPINAME')
        );
        objWrap.loggedinUserProfileName = UserDomain.queryLoggedInUserProfileName();
        objWrap.labelAndContentWrapperMap = labelToContentMap;
        objWrap.eligibleProfileForUTLCreation = FeatureControlDomain.getFeatureControlRecord(
            labelToContentMap.get('FEATURECONTROLTASKCREATION')
        ).EligibleProfileForUTLCreation__c;
        if(String.isNotBlank(recordId)) {
            objWrap.wrapCommunication = SendCommunicationController.fetchCommunicateRec(recordId);
        }
        return objWrap;
    }
    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : inner wrapper class
    */
    public class WrapperData {
        @AuraEnabled
        public String loggedinUserProfileName = '';
        @AuraEnabled
        public Map<String, String> fieldLabelToFieldApi  = new Map<String, String>();
        @AuraEnabled
        public Map<String, String> typeLabelToFieldApi  = new Map<String, String>();
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
        @AuraEnabled
        public SendCommunicationController.Communicate wrapCommunication;
        @AuraEnabled
        public String eligibleProfileForUTLCreation = '';
    }
    
    /**
    * @author : Sunil Kumar
    * @description : This method is used to fetch Knowledge records in sorted orders.
    * @return : String
    * @param ids
    */
    @AuraEnabled
    public static String getArticlesForPreview(
        String ids
    ){
        set<String> setRecId = new set<String>();
        String idsToReturn = '';
        For(String recId : ids.split(',')){
            setRecId.add(recId);
        }
        For(Knowledge__kav obj : KnowledgeDomain.getArticlesForPreview(setRecId)){
            idsToReturn += obj.Id+',';
        }
        idsToReturn = idsToReturn.removeEnd(',');
        return idsToReturn;
    }
}