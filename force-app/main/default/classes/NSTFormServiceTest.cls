/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
*                NSTFormService class.
*/
@isTest(SeeAllData=false)
public with sharing class NSTFormServiceTest {
     /**
    * @author : Daksh
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        User u = UserTestData.getUser('System Administrator',null);
        u.EmployeeID__c = 'Test1234';
        insert u;
        List<Account> lstAcc = AccountTestData.createAccountRecords(1,null);
        lstAcc[0].Employee_ID__c = 'Test1234';
        insert lstAcc;
        Store__C store1 =  new  Store__C();             
        store1.Store_Name__c = 'Balmain BWS';
        store1.Store_Type__c = 'BWS';
        store1.Store_Number__c = '1033';
        store1.Postal_Code__c = '2041';
        insert store1;
        Store__C store2 = new Store__C();             
        store2.Store_Name__c = 'Balmain BWS';
        store2.Store_Type__c = 'CFC';
        store2.Store_Number__c = '1034';
        store2.Postal_Code__c = '2041';
        insert store2;
        List<NSTRequest__c> lstNST = NSTTestData.create(2);
        lstNST[0].PayrollID__c = lstAcc[0].Id;
        lstNST[1].PayrollID__c = lstAcc[0].Id;
        lstNST[1].EntryType__c = 'Store';
        lstNST[1].Store__c = store1.Id;
        insert lstNST;
    }
    
    /**
    @Author : Akshansh Jain
    @Company : Cognizant
    @description : Test Clock In Store for CFC
    */
    @isTest
    static void testClockInStoreForCFC() {
    	User u = [Select Id, EmployeeID__c FROM user WHERE EmployeeID__c = 'Test1234' limit 1];
       	Account acc = [Select Id, Employee_ID__c FROM Account limit 1];
        Store__c store1 = [Select Id, Store_Name__c, Store_Type__c FROM Store__C where Store_Type__c='CFC' LIMIT 1];
        List<NSTRequest__c> lstNST = NSTTestData.create(3);
        lstNST[0].PayrollID__c = acc.Id;
        lstNST[0].EntryType__c = 'Store';
        lstNST[0].Store__c = store1.Id;
        lstNST[0].VisitedDate_Start__c = Datetime.now().addDays(-1);
        lstNST[1].PayrollID__c = acc.Id;
        lstNST[1].EntryType__c = 'Store';
        lstNST[1].Store__c = store1.Id;
        lstNST[1].VisitedDate_Start__c = Datetime.now().addDays(-2);
        lstNST[2].PayrollID__c = acc.Id;
        lstNST[2].EntryType__c = 'Store';
        lstNST[2].Store__c = store1.Id;
        lstNST[2].VisitedDate_Start__c = Datetime.now();
        insert lstNST;
        System.assertEquals(lstNST.size(), 3);
        
       	Test.startTest();
        System.runAs(u){
            NSTFormService.getNSTRequestDetail();
        	System.assertEquals(lstNST.size(), 3);            
            delete lstNST[1];
            LightningResponse objResponse = NSTFormService.getNSTRequestDetail();
            NSTFormService.NSTWrapper objWrap = (NSTFormService.NSTWrapper)JSON.deserialize(
                objResponse.payLoad,NSTFormService.NSTWrapper.class);
            System.assertEquals(objWrap.lstRequestDateGroup.size(), 2);
        }
       	Test.stopTest(); 
    }
    
    /**
    @Author : Akshansh Jain
    @Company : Cognizant
    @description : Test Clock In Store for CFC
    */
    @isTest
    static void testClockInStoreCFC() {
    	User u = [Select Id, EmployeeID__c FROM user WHERE EmployeeID__c = 'Test1234' limit 1];
       	Account acc = [Select Id, Employee_ID__c FROM Account limit 1];
        Store__C store = [Select Id, Store_Name__c, Store_Type__c FROM Store__C where Store_Type__c ='BWS' LIMIT 1];
        List<NSTRequest__c> lstNSTD = [Select Id FROM NSTRequest__c];
        delete lstNSTD;
        Store__C storeCFC = [Select Id, Store_Name__c, Store_Type__c FROM Store__C where Store_Type__c ='CFC' LIMIT 1];
        List<NSTRequest__c> lstNST = NSTTestData.create(2);
        lstNST[0].PayrollID__c = acc.Id;
        lstNST[0].EntryType__c = 'Store';
        lstNST[0].Store__c = store.Id;
        lstNST[0].VisitedDate_Start__c = Datetime.now().addDays(-1);
        lstNST[1].PayrollID__c = acc.Id;
        lstNST[1].EntryType__c = 'Store';
        lstNST[1].Store__c = store.Id;
        lstNST[1].VisitedDate_Start__c = Datetime.now().addDays(-2);
        insert lstNST;
        System.assertEquals(lstNST.size(), 2);
        
       	Test.startTest();
        System.runAs(u){
            NSTFormService.getNSTRequestDetail();
        	LightningResponse objResponse = NSTFormService.getNSTRequestDetail();
            NSTFormService.NSTWrapper objWrap = (NSTFormService.NSTWrapper)JSON.deserialize(
               objResponse.payLoad,NSTFormService.NSTWrapper.class);
            lstNST[0].Store__c = storeCFC.Id;
            update lstNST[0];
            NSTFormService.getNSTRequestDetail();
            
            delete lstNST[0];
            lstNST[1].VisitedDate_Start__c = DateTime.now();
            update lstNST[1];
            NSTFormService.getNSTRequestDetail();
        }
       	Test.stopTest(); 
    }

    /**
    @Author : Sunil Kumar
    @Company : Cognizant
    @description : Test Clock In Coach
    */
    @isTest
    static void testClockInCoach() {
       User u = [Select Id, EmployeeID__c FROM user WHERE EmployeeID__c = 'Test1234' limit 1];
       Account acc = [Select Id, Employee_ID__c FROM Account limit 1];
       List<NSTRequest__c> lstNST = [Select Id, PayrollID__c, EntryType__c, 
                                    Distance_Travelled__c, Time_Travel__c, VisitedDate_Start__c
                                    FROM NSTRequest__c];
       Test.startTest();
           System.assertEquals(u.EmployeeID__c , acc.Employee_ID__c );
           System.assert(lstNST != null);
           System.runAs(u){
                NSTFormService.getNSTRequestDetail();
                NSTFormService.getAllPicklIstValue();
            }
        Test.stopTest(); 
    }
    /**
    @Author : Sunil Kumar
    @Company : Cognizant
    @description : Test Clock In Coach
    */
    @isTest
    static void testClockInStore() {
       User u = [Select Id, EmployeeID__c FROM user WHERE EmployeeID__c = 'Test1234' limit 1];
       Account acc = [Select Id, Employee_ID__c FROM Account limit 1];
       List<NSTRequest__c> lstNST = [Select Id, PayrollID__c, EntryType__c, 
                                    Distance_Travelled__c, Time_Travel__c, VisitedDate_Start__c
                                    FROM NSTRequest__c];
       lstNST[0].EntryType__c = 'Store';
       update lstNST;                              
       Test.startTest();
           System.assertEquals(u.EmployeeID__c , acc.Employee_ID__c );
           System.assert(lstNST != null);
           System.runAs(u){
                NSTFormService.getNSTRequestDetail();
                NSTFormService.getAllPicklIstValue();
            }
        Test.stopTest(); 
    }
     /**
    @Author : Sunil Kumar
    @Company : Cognizant
    @description : Test ClockOut
    */
    @isTest
    static void testClockOut() {
       User u = [Select Id, EmployeeID__c FROM user WHERE EmployeeID__c = 'Test1234' limit 1];
       Account acc = [Select Id, Employee_ID__c FROM Account limit 1];
       List<NSTRequest__c> lstNST = [Select Id, PayrollID__c, EntryType__c, 
                                    Distance_Travelled__c, Time_Travel__c, VisitedDate_Start__c
                                    FROM NSTRequest__c];
       lstNST[0].VisitedDate_End__c = System.Now();
       lstNST[0].Break_Duration__c = '0 Min';
       
       update lstNST;                              
       Test.startTest();
           System.assertEquals(u.EmployeeID__c , acc.Employee_ID__c );
           System.assert(lstNST != null);
           System.runAs(u){
                NSTFormService.getNSTRequestDetail();
                NSTFormService.getAllPicklIstValue();
            }
        Test.stopTest(); 
    }
}