/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This trigger is used to Insert or Update CollaborationGroup.
*/
trigger CollaborationGroupTrigger on CollaborationGroup (before insert,before update) {
    new CollaborationGroupTriggerHandler().run('CollaborationGroupTrigger');
}