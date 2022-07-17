/**
 * @description       : This is test class for VIPEmployeeService 
*                      to cover positive and negative scenarios
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-08-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   04-08-2021   Prathamesh Lad   Initial Version
**/
@isTest
public class VIPEmployeeServiceTest {
    /**
    * @description This method is used to set the data
    * @author Prathamesh Lad | 04-08-2021
    **/
    @testSetup
    static void makeData(){
        //Create Users
        List<User> listUsers=new List<User>();
        User user1
            =UserTestData.getUserRecords('PS ER Advisory','testOrg1@test.com.temp1');
        listUsers.add(user1);

        User user2
            =UserTestData.getUserRecords('PS ER Advisory','testOrg2@test.com.temp2');
        listUsers.add(user2);
        
        User user3
            =UserTestData.getUserRecords('PS Integration User','testOrg3@test.com.temp3');
        listUsers.add(user3);
        insert listUsers;
        
        System.runAs(user3) {
            //Create General Settings
            General_Setting__c genSetObj=new General_Setting__c();
            genSetObj.Name='Emails';
            genSetObj.HR_Smart_IVR_Emails__c='testOrg1@test.com,testOrg1@test.com';
            insert genSetObj;
            
            //Create Accounts
            Id devRecordTypeId 
                = Schema.SObjectType.Account.getRecordTypeInfosByName()
                    .get('Individual Account').getRecordTypeId();
            List<Account> listAccounts=AccountTestData.createAccForVIPEmpService(1,devRecordTypeId);
            insert listAccounts;
    
            //Create Email Template
            List<emailTemplate> listemailTemplate
                =EmailTemplateTestdata.getEmailTemplateRecords
                    (1,'Smart IVR Templates','PositionNotificationTemplateTest');
            insert listemailTemplate;
        }
    }
    
    /**
    * @description This method is used to cover below scenario
    * 			   No payroll Id in Request
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet1(){
        test.startTest();
        // Set up a test request
        String payRollId='';
        RestRequest request = new RestRequest();
        request.requestUri 
            ='https://yourInstance.salesforce.com/services/apexrest/GetVIPFlag/'+payRollId ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('E',resp.vipFlag);
    }
    
    /**
    * @description This method is used to cover below scenario
    * 			   Payroll Id exist in request but not exist in Salesforce
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet2(){
        test.startTest();
        // Set up a test request
        String payRollId='Test1';
        RestRequest request = new RestRequest();
        request.requestUri 
            ='https://yourInstance.salesforce.com/services/apexrest/GetVIPFlag/'+payRollId ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('E',resp.vipFlag);
    }
    
    /**
    * @description This method is used to cover below scenario
    * 			   No VIP Employee Record Found based on Employee details
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet3(){
        test.startTest();
        // Set up a test request
        String payRollId='Test0';
        RestRequest request = new RestRequest();
        request.requestUri 
            ='https://yourInstance.salesforce.com/services/apexrest/GetVIPFlag/'+payRollId ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('E',resp.vipFlag);
    }

    /**
    * @description This method is used to cover below scenario
    * 			   VIP Employee records found and VIP Flag is true
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet4(){
        //Create VIPEmployee Master records
        List<VIP_Employee_Matrix__c> listVIPMasterRecords=new List<VIP_Employee_Matrix__c>();
        VIP_Employee_Matrix__c vipMaster1
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('Position','Test Position','Yes');
        listVIPMasterRecords.add(vipMaster1);

        VIP_Employee_Matrix__c vipMaster2
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('Division','Test Division','No');
        listVIPMasterRecords.add(vipMaster2);

        VIP_Employee_Matrix__c vipMaster3
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('State','Test State','No');
        listVIPMasterRecords.add(vipMaster3);
        insert listVIPMasterRecords;
        
        test.startTest();
        // Set up a test request
        String payRollId='Test0';
        RestRequest request = new RestRequest();
        request.requestUri 
            ='https://yourInstance.salesforce.com/services/apexrest/GetVIPFlag/'+payRollId ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('Y',resp.vipFlag);
    }
    
    /**
    * @description This method is used to cover below scenario
    * 			   VIP Employee records found and VIP Flag is false
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet5(){
        //Create VIPEmployee Master records
        List<VIP_Employee_Matrix__c> listVIPMasterRecords=new List<VIP_Employee_Matrix__c>();
        VIP_Employee_Matrix__c vipMaster1
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('Position','Test Position','No');
        listVIPMasterRecords.add(vipMaster1);

        VIP_Employee_Matrix__c vipMaster2
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('Division','Test Division','No');
        listVIPMasterRecords.add(vipMaster2);

        VIP_Employee_Matrix__c vipMaster3
            =VIPEmployeeMatrixTestData.getVIPMasterRecord
                ('State','Test State','No');
        listVIPMasterRecords.add(vipMaster3);
        insert listVIPMasterRecords;
        
        test.startTest();
        // Set up a test request
        String payRollId='Test0';
        RestRequest request = new RestRequest();
        request.requestUri 
            ='https://yourInstance.salesforce.com/services/apexrest/GetVIPFlag/'+payRollId ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('N',resp.vipFlag);
    }
    
    /**
    * @description Cover Exception
    * @author Prathamesh Lad | 04-08-2021
    **/
    @isTest 
    static void testDoGet6(){
        test.startTest();
        // Set up a test request
        String payRollId='';
        RestRequest request = new RestRequest();
        request.requestUri = null ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        VIPEmployeeServiceHelper.VIPServiceResponse resp=VIPEmployeeService.doGet(); 
        test.stopTest();
        
        system.assertEquals('E',resp.vipFlag);
    }
}
