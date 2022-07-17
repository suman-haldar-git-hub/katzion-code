/**
* @author : Ankit Singh
* @company : Cognizant
* @description : This class will be act as a service class for any operation on Communication__c
*/
public with sharing class CommunicationService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Ankit Singh
    * @description : This method use to get Audience List
    * @param multiSelectLookupIds
    * @param audienceDataMap
    * @param audienceList
    * @return : audienceList
    */
    public static List<Audience__c> getAudienceList(
        List<Id> multiSelectLookupIds,
        Map<String, String> audienceDataMap,
        List<Audience__c> audienceList
    ) {
        String childCampaignName = audienceDataMap.get('childCampaignName');
        String primaryCampaignName = audienceDataMap.get('primaryCampaignName');
        String type = audienceDataMap.get('type');
        Id communicationRecordId = Id.valueOf(audienceDataMap.get('communicationRecordId'));
        for(Id recId : multiSelectLookupIds){
            if(recId.getSObjectType().getDescribe().getName().equals('DistributionList__c')){
                    audienceList.add(
                            new Audience__c(
                                    DistributionList__c = recId,
                                    Communication__c = communicationRecordId//,
                                    //Name =
                                    //primaryCampaignName + ' child audience distribution'
                            )
                    );
            }
            else{
                audienceList.add(
                        new Audience__c(
                                Contact__c = recId,
                                Communication__c = communicationRecordId//,
                                //Name =
                                //primaryCampaignName + ' child audience contact'
                        )
                );
            }
        }
        return audienceList;
    }
    /**
    * @author : Monika Bist
    * @description : delete all child for Communication Type
    * @param listAudience
    * @param campaignContentList
    * @param campaignObj
    */
    public static void deleteCommunicationChild(
        List<Audience__c> listAudience,
        List<CampaignContent__c> campaignContentList,
        Campaign campaignObj
    ) {
        if(listAudience != null && !listAudience.isEmpty()) {
            delete listAudience;
        }
        if(campaignContentList != null && !campaignContentList.isEmpty()) {
            delete campaignContentList;
        }
        if(campaignObj != null) {
            delete campaignObj;
        }
    }
    /**
    * @author : Ankit Singh
    * @description : validate of child communication is present for UTL Action
    * @param communicationObj
    * @return : isValid
    */
    public static Boolean hasChildCommunication(
        Communication__c communicationObj
    ) {
        Boolean isValid = false;
        if(
                String.isNotBlank(communicationObj.Type__c)
                &&
                communicationObj.Type__c == labelToContentMap.get('TYPEUTLACTION')
                &&
                communicationObj.Communications__r != null
                &&
                !communicationObj.Communications__r.isEmpty()
        ) {
            isValid = true;
        }
        return isValid;
    }
    /**
    * @author : Ankit Singh
    * @description : check if type is Communication or not
    * @param communicationObj
    * @return : isValid
    */
    public static Boolean isCommunicationType(
        Communication__c communicationObj
    ) {
        Boolean isValid = false;
        if(
                String.isBlank(communicationObj.Type__c)
                ||
                (
                    String.isNotBlank(communicationObj.Type__c)
                    &&
                    communicationObj.Type__c == labelToContentMap.get('TYPECOMMUNICATION')
                )
        ) {
            isValid = true;
        }
        return isValid;
    }
}