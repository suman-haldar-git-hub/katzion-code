/**
*@author : Ashish Singh
*@company : Cognizant
*@description : This class provides generic method which can be referred in other functionalities
*/
public inherited sharing class UtilityClass{

        /**
         * @author : Ashish Singh
         * @description : This method checks for sandbox 
         * @return : Boolean
         */
    public static Boolean runningInASandbox{
        get {
            if (runningInASandbox == null) {
                runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            }
            return runningInASandbox;
        }
        set;
    }
         /**
         * @author : Ashish Singh
         * @description : This method is for creating ContentDocumentLink 
         * @return : ContentDocumentLink
         * @param parentRecordId
         * @param contentDocumentId
         */
    public static ContentDocumentLink createContentDocumentLink(String parentRecordId, String contentDocumentId){
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = parentRecordId;    
        cdl.ContentDocumentId = contentDocumentId;
        cdl.ShareType = 'V';
        return cdl;
    }

}