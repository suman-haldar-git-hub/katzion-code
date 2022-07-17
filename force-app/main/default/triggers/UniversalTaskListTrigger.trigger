/**
* @Author : Monika Bisht
* @Company : Cognizant
* @description : This trigger is used to Insert or Update UTL.
*/
trigger UniversalTaskListTrigger on UniversalTaskList__c (before insert,before update, after insert, after update) {
    new UniversalTaskListTriggerHandler().run('UniversalTaskListTrigger');
}