/**
 * @author : Amit Sharma
 * @company : Cognizant
 * @description : This trigger handler is used to handle all events of CaseCommentTrigger.
*/
public with sharing class CaseCommentTriggerHandler extends TriggerHandler {
    private List<Case_Comment__c> triggerNew;
    
    /**
     * @author : Amit Sharma
     * @description : Constructor.
    */
    public CaseCommentTriggerHandler() {
        this.triggerNew = (List<Case_Comment__c>) Trigger.new;
    }
    /**
     * @author : Amit Sharma
     * @description : This trigger handler is used to handle after Insert events of 
     *                 CaseCommentTrigger.
    */
    public override void afterInsert() {
        CaseCommentTriggerService.createChildCampaigRecord(triggerNew);
    }
}