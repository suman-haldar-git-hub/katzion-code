/**
 * @description       : This is test data builder class for VIP Employee Matrix object.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-08-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   04-08-2021   Prathamesh Lad   Initial Version
**/
@isTest
public class VIPEmployeeMatrixTestData {
   /**
    * @description This method is used to create VIP Employee Matrix object record
    * @author Prathamesh Lad | 04-08-2021 
    * @param type
    * @param value
    * @param isVIP
    * @return VIP_Employee_Matrix__c 
    **/
    public static VIP_Employee_Matrix__c getVIPMasterRecord
        (String type, String value, String isVIP) {
        VIP_Employee_Matrix__c obj=new VIP_Employee_Matrix__c();
        obj.type__c = type;
        obj.value__c = value;
        obj.Is_VIP__c=isVIP;
        return obj;
    } 
}