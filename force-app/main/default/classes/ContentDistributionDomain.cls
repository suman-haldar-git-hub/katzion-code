/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLs for ContentDistribution object
*/
public with sharing class ContentDistributionDomain {
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query ContentDistribution object based on passed record id.
    * @return : ContentDistribution
    * @param contentDocId
    */
    public static ContentDistribution getContentDistribution(Id contentDocId){
        return [SELECT Id, DistributionPublicUrl,
                ContentDownloadUrl
                FROM ContentDistribution
                WHERE Id = :contentDocId
                LIMIT 1
                ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to insert ContentDistribution object.s
    * @param conDistributionRec
    */
    public static void insertContentDistribution(ContentDistribution conDistributionRec){
        Database.insert(conDistributionRec);
    }
    /**
    * @author : Sunil
    * @description : This method is used to query ContentDistribution object based on passed record id.
    * @return : List<ContentDistribution>
    * @param contentVerId
    */
    public static List<ContentDistribution> getContentDistributions(Set<Id> contentVerId){
        return [SELECT Id, ContentDocumentId, DistributionPublicUrl, 
                ContentDownloadUrl
                FROM ContentDistribution
                WHERE ContentVersionId IN: contentVerId
               ];
    }
}