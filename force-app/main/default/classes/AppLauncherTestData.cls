/**
 * @description Test data for App Launcher user stories
 * @author      Abhishek Setia
 */
@isTest
public class AppLauncherTestData {
        

    /**
     * @author      Abhishek Setia
     * @description Creates fake applications
     * @param       noOfRec - No. of records
     * @param       isInsert - If to insert records
     * @return      List<ApplicationAndPortal__c> fake data
     */
    public static List<ApplicationAndPortal__c> createApplicationsForAppLauncher(
        Integer noOfRec,
        Boolean isInsert){
            
            List<ApplicationAndPortal__c> lst=new List<ApplicationAndPortal__c>();
            for(Integer i=1;i<=noOfRec;i++){
                ApplicationAndPortal__c ap = new ApplicationAndPortal__c();
                ap.Name='Application '+i;
                ap.AvailableInLauncher__c=true;
                ap.Category__c='Application';
                ap.Description__c='App test record '+i;
                ap.LaunchURL__c='https://testrecord'+i;
                ap.LogoName__c='testlogo'+i;
                ap.SortOrderWithinSubCategory__c=i;
                ap.SubCategory__c='Learning & Development';
                ap.Type__c='Core App';
                ap.ProfileAccess__c='System Administrator';
                lst.add(ap);
            }
            if(!lst.isEmpty() && isInsert){
                INSERT lst;
            }
            return lst;
        }


    /**
     * @author      Abhishek Setia
     * @description Creates fake portals
     * @param       noOfRec - No. of records
     * @param       isInsert - If to insert records
     * @return      List<ApplicationAndPortal__c> fake data
     */
    public static List<ApplicationAndPortal__c> createPortalsForAppLauncher(
        Integer noOfRec,
        Boolean isInsert){
            
            List<ApplicationAndPortal__c> lst=new List<ApplicationAndPortal__c>();
            for(Integer i=1;i<=noOfRec;i++){
                ApplicationAndPortal__c ap = new ApplicationAndPortal__c();
                ap.Name='Portal '+i;
                ap.AvailableInLauncher__c=true;
                ap.Category__c='Portal';
                ap.Description__c='Portal test record '+i;
                ap.LaunchURL__c='https://testrecord'+i;
                ap.LogoName__c='testlogo'+i;
                ap.SortOrderWithinSubCategory__c=i;
                ap.SubCategory__c='Supply Chain & Procurement';
                ap.Type__c='Core App';
                ap.ProfileAccess__c='System Administrator';
                lst.add(ap);
            }
            if(!lst.isEmpty() && isInsert){
                INSERT lst;
            }
            return lst;
        }        

    
}