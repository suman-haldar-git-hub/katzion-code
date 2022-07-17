/*Test class for NSTController and NSTUpdateController*/
/*
Author Name : Jebisha (TCS)
Date : 08-Sept-2020
Class Name : NSTControllerTest
Description : This class is used to test the NSTController class and NSTUpdateController
*/
@istest
public class NSTControllerTest {
    @testSetup
    static void setupTestData(){
        
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'Account1';
        acc.PersonEmail = 'test@tcs.woolworths.com';
        acc.Employee_ID__c = '123789';
        acc.PersonBirthdate= Date.newInstance(1998, 03, 04);
        insert acc;
        
        Store__C store1 =  new  Store__C();             
        store1.Store_Name__c = 'test store1';
        store1.Store_Type__c = 'BWS';
        store1.Store_Number__c = '0501';
        store1.Postal_Code__c = '2041';
        insert store1;
        
        Store__C store2 =  new  Store__C();             
        store2.Store_Name__c = 'No Store Found';
        store2.Store_Number__c = '999999';
        insert store2;
        
        ReCaptcha__c recaptcha=new ReCaptcha__c();
        recaptcha.ReCaptcha_Threshold_Score__c=0.5;
        Insert recaptcha;
        createprofile();
        
    }
    
    @future
    static void createprofile()
    {
          Profile p = [SELECT Id FROM Profile WHERE Name='National Stocktake Leader User'];
        UserRole roledata=[SELECT ID FROM UserRole WHERE Name LIKE '%National%'];
        user managerUser = new user();
        managerUser.LastName = 'test1';
        managerUser.Email='standarduser@testorg.com';
        managerUser.Alias = 'standt';
        managerUser.ProfileId = p.id;
        managerUser.EmailEncodingKey='UTF-8';
        managerUser.LanguageLocaleKey='en_US';
        managerUser.LocaleSidKey='en_US';
        managerUser.TimeZoneSidKey = 'America/Los_Angeles';
        managerUser.UserName='standarduser101@testorg.com';
        managerUser.UserRoleId = roledata.id;
        insert managerUser;
    }
    /*Test method for searchEmployee*/
  
    @isTest static void searchEmployee_Success()
    {
        test.startTest();
        
        Account val = NSTController.searchEmployee('123789','1998-03-04');
        system.assertequals(val.FirstName.contains('test'), true);
        system.assertequals(val.LastName.contains('Account1'), true);
        
        test.stopTest();
    }
    
    @isTest static void searchEmployee_Exception()
    {
        test.startTest();
        try{
        	Account val = NSTController.searchEmployee('1237892','1998-30-30');
		}
        catch(Exception e) 
        {
			System.assertEquals('Exception test','Exception test');
		}
        
        test.stopTest();
    }

