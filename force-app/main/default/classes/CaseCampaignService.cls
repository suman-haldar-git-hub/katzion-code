/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This service class is used to write a code for case trigger handler
*/
public without sharing class CaseCampaignService{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta(); 
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record and 
    * update its team member 
    * @param lstCases - trigger new case list
    * @param mapOldCase - trigger old map of case
    */
    public static void createChildCampaigRecord(List<Case> lstCases, Map<Id,Case> mapOldCase){ 
        Set<Id> setCaseId = new Set<Id>();
        Set<Id> setCaseIdfCP = new Set<Id>();
        Map<Campaign,List<Case>> mapCampaignAndCaseList = 
                                new Map<Campaign,List<Case>> ();
        
        for(Case objCase : lstCases){
            Case oldCaseObj ;
            if(mapOldCase != null){
                oldCaseObj = (Case)mapOldCase.get(objCase.ID);
            }
            
            if(isValidForSalarySacrifice(objCase,oldCaseObj)){
                setCaseId.add(objCase.id);
            }
            else if(isValidForCasePortal(objCase,oldCaseObj)){
                setCaseIdfCP.add(objCase.id);
            }
        }
        mapCampaignAndCaseList = getMapOfCampaignAndCaseList(setCaseId,setCaseIdfCP);
        if(!mapCampaignAndCaseList.isEmpty()){
            insertCampaignAndMember(mapCampaignAndCaseList);
        }
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return the case id
    * @return Map<Campaign,List<Case>> - map of campaign and list of case
    * @param setCaseId - set of case id for Salary secrifice
    * @param setCaseIdfCP - set of case id for case portal
    */
    private static Map<Campaign,List<Case>> getMapOfCampaignAndCaseList(Set<Id> setCaseId, 
                                                                    Set<Id> setCaseIdfCP){
        List<Case> lstCaseObj = new List<Case> ();
        Map<Campaign,List<Case>> mapCampaignAndCaseList = new Map<Campaign,List<Case>> ();
        
        if(!setCaseId.isEmpty()){
            lstCaseObj = CaseDomain.getCaseFilteredRecord(setCaseId,true);
            
            if(!lstCaseObj.isEmpty()){
                Campaign primaryCampaign = CampaignDomain.getCampaignRecordByCode(
                                    labelToContentMap.get('SALARYSACRIFICENOTIF'));
                if(!mapCampaignAndCaseList.containsKey(primaryCampaign)){
                    mapCampaignAndCaseList.put(primaryCampaign,new List<Case>());
                }
                mapCampaignAndCaseList.get(primaryCampaign).addAll(lstCaseObj);
            }
        }
        if(!setCaseIdfCP.isEmpty()){
            lstCaseObj = new List<Case> ();
            lstCaseObj = CaseDomain.getCaseFilteredRecord(setCaseIdfCP,true);
            if(!lstCaseObj.isEmpty()){
                Campaign primaryCampaignCP = CampaignDomain.getCampaignRecordByCode(
                                    labelToContentMap.get('CASEPORTALNOTIF'));
                if(!mapCampaignAndCaseList.containsKey(primaryCampaignCP)){
                    mapCampaignAndCaseList.put(primaryCampaignCP,new List<Case>());
                }
                mapCampaignAndCaseList.get(primaryCampaignCP).addAll(lstCaseObj);
            }
        }
        return mapCampaignAndCaseList;
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return the case id
    * @return Boolean - True/False
    * @param objCase - trigger new case id
    * @param oldCaseObj - trigger old case id
    */
    private static Boolean isValidForSalarySacrifice(Case objCase, Case oldCaseObj){
        Boolean isValidToComm = false;
        if((oldCaseObj == null || (objCase.CaseApproved__c != oldCaseObj.CaseApproved__c && 
          (objCase.CaseApproved__c == labelToContentMap.get('APPROVED') || 
          objCase.CaseApproved__c == labelToContentMap.get('CASEREJECTED')))
          ) &&
          objCase.Category__c == labelToContentMap.get('CASECATEGORYPAYANDBASICS') &&           
          objCase.Sub_Category__c == labelToContentMap.get('CASESUBCATSALARYSACRIFICE') && 
          objCase.Origin == labelToContentMap.get('CASEORIGINTEAMHUB') &&
          objCase.TeamHubApplicationType__c == labelToContentMap.get('FORMTABSALARYSACRIFICE')
        )
        {
            isValidToComm = true;
        }
        
        return isValidToComm;
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to return true/false
    * @return Boolean - True/False
    * @param objCase - trigger new case id
    * @param oldCaseObj - trigger old case id
    */
    private static Boolean isValidForCasePortal(Case objCase, Case oldCaseObj){
        Boolean isValidToComm = false;
        List<String> requestOpts = labelToContentMap.get('REQUESTS')?.split(',');
        if((oldCaseObj == null || (oldCaseObj.Status != objCase.Status && 
                                   objCase.Status == 'Closed')
             ) &&
            objCase.Origin == labelToContentMap.get('CASEORIGINTEAMHUB') && 
            objCase.Sub_Category__c != labelToContentMap.get('CASESUBCATSALARYSACRIFICE') &&
            objCase.Sub_Category__c != labelToContentMap.get('SUPERANNUATIONPROCESSING') && 
            objCase.Send_Notification__c != labelToContentMap.get('DONOTSEND') && 
            requestOpts != null && requestOpts.contains(objCase.TeamHubApplicationType__c)
        )
        {
            isValidToComm = true;
        }
        return isValidToComm;
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record and 
    *                update its team member 
    * @param mapPrimaryCampaignAndCaseList - map of primary campaign and case list
    */
    public static void insertCampaignAndMember(
                                        Map<Campaign,List<Case>> mapPrimaryCampaignAndCaseList){
        Map<ID,Case> mapCasObjAndCase = new Map<ID,Case> ();
        Map<String,Id> mapCampaignAndCaseId = new Map<String,Id> ();
        List<Campaign> lstChildCampaign = new List<Campaign>();
        List<CampaignMember> lstCampaignMember = new List<CampaignMember> ();
        
        for(Campaign primaryCampaign :  mapPrimaryCampaignAndCaseList.keySet()){
            for(Case objCaseForCampaign : mapPrimaryCampaignAndCaseList.get(primaryCampaign)){
                Campaign childCampaign = new Campaign(
                    Name = primaryCampaign.Name,
                    ParentId = primaryCampaign.Id,
                    UniqueId__c = String.valueOf(primaryCampaign.id)+
                                                         String.valueOf(objCaseForCampaign.id) +
                                                         system.now()
                );
                lstChildCampaign.add(childCampaign);
                mapCasObjAndCase.put( objCaseForCampaign.Id,objCaseForCampaign);
                mapCampaignAndCaseId.put(childCampaign.UniqueId__c,objCaseForCampaign.id);
            }
        }
        if(!lstChildCampaign.isEmpty()){
            CampaignDomain.dmlOnCampaignRecd(lstChildCampaign,'insert');
            for(Campaign objChildCampaign : lstChildCampaign){
                Case objCase = mapCasObjAndCase.get(
                    mapCampaignAndCaseId.get(objChildCampaign.UniqueId__c));
                
                CampaignMember campaignMember = new CampaignMember();
                campaignMember.CampaignId = objChildCampaign.Id;
                campaignMember.ContactId = objCase.ContactId;
                campaignMember.Case__c   = objCase.Id;
                campaignMember.ClosedCaseComments__c = (objCase.Closed_Case_Comments__c != null &&
                          objCase.Closed_Case_Comments__c != '') ? 
                                    objCase.Closed_Case_Comments__c.left(4000) : '';
                campaignMember.User__c = objCase.RequesterUser__c;
                
                lstCampaignMember.add(campaignMember);
            }
        }
        if(!lstCampaignMember.isEmpty()){
            CampaignMemberDomain.dmlOnCampaignMemberRecd( lstCampaignMember,'insert');
        }
    }
}