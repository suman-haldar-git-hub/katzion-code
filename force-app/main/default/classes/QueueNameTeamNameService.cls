/**
 * @author      Abhishek Setia
 * @description Handles logic related to CustomMetadata 'QueueNameTeamName__mdt'
 */
public without sharing class QueueNameTeamNameService {
    
    /**
     * author       Abhishek Setia
     * @description Returns map of QueueName to TeamName
     * @param       groupNames
     * @return      Map<String,String>
     */
    public static Map<String,String> mappingCaseOwnerWithTeamName(Set<String> groupNames){
        Map<String,String> mQueuenameTeamName=new Map<String,String>();
        for(QueueNameTeamName__mdt queuenameTeamName:QueueNameTeamNameDomain.getSetofRecords(groupNames)){
            mQueuenameTeamName.put(queuenameTeamName.DeveloperName, queuenameTeamName.TeamName__c);
        }
        return mQueuenameTeamName;
    }

}