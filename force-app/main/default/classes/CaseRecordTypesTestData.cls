/**
* @author : Sumit Banarji
* @company : Cognizant
* @description : This is test data builder class for Case_Record_Types__c custom setting.
*/
@isTest
public class CaseRecordTypesTestData {
    
    /**
    * @author : Sumit Banarji
    * @company : Cognizant
    * @description : This will create the Case_Record_Types__c custom setting.
    * @return : Case_Record_Types__c
    */
    public static Case_Record_Types__c crateTestCustomSetting() {
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();

        for(RecordType recType : [SELECT ID, Name, DeveloperName, sObjectType 
                                    FROM RecordType 
                                    WHERE sObjectType = 'Case']){
            if(recType.DeveloperName == 'Transaction'){
                caseRecTypeCS.Transaction_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'ER_Case'){
                caseRecTypeCS.ER_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'WOW_NZ_ER_Case'){
                caseRecTypeCS.WOW_NZ_ER_Case__c = recType.Id;
            }
            else if(recType.DeveloperName == 'PS_Query_Case'){
                caseRecTypeCS.Query_Case__c = recType.Id;
            }
        }
        insert caseRecTypeCS;
        return caseRecTypeCS;
    }
}
