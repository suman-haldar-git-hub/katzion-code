/**
 * @author      Abhishek Setia
 * @description Handle queries related to Custom Metadata 'QueueNameTeamName__mdt'
 */
public inherited sharing class QueueNameTeamNameDomain {
    
    /**
     * author       Abhishek Setia
     * @description Get QueueNameTeamName__mdt records based on MasterLabel
     * @param       groupNames
     * @return      List<QueueNameTeamName__mdt>
     */
    public static List<QueueNameTeamName__mdt> getSetofRecords(Set<String> groupNames){
        return [SELECT Id,DeveloperName,TeamName__c,MasterLabel FROM QueueNameTeamName__mdt
                WHERE DeveloperName IN :groupNames];
    }

}