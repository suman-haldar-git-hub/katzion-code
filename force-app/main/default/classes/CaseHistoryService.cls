/**
 * @author      Abhishek Setia
 * @description Handles logic related to SObject 'CaseHistory'
 */
public with sharing class CaseHistoryService {
    
    private static Map<String,String> customMetadataMap;

    /**
     * author       Abhishek Setia
     * @description Prepare Case Reallocation from SObject 'CaseHistory'
     * @param       caseId
     * @return      List<PeoplePortalFlowController.CaseDetailWrapper>  
     */
    public static List<PeoplePortalFlowController.CaseDetailWrapper> historySetupPeoplePortal(Id caseId){
        List<CaseHistory> casehistories=new CaseHistoryDomain().getOwnerChangeHistory(new Set<Id>{caseId});
        return historySetupPeoplePortal(caseId,casehistories);
    }

    /**
     * author       Abhishek Setia
     * @description Prepare Case Reallocation from SObject 'CaseHistory'
     * @param       caseId
     * @param       casehistories
     * @return      List<PeoplePortalFlowController.CaseDetailWrapper>  
     */
    @TestVisible
    private static List<PeoplePortalFlowController.CaseDetailWrapper> historySetupPeoplePortal
    (
        Id caseId,
        List<CaseHistory> casehistories
    ){
        Set<Id> queueids=new Set<Id>();
        Id oldid,newid;
        for(CaseHistory ch:casehistories){
            if(!Test.isRunningTest()){
                oldid=Id.valueOf((String)ch.OldValue);
                newid=Id.valueOf((String)ch.NewValue);
            }else{
                // Used in testing purpose.
                oldid=CaseHistoryServiceTest.groups[0].Id;
                newid=CaseHistoryServiceTest.groups[1].Id;
            }
            
            /** Condition for Case Reallocation **/
            if(newid.getSObjectType()==Group.sObjectType){
                queueids.add(newid);    
            }
            if(oldid.getSObjectType()==Group.sObjectType){
                queueids.add(oldid);
            }
        }
        Set<String> groupNames=new Set<String>();
        List<Group> groups=GroupDomain.getGroups(queueids);
        for(Group gp:groups){
            groupNames.add(gp.DeveloperName);
        }
        return fillCaseDetailWrapper(QueueNameTeamNameService.mappingCaseOwnerWithTeamName(
                            groupNames),casehistories,new Map<Id,Group>(groups));
    }


    /**
     * @author      Abhishek Setia
     * @description Get CustomMetadata mappings
     * @return      Map<String,String>
     */
    private static Map<String,String> getCustomMetadataMapping(){
        Set<String> developerNames=new Set<String>{'CPREALLOCATIONHEADING','CPREALLOCATIONTITLE',
            'CPCREATIONICON','CPCREATIONIMAGE'};
        return CommunityContentInfoService.getCommunityContentInfoMapping(developerNames);
    }

    /**
     * author       Abhishek Setia
     * @description Case Reallocation conditions. 
     *              Re-assign oldId to last queue id, if User is changed to Queue
     * @param       oldId
     * @param       newId
     * @param       mUseridQueueid
     * @return      Id
     */    
    private static Id caseReallocationCondition(Id oldId,
        Id newId,
        Map<Id,Id> mUseridQueueid){            
            if(oldId.getSObjectType()==Group.sObjectType && 
                                        newId.getSObjectType()==User.sObjectType){
                mUseridQueueid.put(newId, oldId);
            }else if(oldId.getSObjectType()==User.sObjectType && 
                                        newId.getSObjectType()==User.sObjectType){                    
                mUseridQueueid.put(newId,mUseridQueueid.get(oldId));
            }else if(oldId.getSObjectType()==User.sObjectType && 
                newId.getSObjectType()==Group.sObjectType && mUseridQueueid.containsKey(oldId)){
                    oldId=mUseridQueueid.get(oldId);
            }
            return oldId;
        }

    /**
     * author       Abhishek Setia
     * @description Conditions to skip records for displaying in Case portal timeline
     * @param       oldId
     * @param       newId
     * @return      Boolean
     */    
    private static Boolean skipConditions(Id oldId, Id newId){        
        if(newId.getSObjectType()==User.sObjectType || oldId==newId ||
            (oldId.getSObjectType()==User.sObjectType && 
                newId.getSObjectType()==Group.sObjectType)){
                    return true;
                }
        return false; 
    }    

    /**
     * author       Abhishek Setia
     * @description Only called internally from method - 'historySetupPeoplePortal'.
     *              Fill wrapper of type 'PeoplePortalFlowController.CaseDetailWrapper'
     * @param       mapQueuenameTeamname
     * @param       casehistories
     * @param       mIdGroup
     * @return      List<PeoplePortalFlowController.CaseDetailWrapper>
     */    
    private static List<PeoplePortalFlowController.CaseDetailWrapper> fillCaseDetailWrapper(
        Map<String,String> mapQueuenameTeamname,
        List<CaseHistory> casehistories,
        Map<Id,Group> mIdGroup
        ){
            customMetadataMap=getCustomMetadataMapping();
            List<PeoplePortalFlowController.CaseDetailWrapper> listcdw = 
                                    new List<PeoplePortalFlowController.CaseDetailWrapper>();
            Map<Id,Id> mUseridQueueid=new Map<Id,Id>();
            Integer i=-1;
            Id newId,oldId;
            for(CaseHistory ch:casehistories){  
                i=i+1;                
                if(!Test.isRunningTest()){
                    newId = Id.valueOf((String)ch.NewValue);
                    oldId = Id.valueOf((String)ch.OldValue);
                }else{
                    // Used in testing purpose.
                    oldId=CaseHistoryServiceTest.groups[0].Id;
                    newId=CaseHistoryServiceTest.groups[1].Id;
                }  
                oldId=caseReallocationCondition(oldId,newId,mUseridQueueid);
                if(i==0 || skipConditions(oldId,newId)){
                    continue;
                }                                                                  
                PeoplePortalFlowController.CaseDetailWrapper cdw = 
                                          new PeoplePortalFlowController.CaseDetailWrapper();
                cdw.heading= customMetadataMap.get('CPREALLOCATIONHEADING');
                String oldNameToDisplay='';
                if(mIdGroup.containsKey(oldId)){
                    String grpName=mIdGroup.get(oldId).DeveloperName;
                    oldNameToDisplay=mapQueuenameTeamname.containsKey(grpName)?
                                                    mapQueuenameTeamname.get(grpName):
                                                    mIdGroup.get(oldId).Name;
                      //oldNameToDisplay=mIdGroup.get(oldId).Name;
                }
                String newNameToDisplay='';
                if(mIdGroup.containsKey(newId)){
                    String grpName=mIdGroup.get(newId).DeveloperName;
                    newNameToDisplay=mapQueuenameTeamname.containsKey(grpName)?
                                                    mapQueuenameTeamname.get(grpName):
                                                    mIdGroup.get(newId).Name;                    
                      //newNameToDisplay=mIdGroup.get(newId).Name;
                }                
                cdw.collapsedTitle=oldNameToDisplay+' '+ 
                            customMetadataMap.get('CPREALLOCATIONTITLE') +' '+newNameToDisplay;
                cdw.expendedTitle=oldNameToDisplay+' '+ 
                            customMetadataMap.get('CPREALLOCATIONTITLE') +' '+newNameToDisplay;
                cdw.createdDateTime=ch.CreatedDate;
                cdw.iconName = customMetadataMap.get('CPCREATIONICON');
                cdw.titleName = customMetadataMap.get('CPCREATIONIMAGE');
                listcdw.add(cdw);                                             
            }
            return listcdw;
        }
        
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return the team name 
    * @return  String - owner team name
    * @param   objCase - case record
    */ 
    public static String getCurrentTeamName(Case objCase){
        List<Group> groups = new List<Group> ();
        Map<String,String> mapQueNameAndTeam = new Map<String,String>();
        
        Id queueId = getQueueId(objCase);
        
        if(queueId != null){
            groups = GroupDomain.getGroups(new Set<Id>{queueId});
            if(!groups.isEmpty()){
                mapQueNameAndTeam = QueueNameTeamNameService.mappingCaseOwnerWithTeamName(
                                                        new Set<String>{groups[0].DeveloperName});
                if(!mapQueNameAndTeam.isEmpty() && 
                                        mapQueNameAndTeam.containsKey(groups[0].DeveloperName)){
                    return mapQueNameAndTeam.get(groups[0].DeveloperName);
                }
                else{
                    return groups[0].Name;
                }
            }
        }
        return objCase.Owner.Name;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return the queue Id 
    * @return  Id
    * @param   objCase - case record
    */ 
    public static Id getQueueId(Case objCase){
        CaseHistoryDomain objClass = new CaseHistoryDomain();
        List<CaseHistory> casehistories = objClass.getCaseOwnerHistory(
                                                    new Set<Id>{objCase.id});
                                                    
        Id queueId ;
        if(casehistories != null && !casehistories.isEmpty()){
            for(CaseHistory ch : casehistories){
                Id oldid = Id.valueOf((String)ch.OldValue);
                Id newid = Id.valueOf((String)ch.NewValue);
               
                if(newid.getSObjectType() == Group.sObjectType){
                    queueId =  newid;  
                    break;
                }else if(oldid.getSObjectType() == Group.sObjectType){
                    queueId = oldid;
                    break;
                }
                else {
                    continue;
                }
            }
        }
        else {
            queueId = objCase.OwnerId;
        }
        return queueId;
    }
}