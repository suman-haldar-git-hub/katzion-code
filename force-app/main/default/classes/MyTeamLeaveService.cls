/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used handle MyTeam component in Leave Page.
*/
public with sharing class MyTeamLeaveService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author :Ankit Singh
    * @description : This method To return initial Wrapper records
    * @param initialRows
    * @return MyTeamWrapper
    */
    @AuraEnabled
    public static MyTeamWrapper getLeaveRecords(Integer initialRows) {
        MyTeamWrapper myTeamWrapper= new MyTeamWrapper();
        try{
            List<Account> lstAccount = new List<Account>();
            Set<String> setOfTeamEmployeeId = new Set<String>();
            Set<String> setOfEmployeeIdHasNudgeForCurrentWeek = new Set<String>();
            List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
            String employeeId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeId__c;
            if(String.isNotBlank(employeeId)){
                //Querying Salaried Team Members' records under logged in Line Manager
                //Order By AnnualLeaveBalance__c in Desc
                lstAccount = AccountDomain.getMyTeamsLeaveBalance(initialRows, employeeId, salariedEmp);
            }
            if(lstAccount != null && !lstAccount.isEmpty()){
                for(Account objAcc : lstAccount) {
                    setOfTeamEmployeeId.add(objAcc.Employee_ID__c);
                    WrapMyTeamData objWrapMyTeamData = new WrapMyTeamData();
                    objWrapMyTeamData.objAcc = objAcc;
                    myTeamWrapper.wrapData.add(objWrapMyTeamData);
                }
            }
            myTeamWrapper.totalRecords = AccountDomain.getTotalCountOfMyTeam(employeeId, salariedEmp);
            if(setOfTeamEmployeeId != null && !setOfTeamEmployeeId.isEmpty()) {
                myTeamWrapper = getUserProfileImage(setOfTeamEmployeeId, myTeamWrapper);
                setOfEmployeeIdHasNudgeForCurrentWeek =
                        NotificationService.getNudgesTaskForCurrentWeek(setOfTeamEmployeeId);
                myTeamWrapper = getNudgeDetailForCurrentWeekInWrapData(
                    setOfEmployeeIdHasNudgeForCurrentWeek,
                    myTeamWrapper
                );
            }
            myTeamWrapper.message = '';
            myTeamWrapper.success = true;
        }
        catch(Exception e) {
            myTeamWrapper.message = e.getMessage();
            myTeamWrapper.success = false;
        }
        return myTeamWrapper;
    }
    /**
    * @author :Ankit Singh
    * @description : This method To return myTeamWrapper
    * @param setOfEmployeeIdHasNudgeForCurrentWeek
    * @param myTeamWrapper
    * @return myTeamWrapper
    */
    public static MyTeamWrapper getNudgeDetailForCurrentWeekInWrapData(
        Set<String> setOfEmployeeIdHasNudgeForCurrentWeek,
        MyTeamWrapper myTeamWrapper
    ) {
        if(
                setOfEmployeeIdHasNudgeForCurrentWeek != null
                &&
                !setOfEmployeeIdHasNudgeForCurrentWeek.isEmpty()
                &&
                myTeamWrapper.wrapData != null
                &&
                !myTeamWrapper.wrapData.isEmpty()
        ) {
            for(WrapMyTeamData eachWrapData :myTeamWrapper.wrapData) {
                if(
                        eachWrapData.objAcc != null
                        &&
                        setOfEmployeeIdHasNudgeForCurrentWeek.contains(
                                eachWrapData.objAcc.Employee_ID__c
                        )
                ) {
                    eachWrapData.hasNudgeDetailForCurrentWeek = true;
                }
            }
        }
        return myTeamWrapper;
    }

    /**
    * @author :Ankit Singh
    * @description : This method set user profile image url in wrapper
    * @param setOfTeamEmployeeId
    * @param myTeamWrapper
    * @return myTeamWrapper
    */
    public static myTeamWrapper getUserProfileImage(
        Set<String> setOfTeamEmployeeId,
        MyTeamWrapper myTeamWrapper
    ) {
        Map<String, String> employeeIdToSmallPhotoUrl = new Map<String, String>();
        employeeIdToSmallPhotoUrl = UserService.getEmployeeIdToUserSmallPhoto(
                setOfTeamEmployeeId,
                myTeamWrapper
        );
        if(employeeIdToSmallPhotoUrl != null && !employeeIdToSmallPhotoUrl.isEmpty()) {
            for(WrapMyTeamData eachWrapData :myTeamWrapper.wrapData) {
                if(
                        eachWrapData.objAcc != null
                        &&
                        String.isNotBlank(eachWrapData.objAcc.Employee_ID__c)
                        &&
                        employeeIdToSmallPhotoUrl.containsKey(
                                eachWrapData.objAcc.Employee_ID__c
                        )
                        &&
                        String.isNotBlank(employeeIdToSmallPhotoUrl.get(
                                eachWrapData.objAcc.Employee_ID__c
                        ))
                ) {
                    eachWrapData.smallPhotoUrl = employeeIdToSmallPhotoUrl.get(
                            eachWrapData.objAcc.Employee_ID__c
                    );
                }
            }
        }
        return myTeamWrapper;
    }

    /**
    * @author :Ankit Singh
    * @description : This method set user profile image url in wrapper
    * @param param
    * @param message
    * @return response
    */
    @AuraEnabled
    public static LightningResponse createNudge(
        String param,
        String message
    ) {
        return NotificationService.createNudge(param, message);
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @param lineManager
    * @return myTeamWrapper
    */
    @AuraEnabled
    public static MyTeamWrapper loadMyTeamWrapperRecords(
        Integer rowLimit,
        Integer rowOffset,
        String lineManager
    ) {
        MyTeamWrapper myTeamWrapper= new MyTeamWrapper();
        try{
            List<Account> lstAccount = new List<Account>();
            Set<String> setOfTeamEmployeeId = new Set<String>();
            Set<String> setOfEmployeeIdHasNudgeForCurrentWeek = new Set<String>();
            if(String.isNotBlank(lineManager)) {
                lstAccount = AccountDomain.getMyTeamsLeaveBalanceUsingOffset(
                        rowLimit,
                        rowOffset,
                        lineManager
                );
            }

            if(lstAccount != null && !lstAccount.isEmpty()) {
                for(Account objAcc : lstAccount) {
                    setOfTeamEmployeeId.add(objAcc.Employee_ID__c);
                    WrapMyTeamData objWrapMyTeamData = new WrapMyTeamData();
                    objWrapMyTeamData.objAcc = objAcc;
                    myTeamWrapper.wrapData.add(objWrapMyTeamData);
                }
            }
            if(setOfTeamEmployeeId != null && !setOfTeamEmployeeId.isEmpty()) {
                myTeamWrapper = getUserProfileImage(setOfTeamEmployeeId, myTeamWrapper);
                setOfEmployeeIdHasNudgeForCurrentWeek =
                        NotificationService.getNudgesTaskForCurrentWeek(setOfTeamEmployeeId);
                myTeamWrapper = getNudgeDetailForCurrentWeekInWrapData(
                    setOfEmployeeIdHasNudgeForCurrentWeek,
                    myTeamWrapper
                );
            }
            myTeamWrapper.success = true;
        }
        catch(Exception e) {
            myTeamWrapper.message = e.getMessage();
            myTeamWrapper.success = false;
            PublishLogEventService.publishExceptionEvent(
                    'MyTeamLeaveService.cls on loadMyTeamWrapperRecords method',
                     e
            );
        }
        return myTeamWrapper;
    }

     /**
    * @author :Akshansh Jain
    * @description : This method return the Date on which Batch last run and updated Leave Balances
    * @return Account
    */
    @AuraEnabled
    public static Account getAsOfDate() {
        return AccountDomain.getLastUpdateAccountFromSAPPY();
    }
    
    /**
    * @author :Ankit Singh
    * @description : wrapper class
    */
    public class MyTeamWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public List<WrapMyTeamData> wrapData = new List<WrapMyTeamData>();
    }

    /**
    * @Author : Ankit Singh
    * @Company : Cognizant
    * @description : This inner Wrapper class to wrap data for Leave and hasNudge
    * value for current week
    */
    public class WrapMyTeamData
    {
        @AuraEnabled
        public Account objAcc = new Account();
        @AuraEnabled
        public String smallPhotoUrl;
        @AuraEnabled
        public Boolean hasNudgeDetailForCurrentWeek = false;
    }
}