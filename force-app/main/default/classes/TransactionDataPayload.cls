public class TransactionDataPayload{

    public Key keys {get; set;}
    public Value values {get; set;}
    
    private class Key{
        private String TransactionID {get; set;}
        
        private Key(Transaction__c transactionRecord){
            this.TransactionID = transactionRecord.Id;
        }
    }
    
    private class Value{
        private String TotalCost {get; set;}
        private String TotalDiscount {get; set;}
        private String TransactionDate {get; set;}
        
        private Value(Transaction__c transactionRecord){
            this.TotalCost = String.valueOf(transactionRecord.Total_Cost__c);
            this.TotalDiscount = String.valueOf(transactionRecord.Total_Discount__c);
            this.TransactionDate = String.valueOf(transactionRecord.Transaction_Date__c);
        }
    }
    
    public TransactionDataPayload(Transaction__c transactionRecord){
        this.keys = new Key(transactionRecord);
        this.values = new Value(transactionRecord);
    }
}
