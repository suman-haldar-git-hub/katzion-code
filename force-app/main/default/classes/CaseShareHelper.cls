/**
* @author : Akshansh
* @company : Cognizant
* @description : This service class is used to write a code for case trigger handler
*/
public without sharing class CaseShareHelper {
    
    /**
    * @author : Akshansh Jain  
    * @description : This method is used to share Case record with creator
    * @param lstCase 
    */  
    public static Void shareCaseWithCreator(List<Case> lstCase){
        List<Id> userId = new List<Id>();
        Map<Id, String> mapUserProfile = new Map<Id, String>();
        try{
            for(Case objCase : lstCase) {
                if(objCase.RequesterUser__c != null && objCase.Origin == 'TeamHub') {
                    userId.add(objCase.RequesterUser__c);
                }
            }
            for(User obj : UserDomain.getUsersProfile(userId)) {
                mapUserProfile.put(obj.Id, obj.Profile.Name);
            }
            List<Case> filteredCase = filterCaseForSysAdmin(lstCase, mapUserProfile);
            Set<String> setDeveloperName = new Set<String>{'ALLOWEDPROFILEFORCASESHARE'};
            List<CommunityContentInfo__mdt> communityInfo = 
                CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName);
            Set<String> profileForCaseShare = new Set<String>();
            for(String str : communityInfo[0].Content__c.split(',')) {
                profileForCaseShare.add(str);
            }
            List<CaseShare> caseShareToInsert = new List<CaseShare>();
            for(Case objCase : filteredCase) {
                CaseShare obj = new CaseShare();
                obj.CaseAccessLevel = 'Edit';
                obj.CaseId = objCase.Id;
                obj.RowCause = 'Manual';
                if(
                    objCase.RequesterUser__c != null &&
                    profileForCaseShare.contains(mapUserProfile.get(objCase.RequesterUser__c))
                ) {
                    obj.UserOrGroupId = objCase.RequesterUser__c;
                }
                caseShareToInsert.add(obj);
            }
            insert caseShareToInsert;
        }
        catch(Exception ex) {
            system.debug('==ex==='+ex);
            PublishLogEventService.publishExceptionEvent(
                'CommonFlowComponentService.cls on getDeviceData',
                ex
            );
        }
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to return the CaseShare record
    * @return List<Case>
    * @param lstCase
    * @param mapUserProfile
    */
    private static List<Case> filterCaseForSysAdmin(List<Case> lstCase, Map<Id, String> mapUserProfile) {
        List<Case> filteredCase = new List<Case>();
        for(Case objCase : lstCase) {
            if(objCase.RequesterUser__c != null && mapUserProfile.get(objCase.RequesterUser__c) != 'System Administrator') {
                filteredCase.add(objCase);
            }
        }
        return filteredCase;
    }
}