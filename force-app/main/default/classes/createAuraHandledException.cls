/************************************************************
* Author    :   Sekar Krishnan
* Purpose   :   To throw custom exception messages to LeX components
* Created Date  :   08-04-2019
* Modified By   :   Sekar Krishnan - 08-04-2019
* Changes Made  : 
* *********************************************************/

public class createAuraHandledException extends Exception {
    public static AuraHandledException createException(String Message){
        AuraHandledException e = new AuraHandledException(Message);
        String errorMsg = '';
        List<String> msgList = Message.split(',');
        if (!msgList.isEmpty()){
            for (integer i=0 ; i<msgList.size(); i++){
                if (i != 0){
                    if(errorMsg == ''){
                        errorMsg += msgList[i];
                    }else{
                        errorMsg += ', ' + msgList[i];
                    }                   
                }
            }
        }
        e.setMessage(errorMsg);
        
        return e; 
    }
}