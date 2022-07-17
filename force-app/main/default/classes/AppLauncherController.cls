/**
 * @author      Abhishek Setia
 * @description Controller for 'applauncher' lwc
 */
public with sharing class AppLauncherController {
    

    /**
     * @author      Abhishek Setia
     * @description Returns response which is used in lwc 'applauncher' 
     * @param       keyword - User input search keyword     
     * @return      LightningResponse wrapper object  
     */
    @AuraEnabled
    public static LightningResponse getResponse(String keyword){
        return AppLauncherService.getResponse(keyword);
    }
    

    /**
     * @author      Abhishek Setia
     * @description Handles logic to bookmark record
     * @param       recordId
     * @return      LightningResponse wrapper object  
     */
    @AuraEnabled
    public static LightningResponse bookmarkRecord(String recordId){
        return AppLauncherService.bookmarkRecordService(recordId);
    }


    /**
     * @author      Abhishek Setia
     * @description Handles logic to unbookmark record
     * @param       recordId
     * @return      LightningResponse wrapper object  
     */
    @AuraEnabled
    public static LightningResponse unbookmarkRecord(String recordId){
        return AppLauncherService.unbookmarkRecordService(recordId);
    }


    /**
     * @author      Abhishek Setia
     * @description Response Wrapper for 'applauncher'
     */
    public class ResponseWrapper{
        @AuraEnabled
        public List<ApplicationAndPortalCategory> apps;
        @AuraEnabled
        public List<ApplicationAndPortalCategory> portals;
        @AuraEnabled
        public List<ApplicationAndPortal__c> favorites;
        @AuraEnabled
        public Boolean favEmpty;
    }

    /**
     * @author      Abhishek Setia
     * @description Inner wrapper of class ResponseWrapper
     */
    public class ApplicationAndPortalCategory{
        @AuraEnabled
        public String key;
        @AuraEnabled
        public String category;
        @AuraEnabled
        public List<ApplicationAndPortal__c> appsAndPortals;        
    }
    
}