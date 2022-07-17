/**
 * @author      Akshansh Jain
 * @company     Cognizant
 * @description This service classk will be work as a controller for peopleInsightPortalRequestDesktop lwc
 */
public with sharing class PeopleInsightPortalRequestService {
    
    /**
    * @author : Akshansh
    * @description : This method is used to fetch picklist options on load.
    * @return : PeopleInsightPortalWrapper
    */
    @AuraEnabled(cacheable=true)
    public static PeopleInsightPortalWrapper getDataOnLoad() {
        PeopleInsightPortalWrapper wrapper = new PeopleInsightPortalWrapper();
        wrapper.mapMetadata = getMetadataRecord();
        wrapper.taskRecordTypeId = getTaskRecordTypeInfoOnLoad();
        wrapper.badgeId = getPDIBadgeId();
        wrapper.accountId=getAccountId();
        wrapper.queryCaseRTId = DescribeSObjectCall.getRecordTypeIdByDeveloperName(
            'Case','PS_Query_Case'
        );
        wrapper.peopleDashboardQueriesFlow = getPeopleDashboardQueryFlowUrl();
        return wrapper;
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to return list of custom metadata 
    * @return : Map<String,String>
    */
    private static Id getPDIBadgeId(){
        List<trailheadapp__Badge__c> lstBadge = 
            [SELECT Id FROM trailheadapp__Badge__c WHERE 
            trailheadapp__API_Name__c='get-started-with-people-data-and-insights'];
        
        return !lstBadge.isEmpty() ? lstBadge[0].Id : null;
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to return list of custom metadata 
    * @return : Map<String,String>
    */
    private static Map<String,String> getMetadataRecord(){
        Map<String,String> mapMetadata = new Map<String,String>();
        Set<String> setDeveloperName = new Set<String> {'INCOMPLETETRAILHEADNOTIFPDI', 
            'CASEORIGINTEAMHUB', 'PDITRAILHEADDEEPLINK', 'SERVICEWOWREQUESTURL','DATAACCESSFINDER'};
        for(CommunityContentInfo__mdt obj : 
            CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName)){
            mapMetadata.put(obj.DeveloperName, obj.Content__c);
        } 
        return mapMetadata;
    }

    /**
    * @author : Akshansh
    * @description : This method is used to fetch UTL recordtype id on load.
    * @return : Id
    */
    private static Id getTaskRecordTypeInfoOnLoad(){
        Id recTypeId = 
            Schema.getGlobalDescribe().get('UniversalTaskList__c').getDescribe().getRecordTypeInfosByDeveloperName(
            ).get('Task').getRecordTypeId();
        return recTypeId;
    }

    /** 
    *@author : Akshansh Jain
    *@description : This wrapper class is used to store inital on Load data
    */
    public class PeopleInsightPortalWrapper{
        @AuraEnabled
        public Map<String,String> mapMetadata;
        @AuraEnabled
        public Id taskRecordTypeId;
        @AuraEnabled
        public Id badgeId;
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String queryCaseRTId;
        @AuraEnabled
        public String peopleDashboardQueriesFlow;
    }


    /**
     * @author      Abhishek Setia
     * @description Returns account id based on logged-in user's EmployeeID__c
     * @return      String
     */
    private static String getAccountId(){
        User usr = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        if(usr != null && String.isNotBlank(usr.EmployeeID__c)){
            List<Account> lstAcc = AccountDomain.getAccounts(usr.EmployeeID__c);
            return lstAcc?.get(0)?.Id;
        }
        return null;
    }

    /**
     * @author      Abhishek Setia
     * @description Returns URL to launch "People Dashboard Queries" flow
     * @return      String
     */
    private static String getPeopleDashboardQueryFlowUrl(){
        Form__c form = FormDomain.getRecordByName('People Dashboard Queries');
        if(form != null){
            return form.RedirectUrl__c + '&pid=' + form.Id;
        }
        return null;
    }
}