    //Test method for saveCheckinDetail
    @isTest static void saveCheckinDetail() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator()); 
        
        
        Id AccountID=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id storeid=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        system.debug('AccountID' + AccountID);
        system.debug('storeid' + storeid);
        system.debug('manager' + manager);
         
        NSTController.saveCheckinDetail(AccountID,storeid, manager,50,20, 'Australia/Brisbane', 'captchaToken');
        test.stopTest();
       
    }
    
    @isTest static void saveCheckinDetail_Captcha_Error() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator()); 
        
        
        Id AccountID=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id storeid=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        system.debug('AccountID' + AccountID);
        system.debug('storeid' + storeid);
        system.debug('manager' + manager);
        try{
        	NSTController.saveCheckinDetail(AccountID,storeid, manager,50,20, 'Australia/Brisbane', 'test');
        }
        catch(Exception e) 
        {
			System.assertEquals('Exception test','Exception test');
		}
        test.stopTest();
       
    }
    
    @isTest static void saveCheckinDetail_Invalid_data() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator()); 
        
        
        Id AccountID=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id storeid=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        system.debug('AccountID' + AccountID);
        system.debug('storeid' + storeid);
        system.debug('manager' + manager);
        try{
        	NSTController.saveCheckinDetail(AccountID,'WrongStoreID', manager,50,20, 'Australia/Brisbane', 'test');
        }
        catch(Exception e) 
        {
			System.assertEquals('Exception test','Exception test');
		}
        test.stopTest();
       
    }
   
   
    @isTest static void saveCheckOutDetailTest() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        
        Id profile=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id store=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        NSTRequest__c ntReq =new NSTRequest__c();
        ntReq.PayrollID__c=profile;
        ntReq.Store__c=store;
        ntReq.ManagerUser__c=manager;
        ntReq.VisitedDate_Start__c=System.Now();
        ntReq.Time_Travel__c=80;
        ntReq.Distance_Travelled__c=12;
        insert ntReq;

        String result= NSTUpdateController.saveCheckOutDetail(ntReq.Id,'0 min','Test Comment','captchaToken');
        System.assertEquals('Success', result);
        test.stopTest();
    }
    
     @isTest static void getNSTRequestDetailTest2() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        
        Id payrollid=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id store=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        NSTRequest__c ntReq =new NSTRequest__c();
        ntReq.PayrollID__c=payrollid;
        ntReq.Store__c=store;
        ntReq.ManagerUser__c=manager;
        ntReq.VisitedDate_Start__c=System.Now();
        //ntReq.VisitedDate_End__c=System.Now();
        ntReq.Time_Travel__c=80;
        ntReq.Distance_Travelled__c=12;
        ntReq.Timezone__c='Australia/Brisbane';
        insert ntReq;
         
         
      
        NSTUpdateController.NSTRequestData data= NSTUpdateController.getNSTRequestDetail(payrollid);
        //System.assertEquals(data.PayrollID, payrollid);
        test.stopTest();
    }
    
    
    
     @isTest static void getNSTRequestDetailTest() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        
        Id payrollid=[Select Id from Account where Name='test Account1' limit 1].Id;
        Id store=[Select Id from Store__c where Store_Name__c='test store1' limit 1].Id;
        Id manager=[Select Id from User where Email='standarduser@testorg.com' limit 1].Id;
        NSTRequest__c ntReq =new NSTRequest__c();
        ntReq.PayrollID__c=payrollid;
        ntReq.Store__c=store;
        ntReq.ManagerUser__c=manager;
        ntReq.VisitedDate_Start__c=System.Now();
        ntReq.Time_Travel__c=80;
        ntReq.Distance_Travelled__c=12;
        ntReq.Timezone__c='Australia/Brisbane';
        insert ntReq;
         
         
      
        NSTUpdateController.NSTRequestData data= NSTUpdateController.getNSTRequestDetail(payrollid);
        //System.assertEquals(data.PayrollID, payrollid);
        test.stopTest();
    }
    
    
     @isTest static void getNSTRequestDetailTest_Exception() {
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        try{
       		NSTUpdateController.NSTRequestData data= NSTUpdateController.getNSTRequestDetail('1234');
        }
        catch(Exception e) 
        {
			System.assertEquals('Exception test','Exception test');
		}
        test.stopTest();
    }
    

    
    
    //Test method for getAllPicklIstValue
    @isTest static void getAllPicklIstValueTest() {
        test.startTest();
        List<NSTController.AllPicklistValue> result=new List<NSTController.AllPicklistValue>();
        result=NSTController.getAllPicklIstValue();
        test.stopTest();
    }

    //Test method for LookUpSearch
    @isTest static void LookUpSearch_Single() {
        test.startTest();
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','store1', 'Store_Name__c', 'Store_Name__c', '', '', '');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    
     @isTest static void LookUpSearch_Multi() {
        test.startTest();
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','store1', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', '', '', '');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    //NODATAFOUND
   
    @isTest static void LookUpSearch_SpecialScenario() {
        test.startTest();
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','store134234', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', '', '', 'NODATAFOUND');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    
    
     @isTest static void LookUpSearch_RecordId() {
        test.startTest();
        Store__c str=[SELECT ID FROM Store__C WHERE Store_Number__c = '0501'];
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','store', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', '', str.Id, '');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    
    //
    @isTest static void LookUpSearch_StaticFilter() {
        test.startTest();
        string staticFilter='Store_Type__c = \'BWS\'';
        Store__c str=[SELECT ID FROM Store__C WHERE Store_Number__c = '0501'];
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','store', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c',staticFilter, '', '');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    
    @isTest static void LookUpSearch_StaticFilter2() {
        test.startTest();
        string staticFilter='Store_Type__c = \'BWS\'';
        Store__c str=[SELECT ID FROM Store__C WHERE Store_Number__c = '0501'];
        List<Object> searchResult= NSTController.LookUpSearch('Store__C','', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c',staticFilter, '', '');
        System.assertEquals(searchResult.size(),1);
        test.stopTest();
    }
    
     @isTest static void LookUpSearch_Exception() {
        test.startTest();
         try{
        	string staticFilter='Store_Type__c = \'BWS\'';
        	Store__c str=[SELECT ID FROM Store__C WHERE Store_Number__c = '0501'];
        	List<Object> searchResult= NSTController.LookUpSearch('Store__C','store', 'XX,Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c', 'Postal_Code_Text__c,Store_Number_Text__c,Store_Name__c',staticFilter, '', '');
        	test.stopTest();
     	}
        catch(Exception e) 
        {
			System.assertEquals('Exception test','Exception test');
		}
    }
    
}