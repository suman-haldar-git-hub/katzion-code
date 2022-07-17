/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLs for ContentDocumentLink object
*/
public with sharing class ContentDocumentLinkDomain {
    /**
* @author : Praveen Tiwari
* @description : This method is used to query ContentDocumentLink object based on passed record id.
* @return : List<ContentDocumentLink>
* @param parentRecordId
*/
    public static List<ContentDocumentLink> getContentDocLinks(Id parentRecordId){
        return [SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp
                FROM ContentDocumentLink
                WHERE LinkedEntityId=:parentRecordId
                ORDER BY SystemModstamp DESC
               ];
    }

    /**
* @author : Sumit Banarji
* @param linkedEntityIds
* @param filterContentDocIds
* @return List
* @description : This method is used to Query Content Document Link list
*/
    public static List<ContentDocumentLink> queryRelatedContentDocumentLink(Set<String> linkedEntityIds, Set<Id> filterContentDocIds) {

        return [SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.LatestPublishedVersion.Title
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN: linkedEntityIds
                AND ContentDocumentId NOT IN :filterContentDocIds];
    }

    /**
* @author : Sumit Banarji
* @param contentDocumentLinkData
* @description : This method is used to insert Content Document Link list
*/
    public static void insertContentDocumentLink(List<ContentDocumentLink> contentDocumentLinkData) {
        insert contentDocumentLinkData;
    }

    /**
    * @author : Sunil
    * @description : This method is used to query ContentDocumentLink object based on passed record id set.
    * @return : List<ContentDocumentLink>
    * @param parentRecordId
    */
    public static List<ContentDocumentLink> getContentDocLinks(Set<Id> parentRecordId){
        //Added by Priyanshu. Null check on line 54.
        if(!parentRecordId.isEmpty()){
            return [SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN: parentRecordId
                    ORDER BY SystemModstamp DESC
                   ];
        }else{
            return new List<ContentDocumentLink>();
        }
    }
}