/**
* @Author : Amit Sharma
* @Company : Cognizant
* @description : This trigger is used to Insert or Update Case Comment.
*/
trigger CaseCommentTrigger on Case_Comment__c (after insert) {
    new CaseCommentTriggerHandler().run('CaseCommentTrigger');
}