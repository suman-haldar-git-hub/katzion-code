/**
 * @author : Tintu Babu
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of User Object.
 *                Due to Internal Server ERROR , The Scenario of before insert updating user setting didnt incorporated in Flow 
 * 				  and chose Trigger    
*/
trigger UserTrigger on User (before insert, before update) {

 new UserTriggerHandler().run('UserTrigger');

}