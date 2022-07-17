/**
 * @description       : This class is utlity class for all the SOQL for VIP Employee Matrix object.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-08-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-31-2021   Prathamesh Lad   Initial Version
**/
public inherited sharing class VIPEmployeeMatrixDomain {
    
    /**
    * @description This method is used to query VIP_Employee_Matrix__c object.
    * @author Prathamesh Lad | 04-01-2021 
    * @param baseQuery 
    * @return List<VIP_Employee_Matrix__c> 
    **/
    public static List<VIP_Employee_Matrix__c> getVIPEmployeeDetails(String baseQuery){
        List<VIP_Employee_Matrix__c> vipEmployessData=Database.query(baseQuery);
        return vipEmployessData;
    }
}