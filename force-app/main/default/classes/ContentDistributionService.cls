/**
* @author : Sunil
* @company : Cognizant
* @description : This class is used to for fetch the public Image URL from ContentDistribution
*/
public with sharing class ContentDistributionService {

    /**
    * @author : Sunil
    * @description : This method is used to fetch KNowledge__kav.
    * @param articleIdSet
    * @return Map<String,String>
    */
    public static Map<String,String> fetchPublicUrl(Set<Id> articleIdSet){
           Map<String, String> mapImageKeyToUrl = new Map<String, String>();
           Map<Id,List<Id>> mapContentDocId =  new Map<Id,List<Id>>(); 
           Set<Id> setConDocId = new set<Id>();
           Map<Id,ContentDistribution> mapDocToConDist =  new Map<Id,ContentDistribution>(); 
           Set<Id> setConVerId =  new Set<Id>(); 
           //Added as ContentDistribution was not returning the image Type
           Map<Id,String> mapDocToImageType =  new Map<Id,String>(); 
           mapLinkedEntityContentDoc(mapContentDocId,setConDocId,articleIdSet);           
           if(setConDocId.size()>0){
                mapContentDocIdImageType(setConDocId,mapDocToImageType,setConVerId);
                for(ContentDistribution cd : ContentDistributionDomain.getContentDistributions(setConVerId)){
                   mapDocToConDist.put(cd.ContentDocumentId, cd);                   
                }                
                for(String knowledgeId : mapContentDocId.keyset()){
                   for(String contentDocId : mapContentDocId.get(knowledgeId)){
                       if(mapDocToConDist.containsKey(contentDocId) && mapDocToImageType.containsKey(ContentDocId)){
                            mapImageKeyToUrl.put(knowledgeId+'-'+mapDocToImageType.get(contentDocId),
                               mapDocToConDist.get(contentDocId).ContentDownloadUrl);
                       }
                   }
               }
           }
        return mapImageKeyToUrl;
    }

    /**
     * @author      Abhishek Setia
     * @description Prepares map of LinkedEntityId, List<Id> ContentDocumentId from ContentDocumentLink
     *              Prepares Set of ContentDocumentId from ContentDocumentLink object.
     * @param       mapContentDocId
     * @param       setConDocId
     * @param       articleIdSet
     */
    private static void mapLinkedEntityContentDoc(
        Map<Id,List<Id>> mapContentDocId,
        Set<Id> setConDocId,
        Set<Id> articleIdSet){        
            for(ContentDocumentLink cdl : ContentDocumentLinkDomain.getContentDocLinks(articleIdSet)){               
                if(mapContentDocId.containsKey(cdl.LinkedEntityId)){
                    mapContentDocId.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
                }else{
                    mapContentDocId.put(cdl.LinkedEntityId,new List<Id>{cdl.ContentDocumentId});
                }
                setConDocId.add(cdl.ContentDocumentId);     
            }            
        }

    /**
     * @author      Abhishek Setia
     * @description Prepares map of ContentDocumentId, ImageType__c from ContentVersion object
     *              Prepares Set of ID's from ContentVersion object.
     * @param       setConDocId
     * @param       mapDocToImageType
     * @param       setConVerId
     */
    private static void mapContentDocIdImageType(
        Set<Id> setConDocId,
        Map<Id,String> mapDocToImageType,
        Set<Id> setConVerId){
            for(ContentVersion conVer : ContentVersionDomain.getContentVersionList(setConDocId)){
                setConVerId.add(conVer.Id);
                mapDocToImageType.put(conVer.ContentDocumentId, conVer.ImageType__c);                
            }
        }
}