/**
* @author : Anubha Billore
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLS for CampaignContent object
*/
public with sharing class CampaignContentDomain {
    /**
* @author : Anubha Billore
* @description : This method is used to query CampaignContent object based on passed record id.
* @return : List<CampaignContent__c>
* @param articleId
*/
    public static List<CampaignContent__c> getArchiveArticle(String articleId) {
        return [SELECT Id, Name, Campaign__c, KnowledgeArticle__c 
                FROM CampaignContent__c 
                WHERE KnowledgeArticle__c = :articleId 
                LIMIT 5000];
    }
    
     /**
* @author : Monika Bisht
* @description : This method is used to query CampaignContent object based on passed set of id.
* @return : List<CampaignContent__c>
* @param setOfCampaign
*/
    public static List<CampaignContent__c> getCampOfComm(set<id> setOfCampaign) {
        return [select id,Campaign__c,Campaign__r.Name,KnowledgeArticle__r.id,
                    KnowledgeArticle__r.Title from CampaignContent__c where Campaign__c =: setOfCampaign];
    }
    
    /**
* @author : Monika Bisht
* @description : This method is used to query CampaignContent object based on passed campaign id.
* @return : List<CampaignContent__c>
* @param objCamaign
*/
    public static List<CampaignContent__c> getCampContentBasedOnCampaign(String objCamaign) {
        return [SELECT Id,Campaign__c,KnowledgeArticle__r.id,
                    KnowledgeArticle__r.Title,
                    KnowledgeArticle__r.Public_Article_Subject__c,
                    KnowledgeArticle__r.CurrentUserName__c,
                    KnowledgeArticle__r.PublisherFirstName__c,
                    KnowledgeArticle__r.RecordTypeName__c
                FROM CampaignContent__c 
                WHERE Campaign__c =: objCamaign];
    }
    /**
* @author : Daksh Madan
* @description : This method is used to insert CampaignContent__c Record List.
* @param campaignContentList
* @param operation
*/
    public static void dmlOnCampaignContentList(List<CampaignContent__c> campaignContentList,
    String operation){
        if(operation.equalsIgnoreCase('insert')){
            insert campaignContentList;
        }
        //please uncomment the following code in case of update.
        /*
        else if(operation.equalsIgnoreCase('update')){
            update campaignContentList;
        }*/
    }
}