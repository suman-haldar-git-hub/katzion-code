/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This handler class is used to write a code for CaseCommentTriggerHandler
*/
public without sharing class CaseCommentTriggerService{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta(); 
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record and 
    * update its team member 
    * @param lstCaseComment - trigger new case list
    */
    public static void createChildCampaigRecord(List<Case_Comment__c> lstCaseComment){ 
        Map<Id,Case_Comment__c> mapCaseIdAndCaseCommentId = new Map<Id,Case_Comment__c> ();
        List<Case> lstCase = new List<Case>();
        
        for(Case_Comment__c objCaseComment : lstCaseComment){
            if(objCaseComment.Type__c == 'External'){
                mapCaseIdAndCaseCommentId.put(objCaseComment.Case__c,objCaseComment);
            }
        }
        
        if(!mapCaseIdAndCaseCommentId.isEmpty()){
            
            For(Case objCase : CaseDomain.getCasesForSendEmailCaseComment(
                        mapCaseIdAndCaseCommentId.keySet(),labelToContentMap)){
                lstCase.add(objCase);
            }
        }
        
        if(!lstCase.isEmpty()){
            Campaign primaryCampaign = CampaignDomain.getCampaignRecordByCode(
                                labelToContentMap.get('CASECOMMENTNOTIF'));
            insertCampaignAndMember(primaryCampaign,lstCase,mapCaseIdAndCaseCommentId);
        }
        
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record and 
    *                update its team member 
    * @param primaryCampaign
    * @param lstCase 
    * @param mapCaseIdAndCaseCommentId 
    */
    public static void insertCampaignAndMember(Campaign primaryCampaign,
                            List<Case> lstCase,Map<Id,Case_Comment__c> mapCaseIdAndCaseCommentId){
        Map<ID,Case> mapIdAndCaseCase = new Map<ID,Case> ();
        Map<String,Id> mapUniqueAndId = new Map<String,Id> ();
        List<Campaign> lstChildCampaign = new List<Campaign>();
        List<CampaignMember> lstCampaignMember = new List<CampaignMember> ();
        
        try{
            for(Case objCase : lstCase){
                Campaign childCampaign = new Campaign(
                    Name = primaryCampaign.Name,
                    ParentId = primaryCampaign.Id,
                    UniqueId__c = String.valueOf(primaryCampaign.id)+
                                                         String.valueOf(objCase.id) +
                                                         system.now()
                );
                lstChildCampaign.add(childCampaign);
                mapIdAndCaseCase.put( objCase.Id,objCase);
                mapUniqueAndId.put(childCampaign.UniqueId__c,objCase.id);
            }
            if(!lstChildCampaign.isEmpty()){
                CampaignDomain.dmlOnCampaignRecd(lstChildCampaign,'insert');
                for(Campaign objChildCampaign : lstChildCampaign){
                    Case objCase = mapIdAndCaseCase.get(
                        mapUniqueAndId.get(objChildCampaign.UniqueId__c));
                    
                    CampaignMember campaignMember = new CampaignMember();
                    campaignMember.CampaignId = objChildCampaign.Id;
                    campaignMember.ContactId = getContactId(objCase.OwnerId);
                    campaignMember.Case__c = objCase.id;
                    campaignMember.CaseComment__c   = mapCaseIdAndCaseCommentId.get(objCase.id).Id;
                    campaignMember.CaseCommentBody__c = 
                             mapCaseIdAndCaseCommentId.get(objCase.id).Comment__c != null ?
                             mapCaseIdAndCaseCommentId.get(objCase.id).Comment__c.left(4000) : '';
                        
                    campaignMember.ClosedCaseComments__c = (objCase.Closed_Case_Comments__c != null &&
                              objCase.Closed_Case_Comments__c != '') ? 
                                        objCase.Closed_Case_Comments__c.left(4000) : '';
                    campaignMember.User__c = objCase.OwnerId;
                    
                    lstCampaignMember.add(campaignMember);
                }
            }
            if(!lstCampaignMember.isEmpty()){
                CampaignMemberDomain.dmlOnCampaignMemberRecd( lstCampaignMember,'insert');
            }
        }
        catch (Exception ex){
             PublishLogEventService.publishExceptionEvent
            ('CaseCommentTriggerService.cls on execute',ex);
        }
        
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to get the contact id
    * return Id - contact id
    * @param owenrId
    * @return Id
    */
    public static Id getContactId (Id owenrId){
        Account accountRecd = new Account();
            User userDetail = UserDomain.queryUserBasedOnId(owenrId);
            String userEmpId = '';
            if(userDetail != null){
                userEmpId = userDetail.EmployeeID__c;
            }
            if(String.isNotBlank(userEmpId)){
                accountRecd = AccountDomain.queryAccountBasedOnEmpId(userEmpId);
            }
        return accountRecd.PersonContactId;
    }
        
        
}