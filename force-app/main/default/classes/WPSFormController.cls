/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Meghna Bhargava
**/

@SuppressWarnings('PMD.ExcessiveParameterList,PMD.CyclomaticComplexity,PMD.ExcessivePublicCount')
public without sharing class WPSFormController {
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @return Account 
    **/
    @AuraEnabled 
    public static Account fetchLoggedInUserDetails() {

        try{
            Account acc = new Account();
            User loggedInUser = [SELECT Id, Name, EmployeeNumber, EmployeeID__c FROM User WHERE Id =: UserInfo.getUserId()];
            String employeeNum = '';
            
            if(loggedInUser.EmployeeNumber != '' && loggedInUser.EmployeeNumber != null){
                employeeNum = loggedInUser.EmployeeNumber;
            } else if(loggedInUser.EmployeeID__c != '' && loggedInUser.EmployeeID__c != null){
                employeeNum = loggedInUser.EmployeeID__c;
            }
            if (employeeNum != '') {
                acc = [SELECT Id, FirstName, LastName,PersonContactId, PersonEmail, Phone  
                       FROM Account 
                       WHERE Employee_ID__c  =: employeeNum 
                       AND PersonEmail != '' 
                       AND Employee_ID__c != '' limit 1];
            }
            return acc;
        }catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSFormController.cls on fetchLoggedInUserDetails',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
       
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @return String 
    **/
    @AuraEnabled 
    public static String fetchWPSRecordTypeName() {
        
        String recordTypeName = [SELECT Name, DeveloperName FROM RecordType
                                 WHERE sObjectType = 'Case' AND DeveloperName = 'WPS'][0].Name;
        return recordTypeName;
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param relatedTo 
    * @return Map<String, List<String>> 
    **/
    @AuraEnabled
    public static Map<String, List<String>> fetchFieldSetData(String relatedTo) {

        try{
            if(String.isBlank(relatedTo)){
                throw new AuraHandledException('Related_To__c can not be blank or null');
            }
            List<WPS_Relational_Data__mdt> relationalDataList = new List<WPS_Relational_Data__mdt>();
            relationalDataList = [SELECT Category__c,Sub_Category__c FROM WPS_Relational_Data__mdt
                                  WHERE Related_To__c =: relatedTo];
            
            Map<String, List<String>> relationalDataMap = new Map<String, List<String>>();
            
            for(WPS_Relational_Data__mdt relationalData : relationalDataList) {
                List<String> subCategories = new List<String>();
                if(!relationalDataMap.containsKey(relationalData.Category__c)) {
                    subCategories.add(relationalData.Sub_Category__c);
                    relationalDataMap.put(relationalData.Category__c, subCategories);
                }
                else {
                    relationalDataMap.get(relationalData.Category__c).add(relationalData.Sub_Category__c);
                }
            }
            return relationalDataMap;
        }catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSFormController.cls on fetchFieldSetData',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param category 
    * @param subCategory 
    * @param relatedTo 
    * @return WPS_Relational_Data__mdt 
    **/
    @AuraEnabled
    public static WPS_Relational_Data__mdt fetchFieldSet(String category, String subCategory, String relatedTo) {
        List<WPS_Relational_Data__mdt> relationalData = new List<WPS_Relational_Data__mdt>();
        relationalData =  [SELECT Field_Set__c,Additional_Comments__c FROM WPS_Relational_Data__mdt 
                           WHERE Category__c =:category AND Sub_Category__c =:subCategory AND Related_To__c =:relatedTo];
        if(relationalData.size() > 0 && relationalData[0].Field_Set__c != null) {
            return relationalData[0];
        }
        else {
            return null;
        } 
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param objectApiName 
    * @param fieldSetName 
    * @return List<FieldSetField> 
    **/
    @AuraEnabled(cacheable = true)
    public static List<FieldSetField> getFieldSetFieldsByFieldSetName(String objectApiName, String fieldSetName) {
        List<Schema.FieldSetMember> fieldSetMembers = ((SObject)Type.forName(objectApiName).newInstance()).getSObjectType().getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
        List<FieldSetField> fields = new List<FieldSetField>();
        
        for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
            
            FieldSetField fieldSetField = new FieldSetField(fieldSetMember);
            
            if(String.valueOf(fieldSetMember.getType()).toLowerCase() == 'picklist') {
                List<PicklistValues> picklistValuesList = getPickListValue(objectApiName, fieldSetMember.fieldPath);
                fieldSetField.picklistValues = picklistValuesList;    
            }
            fields.add(fieldSetField);
        }
        return fields;
    }
    

    /**
    * @description 
    * @author Akhil Kumar | 09-16-2021 
    * @param objApiName 
    * @param fieldName 
    * @return List<PicklistValues> 
    **/
    private static List<PicklistValues> getPickListValue(String objApiName, String fieldName) {

            PicklistValues picklistvalobj;
            List<PicklistValues> pickListValuesList = new List<PicklistValues>();
            Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objApiName);
            Sobject objectName = convertType.newSObject();
            Schema.SObjectType objType = objectName.getSObjectType();
            Schema.DescribeSObjectResult objDesc= objType.getDescribe();
            Map<String,Schema.SObjectField> fieldMap = objDesc.fields.getMap();
            List<Schema.PicklistEntry> pickList = fieldMap.get(fieldName).getDescribe().getPickListValues();
            
            for(Schema.PicklistEntry pickListVal : pickList) {
                picklistvalobj = new PicklistValues();
                picklistvalobj.label = pickListVal.getLabel();
                picklistvalobj.value = pickListVal.getValue();
                pickListValuesList.add(picklistvalobj);
            }
            return pickListValuesList; 
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @return List<WPS_Room_Capacity__mdt> 
    **/
    @AuraEnabled 
    public static List<WPS_Room_Capacity__mdt> fetchRoomsByCapacity() {
        List<WPS_Room_Capacity__mdt> wpsRoomCapacityList = [SELECT Room__c, Capacity__c FROM WPS_Room_Capacity__mdt];
        return wpsRoomCapacityList;
    }
    
    /**
    * @description 
    * @author Akhil Kumar | 09-15-2021 
    * @param caseRecord 
    * @param workRequestRecord 
    * @param cvList 
    * @return String 
    **/
    @AuraEnabled
    public static String submitWPSForm(Case caseRecord, Work_Requests__c workRequestRecord, List<String> cvList) {
        
        try {
            //Fetching the assignment rules on case
            AssignmentRule assignmentRule = new AssignmentRule();
            assignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            if(assignmentRule !=null){
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id;
                dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
                
                //Setting the DMLOption on Case instance
                caseRecord.setOptions(dmlOpts);
            }
            caseRecord.RequesterUser__c = userinfo.getUserId();
            insert caseRecord; 
            
            //insert work request record related to case
            workRequestRecord.Case__c = caseRecord.Id;
            insert workRequestRecord;
            
            Case caseRec;
            String caseNumber;
            List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
            
            if(caseRecord.Id != null) {
                caseRec = [SELECT id,CaseNumber FROM Case WHERE Id =:caseRecord.Id][0];
                caseNumber = caseRec.CaseNumber;

                for(contentversion cv : [SELECT Id, ContentDocumentId, Title, Guest_Record_fileupload__c FROM ContentVersion WHERE id in: cvList]){
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.LinkedEntityId = caseRec.Id;    
                    cdl.ContentDocumentId = cv.ContentDocumentId;
                    cdl.ShareType = 'V';
                    cdlToInsert.add(cdl);
                }
                insert cdlToInsert;
            }
            return caseNumber;
        }
        catch (Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSFormController.cls on submitWPSForm',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param caseRecord 
    * @param workRequestRecord 
    * @param captchaToken 
    * @param cvList 
    * @return String 
    **/
    @AuraEnabled
    public static String submitWPSWebForm(Case caseRecord, Work_Requests__c workRequestRecord, String captchaToken, List<String> cvList) { 
      try {
            if(!hasRequiredFields(caseRecord)){
                throw new AuraHandledException(System.Label.Payroll_form_missing_info);
            }
            if(System.Label.isCaptachEnabled =='true' && captchaToken != null && captchaToken != ''){
                Boolean captchaValidationResult = GoogleRecaptchaAPI.rtwCaptchaValidationResult(captchaToken);
                if(!captchaValidationResult)
                {
                    throw new AuraHandledException(System.Label.RTW_Exception_Recaptcha);
                }
            } 

            List<Account> teamMembers = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c,PersonContactId FROM Account WHERE PersonEmail=:caseRecord.Preferred_Email__c];
 
          if(teamMembers.size()>0){
                caseRecord.AccountId = teamMembers[0].Id;
                caseRecord.ContactId = teamMembers[0].PersonContactId;
                caseRecord.Preferred_Name__c = teamMembers[0].Preferred_Name__c;
                caseRecord.Employee_ID__c = teamMembers[0].Employee_ID__c;
                caseRecord.Employee_Birthdate__c = teamMembers[0].PersonBirthdate;
                caseRecord.Account_Email_Address__c = teamMembers[0].PersonEmail;
                caseRecord.Employee_Class__c = teamMembers[0].Employee_Class__c;
            }else{
                List<Account> dummyAccount = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c,PersonContactId FROM Account WHERE Employee_ID__c=:System.Label.Dummy_Record_Id LIMIT 1];
       
                if(dummyAccount.size()>0){
                    caseRecord.AccountId = dummyAccount[0].Id;
                    caseRecord.ContactId = dummyAccount[0].PersonContactId;
                    caseRecord.Preferred_Name__c = dummyAccount[0].Preferred_Name__c;
                    caseRecord.Employee_ID__c = dummyAccount[0].Employee_ID__c;
                    caseRecord.Employee_Birthdate__c = dummyAccount[0].PersonBirthdate;
                    caseRecord.Account_Email_Address__c = dummyAccount[0].PersonEmail;
                    caseRecord.Employee_Class__c = dummyAccount[0].Employee_Class__c;
                }
            }
			
            if(caseRecord.New_or_Existing_Request__c == 'Existing' && !String.isBlank(caseRecord.ParentId)){
                List<Case> existingCases = new List<Case>();
                try{
                    existingCases = [SELECT Id, CaseNumber FROM Case WHERE CaseNumber =:caseRecord.ParentId];
                    if(existingCases.size()>0){
                        caseRecord.ParentId = existingCases[0].Id;
                    }else{
                        caseRecord.ParentId = null;
                    }
                }catch(Exception ex){
                    caseRecord.ParentId = null;
                    AuraHandledException auraException = new AuraHandledException(ex.getMessage());
                    auraException.setMessage(ex.getMessage());
                    throw auraException;
                }
               
            }
           
            //Fetching the assignment rules on case
            AssignmentRule assignmentRule = new AssignmentRule();
            assignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            if(assignmentRule !=null){
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id;
                dmlOpts.EmailHeader.triggerAutoResponseEmail = true;
                
                //Setting the DMLOption on Case instance
                caseRecord.setOptions(dmlOpts);
            }
            insert caseRecord; 
            
            //insert work request record related to case
            workRequestRecord.Case__c = caseRecord.Id;
            insert workRequestRecord;
            
            Case caseRec;
            String caseNumber;
            List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();

            if(caseRecord.Id != null) {
                caseRec = [SELECT id,CaseNumber FROM Case WHERE Id =:caseRecord.Id][0];
                caseNumber = caseRec.CaseNumber;

                for(contentversion cv : [SELECT Id, ContentDocumentId, Title, Guest_Record_fileupload__c FROM ContentVersion WHERE id in: cvList]){
                    cdlToInsert.add(UtilityClass.createContentDocumentLink(caseRec.Id, cv.ContentDocumentId));
                }
                insert cdlToInsert;
				
            }
         
            return caseNumber;
        }
        catch (Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'WPSFormController.cls on submitWPSWebForm',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param caseRecord 
    * @return Boolean 
    **/
    private static Boolean hasRequiredFields(Case caseRecord){

        if(String.isBlank(caseRecord.Web_First_Name__c) ||
            String.isBlank(caseRecord.Web_Last_Name__c) ||
            String.isBlank(caseRecord.New_or_Existing_Request__c) ||
            String.isBlank(caseRecord.Preferred_Email__c) ||
            String.isBlank(caseRecord.Preferred_Phone__c) ||
            String.isBlank(caseRecord.Category__c) ||
            String.isBlank(caseRecord.Sub_Category_New__c) ||
            String.isBlank(caseRecord.Sub_Category_2__c) ||
            String.isBlank(caseRecord.Sub_Category_3__c) ||
            String.isBlank(caseRecord.RecordTypeId) ||
            String.isBlank(caseRecord.Subject) ||
            String.isBlank(caseRecord.Description) || 
            String.isBlank(caseRecord.Select_Floor__c) || 
            String.isBlank(caseRecord.Select_Location__c)){
                return false;
        }else{
            return true;
        }
    }

    /**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Meghna Bhargava
**/
    
    public class FieldSetField {
        @AuraEnabled
        public Boolean dbRequired;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Boolean required;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public List<PicklistValues> picklistValues;
        
        /**
        * @description 
        * @author Akhil Kumar | 09-15-2021 
        * @param fieldSetMember 
        **/
        public FieldSetField(Schema.FieldSetMember fieldSetMember) {
            this.dbRequired = fieldSetMember.dbRequired;
            this.apiName = fieldSetMember.fieldPath;
            this.label = fieldSetMember.label;
            this.required = fieldSetMember.required;
            this.type = String.valueOf(fieldSetMember.getType());
            this.picklistValues = new List<PicklistValues>();
        }
    }
    

     /**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Meghna Bhargava
**/
    public class PicklistValues{
         /**
        * @description 
        * @author Akhil Kumar ( Cognizant) | 08-23-2021 
        * @param  label 
        **/
        @AuraEnabled
        public string label{get;set;}

             /**
        * @description 
        * @author Akhil Kumar ( Cognizant) | 08-23-2021 
        * @param  value 
        **/

        @AuraEnabled
        public string value{get;set;}
    }
    /**
* @description 
* @author Harshit Goyal ( Cognizant) | 08-23-2021 
* @param  caseId 
* @return case 
**/
    @AuraEnabled
    public static CaseRelatedData getCaseRecord(String caseId){
        Map<String, Schema.SObjectField> fieldMap = Work_Requests__c.sObjectType.getDescribe().fields.getMap();
        Set<String> fieldNames = fieldMap.keySet();
        CaseRelatedData caseRelatedWrapper = new CaseRelatedData();
        caseRelatedWrapper.caseRecord = [SELECT Id,Category__c,Sub_Category_New__c,Sub_Category_2__c,Sub_Category_3__c,Select_Location__c,Select_Floor__c from Case WHERE Id =:caseId LIMIT 1];
        List<Work_Requests__c> workRequestList = Database.query('SELECT Case__r.CaseNumber,' + String.join((Iterable<String>)fieldNames, ',') + ' from Work_Requests__c WHERE  Case__c =: caseId LIMIT 1');
        if(!workRequestList.isEmpty()){
            caseRelatedWrapper.workRequest = workRequestList[0];
        }
        return caseRelatedWrapper;
        
        
    }

         /**
 * @description       : 
 * @author            : Harshit Goyal
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Meghna Bhargava
**/
    public class CaseRelatedData{
                    /**
        * @description 
        * @author Harshit Goyal ( Cognizant) | 08-23-2021 
        * @param  caseRecord 
        **/
        @AuraEnabled
        public case caseRecord{get;set;}
       
                /**
        * @description 
        * @author Harshit Goyal ( Cognizant) | 08-23-2021 
        * @param  workRequest 
        **/
        @AuraEnabled
        public Work_Requests__c workRequest{get;set;}
    }
             /**
 * @description       : 
 * @author            : Harshit Goyal
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Meghna Bhargava
**/
    public class RecordTypeData{
        /**
        * @description 
        * @author Akhil Kumar ( Cognizant) | 08-23-2021 
        * @param  Id 
        **/
        @AuraEnabled
        public Id defaultRTId{get;set;}
        /**
        * @description 
        * @author Akhil Kumar ( Cognizant) | 08-23-2021 
        * @param  Id 
        **/
        @AuraEnabled
        public Id wpsRTId{get;set;}
    }

/**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 09-01-2021 
    * @return Id 
    **/
    @AuraEnabled 
    public static RecordTypeData getWPSRTId(){
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Case.RecordTypeInfos;
        Id defaultRecordTypeId;
        for (Schema.RecordTypeInfo info : infos) {
        if (info.DefaultRecordTypeMapping) {
            defaultRecordTypeId = info.RecordTypeId;
            }
        }
        RecordTypeData rtWrapper = new RecordTypeData();
        rtWrapper.defaultRTId = defaultRecordTypeId;
        rtWrapper.wpsRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WPS').getRecordTypeId();
        return rtWrapper;
    }
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 09-02-2021 
    * @param accountId 
    * @return Account 
    **/
    @AuraEnabled 
    public static Account getAccountRecord(String accountId){
    return[SELECT Id, FirstName, LastName,Preferred_Name__c, PersonEmail, Phone  
    FROM Account WHERE Id =:accountId LIMIT 1];
    }
    /**
    * @description 
    * @author Harshit Goyal ( Cognizant ) | 10-18-2021 
    * @param caseId 
    * @return boolean 
    * @LastModifiedBy: Aman Kumar : 04/07/2022
    **/
    @AuraEnabled 
    public static string getCaseRecordType(String caseId){
        Case caseRecord = new Case();
        if(String.isNotBlank(caseId)){
            caseRecord = [SELECT Id,RecordType.DeveloperName FROM Case WHERE Id=:caseId];
        }
        return caseRecord.RecordType.DeveloperName;
    }
}
