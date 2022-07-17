/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ConnectorController_Test {
    @TestSetup
    static void makeData(){
        Case_Record_Types__c custSetting = new Case_Record_Types__c();
        custSetting.ER_Case__c = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_Case').getRecordTypeId();
        custSetting.Query_Case__c = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        custSetting.Transaction_Case__c = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Transaction').getRecordTypeId();
        custSetting.WOW_NZ_ER_Case__c = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WOW_NZ_ER_Case').getRecordTypeId();
        insert custSetting;
    }
    static testMethod void findContactTest() {
        Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Phone = '1234');
        insert contact;
        Contact c = (Contact)ConnectorController.findContact('Phone', '1234', null, null);
        System.assert(c != null);
        
        c = (Contact)ConnectorController.getContact(c.Id, null);
        System.assert(c != null);
        
        /* exception case */
        c = (Contact)ConnectorController.getContact(c.Id, 'crud');
        System.assert(c == null);
        
        /* multiple contacts */
        Contact contact2 = new Contact(FirstName = 'Foo', LastName = 'Bar', Phone = '1234');
        insert contact2;
        c = (Contact)ConnectorController.findContact('Phone', '1234', null, null);
        System.assert(c.Id == null);
        
        /* search unsuccessful */
        c = (Contact)ConnectorController.findContact('Phone', 'abcd', null, null);
        System.assert(c == null);
        
        /* exception case */
        c = (Contact)ConnectorController.findContact('x', 'y', null, null);
        System.assert(c == null);
    }
    
    static testMethod void findAccountTest() {
        Account account = new Account(Name = 'Acme', Employee_ID__c = '002345');
        insert account;
        //Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Phone = '2345');
        //insert contact;
        Account c = (Account)ConnectorController.findContact('Account.Employee_ID__c', '002345', null, null);
        System.assert(c != null);
        
        c = (Account)ConnectorController.getContact(c.Id, null);
        System.assert(c != null); 
        
        /* multiple leads */
        Account account2 = new Account(Name = 'Foo2', Phone = '2345');
        insert account2;
        c = (Account)ConnectorController.findContact('Phone', '2345', null, null);
        System.assert(c == null);
    }
    
    static testMethod void findLeadTest() {
        Lead lead = new Lead(Company = 'Lead Company', FirstName = 'firstname', LastName = 'lastname', Phone = '3456');
        insert lead;
        Lead c = (Lead)ConnectorController.findContact('Phone', '3456', null, null);
        System.assert(c != null);
        
        c = (Lead)ConnectorController.getContact(c.Id, null);
        System.assert(c != null); 
        
        Lead lead2 = new Lead(Company = 'Lead Company', FirstName = 'firstname2', LastName = 'lastname2', Phone = '3456');
        insert lead2;
        c = (Lead)ConnectorController.findContact('Phone', '3456', null, null);
        System.assert(c.Id == null);
    }
    
    static testMethod void findCase() {
        Case newCase = new Case(Subject = 'abc');
        insert newCase;
        
        Case myCase = [SELECT CaseNumber FROM Case WHERE Subject = :'abc'];  
        Case c = ConnectorController.findCase(myCase.CaseNumber);
        System.assert(c != null);
        
        // exception case
        c = ConnectorController.findCase('foobar');
        System.assert(c == null);
    }
    
    static testMethod void createTask() {
        Map<String, String> taskMap = new Map<String, String>();
        taskMap.put('Priority', 'Normal');
        taskMap.put('CallDurationInSeconds', '1');
        
        Map<String, String> userData = new Map<String, String>();
        userData.put('ANI', '23451234');
        userData.put('BLAH', '2345');
        
        Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Phone = '1234');
        insert contact;
        Contact c = (Contact)ConnectorController.findContact('Phone', '1234', null, userData);
        Contact c2 = c;
        
        Task task = ConnectorController.createTask(c.Id, c.Id, c.AccountId, 'my subject', userData, taskMap); 
        System.assert(task != null);
        
        task = ConnectorController.updateTaskDetails(task.Id, c.Id, c.AccountId); 
        System.assert(task != null);
        
        task = ConnectorController.updateTask(task.Id, null, taskMap); 
        System.assert(task != null);
        
        userData.put('DispositionCode', 'foobar');
        task = ConnectorController.closeTask(c.Id, c.Id, task.Id, c.AccountId, '', 'blah', userData, 'DispositionCode', taskMap, 10);
        System.assert(task != null);
        
        task = ConnectorController.getContactByTask(task.id);
        System.assert(task != null);
        
        c = (Contact)ConnectorController.getRecord(c.Id, 'Name');
        System.assert(c != null);
        
        // Close/create the task with an associated with a case
        Case ca = ConnectorController.createCase(c2.Id, c2.AccountId, 'interaction', 'a subject', null, null);
        task = ConnectorController.closeTask(c2.Id, c2.Id, null, ca.Id, '', 'blah', userData, 'DispositionCode', taskMap, 10);
        System.assert(task != null);
        
        // get the task with an associated case
        task = ConnectorController.getContactByTask(task.id);
        System.assert(task != null);
    }
    
    static testMethod void createCase() {
        Map<String, String> caseMap = new Map<String, String>();
        caseMap.put('Priority', 'Normal');
        
        Map<String, String> userData = new Map<String, String>();
        userData.put('ANI', '23451234');
        userData.put('BLAH', '2345');
        
        Account account = new Account(Name = 'Acme', Phone = '2345');
        insert account;
        
        Case ca = ConnectorController.createCase(account.Id, null, 'interaction', 'a subject', userData, caseMap);
        System.assert(ca != null);
        
        ca = ConnectorController.updateCaseDetails(ca.Id, null, account.Id);
        System.assert(ca != null);
        
        ca = ConnectorController.updateCase(ca.Id, userData, caseMap);
        System.assert(ca != null);

        // exception case
        ca = ConnectorController.createCase('foobar', 'foobar', 'interaction', 'a subject', userData, caseMap);
        System.assert(ca == null);
    }
    
     static testMethod void getCases() {
        Case ca2;
        Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Phone = '1234');
        insert contact;
        
        Case ca = ConnectorController.createCase(contact.Id, contact.AccountId, 'interaction', 'a subject', null, null);
        System.assert(ca != null);
        
        Case[] cases = ConnectorController.getCases('SELECT Id FROM Case Where ContactId=\'' + contact.Id + '\' ORDER BY CreatedDate DESC LIMIT 1');
        System.assert(cases != null && cases.size() == 1);
        
        cases = ConnectorController.getCases('SELECT Id FROM Case Where CaseNumber=\'1234\'');
        System.assert(cases == null);
     }
}