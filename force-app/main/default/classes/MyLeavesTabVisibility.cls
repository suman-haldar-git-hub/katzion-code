/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This class contains logic to show/hide tabs in MyLeaveTab cmp.
*/
public with sharing class MyLeavesTabVisibility {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /** 
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class MyLeavesTabWrapper {
        public Boolean isContractor;
        public Boolean isSalariedDirectReport;
    }
    /**
* @author : Daksh
* @description : This method is used to fetch all the required data on load.
* @return : LightningResponse
*/
    public static MyLeavesTabVisibility.MyLeavesTabWrapper getMyLeavesTabWrapperData(){
        MyLeavesTabWrapper dataWrapper = new MyLeavesTabWrapper();
        try{
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
                            BaseCommunityLayoutService.checkSalariedDirectReportToUser
                            (acctList[0].Employee_ID__c,(labelToContentMap.get('SALARIEDEMPLOYEE')).split(','));
                    }
                    dataWrapper.isContractor = isContractor;
                    dataWrapper.isSalariedDirectReport = isSalariedDirectReport;
                }
            }
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'MyLeavesTabVisibility.cls on Load',ex);
        }
        return dataWrapper;
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