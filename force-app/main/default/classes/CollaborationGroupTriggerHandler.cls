/**
 * @author : Ankit Singh
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of CollaborationGroupTrigger.
*/
public with sharing class CollaborationGroupTriggerHandler extends TriggerHandler{
    /**
    * @author : Ankit Singh
    * @description : This trigger handler is used to handle after Insert
    * events of CollaborationGroupTrigger.
    */
    public override void beforeInsert() {
        blockCreationOfPublicGroup((List<CollaborationGroup>) Trigger.new, null);
    }
    /**
    * @author : Ankit Singh
    * @description : This trigger handler is used to handle after Update
    * events of CollaborationGroupTrigger.
    */
    public override void beforeupdate() {
        blockCreationOfPublicGroup(
                (List<CollaborationGroup>) Trigger.new,
                (Map<Id, CollaborationGroup>) Trigger.oldMap
        );
    }
    /**
    * @author : Ankit Singh
    * @description : Block user from creation of Public group for all Profile except BU and CT
    * @param collaborationList
    * @param triggerOldMap
    */
    public void blockCreationOfPublicGroup(
        List<CollaborationGroup> collaborationList,
        Map<Id, CollaborationGroup> triggerOldMap
    ) {
        Map<String, String> labelToContentMap = CommunityContentInfoService.getMappingFromMetadeta();
        String loggedInUserProfile = UserDomain.queryLoggedInUserProfileName();
        String[] allowedProfileForPublicGroup = (FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLALLOWEDPROFILE')).PublicGroupCreationProfile__c
        ).split(',');
        Boolean isValidProfile = allowedProfileForPublicGroup.contains(loggedInUserProfile);
        for(CollaborationGroup eachGroup : collaborationList) {
            if(isValid(eachGroup,triggerOldMap) && !isValidProfile
            ) {
                eachGroup.addError(
                    labelToContentMap.get('COLLABORATIONGROUPCREATIONMESSAGE')
                );
            }
            else if(isValid(eachGroup,triggerOldMap) && isValidProfile &&
                eachGroup.CollaborationType == labelToContentMap.get('COLLABORATIONGROUPTYPEPUBLIC')
            ) {
                eachGroup.addError(
                    labelToContentMap.get('PRIVATEGROUPCREATIONMESSAGE')
                );
            }
        }
    }

    /**
    * @author : Ankit Singh
    * @description : is Valid for execution
    * @param eachGroup
    * @param triggerOldMap
    * @return true
    */
    public Boolean isValid(
        CollaborationGroup eachGroup,
        Map<Id, CollaborationGroup> triggerOldMap
    ) {
        if(
            Trigger.isInsert
            ||
            (
                Trigger.isUpdate
                &&
                eachGroup.CollaborationType !=
                triggerOldMap.get(eachGroup.Id).CollaborationType
            )
        ) {
            return true;
        }
        return false;
    }
}