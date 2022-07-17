/**
*@author : Saurabh Bisht
*@company : SaasFocus
*@description : This class handles the operations performed on PS Web TO Case form ...
*/
public without sharing class PSWebToCaseController {
    public static PicklistData masterPicklistData;
    public static LightningResponse ltngResp;
    
    /**
@author : Shubham Shukla
@description : This method returns the category getpswebtocase..
@return : lightning Response
*/
    @auraEnabled
    public static LightningResponse getpswebtocase(){
        return pswebtocaseadapter.getpswebtocase();
    }
    
    /**
@author : Saurabh Bisht
@description : This method creates the new Case from WebToCase form...
@return LightningResponse
@param newCase
@param isSecure
*/
    @auraEnabled
    public static LightningResponse saveCaseDetails(Case newCase,Boolean isSecure){
        ltngResp = new LightningResponse();
        try{
            if(newCase!=null){
                newCase.Origin = 'Web';
                if(newCase.Web_On_Behalf_Of_Employee_Id__c==''){
                    newCase.Web_On_Behalf_Of_Employee_Id__c=null;
                }
                newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
                // this is pointing to Advisory by Default. This will stop Status changing to "inprogress"...
                newCase.ownerID = Label.Case_Owner_Id;
                newCase.On_Behalf_Of_Name__c = setOnBehalfOfName(newCase.Web_On_Behalf_Of_Employee_Id__c);
                newCase.Category__c = setCaseCategory(newCase.Category__c, newCase.Sub_Category__c);
                newCase.Verified__c = isSecure;
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
        if( docId!=null && !docId.isEmpty()){
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
        }else{
            ltngResp.payLoad = '';
            ltngResp.errorOrSuccessMessage = 'Data Saved.';
            ltngResp.isError = false;
            ltngResp.errorType = 'success';
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
    public static LightningResponse linkDocWithCase(String docData,string caseRecId,string isSecured){
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
* @author : Saurabh Bisht
* @description : This method sets the case category based on conditions...
* @return String
* @param category
* @param subCategory
*/
    private static String setCaseCategory(String category, String subCategory){system.debug('category===>'+category);
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
@author : Ashish Singh
@description : This method returns the list of Team Member
@return : List<Account>
@param employeeId
*/
    @auraEnabled(cacheable=true)
    public static list<Account> getTeamMemberDetail(String employeeId){
        list<Account> teamMemberData = new list<Account>();
        try{
            teamMemberData = AccountDomain.getAccounts(employeeId);
            return teamMemberData;
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
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
    
    /**
@author : Ashish Singh
@description : This method returns the list of Team Member
@return : OTPComponentFor__mdt
@param formName
*/
    @auraEnabled(cacheable=false)
    public static OTPComponentFor__mdt getOtpSwitch(String formName){
        try{
            OTPComponentFor__mdt mc = OTPController.otpSwitchMdt(formName);
            return mc;
        }
        catch(exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}