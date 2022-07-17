/**
     * @Author       : Shubham Shukla
     * @Company      : Saasfocus
     * @description  : This class is to used to perform the DML operation or fetch the data of the EmployeeRealtionMaster.
**/ 
public inherited sharing class EmployeeRealtionMasterDomain {
    /**
    @author : Shubham Shukla
    @description : This method return the employee relationmaster data
    @return list<Employee_Relation_Master__c>
    */
    public static list<Employee_Relation_Master__c> getEmployeeRelationMaster(){
        return [select id,recordtypeid,Selection_value__c
        ,Parent_value__c,Parent_value__r.recordtypeid,Parent_value__r.Selection_value__c,
        Further_Information__c,sequence_number__c 
        from Employee_Relation_Master__c order by Sequence_Number__c ASC NULLS LAST limit 50000]; 
    }
}
