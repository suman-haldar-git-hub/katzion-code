/*
    Author:             Jerome To
    Created Date:       JUNE 23, 2015 
    Brief:              Case Trigger 
    Description:        Case Trigger that has functionality on before insert and before Update

    Visualforce Page:   N/A
    Test Class:         N/A
    Apex Class:         CaseTriggerHandler.cls   
    Version Control:    v1.0

    @Revision History:  N/A

*/

trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        CaseTriggerHandler.updateTotalTime(Trigger.new);
        if(Trigger.isInsert) {
            CaseTriggerHandler.synchAccountAndContactName(trigger.new);// Before insert trigger that triggers when cloning a case
            CaseTriggerHandler.setPriority(Trigger.new);       
        }
        CaseTriggerHandler.updateSubCatAndReason(Trigger.new,Trigger.IsInsert,Trigger.IsUpdate);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        CaseTriggerHandler.afterUpdate(Trigger.new, trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        CaseTriggerHandler.afterInsert(Trigger.new);
    }
    
    
    if(Trigger.isBefore && Trigger.isUpdate){
        CaseTriggerHandler.updateContactName(Trigger.new);
        CaseTriggerHandler.synchAccountAndContactName(trigger.oldMap,trigger.newMap);
        CaseTriggerHandler.beforeUpdate(Trigger.new, trigger.oldMap);
    }
    
    // Before Update trigger to validate either Account Verified or Account Verified N/A is checked.
    // This validation was being triggered on new case as well due to recurssion, To avoid this new Before update block is introduced.
    if(CaseTriggerHandler.runOnce()){
        if(Trigger.isBefore && Trigger.isUpdate){
            CaseTriggerHandler.accountCheck(Trigger.new,  Trigger.oldMap);
        }  
    }
}