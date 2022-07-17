/**
 * @author      Abhishek Setia
 * @description Handle queries and dml operations related to sObject 'ApplicationAndPortal__c'
 */
public inherited sharing class ApplicationAndPortalDomain {


    /**
     * author       Abhishek Setia
     * @description Get ApplicationAndPortal__c objects based on criteria AvailableInLauncher__c
     * @param       availableInLauncher - Specify if AvailableInLauncher__c is true / false.
     * @param       keyword - User input search keyword
     * @param       loggedinProfileName
     * @return      List<ApplicationAndPortal__c>
     */
    public static List<ApplicationAndPortal__c> dataCriteriaAvailableInLauncher(Boolean availableInLauncher, String keyword,
        String loggedinProfileName){
            String query = 'SELECT Id, Name, Category__c, SubCategory__c, Description__c, ImageName__c, LogoName__c, LaunchURL__c, HelpArticleLink__c' 
                    +' FROM ApplicationAndPortal__c'
                    +' WHERE AvailableInLauncher__c=:availableInLauncher AND Category__c<>null AND SubCategory__c<>null'
                    +' AND ProfileAccess__c INCLUDES (\''+loggedinProfileName+'\')';
            if(String.isNotBlank(keyword)){
                query += ' AND (Name like \'%'+String.escapeSingleQuotes(keyword)+'%\' OR Description__c like \'%'+String.escapeSingleQuotes(keyword)+'%\')';
            }
            query += ' ORDER BY SortOrderWithinCategory__c,SortOrderWithinSubCategory__c,Name';
            return System.Database.query(query);
    }


    /**
     * author       Abhishek Setia
     * @description Get ApplicationAndPortal__c objects based on criteria AvailableInLauncher__c
     *              and Set<Id>
     * @param       availableInLauncher - Specify if AvailableInLauncher__c is true / false.
     * @param       recId - Set<Id>
     * @param       keyword - User input
     * @param       loggedinProfileName
     * @return      List<ApplicationAndPortal__c>
     */
    public static List<ApplicationAndPortal__c> criteriaAvailableInLauncherRecIdKeyword(Boolean availableInLauncher, Set<Id> recId,
        String keyword, String loggedinProfileName){
        String query = 'SELECT Id, Name, Category__c, SubCategory__c, Description__c, ImageName__c, LogoName__c, LaunchURL__c, HelpArticleLink__c'
        +' FROM ApplicationAndPortal__c'
        +' WHERE AvailableInLauncher__c=:availableInLauncher AND Id IN :recId'
        +' AND ProfileAccess__c INCLUDES (\''+loggedinProfileName+'\')';
        if(String.isNotBlank(keyword)){
            query += ' AND (Name like \'%'+String.escapeSingleQuotes(keyword)+'%\' OR Description__c like \'%'+String.escapeSingleQuotes(keyword)+'%\')';
        }            
        query += ' ORDER BY CreatedDate desc';
        return System.Database.query(query);
    }


}