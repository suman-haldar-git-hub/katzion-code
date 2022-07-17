/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This class contains all the logic of MyLeavesTab component
*/
public with sharing class MyLeavesTabController {
     private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /** 
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class MyLeavesTabWrapper {
        Boolean isContractor;
        Boolean isSalariedDirectReport;
    }
    /**
* @author : Daksh
* @description : This method is used to fetch all the required data on load.
* @return : LightningResponse
*/
    public static LightningResponse getMyLeavesTabWrapperData(){
        LightningResponse response = new LightningResponse();
        try{
            MyLeavesTabWrapper dataWrapper = new MyLeavesTabWrapper();
            Boolean isContractor = false;
            Boolean isSalariedDirectReport = true;
            User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
            String userEmpId = userDetail.EmployeeID__c;
            if(String.isNotBlank(userEmpId)){
                List<Account> acctList = AccountDomain.queryAcctFromEmpId(userEmpId);
                if(!acctList.isEmpty()){
                    isContractor = checkForContractorEmp(acctList[0].Employee_Class__c);
                    if(!isContractor){
                        isSalariedDirectReport = 
                            VerticalNavigationController.checkSalariedDirectReportToUser
                            (acctList[0].Employee_ID__c,(labelToContentMap.get('SALARIEDEMPLOYEE')).split(','));
                    }
                    dataWrapper.isContractor = isContractor;
                    dataWrapper.isSalariedDirectReport = isSalariedDirectReport;
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
        catch(Exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'MyLeavesTabController.cls on Load',ex);
        }
        return response;
    }
    /**
* @author : Daksh
* @description : This method is check whether the user is salaried/contractor employee.
* @return : Boolean
* @param  acctEmpGroup
*/
    public static Boolean checkForContractorEmp(String acctEmpGroup){
        List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
        List<String> contractorEmp = (labelToContentMap.get('CONTRACTOREMPLOYEE')).split(',');
        if(contractorEmp.contains(acctEmpGroup)){
            return true;
        }
        return false;
    }
}