public class TransactionItemDataPayload{

    public Key keys {get; set;}
    public Value values {get; set;}
    
    private class Key{
        private String TransactionItemID {get; set;}
        
        private Key(Transaction_Item__c transactionItemRecord){
            this.TransactionItemID = transactionItemRecord.Id;
        }
    }
    
    private class Value{
        private String ItemCost {get; set;}
        private String ItemName {get; set;}
        
        private Value(Transaction_Item__c transactionItemRecord){
            this.ItemCost = String.valueOf(transactionItemRecord.Item_Cost__c);
            this.ItemName = transactionItemRecord.Name;
        }
    }
    
    public TransactionItemDataPayload(Transaction_Item__c transactionItemRecord){
        this.keys = new Key(transactionItemRecord);
        this.values = new Value(transactionItemRecord);
    }
}
