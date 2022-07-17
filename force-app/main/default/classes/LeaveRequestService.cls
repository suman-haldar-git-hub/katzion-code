/**
* @author : Sunil
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of LeaveManagementController
*/
public with sharing class LeaveRequestService {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Praveen Tiwari
    * @description : This method used to check all the criteria to show Cashin Leave comp.
    * @param objAccount
    * @return isEligible
    */
    public static Boolean checksToDisplayCashIn(Account objAccount){
        Boolean isEligible = false;
        Integer baseHours = 0;
        if(objAccount.BaseHours__c != null){
            baseHours = baseHours + (Integer)objAccount.BaseHours__c;
        }
        if(
            objAccount.AnnualLeaveBalance__c != null &&
            (integer)objAccount.AnnualLeaveBalance__c > (baseHours * 4) &&
            (
                objAccount.Country__c != null &&
                objAccount.Country__c == labelToContentMap.get('AUSTRALIA')
            ) &&
            (
                String.isNotBlank(objAccount.Employee_Class__c)
                &&
                (
                    objAccount.Employee_Class__c == labelToContentMap.get('EMPLOYEEGROUPFULLTIME')
                    ||
                    objAccount.Employee_Class__c == labelToContentMap.get('EMPLOYEEGROUPPARTTIME')
                )
                &&
                objAccount.TerminationDate__c == null
            )
        ){
            isEligible = true;
        }
        return isEligible;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method used to create data for Doughnut Chart.
    * @param objeAcc
    * @return String
    */
    public static String createDoughnutChartData
    (
        Account objeAcc
    ){
        Map<String,Decimal> mapLeaveToBalance = new Map<String,Decimal>();
        Decimal annualLeave = objeAcc.AnnualLeaveBalance__c;
        Decimal baseHours = objeAcc.BaseHours__c;
        if(annualLeave != null){
            mapLeaveToBalance.put('Annual', annualLeave.setScale(2));
            if(baseHours != null
                &&
                annualLeave > baseHours * 8
            ){
                mapLeaveToBalance.put('Annual', (baseHours * 8).setScale(2));
                mapLeaveToBalance.put('Excess', (annualLeave - (baseHours * 8)).setScale(2));
            }
        }
        List<DoughnutDataWrapper> wrapperData = new List<DoughnutDataWrapper>();
        for(String key : mapLeaveToBalance.keySet())
        {
            DoughnutDataWrapper ddw = new DoughnutDataWrapper();
            ddw.name=key;
            ddw.y=mapLeaveToBalance.get(key);
            wrapperData.add(ddw);
        }
        return System.json.serialize(wrapperData);
    }
     /**
    * @Author : Praveen Tiwari
    * @Company : Cognizant
    * @description : This Wrapper class to create data for Doughnut chart.
    */
    public class DoughnutDataWrapper
    {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Decimal y;
    }
}