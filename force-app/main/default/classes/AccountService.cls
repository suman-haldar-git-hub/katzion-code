/**
* @Author : Ankit
* @Company : Cognizant
* @description : This Service Class is used to handle data for Account object
*/
public inherited sharing class AccountService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta(); 
        
    /**
    * @Author : Ankit
    * @description :This method returns the Account for Line Manager
    * @return lstAccount
    * @param lineManager
    */
    public static List<Account> getAccountIdForLineManager(String lineManager) {
        List<Account> lstAccount = new List<Account>();
        if(String.isNotBlank(lineManager)) {
            lstAccount = AccountDomain.queryAccountFromLineManager(lineManager);
        }
        return lstAccount;
    }

    /**
    * @Author : Ankit
    * @description :This method populate Ariba External Id
    * @param lstAccount
    */
    public static void populateAribaExternalId(List<Account> lstAccount) {
        for(Account eachAccount: lstAccount) {
            if(
                String.isBlank(eachAccount.AribaExternalId__c)
                &&
                String.isNotBlank(eachAccount.Employee_ID__c)
            ) {
                eachAccount.AribaExternalId__c = eachAccount.Employee_ID__c;
            }
            
            if(
                String.isBlank(eachAccount.CATSExternalId__c)
                &&
                String.isNotBlank(eachAccount.Employee_ID__c)
            ) {
                eachAccount.CATSExternalId__c= eachAccount.Employee_ID__c;
            }
        }
    }

    /**
    * @Author : Amit Sharma
    * @description : This method is used to create universal task for Cats 
    * @param lstAccount - List of Account new version data
    * @param mapOldAccount - map of account id and account with old version of data
    */
    public static void createCatsTask(List<Account> lstAccount, Map<Id,Account> mapOldAccount) {
        Map<String,Id> mapEmployeeIdAndAccountId = new Map<String,Id> ();
        List<UniversalTaskList__c> lstUniversalTaskList = new List<UniversalTaskList__c> ();
        for(Account eachAccount : lstAccount) {
            if(isValidTocreateCatsTask(eachAccount,mapOldAccount))
            {
                mapEmployeeIdAndAccountId.put(eachAccount.Employee_ID__c,eachAccount.id);
            }
        }
        if(!mapEmployeeIdAndAccountId.isEmpty()){
            List<User> lstUserRecords = 
                                UserDomain.getCatsUserList(mapEmployeeIdAndAccountId.keySet());
            if(lstUserRecords != null && !lstUserRecords.isEmpty()){
                for(User objUser : lstUserRecords){
                    UniversalTaskList__c objTask  = new UniversalTaskList__c();
                    objTask.OriginatingSystem__c  = labelToContentMap.get('DEFAULTTASKTYPE');
                    objTask.SystemOfAction__c     = labelToContentMap.get('DEFAULTTASKTYPE');
                    objTask.Title__c              = labelToContentMap.get('CATSTITLE');
                    objTask.ReceivedDate__c       = Datetime.now();
                    objTask.DueDate__c            = Datetime.now().addDays(3);
                    objTask.AssignedToAccount__c  = mapEmployeeIdAndAccountId.get(
                                                                objUser.EmployeeID__c);
                    objTask.recordtypeId    = DescribeSObjectCall.getRecordTypeIdByDeveloperName(
                            'UniversalTaskList__c',labelToContentMap.get('UTLRECORDTYPETASK'));
                    objTask.SubmittedByAccount__c =  AccountDomain.getAdminAccountId(
                                            labelToContentMap.get('CATSADMINACCOUNT'),
                                            labelToContentMap.get('SYSTEMGENERATEDEMPLOYEEID'));
                    objTask.Status__c            = labelToContentMap.get('UTLTASKSTATUS');
                    objTask.Description__c       = labelToContentMap.get('CATSDESCRIPTION');
                    objTask.Type__c              = labelToContentMap.get('DEFAULTTASKTYPE');
                    objTask.DeepLink__c          = labelToContentMap.get('CATSDEEPLINKURL');
                    
                    lstUniversalTaskList.add(objTask);
                }
            }
        }
        if(!lstUniversalTaskList.isEmpty()){
            insert lstUniversalTaskList;
        }
            
    }

    /**
    * @Author : Amit Sharma
    * @description : This method is used to retun true or false
    * @return Boolean - true/false
    * @param objAccount - new Account data
    * @param mapOldAccount - map of account id and account with old version of data
    */
    public static Boolean isValidTocreateCatsTask(Account objAccount, 
                                                                Map<Id,Account> mapOldAccount)
    {
        if(objAccount.Employee_ID__c != null && 
              (
              (objAccount.IsTimeSheetSubmitter__c == true &&
               objAccount.IsTimeSheetSubmitter__c != 
                                      mapOldAccount.get(objAccount.id).IsTimeSheetSubmitter__c) ||
               (objAccount.IsTimeSheetApprover__c == true 
               && objAccount.IsTimeSheetApprover__c != 
                                      mapOldAccount.get(objAccount.id).IsTimeSheetApprover__c)
               )
           )
        {
            return true;
        }
        return false;
    }

    /**
    * @Author : Akshansh Jain
    * @description :This method populates the datetime when Leave balance is updated
    * @param lstAccount
    * @param mapOldAccount
    */
    public static void populateLeaveBalLastUpdated(
        List<Account> lstAccount, Map<Id,Account> mapOldAccount
    ) {
        for(Account acc : lstAccount) {
            if(
                (acc.AnnualLeaveBalance__c != mapOldAccount.get(acc.Id).AnnualLeaveBalance__c) ||
                (acc.PersonalLeaveBalance__c != mapOldAccount.get(acc.Id).PersonalLeaveBalance__c) ||
                (acc.PurchasedLeaveBalance__c != mapOldAccount.get(acc.Id).PurchasedLeaveBalance__c) ||
                (acc.LongServiceLeaveBalance__c != mapOldAccount.get(acc.Id).LongServiceLeaveBalance__c)
                //Removing BaseHour from Leave Balance calculation for As of Date/Time stamp
                //||(acc.BaseHours__c != mapOldAccount.get(acc.Id).BaseHours__c)
            ) {
                acc.LeaveBalanceLastUpdated__c = Datetime.now();
            }
        }
    }
}