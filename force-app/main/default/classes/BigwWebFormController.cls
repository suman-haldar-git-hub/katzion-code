/**
*@author : Saurabh Bisht
*@company : SaasFocus
*@description : This class handles the operations performed on BigW Web TO Case form ...
*/
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class BigwWebFormController {
    public static PicklistData masterPicklistData;
    public static LightningResponse ltngResp;
    /**
    *@author : Saurabh Bisht
    *@description : This method returns the list of "PicklistData" type, containing all the picklist data required in the component in a single call...
    *@return : String
    */
    @auraEnabled
    public static String getAllPicklistData(){
        masterPicklistData = new PicklistData();
        
        List<DropDown> category = getCategoryData('Case','Category');
        List<DropDown> subCategory = getSubCategoryData();
        List<DropDown> requestFrequency = getPicklistValues('Case','Request_Frequency__c');
        List<DropDown> fileFormat = getPicklistValues('Case','Report_Format__c');
        List<DropDown> contactMethods = getPicklistValues('Case','Preferred_Contact_Method__c');
        List<DropDown> audience = getPicklistValues('Case','Audience__c');
        List<DropDown> processRequest = getPicklistValues('Case','New_People_Query_or_Process_Request__c');
        

        masterPicklistdata.categoryData = category;
        masterPicklistdata.subCategoryData = subCategory;
        masterPicklistdata.requestFrequencyData = requestFrequency;
        masterPicklistdata.fileFormatData = fileFormat;
        masterPicklistdata.contactMethodsData = contactMethods;
        masterPicklistdata.audienceData = audience;
        masterPicklistdata.processRequestData = processRequest;
        return json.serialize(masterPicklistData);
    }
    /**
    @author : Saurabh Bisht
    @description : This method returns the category data...
    @return : List<DropDown>
    @param objectName
    @param fieldName
    */
    public static List<DropDown> getCategoryData(String objectName, String fieldName){
    List<DropDown> data = new List<DropDown>();
        List<Picklist_Field_Value__c> picklistData = PicklistFieldValueDomain.getData(objectName,fieldName);
        if(picklistData!=null){
      for(Picklist_Field_Value__c p : picklistData){
                DropDown dd = new DropDown();
                dd.label = p.Web_Value__c;
                dd.value = p.Picklist_Field_Value__c;
                if(p.Sub_Category_Mandatory_in_Webform__c){
                    dd.otherValue = 'true';
                }else{
                    dd.otherValue = 'false';
                }
                data.add(dd);
            }
        }
    return data;
    }
    /**
    @author : Saurabh Bisht
    @description : This method returns the sub category data based on category...
    @return List<DropDown>
     */
    public static List<DropDown> getSubCategoryData(){
    List<Related_Value__c> picklistData = RelatedValueDomain.getData();
        List<DropDown> data = new List<DropDown>();
        if(picklistData!=null){
            for(Related_Value__c p : picklistData){
                DropDown dd = new DropDown();
                dd.label = p.Dependant_Field_Value__r.Picklist_Field_Value__c;
                dd.value = p.Dependant_Field_Value__r.Web_Value__c;
                dd.otherValue = p.Top_Field_Value__r.Picklist_Field_Value__c;
                data.add(dd);
            }
        }
        return data;
    }
    /**
    @author : Saurabh Bisht
    @description : This method returns the picklist data on the form of label and value based on the provided object and field...
    @return List<DropDown>
    @param objectName
    @param fieldName
    */
    public static List<DropDown> getPicklistValues(String objectName, String fieldName){
        List<DropDown> data = new List<DropDown>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            DropDown dd = new DropDown();
            dd.value = pickListVal.getValue();
            dd.label = pickListVal.getLabel();
            data.add(dd);
        }
        return data;
    }
    /**
    @author : Saurabh Bisht
    @description : This method creates the new Case from WebToCase form...
    @return LightningResponse
    @param newCase
    */
    @auraEnabled
    public static LightningResponse saveCaseDetails(Case newCase){
        ltngResp = new LightningResponse();
        try{
            if(newCase!=null){
                newCase.Origin = 'Web';
                newCase.ownerID = Label.Case_Owner_Id2; // this is pointing to Big W by Default. This will stop Status changing to "inprogress"
                newCase.RecordTypeId = setBigWRecordTypeId(newCase.Category__c,'Category');
                newCase.On_Behalf_Of_Name__c = setOnBehalfOfName(newCase.Web_On_Behalf_Of_Employee_Id__c);
                newCase.Category__c = setCaseCategory(newCase.Category__c, newCase.Sub_Category__c);

                CaseDomain.insertNewCase(newCase);

                ltngResp.payLoad = json.serialize(newCase);
                ltngResp.errorOrSuccessMessage = 'Data Saved';
                ltngResp.isError = false;
                ltngResp.errorType = 'success';
            }else{
                ltngResp.payLoad = json.serialize(newCase);
                ltngResp.errorOrSuccessMessage = 'Error: No data to insert.';
                ltngResp.isError = true;
                ltngResp.errorType = 'error';
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
    @author : Saurabh Bisht
    @description : This method returns the list of data required in init, containing all the picklist data
                    required in the "Attachment" component in a single call...
    @return : String
    */
    @auraEnabled
    public static String getAllPicklistDataForAttachment(){
        masterPicklistData = new PicklistData();
        
        List<DropDown> attachment = getAttachmentData('Case','AttachmentType');
        DropDown loginUser = new DropDown();
        loginUser.value = userInfo.getUserId();

        masterPicklistdata.attachmentData = attachment;
        masterPicklistdata.userData = loginUser;
        return json.serialize(masterPicklistData);
    }
    /**
    @author : Saurabh Bisht
    @description : This method returns the attachment data...
    @return : List<DropDown>
    @param objectName
    @param fieldName
    */
    @auraEnabled
    public static List<DropDown> getAttachmentData(String objectName, String fieldName){
        List<DropDown> data = new List<DropDown>();
        List<Picklist_Field_Value__c> picklistData = PicklistFieldValueDomain.getValues(objectName,fieldName);
        if(picklistData!=null){
            for(Picklist_Field_Value__c p : picklistData){
                DropDown dd = new DropDown();
                dd.label = p.Picklist_Field_Value__c;
                dd.value = p.Web_Value__c;
                data.add(dd);
            }
        }
        return data;
    }
    /**
    @author : Saurabh Bisht
    @description : This method removes the document from the database...
    @return : LightningResponse
    @param docId
     */
    @auraEnabled
    public static LightningResponse deleteDocuments(List<String> docId){
        ltngResp = new LightningResponse();
        try{
            String dIds = '';
            for(String str: docId){
                if(dIds==''){
                    dIds = str;
                }else{
                    dIds += ','+str;
                }
            }
            Document_Upload__e platformEvt = new Document_Upload__e();
            platformEvt.DocumentId__c = dIds;
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
        return ltngResp;
    }
    /**
    @author : Saurabh Bisht
    @description : This method links the document to the given case id from WebToCase form...
    @return : LightningResponse
    @param docData
    @param caseRecId
    @param isSecured
     */
    @AuraEnabled
    public static LightningResponse linkDocWithCase(String docData,string caseRecId,String isSecured){
        ltngResp = new LightningResponse();
        Set<Id> docIds = new Set<Id>();
        Set<String> docCaseId = new Set<String>();
        List<ContentDocumentLink> newDocLinks = new List<ContentDocumentLink>();
        try{
            if(docData!=''){
                List<ContentDocumentData> documentData = (List<ContentDocumentData>) system.JSON.deserialize(docData,List<ContentDocumentData>.class);
				if(boolean.valueOf(isSecured)){
                    map<string,string> contentVersionIdDocIdMap = new map<string,string>();
                    for(ContentDocumentData cdd: documentData){
                        contentVersionIdDocIdMap.put(cdd.contentVersionId,cdd.documentId);
                    }
                    for(contentVersion cv : [SELECT id,ContentDocumentId, VersionData, Title, ContentSize, FileExtension 
                                             FROM ContentVersion 
                                             WHERE Id IN: contentVersionIdDocIdMap.keySet()]){
                                             contentVersionIdDocIdMap.put(cv.Id,cv.ContentDocumentId);   
                                             }
                    
                    for(ContentDocumentData cdd : documentData){
                        cdd.documentId = contentVersionIdDocIdMap.get(cdd.contentVersionId);
                    }
                }
                
                for(ContentDocumentData cdd: documentData){
                    if(!docCaseId.contains(cdd.documentId+'-'+caseRecId)) {
                        docIds.add(cdd.documentId);
                        docCaseId.add(cdd.documentId+'-'+caseRecId);
                        newDocLinks.add(UtilityClass.createContentDocumentLink(caseRecId,cdd.documentId));
                 
                    }
                }
                ContentDocumentDomain.insertContentDocumentLinkForBigW(newDocLinks);
                ltngResp.payLoad = json.serialize([SELECT Id,Title,Description,ContentSize
                                    FROM ContentDocument WHERE Id IN: docIds]);
                ltngResp.errorOrSuccessMessage = 'Document Uploaded';
                ltngResp.isError = false;
                ltngResp.errorType = 'success';
            }else{
                ltngResp.payLoad = '';
                ltngResp.errorOrSuccessMessage = 'No Document Found.';
                ltngResp.isError = true;
                ltngResp.errorType = 'error';
            }
        }catch(exception e){
            ltngResp.payLoad = json.serialize([SELECT Id,Title,Description,ContentSize
                                FROM ContentDocument WHERE Id IN: docIds]);
            ltngResp.errorOrSuccessMessage = e.getMessage();
            ltngResp.isError = true;
            ltngResp.errorType = 'error';
        }
        return ltngResp;
    }
    
    /**
   *@author : Ashish Singh
   *@description : This method returns the OTP Switch from Metadata
   *@return : OTPComponentFor__mdt
   *@param formName
   */
    @auraEnabled
    public static OTPComponentFor__mdt getOtpSwitch(String formName){
        try{
            OTPComponentFor__mdt mc = OTPController.otpSwitchMdt(formName);
            return mc;
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
  /**
     * @author : Saurabh Bisht
     * @description : This method sets the case recordtypeid for the BigW type...
     * @return String
     * @param fieldValue
     * @param fieldName
     */
  private static Id setBigWRecordTypeId(String fieldValue, String fieldName){
    List<Picklist_Field_Value__c> bigWRecType = PicklistFieldValueDomain.getDataForBigWRecordType(fieldValue,fieldName);
        system.debug('params==>'+fieldValue+'  :  '+fieldName);
        system.debug('query===>'+bigWRecType);
        if(bigWRecType!=null && !bigWRecType.isEmpty()){
            if(bigWRecType[0].Big_W_Record_Type__c == 'Big_W_Case'){
                return Label.RecordTypeId_BigWCase;
            }else{
                return Label.RecordTypeId_QueryCase;
            }
        }
        return null;
  }
  /**
     * @author : Saurabh Bisht
     * @description : This method sets the case category based on conditions...
     * @return String
     * @param category
     * @param subCategory
     */
    private static String setCaseCategory(String category, String subCategory){
        if(category == 'Pay and the Basics' && subCategory == 'WOW People Discount Card') {
            return 'Benefits';
        } else if (category == 'Pay and the Basics' && subCategory == 'Salary Sacrifice Forms') {
            return 'Reward';
        }else{
            return category;
        }
    }
    /**
     * @author : Saurabh Bisht
     * @description : This method sets the value for Web_On_Behalf_Of_Employee_Id__c based on conditions...
     * @return Id
     * @param onBehalfEmpId
     */
    private static Id setOnBehalfOfName(String onBehalfEmpId){
        if(onBehalfEmpId != null && onBehalfEmpId != '') {
            list<Account> lstbehalf = AccountDomain.getAccounts(onBehalfEmpId);
            if(!lstbehalf.isEmpty()) {
                return lstbehalf[0].Id;
            }
        }
        return null;
    }
    /**
    @author : Saurabh Bisht
    @description : This wrapper class is used to manupulate document data...
    */
    public class ContentDocumentData{
        public String name;
        public String documentId;
        public String contentVersionId;
        /**
         * @author : Ashish Singh
         * @description : This is contructor for ContentDocumentData wrapper class
         * @param name
         * @param documentId
         * @param contentVersionId
         */
        public ContentDocumentData(string name,String documentId,string contentVersionId){
            this.name = name;
            this.documentId = documentId;
            this.contentVersionId = contentVersionId;
        }
    }
    /**
    @author : Saurabh Bisht
    @description : Wrapper class to get all the required picklist values in a single call...
    */
    public class PicklistData{
        public List<DropDown> categoryData;
        public List<DropDown> subCategoryData;
        public List<DropDown> attachmentData;
        public List<DropDown> requestFrequencyData;
        public List<DropDown> fileFormatData;
        public List<DropDown> contactMethodsData;
        public List<DropDown> audienceData;
        public List<DropDown> processRequestData;
        public DropDown userData;        
    }
    /**
    @author : Saurabh Bisht
    @description : This wrapper class is used to store picklist's data...
    */
    public class DropDown{
        public String value;
        public String label;
        public string otherValue;
    }
}