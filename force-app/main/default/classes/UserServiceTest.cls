/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
UserService class.
*/
@isTest(SeeAllData=false)
public class UserServiceTest {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
   /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
             labelToContentMap.get('INDIVIDUALACCOUNT')).getRecordTypeId();
        Id leaveBalanceRecdTypeId = Schema.SObjectType.Leave__c.getRecordTypeInfosByName().get(
            labelToContentMap.get('RECORDTYPELEAVEBALANCE')).getRecordTypeId();
        Id recordTypeIdTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get(
            labelToContentMap.get('RECORDTYPENUDGE')).getRecordTypeId();
        List<User> lstUser = new List<User>();
        User lineManagerUser = UserTestData.getUser('System Administrator', 'Test2');
        lineManagerUser.EmployeeID__c = 'test67';
        lineManagerUser.UserName = 'testinguserAnkit@testorg.com';
        lstUser.add(lineManagerUser);

        User testUser = UserTestData.getUser('System Administrator', 'Test2');
        testUser.EmployeeID__c = 'Test56';
        testUser.UserName = 'ankit@testorg.com';
        lstUser.add(testUser);
        insert lstUser;

        List<Account> acctList = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        acctList[0].Area_Dept_Name__c = 'Test';
        acctList[0].Location_Name__c = 'Test';
        acctList[0].IsLineManager__c = 'Yes';
        acctList[0].HasDOA__c = 'Yes';
        acctList[0].CareerLevel__c = 'Test';
        acctList[0].Region__c = 'Test';
        acctList[0].BaseHours__c = 40;
        acctList[0].Employee_Class__c = labelToContentMap.get('EMPLOYEEGROUPFULLTIME');
        acctList[0].TerminationDate__c = null;
        acctList[0].Employee_ID__c = 'test67';
        acctList[0].Line_Manager__c = 'test67';
        insert acctList;

        //create leave records
        List<Leave__c> leaveList = LeaveTestData.createLeaveRecds(3, leaveBalanceRecdTypeId);
        for(Integer i=0 ; i<3 ; i++) {
            leaveList[i].SubmittedBy__c = acctList[0].Id;
            if(i == 2) {
                leaveList[i].AnnualLeaveBal__c = 2000;
            } else if(i == 3) {
                leaveList[i].RecordTypeId = leaveBalanceRecdTypeId;
                leaveList[i].LeaveDuration__c  = 1;
                leaveList[i].Status__c = labelToContentMap.get('APPROVED');
                leaveList[i].AnnualLeaveBal__c = 2000;
            } else if(i == 1) {
                leaveList[i].LongServiceLeaveBal__c = null;
                leaveList[i].AnnualLeaveBal__c = 2000;
            }
        }
        insert leaveList;

        List<Task> taskList = TaskTestData.createTaskRecds(5, recordTypeIdTask);
        taskList[0].Status = labelToContentMap.get('TASKSTATUSINPROGRESS');
        taskList[0].OwnerId = lstUser[0].id;
        insert taskList;
        
        set<String> usrIds = new  set<String>();
        usrIds.add('test67');
        UserService.getEmployeeIdToUserId(usrIds);
    }

    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test MyTeamLeaveService method
    */
    @isTest
    static void testGetEmployeeIdToUserSmallPhoto(){
        List<Account> listOfAccount = [
            SELECT Id, Name, Employee_ID__c, GrossPay__c, PaymentFrequency__c, BaseHours__c,
            TerminationDate__c, Line_Manager__c, Employee_Class__c,
            (
                SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c,
                SubmittedBy__r.Name, SubmittedBy__r.Line_Manager__c,
                SubmittedBy__r.BaseHours__c, CreatedDate, SubmittedBy__r.Employee_ID__c
                FROM SubmittedBy__r
            )
            FROM Account
        ];
        System.assert(!listOfAccount.isEmpty());
        set<string> setEmpId = new set<string>();
        setEmpId.add(listOfAccount[0].Employee_ID__c);
        User userRecord = [SELECT Id,EmployeeID__c FROM User WHERE EmployeeID__c ='test67'];
        System.runAs(userRecord) {
            MyTeamLeaveService.WrapMyTeamData wrapMyTeamDataWrap = new MyTeamLeaveService.WrapMyTeamData();
            MyTeamLeaveService.MyTeamWrapper myTeamWrapper = new  MyTeamLeaveService.MyTeamWrapper();
            myTeamWrapper.wrapData.add(wrapMyTeamDataWrap);
            Test.startTest();
            UserService.getEmployeeIdToUserSmallPhoto(setEmpId,myTeamWrapper);
            Test.stopTest();
        }
    }
    
     /**
    @Author : Tintu Babu
    @Company :  Cognizant 
    @description : Update User To trigger UserTrigger
    */
     @isTest	
    static void updateUser1(){	
        Profile pr = [SELECT Id FROM Profile WHERE Name='PS ER Advisory'];	
        User erUser = new User();	
        erUser.LastName = 'test1';	
        erUser.Email='standarduser@testorg.com';	
        erUser.Alias = 'standt';	
        erUser.ProfileId = pr.id;	
        erUser.EmailEncodingKey='UTF-8';	
        erUser.LanguageLocaleKey='en_US';	
        erUser.LocaleSidKey='en_US';	
        erUser.TimeZoneSidKey = 'Asia/Kolkata';	
        erUser.UserName='standarduser101@testorg.com';	
        erUser.EmployeeID__c='Test0';	
        erUser.FederationIdentifier='testy@tt.com';	
        insert erUser;	
       	
        erUser.UserPermissionsMarketingUser=true;	
        erUser.UserPermissionsSupportUser=true;	
        erUser.UserPermissionsLiveAgentUser=true;	
        erUser.ForecastEnabled=true;	
        update erUser;	
        Profile p = [select id from profile where name='TeamMember-NoAccess'];	
        erUser.ProfileId = p.id;	
        update erUser;
        set<Id> usrIds = new  set<Id>();
        usrIds.add(erUser.Id);
        UserService.getIdUsernameMap(usrIds);	
    }
}
