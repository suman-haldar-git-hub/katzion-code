/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This domain class is used to return Group information.
*/
public inherited sharing class GroupDomain {
    /** 
    * @author : Sunil
    * @description : This method will return Group id.
    * @return : Id
    * @param  developerName
    */
    public static Id getGroupId(String developerName) {
    Group groupDetail = 
        [SELECT Id, Name, 
         DeveloperName, Email, Type 
         FROM Group 
         WHERE Type='Queue' 
         AND DeveloperName =:developerName LIMIT 1];
         return groupDetail.Id;
    
    }

    /**
     * author       Abhishek Setia
     * @description Get Queue records from Id's
     * @param       groupids
     * @return      List<Group>
     */
    public static List<Group> getGroups(Set<Id> groupids){
        return [SELECT Id,DeveloperName,Name FROM Group
                WHERE Type='Queue' AND Id IN :groupids];
    }
}