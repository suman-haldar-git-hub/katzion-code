public without sharing class TransactionTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public TransactionTriggerHelper helper;
    
    public TransactionTriggerHandler (boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new TransactionTriggerHelper();
    }
    public void beforeInsert(List<Transaction__c> newTransactions) {}
    
    public void beforeUpdate(List<Transaction__c> oldTransactions, List<Transaction__c> newTransactions, Map<ID, SObject> oldTransactionMap, Map<ID, SObject> newTransactionMap) {}
    
    public void beforeDelete(List<Transaction__c> oldTransactions, Map<ID, SObject> oldTransactionMap) {}
    
    public void afterInsert(List<Transaction__c> newTransactions, Map<ID, SObject> newTransactionMap) {
        List<TransactionDataPayload> listTransactionPayloads = new List<TransactionDataPayload>();
        for(Transaction__c t: newTransactions){
            listTransactionPayloads.add(new TransactionDataPayload(t));
        }
        helper.transactionAPICallHelper(String.valueOf(listTransactionPayloads[0]));
    }
    
    public void afterUpdate(List<Transaction__c> oldTransactions, List<Transaction__c> newTransactions, Map<ID, SObject> oldTransactionMap, Map<ID, SObject> newTransactionMap) {}
    
    public void afterDelete(List<Transaction__c> oldTransactions, Map<ID, SObject> oldTransactionMap) {}
    
    public void afterUndelete(List<Transaction__c> newTransactions, Map<ID, SObject> newTransactionMap) {}
}