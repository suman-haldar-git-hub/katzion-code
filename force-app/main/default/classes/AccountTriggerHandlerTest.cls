/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This is the test class of AccountTriggerHandler.
*/
@isTest(SeeAllData=false)
public class AccountTriggerHandlerTest {
    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        //create account records
        Id personAcctRecdTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Account').
            getRecordTypeId();
        //create account records
        List<Account> accountList = 
            AccountTestData.createPersonAccount(2, personAcctRecdTypeId);
        accountList[1].Line_Manager__c = accountList[0].Employee_ID__c;
        insert accountList;
    }
}