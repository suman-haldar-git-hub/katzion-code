/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for DistributionList__c object.
*/
@isTest
public class DistributionListTestData {
    /**
* @author : Daksh Madan
* @company : Cognizant
* @description : This will create the contact records.
* @return : List<DistributionList__c>
* @param count
*/
    public static List<DistributionList__c> createDistributionListRecords(Integer count){
        // List Intilization
        List<DistributionList__c> distributionList = new List<DistributionList__c>();
        for (Integer i = 0; i < count; i++) {
            DistributionList__c singleRecord = new DistributionList__c();
            singleRecord.Name = 'DistributionList Test Date '+i;
            singleRecord.Description__c = 'Test Discription '+i;
            singleRecord.OpsSupport__c = 'IT';
            singleRecord.Group__c = 'Corporate';
            singleRecord.Brand__c = 'IT';
            singleRecord.Location__c = 'Sydney';
            singleRecord.EmployeeGroup__c = 'IT';
            singleRecord.EmployeeSubgroup__c = 'IT-Subgroup';
            singleRecord.Area__c = 'North Sydney';
            singleRecord.CareerLevel__c = 'Medium';
            distributionList.add(singleRecord);
        }
        return distributionList;
        }
}