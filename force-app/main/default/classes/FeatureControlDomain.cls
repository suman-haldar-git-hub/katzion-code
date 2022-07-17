/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This Domain Class is used to query FeatureControl__mdt
*/
public inherited sharing class FeatureControlDomain {
    
    /**
    * @Author : Akshansh Jain
    * @description :This method returns the FeatureControl__mdt details
    * @return FeatureControl__mdt
    * @param developerName
    */
    public static FeatureControl__mdt getFeatureControlRecordByDN(String developerName) {
        return [
            SELECT DeveloperName, Content__c, ModuleName__c FROM FeatureControl__mdt
            WHERE DeveloperName =: developerName Limit 1
        ];
    }


    /**
    * @author       Abhishek Setia
    * @description  This method returns the FeatureControl__mdt details
    * @return       FeatureControl__mdt
    * @param        developerNames
    */
    public static List<FeatureControl__mdt> getFeatureControlRecordByDN(Set<String> developerNames) {
        return [
            SELECT MasterLabel, Content__c, ModuleName__c FROM FeatureControl__mdt
            WHERE DeveloperName IN :developerNames
        ];
    }
    
    /**
    * @Author : Ankit Singh
    * @description :This method returns the FeatureControl__mdt details
    * @return FeatureControl__mdt
    * @param masterLabel
    */
    public static FeatureControl__mdt getFeatureControlRecord(String masterLabel) {
        return [
            SELECT Active__c, EligibleProfileForUTLCreation__c, PublicGroupCreationProfile__c,
            EnableCommsBatches__c, EnableUTLBatches__c, EnableLeaveBatches__c,Content__c,
            ModuleName__c, EnableSSBatches__c
            FROM FeatureControl__mdt
            WHERE MasterLabel =: masterLabel Limit 1
        ];
    }
    /**
    * @Author : Ankit Singh
    * @description :This method returns the FeatureControl__mdt details
    * @return List<FeatureControl__mdt>
    * @param setOfMasterLabel
    */
    public static List<FeatureControl__mdt> getFeatureControlRecord(Set<String> setOfMasterLabel) {
        return [
            SELECT Active__c, EligibleProfileForUTLCreation__c, PublicGroupCreationProfile__c,
            EnableCommsBatches__c, EnableUTLBatches__c, EnableLeaveBatches__c, MasterLabel,
            Content__c, ModuleName__c 
            FROM FeatureControl__mdt
            WHERE MasterLabel =: setOfMasterLabel
        ];
    }
    /**
    * @Author : Ankit Singh
    * @description :This method returns the FeatureControl__mdt details along with Walkthrough
    * @return List<FeatureControl__mdt>
    */
    public static List<FeatureControl__mdt> getFeatureControlWithWalkthroughRecord() {
        List<FeatureControl__mdt> lstFeatureControl = new List<FeatureControl__mdt>();
        lstFeatureControl = [
                SELECT Active__c, ModuleName__c,
                (
                    SELECT Id, Content__c, SequenceNumber__c, TooltipPosition__c, Header__c
                    FROM Walkthroughs__r
                )
                FROM FeatureControl__mdt
                WHERE ModuleName__c != null
                AND Active__c = true
        ];
        return lstFeatureControl;
    }
}