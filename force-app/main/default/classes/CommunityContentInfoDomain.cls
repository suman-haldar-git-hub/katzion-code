/**
* @author : Monika Bisht
* @company : SaaSFocus A Cognizant Company
* @description : This class is utility class for CommunityContentInfo__mdt.
*/
public inherited sharing class CommunityContentInfoDomain {
/**
* @author : Monika Bisht
* @description : This method is used to query CommunityContentInfo__mdt.
* @return : List<CommunityContentInfo__mdt>
*/
    public static List<CommunityContentInfo__mdt> queryCommunityContentInfo() {
        return [
            SELECT MasterLabel,Content__c,PageName__c,SectionName__c from CommunityContentInfo__mdt
            LIMIT 50000
        ];
    }

/**
* @author : Amit Sharma
* @description : This method is used to query CommunityContentInfo__mdt .
* @return : List<CommunityContentInfo__mdt>
* @param  setDeveloperName - contains the custom metadata records
*/
    public static List<CommunityContentInfo__mdt> queryCommContentInfo(
                                            Set<String> setDeveloperName) {
        return [
                Select Id, MasterLabel,DeveloperName,Content__c,PageName__c,
                SectionName__c
              from CommunityContentInfo__mdt 
            Where DeveloperName in: setDeveloperName
           order by DeveloperName ASC LIMIT 50000
        ];
    }
}