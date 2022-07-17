/**
 * @description       : 
 * @author            : Joginder Kumar
 * @group             : 
 * @last modified on  : 10-20-2021
 * @last modified by  : Akhil Kumar
**/
@SuppressWarnings('PMD.CyclomaticComplexity')
public without sharing class PerformanceRewardFormController {
   
    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    * @param cvList 
    * @param captchaToken 
    **/
    @AuraEnabled  
    public static void createPNRQuery(Case queryData,List<String> cvList, String captchaToken){
        try{
            if(!hasValidData(queryData)){
                throw new AuraHandledException(System.Label.Payroll_form_missing_info);
            }

            if(System.Label.isCaptachEnabled == 'true' && captchaToken != null && captchaToken != ''){
                if(!GoogleRecaptchaAPI.rtwCaptchaValidationResult(captchaToken))
                {
                    throw new AuraHandledException(Label.RTW_Exception_Recaptcha);
                }
            }

            mapTeamMember(queryData);
            createCase(queryData);
            uploadFile(cvList,queryData);
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'PerformanceRewardFormController.cls on createPNRQuery',
                ex
            );
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
    * @description  - upload file if any
    * @author Joginder Kumar | 09-15-2021 
    * @param cvList 
    * @param queryData 
    **/
    private static void uploadFile(List<String> cvList, Case queryData){
        Case caseRec;
        List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
        
        if(queryData.Id != null) {
            caseRec = [SELECT id,CaseNumber FROM Case WHERE Id =:queryData.Id][0];
            
            for(contentversion cv : [SELECT Id, ContentDocumentId, Title, Guest_Record_fileupload__c 
                                    FROM ContentVersion 
                                    WHERE id in: cvList]){
                cdlToInsert.add(UtilityClass.createContentDocumentLink(queryData.Id, cv.ContentDocumentId));
            }
            insert cdlToInsert;
        }
    }

    /**
    * @description 
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    **/
    private static void createCase(Case queryData){
        //Fetching the assignment rules on case
        AssignmentRule assignmentRule = new AssignmentRule();
        assignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        if(assignmentRule !=null){
              //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentRule.id;

            //Setting the DMLOption on Case instance
            queryData.setOptions(dmlOpts);   
        }
        insert queryData ;
    }


    /**
    * @description - mapping team member
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
    * @description - validate form data
    * @author Joginder Kumar | 09-15-2021 
    * @param queryData 
    * @return Boolean 
    **/
    private static Boolean hasValidData(Case queryData){

       if(String.isBlank(queryData.Web_First_Name__c) ||
          String.isBlank(queryData.Web_Last_Name__c) ||
          String.isBlank(queryData.Web_Employee_Id__c) ||
          String.isBlank(queryData.WOW_Web_Email_Address__c) ||
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
}