/**
*@author : Saurabh Bisht
*@company : SaasFocus
*@description : This class handles the operations DML performed on ContentDocument and its related objects ...
*/
public inherited sharing class ContentDocumentDomain {
    /**
     * @author : Saurabh Bisht
     * @description : This method inserts the ContentDocumentLink records for BigW case recordTypes...
     * @param newDocLinks
     */
    public static void insertContentDocumentLinkForBigW(List<ContentDocumentLink> newDocLinks){
        if(newDocLinks!=null && !newDocLinks.isEmpty()){
            insert newDocLinks;
        }
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query ContentDocument object based on passed record id.
    * @return : ContentDocument
    * @param recordId
    */
    public static ContentDocument getContentDocs(Id recordId){
        return [SELECT Id,Title,FileType
                FROM ContentDocument
                WHERE Id=:recordId
                ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query ContentDocument object based on passed Set of
    *                record ids.
    * @return : List<ContentDocument>
    * @param setRecordIds
    */
    public static List<ContentDocument> getContentDocLinks(Set<Id> setRecordIds){
        return [SELECT Id,Title,FileType 
                FROM ContentDocument 
                WHERE id IN: setRecordIds
                ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method deletes the ContentDocument
    * @param setContentDocumentIds
    */
    public static void deleteContentDocument(Set<Id> setContentDocumentIds){
        if(Schema.sObjectType.ContentDocument.isDeletable()){
            delete [SELECT Id
               FROM ContentDocument
               WHERE Id IN :setContentDocumentIds];
        }
    }
}