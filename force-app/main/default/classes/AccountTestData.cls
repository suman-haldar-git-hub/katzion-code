/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for Contact object.
*/
@isTest
public class AccountTestData {
    /**
    * @author : Daksh Madan
    * @company : Cognizant
    * @description : This will create the contact records.
    * @return : List<Account>
    * @param count
    * @param recordTypeId
    */
    public static List<Account> createAccountRecords(Integer count, String recordTypeId){
        // List Intilization
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account singleRecord = new Account();
            singleRecord.Name = 'Business Account Test Data '+i;
            singleRecord.Employee_ID__c = 'Test'+i;
            singleRecord.Business_Account_Type__c = 'Internal';
            if(String.isNotEmpty(recordTypeId)){
                singleRecord.RecordTypeId = recordTypeId;
            }
            accountList.add(singleRecord);
        }
        return accountList;
    }

    /**
    * @author : Ankit Singh
    * @company : Cognizant
    * @description : This will create the contact records.
    * @return : List<Account>
    * @param count
    * @param recordTypeId
    */
    public static List<Account> createPersonAccount(Integer count, String recordTypeId){
        // List Intilization
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account singleRecord = new Account();
            singleRecord.FirstName = 'Woolworth';
            singleRecord.LastName = 'Countdown'+i;
            singleRecord.Employee_ID__c = 'Test'+i;
            singleRecord.Business_Account_Type__c = 'Internal';
            if(String.isNotEmpty(recordTypeId)){
                singleRecord.RecordTypeId = recordTypeId;
            }
            accountList.add(singleRecord);
        }
        return accountList;
    }

    
    /**
    * @description This will create Account records for VIPEmployeeService
    * @author Prathamesh Lad | 04-08-2021 
    * @param count 
    * @param recordTypeId 
    * @return List<Account> 
    **/
    public static List<Account> createAccForVIPEmpService(Integer count, String recordTypeId){
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            Account singleRecord = new Account();
            singleRecord.FirstName = 'Woolworth';
            singleRecord.LastName = 'Countdown'+i;
            singleRecord.Employee_ID__c = 'Test'+i;
            singleRecord.Position__c = 'Test Position';
            singleRecord.Division__c = 'Test Division';
            singleRecord.Location_Name__c = 'Test Location';
            singleRecord.State__c = 'Test State';
            singleRecord.recordTypeId=recordTypeId;
            accountList.add(singleRecord);
        }
        return accountList;
    }
}