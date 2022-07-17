/*
@Author: Saurabh Bisht
@Company: SaasFocus
@CreatedOn: 01/06/2020
@Description: This trigger deletes the content document record when the platform is fired...
*/
trigger DeleteDocument on Document_Upload__e (after insert) {system.debug('INSIDE TIGGER');
    List<String> docIds;
    for(Document_Upload__e evt : trigger.new){
        docIds = new List<String>();
        docIds = evt.documentID__c.split(',');
    }
    if(docIds!=null && !docIds.isEmpty()){system.debug('INSIDE DELETION');
        delete [SELECT Id FROM ContentDocument WHERE Id IN: docIds];
    }
}