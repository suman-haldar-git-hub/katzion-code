/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLs for ContentVersion object
*/
public with sharing class ContentVersionDomain {
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query ContentVersion object based on passed record id.
    * @return : ContentVersion
    * @param contentDocId
    */
    public static ContentVersion getContentVersion(Id contentDocId){
        return [SELECT Id, Title, ImageType__c, PublicURL__c
                FROM ContentVersion
                WHERE ContentDocumentId = :contentDocId
                ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query ContentVersion object based on passed Set of 
    * ContentDocument ids.
    * @return : ContentVersion
    * @param contentDocSetId
    */
    public static List<ContentVersion> getContentVersionList(Set<Id> contentDocSetId){
        return [SELECT Id, Title, ImageType__c, PublicURL__c,ContentDocumentId,CreatedDate,FileType
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocSetId
                ORDER BY SystemModstamp DESC
                ];
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to query ContentVersion object based on passed Set of 
    * ContentDocument ids.and apply the filter with current user
    * @return : ContentVersion
    * @param contentDocSetId
    * @param currentUserId
    */
    public static List<ContentVersion> getContentVersionOfCurrentUse(Set<Id> contentDocSetId, 
                                                                                Id currentUserId){
        return [SELECT Id, Title, ImageType__c, PublicURL__c,ContentDocumentId,CreatedDate,FileType
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocSetId AND OwnerId =: currentUserId
                ORDER BY SystemModstamp DESC
                ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to updates ContentVersion object.
    * @param conVersionRec
    */
    public static void updateContentVersion(ContentVersion conVersionRec){
        if(Schema.sObjectType.ContentVersion.isUpdateable()){
            Database.update(conVersionRec);
        }
    }

    /**
    * @author : Sumit Banarji
    * @description : This method is used to version data from ContentVersion object.
    * @param contentDocSetId
    * @return List<ContentVersion>
    */
    public static List<ContentVersion> getVersionData(Set<String> contentDocSetId){
        return [SELECT ContentDocumentId, VersionData, Title, ContentSize, FileExtension 
                    FROM ContentVersion 
                    WHERE ContentDocumentId in: contentDocSetId];
    }
}