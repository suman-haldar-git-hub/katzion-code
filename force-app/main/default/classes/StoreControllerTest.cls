/**
 * @Author      :   Spoorthi Munnangi
 * @Date        :   15-Jun-2020
 * @Description :   Test Class for StoreController
**/

/**
 * @description Hello World
 */
@isTest
public class StoreControllerTest {
    
     /**
     * @description setup
     */
    @testSetup static void setup() {
        
        List<Store__C> storelist = new List<Store__c>();
        Store__C store1 =  new  Store__C();             
        store1.Store_Name__c = 'Balmain BWS';
        store1.Store_Type__c = 'BWS';
        store1.Store_Number__c = '1033';
        store1.Postal_Code__c = '2041';
        storelist.add(store1);
        
        Store__C store2 =  new  Store__C();             
        store2.Store_Name__c = 'Chester Hill BWS';
        store2.Store_Type__c = 'BWS';
        store2.Store_Number__c = '6508';
        store2.Postal_Code__c = '2162';
        storelist.add(store2);
        
        Store__C store3 =  new  Store__C();             
        store3.Store_Name__c = 'Armidale';
        store3.Store_Type__c = 'Dan Murphys';
        store3.Store_Number__c ='1871' ;
        store3.Postal_Code__c ='2350' ;
        storelist.add(store3);
        
        Store__C store4 =  new  Store__C();             
        store4.Store_Name__c = 'Castle Hill DANS';
        store4.Store_Type__c = 'Dan Murphys';
        store4.Store_Number__c = '1469';
        store4.Postal_Code__c ='2154' ;
        storelist.add(store4);
        insert storelist;
        
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Webform';
        acc.PersonEmail = 'smunnangi@tcs.woolworths.com.au';
        acc.Employee_ID__c = '123789';
        acc.Division__c = 'BWS';
        acc.PersonBirthdate= Date.newInstance(1998, 03, 04);
        database.insert(acc);
        
    }
    /**
     * @description testsearchStoreBWS
     */
    @isTest 
    static void testsearchStoreBWS()
    {
        test.startTest();  
        string val = StoreController.searchStore('main', 'BWS');          
        system.assertequals(val.contains('Balmain'), true);  
        test.stopTest();            
    }
    
    /**
     * @description testsearchStoreDANS
     */
    @isTest 
    static void testsearchStoreDANS()
    {
       test.startTest();
          
       string val = StoreController.searchStore('Arm', 'Dan Murphys');
       system.assertequals(val.contains('Armidale'), true);
          
       test.stopTest();
    }
    
     /**
     * @description testsearchEmployee
     */
    @isTest 
    static void testsearchEmployee()
    {
          
       test.startTest();
       string val = StoreController.searchEmployee('123789','1998-03-04','BWS');
       system.assertequals(val.contains('Test'), true);
       test.stopTest();
    }
    /**
     * @description testaddStoreNomination
     */
    @isTest 
    static void testaddStoreNomination()
    {
        ReCaptcha__c recaptcha=new ReCaptcha__c();
        recaptcha.ReCaptcha_Threshold_Score__c=0.5;
        Insert recaptcha;
        Test.startTest();
          
          
        Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
        string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
        string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        try{
            string val = StoreController.addStoreNomination('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,storetoRemove,'captchaToken');
            system.assertequals('Success',val);  
        }
        catch(Exception e)
        {
            system.debug('Within  : Exception');
        }
          
        Test.stopTest();   
     }
    
    /**
     * @description testAddStoreNominationSubmit added by Saniya Virmani for 457
     */
    @isTest 
    static void testAddStoreNominationSubmit()
    {
        Test.startTest();          
          
        Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
        string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
        string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        try{
            string val = StoreController.addStoreNominationSubmit('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,storetoRemove,'captchaToken');
            system.assertequals('{"title":"","payLoad":"","isError":false,"hasObjectAccess":false,"errorType":"","errorOrSuccessMessage":"Request submitted successfully."}',val);  
        }
        catch(Exception e)
        {
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error'; 
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent); 
        }
          
        Test.stopTest();   
     }
        
     /**
     * @description to the the exception scenario : testaddStoreNominationExc 
     */
    @isTest 
    static void testaddStoreNominationExc()
    {
        ReCaptcha__c recaptcha=new ReCaptcha__c();
        recaptcha.ReCaptcha_Threshold_Score__c=0.5;
        Insert recaptcha;
        
        Test.startTest();
  
        Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
        string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
        string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        try{
            string val = StoreController.addStoreNomination('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,'Test','captchaToken');
            system.assertequals('Success',val);
            
        }
        catch(Exception e)
        {
            system.debug('Within  : Exception');
        }
          
        Test.stopTest();
    }
        /**
        * @description testAddStoreNominationSubmitExp added by Saniya Virmani for 457
        */
        @isTest 
        static void testAddStoreNominationSubmitExp()
        {
                        
            Test.startTest();
            
            Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
            string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
            string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
            // Set mock callout class  
            Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());           
            try{
                string val = StoreController.addStoreNominationSubmit('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,'Test', 'captchaToken');
                system.assertequals('{"title":"","payLoad":"","isError":false,"hasObjectAccess":false,"errorType":"","errorOrSuccessMessage":"Request submitted successfully."}',val);                
            }
            catch(Exception e)
            {
                LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
                logExceptionEvent.DebugLevel__c	= 'Error'; 
                logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
                logExceptionEvent.ExceptionMessage__c = e.getMessage();
                logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
                logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
                logExceptionEvent.User__c = UserInfo.getUserId();
                
                LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent); 
            }  
            Test.stopTest();
    }
    
     /**
     * @description to the the exception scenario : testaddStoreNominationExc 
     */
    @isTest 
    static void invalidCaptcha()
    {
        Test.startTest();
        Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
        string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
        string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleReCaptcha_MockHttpRespGenerator());
        try{
            string val = StoreController.addStoreNomination('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,'Test','captchaToken');
            string valSubmit = StoreController.addStoreNominationSubmit('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,'Test','captchaToken');
            system.assertequals('Success',val);
            system.assertequals('Success',valSubmit);
            
        }catch(Exception e)
        {
            system.debug('Within  : Exception');
        }
          
        Test.stopTest();   
     }
    
    /**
     * @description to the the exception scenario : testaddStoreNominationSubmitExc 
     */
    @isTest 
    static void invalidCaptchaSubmit()
    {
        Test.startTest();
        Id acc = [select Id from Account where Employee_ID__c = '123789'].id;
        string storetoAdd = [select Id from Store__C where Store_Name__c = 'Chester Hill BWS'].id;
        string storetoRemove = [select Id from Store__C where Store_Name__c = 'Balmain BWS'].id;
        // Set mock callout class 
        try{
            string valSubmit = StoreController.addStoreNominationSubmit('123789',acc,'smunnangi@tcs.woolworths.com.au',storetoAdd,'Test','captchaToken');
            system.assertequals('{"title":"","payLoad":"","isError":false,"hasObjectAccess":false,"errorType":"","errorOrSuccessMessage":"Request submitted successfully."}',valSubmit);
            
        }catch(Exception e)
        {
            LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
            logExceptionEvent.DebugLevel__c	= 'Error'; 
            logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
            logExceptionEvent.ExceptionMessage__c = e.getMessage();
            logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
            logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
            logExceptionEvent.User__c = UserInfo.getUserId();
            
            LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent); 
        }
          
        Test.stopTest();   
     }

}