/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query data for custom metadeta
* MyTeamSlabs__mdt object
*/
public inherited sharing class MyTeamSlabDomain {
    /**
    * @Author : Ankit Singh
    * @description :This method returns the MyTeamSlabs__mdt details
    * in between the maxAnnualLeaveBalance
    * @return lstMyTeamSlab
    * @param maxAnnualLeaveBalance
    */
    public static List<MyTeamSlabs__mdt> queryMyTeamSlab(Integer maxAnnualLeaveBalance) {
        List<MyTeamSlabs__mdt> lstMyTeamSlab = new List<MyTeamSlabs__mdt>();
        lstMyTeamSlab =  [
                SELECT MaximumAnnualLeaveBalance__c, MinimumAnnualLeaveBalance__c, MaximumSlab__c
                FROM MyTeamSlabs__mdt
                WHERE MinimumAnnualLeaveBalance__c <=: maxAnnualLeaveBalance
                AND MaximumAnnualLeaveBalance__c >=: maxAnnualLeaveBalance
        ];
        return lstMyTeamSlab;
    }
}