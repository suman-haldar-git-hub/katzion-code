/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the DML operations performed on the Case records...
 */
public inherited sharing class CaseDomain {
    /**
     * @author : Saurabh Bisht
     * @description : This method inserts the new case...
     * @param newCase
     */
    public static void insertNewCase(Case newCase){
        if(Schema.sObjectType.Case.fields.category__c.isCreateable() && 
            Schema.sObjectType.Case.fields.origin.isCreateable() &&
            Schema.sObjectType.Case.fields.ownerid.isCreateable() && 
            Schema.sObjectType.Case.fields.sub_category__c.isCreateable() &&
            Schema.sObjectType.Case.fields.on_behalf_of_name__c.isCreateable())
        {
            insert newCase;       
        }
    }
    /**
     * @author      Sunil
     * @description This method used to get current user's open cases
     * @return      List of case
     */
    public static List<Case> getCurrentUserCases(){
        return [Select id, Status, Description, Type, LastmodifiedDate,
                Created_Date__c
                FROM Case
                Where RequesterUser__c =: UserInfo.getUserId()];
    }


    /**
     * @author : Sumit Banarji
     * @param caseIds
     * @return List
     * @description : This method is used to Query Case object
    */
    public static List<Case> queryCases(Set<String> caseIds) {
        return [SELECT Id, CaseNumber,ownerid, owner.name,labels__c 
                FROM Case 
                WHERE Id in: caseIds];
    }

        /**
     * @author : Shubham Shukla
     * @param cases
     *
     * @description : This method is used to Query Case object
    */
    public static void updateCases(List<Case> cases) {
            if (!cases.isempty()){
                update cases;
            }
    }
    
    /**
     * @author      Abhishek Setia
     * @description Sub query of method salarySacrificeCasesOnAccount
     * @param       pw - ParameterWrapper object
     * @param       customMetadataMap
     * @return      String
     */
    private static String myApplicationArchiveQuerySubcat(ParameterWrapper pw,Map<String,String> customMetadataMap){
        String query1=' WHERE AccountId IN :accountids AND (';
        if(pw.strList3.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE'))){            
            //query1 += ' (Sub_Category__c IN :subcategories AND CaseApproved__c IN :caseappr)';            
            query1 += ' (TeamHubApplicationType__c = :salarysacrifice AND CaseApproved__c IN :caseappr)';            
        }
        if(pw.strList3.contains(customMetadataMap.get('LEAVEREQUESTTYPE'))){
            if(pw.strList3.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE'))){
                query1 += ' OR ';
            }
            //query1 += ' (Sub_Category__c IN :leavesubcategories AND Status IN :statusvalue)';
            query1 += ' (TeamHubApplicationType__c = :leave AND Status IN :statusvalue)';
        }
        if(pw.strList3.contains(customMetadataMap.get('TEAMHUBAPPLICATIONTYPEWPS'))){ 
            if(pw.strList3.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE'))||
                pw.strList3.contains(customMetadataMap.get('LEAVEREQUESTTYPE'))){
                query1 += ' OR ';
            }
                query1 += ' (TeamHubApplicationType__c = :wpsAppType AND Status IN :statusvalue)'; 
        }
        if(pw.strList3.contains(customMetadataMap.get('REQUESTSTYPE'))){ 
            if(pw.strList3.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE'))||
            pw.strList3.contains(customMetadataMap.get('LEAVEREQUESTTYPE')) ||
            pw.strList3.contains(customMetadataMap.get('TEAMHUBAPPLICATIONTYPEWPS'))){
                query1 += ' OR ';
            }            
            //query1 += ' (Sub_Category__c NOT IN :subcategories AND Sub_Category__c NOT IN :leavesubcategories'
              //     +' AND Status IN :statusvalue)';
              query1 += ' (TeamHubApplicationType__c IN :requests AND Status IN :statusvalue AND Category__c !=\'WPS\')';
        }
        query1 += ')';
        return query1;
    }


    /**
     * @author      Abhishek Setia
     * @description Sub query of method salarySacrificeCasesOnAccount
     * @param       pw - ParameterWrapper object
     * @param       customMetadataMap
     * @return      String
     */
    private static String myApplicationArchiveQuerySub(ParameterWrapper pw,Map<String,String> customMetadataMap){
        String query1='';
        if(String.isNotBlank(pw.str3) && String.isNotBlank(pw.str4)){
            if(pw.str4==customMetadataMap.get('MYAPPLICATIONS')){
                query1 += ' AND Subject like \'%'+String.escapeSingleQuotes(pw.str3)+'%\'';
            }else if(pw.str4==customMetadataMap.get('ARCHIVE')){
                query1 += ' AND (Subject like \'%'+String.escapeSingleQuotes(pw.str3)+'%\' OR Origin like \'%'+
                    String.escapeSingleQuotes(pw.str3)+'%\' OR Account.Name like \'%'+
                    String.escapeSingleQuotes(pw.str3)+'%\')';
            }            
        }        
        query1 += ' AND Origin = :caseorigin';
        return query1;
    }

    /**
     * @author      Abhishek Setia
     * @description Salary Sacrifice / Leave Forms Cases on account.
     *              Ticket No. TH-1878
     * @param       pw - ParameterWrapper object
     * @param       customMetadataMap
     * @return      List of cases
     */
    public static List<Case> salarySacrificeCasesOnAccount(ParameterWrapper pw,Map<String,String> customMetadataMap){
        Set<Id> accountids = pw.idSet1;
        String caseorigin=customMetadataMap.get('CASEORIGINTEAMHUB');   
        List<String> caseappr = pw.strList2;
        String salarysacrifice = customMetadataMap.get('TEAMHUBAPPLICATIONTYPESALARYSACRIFICE');                    
        String leave = customMetadataMap.get('TEAMHUBAPPLICATIONTYPELEAVE');
        String wpsAppType = customMetadataMap.get('TEAMHUBAPPLICATIONTYPEWPS');
        Set<String> requests = pw.strSet1;
        Set<String> statusvalue = (pw.str4==customMetadataMap.get('MYAPPLICATIONS'))?
            DescribeSObjectCall.getPicklistValues('Case', 'Status', new Set<String>{
                customMetadataMap.get('CASESTATUSCLOSED')
            }):new Set<String>{customMetadataMap.get('CASESTATUSCLOSED')};
        String query1 = 'SELECT id, Status, Subject__c, Category__c, RecordType.Name, Account.Name,toLabel(Origin), ClosedDate,'
        + ' TypeofDevice__c, CaseApproved__c, Subject, Sub_Category__c, LastmodifiedDate, CreatedDate, TeamHubApplicationType__c'
        + ' FROM Case';
        query1 += myApplicationArchiveQuerySubcat(pw,customMetadataMap);   
        query1 += myApplicationArchiveQuerySub(pw,customMetadataMap);         
        if(String.isNotBlank(pw.str1) && String.isNotBlank(pw.str2)){
            query1 += ' ORDER BY '+String.escapeSingleQuotes(pw.str1)+' '+String.escapeSingleQuotes(pw.str2);
        }   
        query1 += ' LIMIT '+pw.int1+' OFFSET '+pw.int2;
        System.debug('query1='+query1);
        return System.Database.query(query1);        
    }

    
    /**
     * @author      Abhishek Setia
     * @description Count cases
     * @param       pw - ParameterWrapper object
     * @param       customMetadataMap
     * @return      No of cases
     */
    public static Integer countCases(ParameterWrapper pw, Map<String,String> customMetadataMap){
        Set<Id> accountids = pw.idSet1;
        String caseorigin=customMetadataMap.get('CASEORIGINTEAMHUB');  
        List<String> caseappr = pw.strList2;
        String salarysacrifice = customMetadataMap.get('TEAMHUBAPPLICATIONTYPESALARYSACRIFICE');                    
        String leave = customMetadataMap.get('TEAMHUBAPPLICATIONTYPELEAVE');
        String wpsAppType = customMetadataMap.get('TEAMHUBAPPLICATIONTYPEWPS');
        Set<String> requests = pw.strSet1;
        Set<String> statusvalue = (pw.str4==customMetadataMap.get('MYAPPLICATIONS'))?
            DescribeSObjectCall.getPicklistValues('Case', 'Status', new Set<String>{
                customMetadataMap.get('CASESTATUSCLOSED')
            }):new Set<String>{customMetadataMap.get('CASESTATUSCLOSED')};              
        String query1 = 'SELECT COUNT(id) noOfCases FROM Case';
        query1 += myApplicationArchiveQuerySubcat(pw,customMetadataMap);   
        query1 += myApplicationArchiveQuerySub(pw,customMetadataMap); 
        List<AggregateResult> agrList=System.Database.query(query1);
        Integer casesCount=0;
        for(AggregateResult agr:agrList){
            casesCount = (Integer)agr.get('noOfCases');
        }                
        return casesCount;          
    }
    
    /**
     * @author : Praveen Tiwari
     * @description : This method used to get MyIncentive parent case
     * @param accountId
     * @param fromDate
     * @param mapMetaData
     * @return : List<Case>
     */
    public static List<Case> getMyIncentiveParentCase(String accountId,
                                                      Date fromDate,
                                                      Map<String,String> mapMetaData){
        return [
            Select Id From Case
            Where Category__c = :mapMetaData.get('CASECATEGORYPAYANDBASICS')
            AND Sub_Category__c = :mapMetaData.get('CASECATEGORYSUPERANNUATIONPROCESSING')
            AND Subject = :mapMetaData.get('MYINCENTIVESUBJECT')
            AND ParentId = null
            AND AccountId =:accountId
            AND CreatedDate <= :System.Now()
            AND CreatedDate >= :fromDate
            AND isClosed = False
        ];
    }
    
     /**
    * @author : Amit Sharma
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to return the Case
    * @return  List<Case>
    * @param setCaseId - set of case record id
    */
    public static List<Case> getCaseRecordDetail(Set<Id> setCaseId) {
        List<Case> lstObjCaseRecord = new List<Case>();
        if(setCaseId != null && !setCaseId.isEmpty()){
            lstObjCaseRecord =  [Select Id,Category__c,Sub_Category__c,ParentId,TypeofDevice__c,
                                    Nomination__c,CaseApproved__c,CreatedDate,ClosedDate,
                                    CaseNumber,Subject,TaskAndApproval__r.Duration__c,Status,
                                    TaskAndApproval__r.SubmittedDate__c, IsClosed, 
                                    TeamHubApplicationType__c
                                From Case
                                Where Id In: setCaseId];
        }
        return lstObjCaseRecord;
    }
    
     /**
    * @author : Amit Sharma
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to return the filtered case
    * @return  List<Case>
    * @param setCaseId - set of case record id
    * @param isSalarySacrifice - boolean variable true/false
    */
    public static List<Case> getCaseFilteredRecord(Set<Id> setCaseId, Boolean isSalarySacrifice) {
        List<Case> lstObjCaseRecord = new List<Case>();
        lstObjCaseRecord =  [Select Id,Category__c,Sub_Category__c,ParentId,
                             ContactId,RequesterUser__c,Subject,CaseApproved__c,
                             RequesterUser__r.SalarySacrificeNotification__c,
                             RequesterUser__r.SalarySacrificeNotificationChannel__c,
                             Closed_Case_Comments__c
                        From Case
                    Where Id In: setCaseId AND 
                    RequesterUser__r.SalarySacrificeNotification__c =: true AND 
                    RequesterUser__r.SalarySacrificeNotificationChannel__c INCLUDES ('Email')];
        
        return lstObjCaseRecord;
    }
    
    /**
    * @author : Amit Sharma
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to return the list of case
    * @return  List<Case>
    * @param setCaseId - set of case record id
    */
    public static List<Case> getCaseAndCommentRecord(Set<String> setCaseId) { 
        List<Case> lstCase = [Select Id,CaseNumber,Related_to_Existing_Case_Number__c,
                Subject,Category__c,Sub_Category__c,Description,CreatedDate,Status,ClosedDate,
                Closed_Case_Comments__c,CaseApproved__c,Subject__c,Description__c,OwnerId,
                owner.Name,Confirm_Send_Closure_Email__c,Send_Notification__c,ServiceWow_RITM__c,TeamHubApplicationType__c,
                 (Select Id,Comment__c,CreatedDate,CreatedBy.Name,Type__c,Case__c
                From Case_Comments__r
               Where CreatedBy.Id =: UserInfo.getUserId() And Type__c =: 'External')
           FROM Case Where Id in: setCaseId];
        return lstCase;
    }
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This method is used to return the filtered case
    * @return  List<Case>
    * @param setCaseId - set of Case id
    * @param labelToContentMap
    */
    public static List<Case> getCasesForSendEmailCaseComment(set<Id> setCaseId,
                                Map<String,String> labelToContentMap) {
        List<Case> lstCase = new List<Case>();
            lstCase = [Select Id,Origin,OwnerId,ContactId,
                       Send_Notification__c,Closed_Case_Comments__c
                 FROM Case 
                Where Id in: setCaseId AND 
                   Owner.Type =: 'User' 
                   AND Origin =: labelToContentMap.get('CASEORIGINTEAMHUB')];
        return lstCase;
    }
}
