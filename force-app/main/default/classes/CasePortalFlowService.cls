/**
*@author :             Akshansh Jain
*@company :            Cognizant
*@description :        This service classk will be work as a controller for casePortalFlowSupport lwc
**/
public without sharing class CasePortalFlowService {  

    /**
    * @author : Akshansh
    * @description : This method is used to fetch Case recordtype id on load.
    * @return : Id
    */
    private static Id getRecordTypeInfoOnLoad() {
        Id recTypeId = 
            Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName(
            ).get('PS_Query_Case').getRecordTypeId();
        return recTypeId;
    }

    /**
    * @author : Akshansh
    * @description : This method is used to fetch picklist options on load.
    * @return : SelectedCategoryWrapper
    * @param formId
    */
    @AuraEnabled(cacheable=true)
    public static SelectedCategoryWrapper getFormDataOnLoad(String formId) {
        return getFormDataOnLoadWeb(formId, null);
    }

    /**
    * @author : Akshansh
    * @description : This method is used to fetch picklist options on load.
    * @return : SelectedCategoryWrapper
    * @param formId
    * @param caseCategory
    */
    @AuraEnabled(cacheable=true)
    public static SelectedCategoryWrapper getFormDataOnLoadWeb(String formId, String caseCategory) {
        SelectedCategoryWrapper wrapper = new SelectedCategoryWrapper();
        wrapper.accDetails = getAccountDetailsOnLoad();
        wrapper.pswebtocase = getpswebtocase();
        wrapper.metadataRecord = getMetadataRecord();
        wrapper.defaultecordTypeId = getRecordTypeInfoOnLoad();
        List < Map < String, String >> options = new List < Map < String, String >> ();
        List<Picklist_Field_Value__c> lstPickObj = new List<Picklist_Field_Value__c>();
        String caseCateg = '';
        if(formId != null) {
            Form__c objForm = FormDomain.getFormDataOnLoad(formId);
            if(objForm != null && objForm.CaseCategory__c != null) {
                caseCateg = objForm.CaseCategory__c;
            } 
        }  
        caseCateg = caseCateg == ''?caseCategory:caseCateg;
        lstPickObj = 
            [SELECT 
                    Id, (
                            SELECT Id, Sub_Category_Description__c, Web_Display__c, 
                                Dependant_Field_Value__r.Picklist_Field_Value__c 
                            FROM Related_Values__r 
                            WHERE Web_Display__c=true ORDER BY Dependant_Field_Value__r.Picklist_Field_Value__c ASC
                    ),
                    Sub_Category_Mandatory_in_Webform__c 
                    FROM Picklist_Field_Value__c 
                    WHERE Web_Value__c=:caseCateg AND 
                    Object_Field__r.Object__c='Case' AND
                    Object_Field__r.Field_API__c='Category__C'
            ];   
        if(!lstPickObj.isEmpty() && lstPickObj[0].Related_Values__r.size()>0) {
            for (Related_Value__c obj : lstPickObj[0].Related_Values__r) {
                Map < String, String > values = new Map < String, String > {
                    'label' => obj.Dependant_Field_Value__r.Picklist_Field_Value__c,
                    'value' => obj.Dependant_Field_Value__r.Picklist_Field_Value__c +'####'+ obj.Sub_Category_Description__c
                };
                options.add(values);
            }
            wrapper.category = lstPickObj[0];
            wrapper.options = options;
        }
        return wrapper;
    }

    /**
    * @author : Akshansh
    * @description : This method is used to fetch Account data on load.
    * @return : Account
    */
    private static Account getAccountDetailsOnLoad() {
        String userId = UserInfo.getUserId();
        User objUser = UserDomain.queryUserBasedOnId(userId);
        return AccountDomain.queryAccountBasedOnEmpId(objUser.EmployeeID__c);
    }

    /**
    * @author : Akshansh Jain
    * @description : This method returns the category getpswebtocase
    * @return : lightning Response
    */
    @auraEnabled(cacheable=true)
    public static LightningResponse getpswebtocase(){
        return PSWebToCaseAdapter.getpswebtocase();
    }    

    /**
    * @author : Akshansh
    * @description : This method is used to ContentDocumentLink record on Save.
    * @param documentIds
    * @param caseId
    */    
    @AuraEnabled
    public static Void createContentDocLinkWithCase(List<String> documentIds, String caseId) {
        List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();
        for(String str : documentIds) {
            lstCDL.add(new ContentDocumentLink(
                ContentDocumentId = str,
                LinkedEntityId = caseId,
                ShareType = 'I',
                Visibility = 'AllUsers'
            ));
        }
        insert lstCDL;
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to return list of custom metadata 
    * @return : Map<String,String>
    */
    private static Map<String,String> getMetadataRecord(){
        Map<String,String> mapMetadata = new Map<String,String>();
        Set<String> setDeveloperName = new Set<String> {
            'INVOICEDELETEMESSAGE', 'CASEPORTALPSWEBFORM', 'CASEPORTALSUBCATEGORYPDF'
        };
        for(CommunityContentInfo__mdt obj : 
            CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName)){
            mapMetadata.put(obj.DeveloperName, obj.Content__c);
        } 
        return mapMetadata;
    }

    /** 
    *@author : Shubham shukla
    *@description : This wrapper class is used to store picklist's data...
    */
    public class SelectedCategoryWrapper{
        @AuraEnabled
        public Picklist_Field_Value__c category;
        @AuraEnabled
        public List<Map<String,String>> options;
        @AuraEnabled
        public Account accDetails;
        @AuraEnabled
        public LightningResponse pswebtocase;
        @AuraEnabled
        public Map<String,String> metadataRecord;
        @AuraEnabled
        public Id defaultecordTypeId;
    }

    /**
    @author : Saurabh Bisht
    @description : This method creates the new Case from WebToCase form...
    @return LightningResponse
    @param newCase
    */
    @AuraEnabled
    public static LightningResponse saveCaseDetails(Case newCase){
        LightningResponse ltngResp = new LightningResponse();
        system.debug('==newCase=='+newCase);
        try{
            if(newCase!=null){
                CaseDomain.insertNewCase(newCase); 
                if(newCase.Id != null){
                    newCase = CaseDomain.getCaseRecordDetail(new Set<Id>{newCase.Id})[0];
                }
                ltngResp.payLoad = json.serialize(newCase);
                ltngResp.errorOrSuccessMessage = 'Data Saved';
                ltngResp.isError = false;
                ltngResp.errorType = 'success';
            }
        }catch(exception e){
            ltngResp.payLoad = json.serialize(newCase);
            ltngResp.errorOrSuccessMessage = e.getMessage();
            ltngResp.isError = true;
            ltngResp.errorType = 'error';
        }
        return ltngResp;
    }

    /**
    * @author : Sunil Kumar
    * @description : return the current userId (required for guest user).
    * @return : String
    */
    @AuraEnabled(cacheable=true)
    public static String getUserId() {
        return UserInfo.getUserId();
    }

    /**
    @author : Sunil Kumar
    @description : This method removes the document from the database...
    @return : LightningResponse
    @param docId
     */
    @AuraEnabled(cacheable=true)
    public static LightningResponse deleteDocuments(String docId){
        LightningResponse ltngResp = new LightningResponse();
        if( docId!=null){
            try{    
                Document_Upload__e platformEvt = new Document_Upload__e();
                platformEvt.DocumentId__c = docId;
                EventBus.publish(platformEvt);
                ltngResp.payLoad = '';
                ltngResp.errorOrSuccessMessage = 'Data Saved.';
                ltngResp.isError = false;
                ltngResp.errorType = 'warning';
            }catch(exception e){
                ltngResp.payLoad = '';
                ltngResp.errorOrSuccessMessage = e.getMessage();
                ltngResp.isError = true;
                ltngResp.errorType = 'error';
            }
        }else{
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = 'Data Saved.';
            ltngResp.isError = false;
            ltngResp.errorType = 'success';
        }
        return ltngResp;
    }
}