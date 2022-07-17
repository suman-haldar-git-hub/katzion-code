/**
 * @author : Saurabh Bisht
 * @company : SaasFocus
 * @description : This class handles the positive and negative scenarios for 'CaseDomain' class...
 */
@isTest
public class CaseDomainTest {
    
    @testSetup
    static void makeData(){
        Id recordTypeIdPersonAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(
            Label.INDIVIDUALACCOUNT).getRecordTypeId();
        List<Account> accountTest = AccountTestData.createPersonAccount(1, recordTypeIdPersonAccount);
        accountTest[0].Employee_ID__c = '123456';
        insert accountTest;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='caseTriggeruser1@testorg.com',
            SalarySacrificeNotification__c = true, SalarySacrificeNotificationChannel__c = 'Email');
        insert u;

        Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        Case_Record_Types__c caseRecTypeCS = new Case_Record_Types__c();
        caseRecTypeCS.Transaction_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.WOW_NZ_ER_Case__c = String.valueOf(caseRecTypeId);
        caseRecTypeCS.Query_Case__c = String.valueOf(caseRecTypeId);
        insert caseRecTypeCS;

        List<Case> caseTest = CaseTestData.getCaseData(
            accountTest[0].Id,
            1,
            false
        );
        caseTest[0].recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        caseTest[0].ownerID = Label.Case_Owner_Id;
        caseTest[0].RequesterUser__c = u.id;
        insert caseTest[0];
        
        List<Case> caseTest1 = CaseTestData.getCaseData(
            accountTest[0].Id,
            1,
            false
        );
        caseTest1[0].Category__c = 'Pay and the Basics';
        caseTest1[0].Sub_Category__c = 'Superannuation Processing';
        caseTest1[0].Subject = 'MyIncentive Info AVC Nominations Full Year';
        caseTest1[0].AccountId = accountTest[0].Id;
        insert caseTest1[0];
    }
    
    @isTest
    static void insertNewCaseTest(){
        List<Account> lstAcc = [Select Id from Account];
        Case objCase = new Case();
        objCase.Web_On_Behalf_Of_Employee_Id__c = '123456';
        objCase.Category__c = 'Pay and the Basics';
        objCase.Sub_Category__c = 'WOW People Discount Card';
        objCase.origin = 'Email';
        objCase.on_behalf_of_name__c = lstAcc[0].id;
        objCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId();
        CaseDomain.insertNewCase(objCase);
        system.assertEquals(objCase!=null, true);
        test.startTest();
        List<Case> lstCase = [Select Id from Case];
        CaseDomain.getCurrentUserCases();
        CaseDomain.queryCases(new Set<String>{lstCase[0].id});
        CaseDomain.updateCases(lstCase);
        CaseDomain.getCaseRecordDetail(new set<Id>{lstCase[0].id});
        CaseDomain.getCaseFilteredRecord(new Set<Id>{lstCase[0].id},true);
        CaseDomain.getCaseAndCommentRecord(new Set<String>{lstCase[0].id});
        
        List<Case> lstCase1 = [Select Id from Case where Subject =: 'MyIncentive Info AVC Nominations Full Year'];
        system.assertEquals(lstCase1!=null, true);
        CaseDomain.getMyIncentiveParentCase(String.ValueOf(lstAcc[0].id),System.today(),New Map<String,String>());
        List<User> lstUser = [Select Id from User limit 1];
        system.assertEquals(lstUser !=null, true);
        objCase.origin = 'TeamHub';
        objCase.OwnerId = lstUser[0].id;
        Map<String,String> mapString = new Map<String,String>();
        mapString.put('CASEORIGINTEAMHUB','TeamHub');
        CaseDomain.getCasesForSendEmailCaseComment(new Set<Id>{objCase.id},mapString);
        test.stopTest();
    }

    /**
     * @author : Sumit Banarji
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * queryCases method of CaseDomain Class.
    */
    @isTest
    static void queryCaseseTest(){
        Case caseObject = TestUtility.createPSQueryCase();
        Set<String> caseIds = new Set<String>();
        caseIds.add(caseObject.Id);
        String caseId = caseObject.Id;
        
        test.startTest();
            List<Case> cases = CaseDomain.queryCases(caseIds);
        test.stopTest();
        system.assertEquals(cases[0].Id , caseId);
    }
    
    @isTest
    static void anonymousTest(){
        List<Case> cases=ActionCentreTestData.myIncentiveCases(1,false);
        Test.startTest();
        insert cases;
        Test.stopTest();
        CaseDomain.getCaseAndCommentRecord(new Set<String>{cases[0].Id});
        CaseDomain.getCaseRecordDetail(new Set<Id>{cases[0].Id});
        CaseDomain.getCaseFilteredRecord(new Set<Id>{cases[0].Id},false);
        CaseDomain.getCurrentUserCases();
    }
    
    /**
     * author       Abhishek Setia
     * @description Test method for MyApplicationsController.getResponse, MyApplicationsService.getResponseService
     */
    @isTest
    static void testgetResponse(){
        Test.startTest();
        User usr=UserTestData.createUser('System Administrator');
        List<Account> accounts=ActionCentreTestData.getAccounts(1,true);
        List<Case> cases=ActionCentreTestData.myIncentiveCases(2,false);
        cases.addAll(ActionCentreTestData.requestCases(1,false));
        cases.addAll(ActionCentreTestData.requestCaseWithNoSubcat(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeMobileCases(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeSmartwatchCases(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeTabletCases(1,false));
        for(Case cs:cases){
            cs.CaseApproved__c='Pending';
            cs.AccountId=accounts[0].Id;
        }
        INSERT cases;  
                 
        System.runAs(usr){
            MyApplicationsController.RequestWrapper reqWrap=new MyApplicationsController.RequestWrapper();
            reqWrap.appTypes='SalarySacrifice,Leave,Requests';
            reqWrap.keyword='';
            reqWrap.sortColumn='LastModifiedDate';
            reqWrap.sortDirection='desc';
            reqWrap.rowOffSet=0;
            reqWrap.rowLimit=10;
            reqWrap.calculateTotalRecords=true;        
            LightningResponse res=MyApplicationsController.getResponse(JSON.serialize(reqWrap));
            MyApplicationsController.ResponseWrapper resWrap=(MyApplicationsController.ResponseWrapper)
                                    JSON.deserialize(res.payLoad, MyApplicationsController.ResponseWrapper.class);           
            System.assert(!resWrap.dataSet.isEmpty());                                    
        }
        Test.stopTest();
    }
}