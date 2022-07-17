/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This class contains all the logic of VerticalNavigation component
*/
public with sharing class VerticalNavigationController {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /** 
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class VerticalMgmtWrapper {
        Boolean showLeaveTab;
    }
    /**
* @author : Daksh
* @description : This method is used to fetch all the required data on load.
* @return : LightningResponse
*/
    public static LightningResponse getVerticalMgmtWrapperData(){
        LightningResponse response = new LightningResponse();
        try{
            VerticalMgmtWrapper dataWrapper = new VerticalMgmtWrapper();
            Boolean showLeaveTab = false;
            if(!topLevelCheck()){
                dataWrapper.showLeaveTab = topLevelCheck();
                response.payLoad = JSON.serialize(dataWrapper);
            }
            else{
                User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
                String userEmpId = userDetail.EmployeeID__c;
                if(String.isNotBlank(userEmpId)){
                    List<Account> acctList = AccountDomain.queryAcctFromEmpId(userEmpId);
                    if(!acctList.isEmpty()){
                        showLeaveTab = 
                            checkSalariedOrContractorAcct(acctList[0]);
                        dataWrapper.showLeaveTab = showLeaveTab;
                        response.payLoad = JSON.serialize(dataWrapper);
                    }
                    /*else{
                        response.isError=true;
                        response.errorOrSuccessMessage = labelToContentMap.get('ACCTOREMPGROUPISMISSING');
                    }*/
                }
                /*else{
                    response.isError=true;
                    response.errorOrSuccessMessage = labelToContentMap.get('USEREMPIDISMISSING');
                }*/
            }
        }
        catch(Exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent('VerticalNavigationController.cls on Load',ex);
        }
        return response;
    }
    /**
* @author : Daksh
* @description : This method check whether EnableLeaveTab checkbox is checked.
* @return : Boolean
*/
    private static Boolean topLevelCheck(){
        FeatureControl__mdt featureControlMtd = [
            Select Active__c 
            From FeatureControl__mdt
            Where MasterLabel = 'EnableLeaveTab'
        ];
        return featureControlMtd.Active__c;
    }
    /**
* @author : Daksh
* @description : This method check whether the Employee Group of Account is Salaried/Contractor.
* @return : Boolean
* @param  acctRecd
*/
    private static Boolean checkSalariedOrContractorAcct(Account acctRecd){
        List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
        List<String> contractorEmp = (labelToContentMap.get('CONTRACTOREMPLOYEE')).split(',');
        String acctEmpGroup = acctRecd.Employee_Class__c;
        if(salariedEmp.contains(acctEmpGroup)){
            return true;
        }
        else if(contractorEmp.contains(acctEmpGroup)){
            return checkSalariedDirectReportToUser(acctRecd.Employee_ID__c,salariedEmp); 
        }
        else{
            return false;
        }
    }
    /**
* @author : Daksh
* @description : This method is check whether contractor is with at least one salaried direct reports.
* @return : Boolean
* @param  empId
* @param  salariedEmp
*/
    public static Boolean checkSalariedDirectReportToUser
        (String empId,List<String> salariedEmp){
            if(String.isNotBlank(empId)){
                if(AccountDomain.queryAcctListFromEmpId(empId,salariedEmp).isEmpty()){
                    return false;
                }
                else{
                    return true;
                }
            }
            else{
                return false;
            }
        }
}