/**
 * @author : Tintu Babu
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of User Object.
 *                Due to Internal Server ERROR , The Scenario of before insert updating user setting didnt incorporated in Flow 
 * 				  and chose Trigger    
*/
public with sharing class UserTriggerHandler extends TriggerHandler{
    /**
    * @author : Tintu Babu
    * @description : This trigger handler is used to handle after 
    * Insert events of UserTriggerHandler.ECICD-1349
    */
    public override void beforeInsert() {
        UserService.uncheckUserSettings((List<User>) Trigger.new,
                                                (Map<Id,User>) Trigger.oldMap);
    }
    /**
    * @author :Tintu Babu
    * @description : This trigger handler is used to handle after 
    * Update events of UserTriggerHandler.ECICD-1349
    */
    public override void beforeUpdate() {
        UserService.uncheckUserSettings((List<User>) Trigger.new,
                                                (Map<Id,User>) Trigger.oldMap);
    }
    
  

}