/**
* Class containing tests for EmailRelatedListController
*/
@IsTest public with sharing class EmailRelatedListControllerTest {
@testSetup
static void setupTestData(){

 /*creating case record*/   
Account testAccount = new Account();
testAccount.Name='Test Account' ;
insert testAccount;

 /*creating caserecordtype record */
Case_Record_Types__c caseRecordType= new Case_Record_Types__c(
Transaction_Case__c= Schema.SObjectType.case.getRecordTypeInfosByName().get('Transaction').getRecordTypeId(),
Query_Case__c= Schema.SObjectType.case.getRecordTypeInfosByName().get('Query Case').getRecordTypeId());

 insert caseRecordType;
 
 
 
 /*creating case record*/
 //Id FetchRecordtype = Schema.SObjectType.case.getRecordTypeInfosByName().get('Query Case').getRecordTypeId();
 Case caseObj = new Case(
 AccountId = testAccount.id,
 RecordtypeId= Schema.SObjectType.case.getRecordTypeInfosByName().get('Transaction').getRecordTypeId(),
 Status = 'Open',
 Origin = 'Phone',
 subject = 'testthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionality',
 Preferred_Email__c = 'test@new.com',
 Category__c = 'Mobility'

 );
 insert caseObj;   
 
 EmailMessage newEmail = new EmailMessage();
 newEmail.FromAddress = 'test@abc.org'; newEmail.Incoming = True; newEmail.ToAddress= 'hello@670ocglw7xhomi4oyr5ywsforce.com'; 
                                newEmail.Subject = 'Test email'; newEmail.status= '0';
                                newEmail.MessageDate=datetime.newInstance(2019, 9, 15, 12, 30, 0); 
                                newEmail.TextBody = '23456 '; newEmail.ParentId = caseObj.Id;  
    newEmail.subject = 'testthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionality';
     newEmail.TextBody='testthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionalitytestthewholefunctionality';

   

                                
  insert newEmail;
 }
 
  static testMethod void testMethod1()
    {
    EmailMessage[] newEmail = [SELECT id,Subject,TextBody,status, Incoming,FromAddressText__c,FromAddress,ToAddress,MessageDate,IsOpened,IsBounced,HasAttachment FROM EmailMessage where Subject = 'Test email'];
Case cas = [Select id from case where Preferred_Email__c = 'test@new.com'];
 Apexpages.StandardController sc = new Apexpages.StandardController(cas);
        EmailRelatedListController ext = new  EmailRelatedListController(sc);         
        ext.delEmail(); 


//EmailRelatedListController.delEmail();
 }
 }