/**
* @author : Sunil
* @company : Cognizant
* @description : This service class is used to write a code for case trigger handler
*/
public without sharing class CaseTriggerService{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta(); 
    
    /**
    * @author : Sunil
    * @description : This method is used to create sharing at case owner changed
    * @param triggerNew - trigger new case list
    * @param oldMap - trigger old map of case
    */
    Public static Void shareCase(List<Case> triggerNew, Map<Id,Case> oldMap){
        try{
            Set<Id> caseIds = new Set<Id>();
            for(Case record: triggerNew){
                if(record.OwnerId != oldMap.get(record.Id).OwnerId){
                    caseIds.add(record.Id);}
            }
            if(!System.isBatch()){
                Persistence.persistSharing(
                JSON.serialize(
                    [SELECT Id, CaseAccessLevel, CaseId, RowCause, UserOrGroupId
                    FROM   CaseShare
                    WHERE  CaseId IN :caseIds AND
                            RowCause = 'Manual']));
            }
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'CaseSharingHelper class in ShareCase method',
                ex
            );
        }
    }

    /**
    * @author : Akshansh Jain  
    * @description : This method is used to share Case record with creator
    * @param lstCase 
    */  
    public static Void shareCaseWithCreator(List<Case> lstCase){
        CaseShareHelper.shareCaseWithCreator(lstCase);
    }
}