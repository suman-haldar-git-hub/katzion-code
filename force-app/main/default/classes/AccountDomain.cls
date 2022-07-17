/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for Account object.
*/
public inherited sharing class AccountDomain { 
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query Account object based on passed record id.
    * @return : Account
    * @param accountId
    */
    public static Account queryAccountBasedOnId(Id accountId){
        return [Select Id, Name From Account Where Id =:accountId];
    }
    /**
    * @author : Daksh Madan
    * @description : This method is used to query Account object based on passed Employee_ID__c.
    * @return : Account
    * @param empId
    */
    public static Account queryAccountBasedOnEmpId(String empId){
        return [
            Select Id, FirstName, LastName, Employee_ID__c, Phone, PersonEmail, PersonBirthdate,
            Name,Group__c,Brand__c,OpsSupport__c,CompanyName__c,CompanyCode__c, Employee_Class__c,
            BrandCode__c,RegionCode__c, Region__c, Store_Id_Cost_Centre__c,  PaymentFrequency__c,
            BaseHours__c, AnnualLeaveBalance__c,LongServiceLeaveBalance__c,PersonalLeaveBalance__c,
            PurchasedLeaveBalance__c, Line_Manager__c, Country__c, TerminationDate__c, GroupCode__c,
            PersonContactId
            From Account
            Where Employee_ID__c =:empId LIMIT 1
        ];
    }

    /**
    *@author : Saurabh Bisht
    *@description : This method will return Account records based on Employee Id...
    *@return : List<Account>
    *@param empId
    */
    public static List<Account> getAccounts(String empId){
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id,FirstName,Name,PersonEmail,Employee_ID__c FROM Account
                    WHERE Employee_ID__c = :empId
                    LIMIT 1];
        return accounts;
    }

    /**
    *@author : Harshad Dani
    *@description : This method will return Account records based on List of Employee Id...
    *@return : Map<String, Account> accounts
    *@param  empIds
    */
    public static Map<String, Account> getAccounts(List<String> empIds){
        Map<String, Account> accounts = new Map<String, Account>();

        for(Account acct : [SELECT Id,FirstName,Employee_ID__c FROM Account
                             WHERE Employee_ID__c IN :empIds]
                            )
        {
            accounts.put(acct.Employee_ID__c, acct);
        }

        return accounts;
    }

    /**
    * @author : Sunil
    * @description : This method is used to query Account records along with Purchase Leave
    * and LWP records for current financial year based on passed Employee_ID__c.
    * @return : Account
    * @param empId
    * @param leaveCategoryValues
    */
    public static Account queryAccountWithLeaves(String empId, List<String> leaveCategoryValues){
        Integer financialYearStartMonth = Integer.valueOf(labelToContentMap.get('FINANCIALYEARSTARTMONTH'));
        Date fromDate = Date.newInstance(System.Today().Year()-1, financialYearStartMonth, 1);
        if(System.Today().Month() >= financialYearStartMonth){
            fromDate = Date.newInstance(System.Today().Year(), financialYearStartMonth, 1);
        }
        return [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c,Country__c,
            AnnualLeaveBalance__c,LongServiceLeaveBalance__c,PersonalLeaveBalance__c,
            PurchasedLeaveBalance__c,
            (
                SELECT Id, From__c, ToDate__c, Status__c, LeaveDuration__c,SubmittedDate__c,
                UnitOfLeave__c, Category__c, SubmittedByAccount__c, AnnualLeaveBal__c,
                PersonalLeaveBal__c, PurchasedLeaveBal__c, LongServiceLeaveBal__c,
                RecordType.DeveloperName, CreatedDate, SubmittedByAccount__r.Name,
                AssignedToAccount__c, SubmittedByAccount__r.FirstName, RecordType.Name,
                SubmittedByAccount__r.Employee_ID__c, ActionURL__c, OwnerId, Duration__c,
                OriginatingSystem__c, Type__c
                From SubmittedByAccount__r
                Where SubmittedDate__c >= :fromDate
                AND SubmittedDate__c <= :System.Now()
                AND Type__c =: labelToContentMap.get('LEAVELABEL')
                AND Category__c IN :leaveCategoryValues
                ORDER BY From__c ASC
            )
            FROM Account
            WHERE Employee_ID__c =:empId
            AND Employee_Class__c != null
        ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query my teams leave balance
    * based on passed Line Manager emp Id.
    * @return : List<Account>
    * @param initialRows
    * @param lineManager
    * @param salEmpCode
    */
    public static List<Account> getMyTeamsLeaveBalance(
        Integer initialRows,
        String lineManager,
        List<String> salEmpCode
    ){
        return [Select Id, AnnualLeaveBalance__c,LongServiceLeaveBalance__c,
                PersonalLeaveBalance__c, Employee_ID__c, Name, Employee_Class__c,
                PurchasedLeaveBalance__c, Line_Manager__c, BaseHours__c, FirstName, LastName
                From Account
                Where Line_Manager__c =: lineManager
                AND Employee_Class__c IN :salEmpCode
                AND AnnualLeaveBalance__c != null
                Order By AnnualLeaveBalance__c DESC NULLS LAST
                LIMIT :initialRows OFFSET 0
               ];
    }
    /**
    * @author : Praveen Tiwari
    * @description :This method returns total record count of Account with specific Line Manager.
    * @return : totalRecord
    * @param lineManager
    * @param salEmpCode
    */
    public static Integer getTotalCountOfMyTeam(String lineManager, List<String> salEmpCode) {
        Integer totalRecord = [
                SELECT COUNT()
                FROM Account
                WHERE Line_Manager__c =: lineManager
                AND Employee_Class__c IN :salEmpCode
                AND AnnualLeaveBalance__c != null
        ];
        return totalRecord;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query my teams leave balance
    * based on passed Line Manager emp Id.
    * @return : List<Account>
    * @param rowLimit
    * @param rowOffset
    * @param lineManager
    */
    public static List<Account> getMyTeamsLeaveBalanceUsingOffset(
        Integer rowLimit,
        Integer rowOffset,
        String lineManager
    ){
        List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
        return [Select Id, AnnualLeaveBalance__c,LongServiceLeaveBalance__c,
                PersonalLeaveBalance__c, Employee_ID__c, Name, Employee_Class__c,
                PurchasedLeaveBalance__c, Line_Manager__c, BaseHours__c, FirstName, LastName
                From Account
                Where Line_Manager__c =: lineManager
                AND Employee_Class__c IN :salariedEmp
                Order By AnnualLeaveBalance__c DESC NULLS LAST
                LIMIT :rowLimit OFFSET :rowOffset
               ];
    }
    /**
    * @author : Daksh
    * @description : This method will return account record whose Employee Group is not null.
    * @return : List<Account>
    * @param empId
    */
    public static List<Account> queryAcctFromEmpId(String empId){
        List<Account> acctList = new List<Account>();
        acctList = [
            Select Id, Employee_Class__c,Employee_ID__c,TerminationDate__c
            From Account
            Where Employee_ID__c =: empId
            AND Employee_Class__c != null
            Limit 1
        ];
        return acctList;
    }
    /**
    * @author : Daksh
    * @description : This method will return salaried/non-salaried account record.
    * @return : List<Account>
    * @param lineMgrId
    * @param salOrNonSalEmp
    */
    public static List<Account> queryAcctListFromEmpId
        (String lineMgrId, List<String> salOrNonSalEmp){
            return[
                Select Id
                From Account
                Where Line_Manager__c =: lineMgrId
                AND Employee_Class__c IN: salOrNonSalEmp
                Limit 1
            ];
    }

    /**
    * @author : Ankit Singh
    * @description : This method will return Line manager Account
    * @return : List<Account>
    * @param lineManager
    */
    public static List<Account> queryAccountFromLineManager(
        String lineManager
    ) {
        List<Account> lstAccount = new List<Account>();
        lstAccount = [
            SELECT Id,PersonContactId
            FROM Account
            WHERE Employee_ID__c =: lineManager
        ];
        return lstAccount;
    }

    /**
    * @author : Daksh
    * @description : This method is used to query Account object based on passed record id Set.
    * @return : List<Account>
    * @param acctIdSet
    */
    public static List<Account> queryAccountBasedOnIdSet(Set<Id> acctIdSet){
        return [
            Select Employee_ID__c,Line_Manager__c
            From Account
            Where Id IN: acctIdSet AND
            (Employee_ID__c != null OR Line_Manager__c != null)
        ];
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to query Account object based on passed id Set.
    * @return : List<Account>
    * @param setAccountId
    */
    public static List<Account> queryAccountForUniversalTask(Set<String> setAccountId){
        return [
            select id,Employee_ID__c, Name from account where id IN: setAccountId
        ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to perform DML on Account object by "Updating".
    * @param accountList
    */
    public static void updateAccountList(List<Account> accountList){
        if(Schema.sObjectType.Account.isUpdateable()){
            Database.update(accountList);
        }
    }
     /**
    * @description This method is used to query Account object based on payrollId.
    * @author Prathamesh Lad | 04-07-2021 
    * @param listPayrollId 
    * @return List<Account> 
    **/
    public static List<Account> getAccountDetails(List<String> listPayrollId){
        System.debug('comment goes here');
        List<Account> listAccounts=[Select id, Position__c, Division__c, Location_Name__c,
                                    State__c,Employee_ID__c from Account 
                                    where Employee_ID__c IN:listPayrollId];
        return listAccounts;
    }
    /**
    * @author : Sunil
    * @description : This method is used to query Account object based on passed record id Set.
    * @return : List<Account>
    * @param empId
    */
    public static List<Account> queryAccountWithTransactionCase(String empId){
        List<Account> acctList = new List<Account>();
        Date fromDate = Date.newInstance(System.Today().Year()-1,04,01);
        If(System.Today().Month()>=04){
            fromDate = Date.newInstance(System.Today().Year(),04,01);
        }
        Integer financialYearStartMonth = Integer.valueOf(labelToContentMap.get('FINANCIALYEARSTARTMONTH'));
        Date fromPurchaseDate = Date.newInstance(System.Today().Year()-1, financialYearStartMonth, 1);
        if(System.Today().Month() >= financialYearStartMonth){
            fromPurchaseDate = Date.newInstance(System.Today().Year(), financialYearStartMonth, 1);
        }
        List<String> leaveCategoryValues = new List<String>();
        if(labelToContentMap.get('ABSENCECATEGORYCODE') != null){
            leaveCategoryValues = labelToContentMap.get('ABSENCECATEGORYCODE').split(',');
        }
        leaveCategoryValues.add(labelToContentMap.get('PURCHASEDLEAVECODE'));
        Set<String> setFeatureControl = new Set<String>{'CASERECORDTYPETRANSACTION',
            'CASEREJECTED',
            'CASECATEGORYPAYANDBASICS',
            'CASESUBCATSALARYSACRIFICE',
            'ABSENCECATEGORYCODE'};
        Map<String,String> mapMetaData = new Map<String,String>();
        For(FeatureControl__mdt obj :FeatureControlDomain.getFeatureControlRecord(setFeatureControl)){
            mapMetaData.put(obj.MasterLabel, obj.Content__c);
        }
        acctList = [
            SELECT Id, FirstName, Employee_Class__c,Employee_ID__c,TerminationDate__c,
            PaymentFrequency__c, BaseHours__c, Line_Manager__c,Country__c,AnnualLeaveBalance__c,
            LongServiceLeaveBalance__c,PersonalLeaveBalance__c,PurchasedLeaveBalance__c,
            (SELECT id, RecordType.Name, CaseApproved__c,
             Category__c, Sub_Category__c, TypeofDevice__c
             FROM Cases
             WHERE RecordType.Name =:mapMetaData.get('CASERECORDTYPETRANSACTION')
             AND CaseApproved__c !=: mapMetaData.get('CASEREJECTED')
             AND Category__c =: mapMetaData.get('CASECATEGORYPAYANDBASICS')
             AND Sub_Category__c =: mapMetaData.get('CASESUBCATSALARYSACRIFICE')
             AND CreatedDate <=:System.Now()
             AND CreatedDate >=:fromDate
            ),
            (
                SELECT Id, From__c, ToDate__c, Status__c, LeaveDuration__c,SubmittedDate__c,
                UnitOfLeave__c, Category__c, SubmittedByAccount__c, AnnualLeaveBal__c,
                PersonalLeaveBal__c, PurchasedLeaveBal__c, LongServiceLeaveBal__c,
                RecordType.DeveloperName, CreatedDate, SubmittedByAccount__r.Name,
                AssignedToAccount__c, SubmittedByAccount__r.FirstName, RecordType.Name,
                SubmittedByAccount__r.Employee_ID__c, ActionURL__c, OwnerId, Duration__c,
                OriginatingSystem__c, Type__c
                From SubmittedByAccount__r
                Where SubmittedDate__c >= :fromPurchaseDate
                AND SubmittedDate__c <= :System.Now()
                AND Type__c =: labelToContentMap.get('LEAVELABEL')
                AND Category__c IN :leaveCategoryValues
                ORDER BY From__c ASC
            )
            From Account
            Where Employee_ID__c =: empId
            AND Employee_Class__c != null
            Limit 1
        ];
        return acctList;
    }

    /**
    * @author : Sunil
    * @description : This method is used to query Account object along with Leave
    * based on passed Employee_ID__c.
    * @return : Account
    * @param empId
    */
    public static List<Account> queryAccountWithNstReq(String empId){
        return [
                SELECT Id, Name, Employee_ID__c,
                (
                    SELECT Id, Banner__c, State__c, Time_Travel__c, Distance_Travelled__c,
                    EntryType__c, ManagerName__c, StoreName__c, CreatedDate , Status__c,
                    VisitedDate_Start_Time__c,VisitedDate_End_Date__c, ManagerUser__c,
                    Break_Duration__c, Comments__c, VisitedDate_End_Time__c, Timezone__c,
                    Store__r.Store_Number__c,
                    toLabel(Store__r.Store_Type__c), VisitedDate_Start__c, VisitedDate_End__c
                    FROM NSTRequest__r
                    WHERE VisitedDate_Start__c = LAST_N_DAYS:2
                    ORDER BY VisitedDate_Start__c ASC
                )
                FROM Account
                WHERE Employee_ID__c =:empId
        ];
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to query Account object along with MyIncentive Case
    * @return : List<Account>
    * @param empId
    * @param parentCaseId
    * @param mapMetaData
    */
    public static List<Account> getIndAccountWithMyIncentiveCase(String empId, String parentCaseId,
                                                                Map<String, String> mapMetaData)
        {
        Date fromDate = Date.newInstance(System.Today().Year()-1,04,01);
        If(System.Today().Month()>=04){
            fromDate = Date.newInstance(System.Today().Year(),04,01);
        }
        List<Account> accList = new List<Account>();
        accList = [
            Select Id,
            (Select Id, LastUpdated__c, Nomination__c, CaseNumber
             From Cases
             Where ParentId =:parentCaseId
             AND CreatedDate <= :System.Now()
             AND CreatedDate >= :fromDate
             AND Category__c = :mapMetaData.get('CASECATEGORYPAYANDBASICS')
             AND Sub_Category__c = :mapMetaData.get('CASECATEGORYSUPERANNUATIONPROCESSING')
             AND isClosed = False
            )
            From Account
            Where Employee_ID__c =: empId
        ];
        return accList;
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to get Admin account id for Cats
    * @return : List<User> - return all valid Users based on employee id
    * @param accountName - name of admin account
    * @param aribaExternalId - ariba external id( for Cats : UTL_SYS)
    */
    public static Id getAdminAccountId(String accountName,String aribaExternalId){
        List<Account> lstAccount = [SELECT Id,Employee_ID__c
                                 FROM Account
                                WHERE Name =: accountName AND
                                AribaExternalId__c =: aribaExternalId];
        if(lstAccount != null && !lstAccount.isEmpty()){
            return lstAccount[0].id;
        }
        else{
            return null;
        }
    }

    /**
* @description This method is used to query Account object based on payrollId.
* @author Prathamesh Lad | 04-07-2021
* @param listPayrollId
* @return List<Account>
**/

public static List<Account> getAccountDetails(List<String> listPayrollId){
    List<Account> listAccounts=[Select id, Position__c, Division__c, Location_Name__c,
    State__c,Employee_ID__c from Account
    where Employee_ID__c IN:listPayrollId];
    return listAccounts;
    }

    /**
    * @author : Akshansh Jain
    * @description : This method is used to get last updated Date of Leave Balance.
    * @return : Account - return latest Account record on which Leave balance last updated
    */
    public static Account getLastUpdateAccountFromSAPPY(){
        Account acc = new Account();
        acc = [SELECT Id, LeaveBalanceLastUpdated__c From Account
                WHERE LeaveBalanceLastUpdated__c != null
                Order by LeaveBalanceLastUpdated__c DESC LIMIT 1];
        return acc;
    }

}
