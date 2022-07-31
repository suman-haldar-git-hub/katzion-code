public without sharing class TransactionItemTriggerHelper {
    
    public TransactionItemTriggerHelper() {
        // This is the class constructor
    }    
    
    public void transactionAPICallHelper(String jsonRequestBody){
        APICallHelper.doAPICall(jsonRequestBody, EnvironmentContants.TRANSACTION_ITEM_API_CALL_END_POINT);
    }
}
