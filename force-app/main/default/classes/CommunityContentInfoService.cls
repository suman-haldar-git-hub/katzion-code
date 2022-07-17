/**
* @author : Monika Bisht
* @company : SaaSFocus A Cognizant Company
* @description : .
*/
public without sharing class CommunityContentInfoService {

    
    /**
    * @author : Monika Bisht
    * @description : This method is get content mapping using custom metadeta
    * @return Map<String, String>
    */
    public static Map<String, String> getMappingFromMetadeta() {
        List<CommunityContentInfo__mdt> lstCompanyContentMapping = new
                List<CommunityContentInfo__mdt>();
        lstCompanyContentMapping = CommunityContentInfoDomain.queryCommunityContentInfo();
        Map<String, String> labelAndContentMap = new
            Map<String, String>();
        if(lstCompanyContentMapping != null && !lstCompanyContentMapping.isEmpty()) {
            for(CommunityContentInfo__mdt eachMapping : lstCompanyContentMapping) {
                if(eachMapping.Content__c != null){
                    labelAndContentMap.put(
                            eachMapping.MasterLabel,
                            eachMapping.Content__c
                    );
                }
            }
        }
        return labelAndContentMap;
    }


    /**
     * author       Abhishek Setia
     * @description Get Mapping of DeveloperName to Content from CustomMetadata 'CommunityContentInfo__mdt'
     * @param       developerNames
     * @return      Map<String,String>
     */
    public static Map<String,String> getCommunityContentInfoMapping(Set<String> developerNames){
        Map<String,String> mapDevnameContent=new Map<String,String>();
        for(CommunityContentInfo__mdt info:CommunityContentInfoDomain.queryCommContentInfo(developerNames)){
            mapDevnameContent.put(info.DeveloperName,info.Content__c);
        }
        return mapDevnameContent;
    }


    /**
     * author       Abhishek Setia
     * @description Returns Set<String> of Content__c values separated by 
     *              delimiter from CommunityContentInfo__mdt
     * @param       recordName - Set of record names
     * @param       delimiter
     * @return      Set<String>
     */    
    public static Set<String> communityContents(Set<String> recordName, String delimiter){
        Set<String> contents=new Set<String>();
        for(CommunityContentInfo__mdt rec:CommunityContentInfoDomain.queryCommContentInfo(recordName)){
            if(String.isNotBlank(rec.Content__c)){
                contents.addAll(rec.Content__c.split(delimiter));                                                
            }            
        }
        return contents;
    }

}