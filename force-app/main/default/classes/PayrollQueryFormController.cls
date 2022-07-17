 /**
 * @description       : This class is used to create case from payroll public site 
 * @author            : Joginder Kumar
 * @group             : 
 * @last modified on  : 04-04-2022
 * @last modified by  : Meghna Bhargava
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class PayrollQueryFormController {
  
    /**
    * @description method to create case
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    * @param captchaToken   
    * @param cvList
    * @param isFileUploadMandatory 
    * @return caseNumber 
    * @Last Modified : Aman Kumar | 01-18-2021 
    **/
    @AuraEnabled  
    public static String createPayrollQuery(Case queryData, String captchaToken,List<String> cvList, boolean isFileUploadMandatory){
        try{
              if(!hasValidData(queryData)){
                throw new AuraHandledException(System.Label.Payroll_form_missing_info);
              }
              //ECICD-839
              if(isFileUploadMandatory && cvList.isEmpty()){
                throw new AuraHandledException(System.Label.File_Upload_Error_Msg);
              }//839 End
            if(System.Label.isCaptachEnabled == 'true' && captchaToken != null && captchaToken != ''){
                if(!GoogleRecaptchaAPI.rtwCaptchaValidationResult(captchaToken))
                {
                    throw new AuraHandledException(Label.RTW_Exception_Recaptcha);
                }
           }           
           mapTeamMember(queryData);
           createCase(queryData);
   
           Case caseRec;
           String caseNumber;
           List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();

           if(queryData.Id != null) {
               caseRec = [SELECT id,CaseNumber FROM Case WHERE Id =:queryData.Id][0];
               caseNumber = caseRec.CaseNumber;

               for(contentversion cv : [SELECT Id, ContentDocumentId, Title, Guest_Record_fileupload__c FROM ContentVersion WHERE id in: cvList]){
                   cdlToInsert.add(UtilityClass.createContentDocumentLink(caseRec.Id, cv.ContentDocumentId));
               }
               insert cdlToInsert;
           }
           return caseNumber;
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                    'PayrollQueryFormController.cls on createPayrollQuery',
                    ex
                );
            throw new AuraHandledException(ex.getMessage());            
        }
    }
    

    /**
    * @description - map team member
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    **/
    private static void mapTeamMember(Case queryData){
         List<Account> teamMembers = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c,PersonContactId FROM Account WHERE Employee_ID__c=:queryData.Web_Employee_Id__c];
            if(teamMembers.size()>0){
                queryData.AccountId = teamMembers[0].Id;
                queryData.ContactId = teamMembers[0].PersonContactId;
                queryData.Preferred_Name__c = teamMembers[0].Preferred_Name__c;
                queryData.Employee_ID__c = teamMembers[0].Employee_ID__c;
                queryData.Employee_Birthdate__c = teamMembers[0].PersonBirthdate;
                queryData.Account_Email_Address__c = teamMembers[0].PersonEmail;
                queryData.Employee_Class__c = teamMembers[0].Employee_Class__c;
            }else{
                List<Account> dummyAccount = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c,PersonContactId FROM Account WHERE Employee_ID__c=:System.Label.Dummy_Record_Id LIMIT 1];
                if(dummyAccount.size()>0){
                    queryData.AccountId = dummyAccount[0].Id;
                    queryData.ContactId = dummyAccount[0].PersonContactId;
                    queryData.Preferred_Name__c = dummyAccount[0].Preferred_Name__c;
                    queryData.Employee_ID__c = dummyAccount[0].Employee_ID__c;
                    queryData.Employee_Birthdate__c = dummyAccount[0].PersonBirthdate;
                    queryData.Account_Email_Address__c = dummyAccount[0].PersonEmail;
                    queryData.Employee_Class__c = dummyAccount[0].Employee_Class__c;
                }
            }

            if(!String.isBlank(queryData.Web_Respondent_Employee_Id__c)){
                List<Account> onBehalfTeamMembers = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c FROM Account WHERE Employee_ID__c=:queryData.Web_Respondent_Employee_Id__c];
                if(onBehalfTeamMembers.size()>0){
                    queryData.Respondent_Name__c = onBehalfTeamMembers[0].Id;
                    queryData.Respondent_Employee_Id__c = onBehalfTeamMembers[0].Employee_ID__c;
                    queryData.Respondent_Employee_Preferred_Name__c = onBehalfTeamMembers[0].Preferred_Name__c;
                    queryData.Respondent_Employee_DOB__c = onBehalfTeamMembers[0].PersonBirthdate;
                    queryData.Respondent_Employee_Email__c = onBehalfTeamMembers[0].PersonEmail;
                    queryData.Respondent_Employee_Group__c = onBehalfTeamMembers[0].Employee_Class__c;
                }else{
                    List<Account> dummyAccount = [SELECT Id, Name,PersonEmail, Preferred_Name__c, Employee_ID__c, PersonBirthdate, Employee_Class__c FROM Account WHERE Employee_ID__c=:System.Label.Dummy_Record_Id LIMIT 1];
                    if(dummyAccount.size()>0){
                        queryData.Respondent_Name__c = dummyAccount[0].Id;
                        queryData.Respondent_Employee_Id__c = dummyAccount[0].Employee_ID__c;
                        queryData.Respondent_Employee_Preferred_Name__c = dummyAccount[0].Preferred_Name__c;
                        queryData.Respondent_Employee_DOB__c = dummyAccount[0].PersonBirthdate;
                        queryData.Respondent_Employee_Email__c = dummyAccount[0].PersonEmail;
                        queryData.Respondent_Employee_Group__c = dummyAccount[0].Employee_Class__c;
                    }
                }
            }
    }


    /**
    * @description -  insert case record
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    **/
    private static void createCase(Case queryData){
        AssignmentRule assignmentRule = new AssignmentRule();
        assignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if(assignmentRule !=null){
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id;
            dmlOpts.EmailHeader.triggerAutoResponseEmail = true;

            //Setting the DMLOption on Case instance
            queryData.setOptions(dmlOpts);
        }
        insert queryData;
    }
    
    /**
    * @description validate form data
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    * @return Boolean 
    **/    
    private static Boolean hasValidData(Case queryData){

       if(String.isBlank(queryData.Web_First_Name__c) ||
          String.isBlank(queryData.Web_Last_Name__c) ||
          String.isBlank(queryData.Web_Employee_Id__c) ||
          String.isBlank(queryData.WOW_Web_Email_Address__c) ||
          String.isBlank(queryData.Business_Area__c) ||
          String.isBlank(queryData.Category__c) ||
          String.isBlank(queryData.Sub_Category_New__c) ||
          String.isBlank(queryData.Sub_Category_2__c) ||
          String.isBlank(queryData.RecordTypeId) ||
          String.isBlank(queryData.Subject) ||
          String.isBlank(queryData.Description)){
              return false;
       } 
       return true;
    }
    
    /**
    * @description get values from meta data Category_Subcategory_AttchDependency__mdt for which attachment is mandatory
    * @author Ashish Singh | 28-03-2022 
    * @return List<Category_Subcategory_AttchDependency__mdt> 
    **/
	@AuraEnabled    
    public static List<Category_Subcategory_AttchDependency__mdt> getIsAttchMandData(){
       List<Category_Subcategory_AttchDependency__mdt> isAttchMandatory = Category_Subcategory_AttchDependency__mdt.getAll().values();
       return isAttchMandatory;
    }   
}
