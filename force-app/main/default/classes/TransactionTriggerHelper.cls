public without sharing class TransactionTriggerHelper {
    
    public TransactionTriggerHelper() {
        // This is the class constructor
    }
    
    public void transactionAPICallHelper(String jsonRequestBody){
        APICallHelper.doAPICall(jsonRequestBody, EnvironmentContants.TRANSACTION_API_CALL_END_POINT);
    }    
}