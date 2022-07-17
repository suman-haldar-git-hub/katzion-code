/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
AccountDomain class.
*/
@isTest(SeeAllData=false)
public class AccountDomainTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].Area_Dept_Name__c = 'Test';
        acctList[0].Location_Name__c = 'Test';
        acctList[0].IsLineManager__c = 'Yes';
        acctList[0].HasDOA__c = 'Yes';
        acctList[0].CareerLevel__c = 'Test';
        acctList[0].Region__c = 'Test';
        acctList[0].BaseHours__c = 40;
        acctList[0].Employee_Class__c = 'F';
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = '123456';
        acctList[0].Line_Manager__c = '1234567';
        acctList[0].AribaExternalId__c = '56732hdw';
        insert acctList;
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123444';
        insert accountTest;
    }

    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test AccountDomain method
    */
    @isTest
    static void testAccountDomain() {
        List<Account> accounts = new List<Account>();
        Set<String> setAccId = new Set<String>();
        accounts = [SELECT Id,Name, Employee_ID__c,AribaExternalId__c, Line_Manager__c FROM Account];
        setAccId.add(accounts[0].id);
        List<String> leaveCategoryValues = new List<String>();
        if(labelToContentMap.get('ABSENCECATEGORYCODE') != null){
            leaveCategoryValues = labelToContentMap.get('ABSENCECATEGORYCODE').split(',');
        }
        System.assert(!accounts.isEmpty());
        AccountDomain.getAccounts(accounts[0].Employee_ID__c);
        AccountDomain.queryAccountBasedOnEmpId(accounts[0].Employee_ID__c);
        AccountDomain.queryAccountBasedOnId(accounts[0].Id);
        AccountDomain.queryAccountBasedOnIdSet(new Set<Id> {accounts[0].Id});
        AccountDomain.queryAccountFromLineManager(accounts[0].Line_Manager__c);
        AccountDomain.queryAccountWithLeaves(accounts[0].Employee_ID__c,leaveCategoryValues);
        AccountDomain.queryAcctFromEmpId(accounts[0].Line_Manager__c);
        AccountDomain.queryAcctListFromEmpId(
                accounts[0].Employee_ID__c,
                new List<String> {Label.EMPLOYEEGROUPFULLTIME}
        );
        AccountDomain.getMyTeamsLeaveBalance(1,accounts[0].Line_Manager__c,New List<String>{'F'});
        AccountDomain.getTotalCountOfMyTeam(accounts[0].Line_Manager__c,New List<String>{'F'});
        AccountDomain.getMyTeamsLeaveBalanceUsingOffset(1,2,accounts[0].Line_Manager__c);
        AccountDomain.queryAccountForUniversalTask(setAccId);
        AccountDomain.queryAccountWithTransactionCase(accounts[0].Employee_ID__c);
        AccountDomain.queryAccountWithNstReq(accounts[0].Employee_ID__c);
        
       
        AccountDomain.getAdminAccountId(accounts[0].Name,accounts[0].AribaExternalId__c);
        accounts = [SELECT Id, AnnualLeaveBalance__c FROM Account];
        accounts[0].AnnualLeaveBalance__c = 160;
        AccountDomain.updateAccountList(accounts);
        Account resp = AccountDomain.getLastUpdateAccountFromSAPPY();
        system.assertEquals(resp!=null, true);
        //Updated by Harshad
        List<String> payrollIds = new List<String>{'123444'};
        AccountDomain.getAccounts(payrollIds);        
    }
    @isTest
    static void getAccountsTest(){
        List<Account > lstAccounts = [SELECT Id FROM Account];
        AccountDomain.updateAccountList(lstAccounts);
        test.startTest();
        List<Account> resp = AccountDomain.getAccounts('123444');
        test.stopTest();
        system.assertEquals(resp!=null, true);
    }
}