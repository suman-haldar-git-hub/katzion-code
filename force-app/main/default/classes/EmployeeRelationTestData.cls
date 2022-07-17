/**
* @author : Shubham Shukla
* @company : Cognizant
* @description : This is test data builder class for Contact object.
*/ 
@isTest
public class EmployeeRelationTestData {
    /**
    * @author : Shubham Shukla
    * @company : Cognizant
    * @description : This will create the Employee_Relation_Master__c records.
    * @return : List<Employee_Relation_Master__c>
    * @param count
    * @param recordTypeId
    */
    public static List<Employee_Relation_Master__c> createEmpRelRecords(
        Integer count, String recordTypeId){
        // List Intilization
        List<Employee_Relation_Master__c> emprels = 
            new List<Employee_Relation_Master__c>();
        for (Integer i = 0; i < count; i++) {
            Employee_Relation_Master__c singleRecord = 
                new Employee_Relation_Master__c();
            singleRecord.Selection_value__c = 'xyz1';
            if(String.isNotEmpty(recordTypeId)){
                singleRecord.RecordTypeId = recordTypeId;
            }
            emprels.add(singleRecord);
        }
        return emprels;
    }
}