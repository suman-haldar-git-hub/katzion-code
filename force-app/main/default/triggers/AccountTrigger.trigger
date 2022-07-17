/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This trigger is used to Insert or Update Account.
*/
trigger AccountTrigger on Account(before insert,before update, after insert, after update) {
    new AccountTriggerHandler().run('AccountTrigger');
}