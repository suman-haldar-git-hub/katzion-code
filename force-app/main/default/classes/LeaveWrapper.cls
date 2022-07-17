/**
* @author :Ankit Singh
* @description : wrapper class
*/
public class LeaveWrapper{
    @AuraEnabled
    public String donutChartData;
    @AuraEnabled
    public Integer baseHours = 0;
    @AuraEnabled
    public Boolean showPurchaseLeave = false;
    @AuraEnabled
    public Boolean showCashInLeave  = false;
    @AuraEnabled
    public Map<string,string> labelAndContentWrapperMap;
    @AuraEnabled
    public MyTeamLeaveService.MyTeamWrapper myTeamWrapper =
        new MyTeamLeaveService.MyTeamWrapper();
    @AuraEnabled
    public List<Form__c> leaveCardData = new List<Form__c>();
    @AuraEnabled
    public Account accLeaveData = new Account();
    @AuraEnabled
    public Boolean showMyLeave = false;
    @AuraEnabled
    public Boolean showMyTeam = false;
    @AuraEnabled
    public Boolean showApplyLeave = false;
    @AuraEnabled
    //String to store number of purchase leave eligible for
    public String noOfPlEligibleFor = '0 Week';
}