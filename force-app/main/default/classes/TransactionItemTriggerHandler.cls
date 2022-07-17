public without sharing class TransactionItemTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public TransactionItemTriggerHelper helper;
    
    public TransactionItemTriggerHandler (boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new TransactionItemTriggerHelper();
    }
    public void beforeInsert(List<Transaction_Item__c> newTransactionItems) {}
    
    public void beforeUpdate(List<Transaction_Item__c> oldTransactionItems, List<Transaction_Item__c> newTransactionItems, Map<ID, SObject> oldTransactionItemMap, Map<ID, SObject> newTransactionItemMap) {}
    
    public void beforeDelete(List<Transaction_Item__c> oldTransactionItems, Map<ID, SObject> oldTransactionItemMap) {}
    
    public void afterInsert(List<Transaction_Item__c> newTransactionItems, Map<ID, SObject> newTransactionItemMap) {
        List<TransactionItemDataPayload> listTransactionItemPayloads = new List<TransactionItemDataPayload>();
        for(Transaction_Item__c t: newTransactionItems){
            listTransactionItemPayloads.add(new TransactionItemDataPayload(t));
        }
        helper.transactionAPICallHelper(String.valueOf(listTransactionItemPayloads));
    }
    
    public void afterUpdate(List<Transaction_Item__c> oldTransactionItems, List<Transaction_Item__c> newTransactionItems, Map<ID, SObject> oldTransactionItemMap, Map<ID, SObject> newTransactionItemMap) {}
    
    public void afterDelete(List<Transaction_Item__c> oldTransactionItems, Map<ID, SObject> oldTransactionItemMap) {}
    
    public void afterUndelete(List<Transaction_Item__c> newTransactionItems, Map<ID, SObject> newTransactionItemMap) {}
}