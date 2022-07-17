/**
 * @author : Shubham Shukla
 * @description : This class handles the DML operations performed on the Label_Master__c records...
*/   
public with sharing class LabelMasterDomain {
    /**
     * @author : Shubham Shukla
     * @param labels
     * @return List
     * @description : This method is used to Query Label Master object
    */
    public static List<Label_Master__c> getLabelMaster(List<String> labels){
        return [Select Id,Label_Name__c,Label_Color__c from Label_Master__c
        where Label_Name__c IN:labels];
    }

}
