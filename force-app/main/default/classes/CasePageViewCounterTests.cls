/*

    Author:             Sally Montgomery

    Created Date:       8th September 2016

    Brief:              Test Class for CasePageViewCounter class

    

    Visualforce Page:   CasePageViewCounter

    Test Class:         CasePageViewCounterTests.cls

    Apex Class:         CasePageViewCounter.cls   

    Version Control:    v1.0



    @Revision History:  8th September 2016     -   Test class created



    @Test Coverage:     xxx%    -   8th September 2016

*/

@isTest

private class CasePageViewCounterTests {

    static CasePageViewCounter ext;

        

        

    

    @isTest

    static void updatecount(){

        

        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();

        insert caseRec;

        

        System.debug('xxxxxcaseRec:' + caseRec.name);

        

        // create transaction cases

        Id transactionCaseId= Id.valueOf(caseRec.Transaction_Case__c); 

        List<Case> cases = TestUtility.createTrxCases(3,transactionCaseId);

        insert cases;

        

        System.debug('xxxxxTransaction Case Size:' + cases.size());

        

        // create query cases

        Id queryCaseId = Id.valueOf(caseRec.Query_Case__c); 

        List<Case> cases1 = TestUtility.createTrxCases(3,queryCaseId);

        insert cases1;

          

        System.debug('xxxxxQuery Case Size:' + cases1.size());

        

        Case cs1 = [Select Id, Page_View_Count__c, Last_Viewed_By__c FROM Case Where RecordTypeID =: transactionCaseId Limit 1];

        Case cs2 = [Select Id, Page_View_Count__c, Last_Viewed_By__c FROM Case Where RecordTypeID =: queryCaseId Limit 1];

        

        System.debug('xxxxxcs1 Id:' + cs1.Id);

        System.debug('xxxxxcs1 Page View Count:' + cs1.Page_View_Count__c);

        System.debug('xxxxxcs1 Last Viewed By:' + cs1.Last_Viewed_By__c);

        

        //Create a User

        User u1 = [Select ID FROM User Where Alias = 'AUser' limit 1];

        

        System.debug('xxxxxu1 Id:' + u1.Id);

        

        //Run As u1

       // System.runAs(u1){

            System.debug('xxxxxValidating view of records');

            

            PageReference pageRef = Page.CasePageViewCounter;

            Test.setCurrentPage(pageRef);

            pageRef.getParameters().put('Id',cs1.Id);

            ApexPages.StandardController stc = new ApexPages.StandardController(cs1);

            ext = new CasePageViewCounter(stc);

            PageReference objPageRef = ext.updatecount();

            system.assert(objPageRef==null);

            //system.assert(cs1.Page_View_Count__c <> Null);

            //system.assert(cs1.Last_Viewed_By__c <> Null);

            system.debug('xxxxxPage View Count: '+cs1.Page_View_Count__c);

            Cs1.Page_View_Count__c = 2;

            Update Cs1 ;

            ApexPages.StandardController stc1 = new ApexPages.StandardController(cs1);

            ext = new CasePageViewCounter(stc1);

            PageReference objPageRef1 = ext.updatecount();
        
			system.assert(objPageRef1==null);

            system.debug('xxxxxPage View Count: '+cs1.Page_View_Count__c);

        //}                             

        

    }

    

}