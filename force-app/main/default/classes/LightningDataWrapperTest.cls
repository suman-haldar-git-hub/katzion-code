/**
 * @description Test class for LightningDataWrapper.cls
 * @author      Abhishek Setia
 */
@isTest
private class LightningDataWrapperTest {
    
    @TestSetup
    static void makeData(){
        List<ApplicationAndPortal__c> lst=new List<ApplicationAndPortal__c>();
        lst.addAll(AppLauncherTestData.createPortalsForAppLauncher(5,false));
        lst.addAll(AppLauncherTestData.createApplicationsForAppLauncher(5,false));        
        if(!lst.isEmpty()){
            INSERT lst;
        }        
    }

    @isTest
    static void testSorting(){
        Test.startTest();        
        List<ApplicationAndPortal__c> apList=[SELECT Id, Name, CreatedDate, Category__c, SubCategory__c, LastModifiedDate, 
                                                Description__c, LogoName__c FROM ApplicationAndPortal__c];
        List<LightningDataWrapper.LightningDataRow> listLDW=new List<LightningDataWrapper.LightningDataRow>();
        for(ApplicationAndPortal__c ap:apList){
            LightningDataWrapper.LightningDataRow ldw=new LightningDataWrapper.LightningDataRow();
            ldw.stringA = ap.Name;
            ldw.stringB = ap.Category__c;
            ldw.stringC = ap.SubCategory__c;
            ldw.stringD = ap.LogoName__c;
            ldw.stringE = ap.Description__c;
            ldw.datetimeA = ap.CreatedDate;
            ldw.datetimeB = ap.LastModifiedDate;
            listLDW.add(ldw);
        } 
        if(!listLDW.isEmpty()){
            LightningDataWrapper.setSortingOrder('datetimeA', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('datetimeA', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('datetimeB', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('datetimeB', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringA', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringA', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringB', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringB', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringC', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringC', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringD', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringD', 'desc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringE', 'asc');
            listLDW.sort();
            LightningDataWrapper.setSortingOrder('stringE', 'desc');
            listLDW.sort();
        }
        System.assert(listLDW!=null);
        Test.stopTest();                                               
    }
}