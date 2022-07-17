/**
* @author : Amit Sharma
* @company : Cognizant
* @description  This class is used as a controller class for peoplePortalCaseDetail
*/
public with sharing class PeoplePortalFlowController {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
        
    private static Integer count=1;

    private static Integer getCount(){
        return count++;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return list of custom metadata 
    * @return : CommunityContentInfo__mdt
    * @param objCase
    */
    public static CommunityContentInfo__mdt getContentFromMetadata (Case objCase){
        
        Set<String> setDeveloperName = new Set<String> {'PPPAYBASICS'};
        
        
        String caseComment = (objCase.Send_Notification__c != null &&  
                                 objCase.Send_Notification__c == 'Send with comments')  ? (
            objCase.Closed_Case_Comments__c != null ? objCase.Closed_Case_Comments__c : '') : '';
        
        
        
        String currentTeamName = CaseHistoryService.getCurrentTeamName(objCase);            
        CommunityContentInfo__mdt objCustomMetadata =  
                            CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName)[0];
        
        if(objCustomMetadata != null && objCase.Status != 'Closed'){
            String sectionValue = objCustomMetadata.SectionName__c;
            String finalSectionValue = '';
            if(String.isNotBlank(currentTeamName)){
                finalSectionValue = sectionValue.replace('ownerTeam',currentTeamName);
            }
            objCustomMetadata.SectionName__c = finalSectionValue;
            
            String contentValue = objCustomMetadata.Content__c;
            String finalContentValue = contentValue.replace('userId',UserInfo.getUserId());
            objCustomMetadata.Content__c = finalContentValue;
        }  
        else if(objCase.Status == 'Closed') {
            objCustomMetadata.SectionName__c = labelToContentMap.get('CPCLOSEDTITLE');
            objCustomMetadata.Content__c = caseComment;
        } 
        
        return objCustomMetadata;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to insert the Case comment record
    * @param caseObjId - Case record id
    * @param comment
    */
    @AuraEnabled
    public static void insertCaseComment(Id caseObjId, String comment) {
        if(String.IsnotBlank(comment)){
            
            Case_Comment__c objCaseComment = new Case_Comment__c();
            objCaseComment.Case__c = caseObjId;
            objCaseComment.Comment__c = comment;
            objCaseComment.Type__c = 'External';
            
            Insert objCaseComment;
        }
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return wrapper of 
    *                Case list form list
    * @return : CaseAndFormWrapper
    * @param caseObjId - Case record id
    */
    @AuraEnabled(cacheable=true)
    public static CaseAndFormWrapper getCaseAndFormWrapper(String caseObjId){
         CaseAndFormWrapper objWrapper = new CaseAndFormWrapper();
         
         List<Case> lstCase = new List<Case> ();
         Form__c formObj = new Form__c();
        
        lstCase = CaseDomain.getCaseAndCommentRecord(new Set<String>{caseObjId});
        
        if(!lstCase.isEmpty()){
            LIst<Form__c> lstForm = new List<Form__c>();
            lstForm = FormDomain.getFormDataBasedOnCategory(lstCase[0].Category__c,true);
            if(lstForm.size() == 0){
                formObj = FormDomain.getFormDataBasedOnCategory('DEFAULT',false)[0];
            }
            else{
                formObj = lstForm[0];
            }
        }
        
        objWrapper.lstCaseObj = lstCase;
        objWrapper.formObjRecord = formObj; 
        objWrapper.customMetadataInfo = getContentFromMetadata(lstCase[0]);
        objWrapper.labelApiCategoryMap = DescribeSObjectCall.picklistValueToLabelMap('Case','Category__c');
        objWrapper.labelApiSubcategoryMap = DescribeSObjectCall.picklistValueToLabelMap('Case','Sub_Category__c');
        return objWrapper;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This wrapper class is used to get 3 different object data 
    */
    public class CaseAndFormWrapper {
        @AuraEnabled
        public List<Case> lstCaseObj;
        @AuraEnabled
        public Form__c formObjRecord;
        @AuraEnabled
        public CommunityContentInfo__mdt customMetadataInfo;
        @AuraEnabled
        public Map<String,String> labelApiCategoryMap;
        @AuraEnabled
        public Map<String,String> labelApiSubcategoryMap;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to create the final wrapper data
    * @return : List<CaseDetailWrapper>
    * @param caseObjId - case record id
    */
    @AuraEnabled
    public static List<CaseDetailWrapper> createFinalWrapperData(String caseObjId){
        List<CaseDetailWrapper> lstFinalCaseDetailWrapper = new List<CaseDetailWrapper>();
        lstFinalCaseDetailWrapper.addAll(createOtherData(caseObjId));
        lstFinalCaseDetailWrapper.addAll(createEmailData(caseObjId));
        lstFinalCaseDetailWrapper.addAll(CaseHistoryService.historySetupPeoplePortal(caseObjId));
        
        return getSortedWrapper(lstFinalCaseDetailWrapper);
    }


    /**
     * author       Abhishek Setia
     * @description Sorting wrapper of type CaseDetailWrapper
     * @param       lstFinalCaseDetailWrapper
     * @return      List<CaseDetailWrapper>
     */
    private static List<CaseDetailWrapper> getSortedWrapper(
        List<CaseDetailWrapper> lstFinalCaseDetailWrapper)
    {
            List<LightningDataWrapper.LightningDataRow> listLDW =
                                        new List<LightningDataWrapper.LightningDataRow>();
            Map<String,CaseDetailWrapper> mkeyWrapperObj=new Map<String,CaseDetailWrapper>();
            List<CaseDetailWrapper> sortedList=new List<CaseDetailWrapper>();
            for(CaseDetailWrapper cdw:lstFinalCaseDetailWrapper){
                LightningDataWrapper.LightningDataRow ldw =
                                                new LightningDataWrapper.LightningDataRow();
                ldw.stringA = cdw.key;
                ldw.datetimeA = DateTime.valueOf(cdw.createdDateTime);
                listLDW.add(ldw);
                mkeyWrapperObj.put(cdw.key,cdw);
            }
            if(!listLDW.isEmpty()){
                LightningDataWrapper.setSortingOrder('datetimeA', 'desc');
                listLDW.sort();
            }
            for(LightningDataWrapper.LightningDataRow ldw:listLDW){
                sortedList.add(mkeyWrapperObj.get(ldw.stringA));
            }
            return sortedList;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to create the wrapper data
    * @return : List<CaseDetailWrapper>
    * @param caseObjId - case record id
    */
    public static List<CaseDetailWrapper> createOtherData(String caseObjId){
        List<CaseDetailWrapper> lstCaseDetailWrapper = new List<CaseDetailWrapper>();
        Case objCase =  getCaseAndFormWrapper(caseObjId).lstCaseObj[0];
        
        DateTime createdDate = objCase.createdDate;
       
        CaseDetailWrapper objCaseDetailWrapper = new CaseDetailWrapper();
        objCaseDetailWrapper.heading = labelToContentMap.get('CPCASECREATION');
        objCaseDetailWrapper.collapsedTitle = labelToContentMap.get('CPCREATIONTITLE'); 
        objCaseDetailWrapper.expendedTitle = labelToContentMap.get('CPCREATIONTITLE');
        objCaseDetailWrapper.iconName = labelToContentMap.get('CPCREATIONICON');
        objCaseDetailWrapper.titleName = labelToContentMap.get('CPCREATIONIMAGE');
        objCaseDetailWrapper.createdDateTime = createdDate;
        
        lstCaseDetailWrapper.add(objCaseDetailWrapper);
        
        if(objCase.Status == 'Closed'){
            DateTime closedDate = objCase.ClosedDate;
            String caseComment = (objCase.Send_Notification__c != null &&  
                                 objCase.Send_Notification__c == 'Send with comments')  ? (
            objCase.Closed_Case_Comments__c != null ? objCase.Closed_Case_Comments__c : '') : '';
           
            CaseDetailWrapper closedCaseWrapper = new CaseDetailWrapper();
            closedCaseWrapper.heading = labelToContentMap.get('CPCASECLOSURE');
            closedCaseWrapper.collapsedTitle = labelToContentMap.get('CPCLOSEDTITLE');
            closedCaseWrapper.expendedTitle = labelToContentMap.get('CPCLOSEDTITLE')+
                                                caseComment;
            closedCaseWrapper.iconName = labelToContentMap.get('CPUSERICON');
            closedCaseWrapper.titleName = labelToContentMap.get('CPUSERIMAGE');
            closedCaseWrapper.createdDateTime = closedDate;
            
            lstCaseDetailWrapper.add(closedCaseWrapper);
        }
        
        if(objCase.Case_Comments__r != null && !objCase.Case_Comments__r.isEmpty()){
            for(Case_Comment__c objCaseComment : objCase.Case_Comments__r){
                DateTime caseCreatedDate = objCaseComment.CreatedDate;
               
                CaseDetailWrapper closedCaseWrapper = new CaseDetailWrapper();
                closedCaseWrapper.heading = labelToContentMap.get('CPCOMMENTHEADING') +' '+ 
                                                            objCaseComment.CreatedBy.Name;
                closedCaseWrapper.collapsedTitle = labelToContentMap.get('CPCOMMENTTITLE');
                closedCaseWrapper.expendedTitle = objCaseComment.Comment__c;
                closedCaseWrapper.iconName = labelToContentMap.get('CPUSERICON');
                closedCaseWrapper.titleName = labelToContentMap.get('CPUSERIMAGE');
                closedCaseWrapper.createdDateTime = caseCreatedDate;
                
                lstCaseDetailWrapper.add(closedCaseWrapper);
            }
        }
            
       return lstCaseDetailWrapper;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to create the wrapper data
    * @return : List<CaseDetailWrapper>
    * @param caseObjId - case record id
    */
    public static List<CaseDetailWrapper> createEmailData(String caseObjId){
       User objUser = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
       List<CaseDetailWrapper> lstCaseDetailWrapper = new List<CaseDetailWrapper>();
       for(EmailMessage emailMsg : EmailMessageDomain.getEmailAndAttachment(caseObjId,objUser)){
           DateTime createdDate = emailMsg.createdDate;
           
           String toEmailAddress = String.ValueOf(emailMsg.ToAddress);
           String fromEmailAddress = String.ValueOf(emailMsg.FromAddress);
           
           CaseDetailWrapper objCaseDetailWrapper = new CaseDetailWrapper();
           objCaseDetailWrapper.heading = emailMsg.Subject;
           objCaseDetailWrapper.collapsedTitle = fromEmailAddress + ' '+
                                                 labelToContentMap.get('CPEMAILTITLE');
           objCaseDetailWrapper.expendedTitle = emailMsg.HtmlBody != null ? 
                                                emailMsg.HtmlBody : emailMsg.TextBody ;
           objCaseDetailWrapper.toAdd = toEmailAddress;
           objCaseDetailWrapper.fromAdd = fromEmailAddress;
           objCaseDetailWrapper.isEmailAvailable = true;
           objCaseDetailWrapper.iconName = labelToContentMap.get('CPEMAILICON');
           objCaseDetailWrapper.titleName = labelToContentMap.get('CPEMAILIMAGE');
           objCaseDetailWrapper.createdDateTime = createdDate;
           
           List<ContentVersion> lstContentVersion = getAllContentVersion(emailMsg);
           if(!lstContentVersion.isEmpty()){
              
               objCaseDetailWrapper.contentFiles = lstContentVersion; 
           }else if(emailMsg.Attachments != null && !emailMsg.Attachments.isEmpty()){
               List<Attachment> lstAttachment = new List<Attachment> ();
               for(Attachment objAtt : emailMsg.Attachments){
                   lstAttachment.add(objAtt);
               }
               objCaseDetailWrapper.attFiles = lstAttachment;
           }
           
           lstCaseDetailWrapper.add(objCaseDetailWrapper);
       }
       
       return lstCaseDetailWrapper;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return all contentversion data
    * @return  : List<ContentVersion>
    * @param  emailMsg - email message record
    */
    public static List<ContentVersion> getAllContentVersion(EmailMessage emailMsg){
        Set<Id> setContentDocId = new Set<Id> ();
        List<ContentVersion> lstContentVersion = new List<ContentVersion>();
        
        List<ContentDocumentLink> lstContentDocLink = 
                        ContentDocumentLinkDomain.getContentDocLinks(emailMsg.Id);
        if(lstContentDocLink != null && !lstContentDocLink.isEmpty()){
            
            for(ContentDocumentLink ovjContLink : lstContentDocLink){
                setContentDocId.add(ovjContLink.ContentDocumentId);
            }
            lstContentVersion = ContentVersionDomain.getContentVersionList(setContentDocId);
        }
        return lstContentVersion;
        
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This wrapper class is used to get all case details 
    */
    public class CaseDetailWrapper {
        @AuraEnabled
        public String heading;
        @AuraEnabled
        public String collapsedTitle;
        @AuraEnabled
        public String expendedTitle;
        @AuraEnabled
        public DateTime createdDateTime;
        @AuraEnabled
        public List<Attachment> attFiles;
        @AuraEnabled
        public List<ContentVersion> contentFiles;
        @AuraEnabled
        public String toAdd;
        @AuraEnabled
        public String fromAdd;
        @AuraEnabled
        public Boolean isEmailAvailable;
        @AuraEnabled
        public String iconName;
        @AuraEnabled
        public String titleName;
        @AuraEnabled
        public String key;
        
        /** 
        * @description : Constructor of wrapper 
        */
        public CaseDetailWrapper(){
            this.isEmailAvailable = false;
            this.key = String.valueOf(getCount());
        }
    }
    
}