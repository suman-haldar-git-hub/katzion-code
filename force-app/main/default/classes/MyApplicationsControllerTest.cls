/**
 * @author      Abhishek Setia
 * @description Test class for MyApplicationsController.cls, MyApplicationsService.cls
 */
@isTest
private class MyApplicationsControllerTest {
    
    /**
     * author       Abhishek Setia
     * @description Custom settings setup data
     */
    @TestSetup
    static void makeData(){        
        ActionCentreTestData.setupSettings(
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId()
            );           
    }


    /**
     * author       Abhishek Setia
     * @description Test method for MyApplicationsController.getResponse, MyApplicationsService.getResponseService
     */
    @isTest
    static void testgetResponse(){
        User usr=UserTestData.createUser('System Administrator');
        List<Account> accounts=ActionCentreTestData.getAccounts(1,true);
        List<Case> cases=ActionCentreTestData.myIncentiveCases(2,false);
        cases.addAll(ActionCentreTestData.requestCases(1,false));
        cases.addAll(ActionCentreTestData.requestCaseWithNoSubcat(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeMobileCases(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeSmartwatchCases(1,false));
        cases.addAll(ActionCentreTestData.salarySacrificeTabletCases(1,false));
        cases.addAll(ActionCentreTestData.requestWPSCases(1,false));
        for(Case cs:cases){
            cs.CaseApproved__c='Pending';
            cs.AccountId=accounts[0].Id;
        }
        INSERT cases;  
                 
        System.runAs(usr){
            List<RTW_Reservation__c> reservationList = ActionCentreTestData.requestReservationRecords(1,System.today()); 
            MyApplicationsController.RequestWrapper reqWrap=new MyApplicationsController.RequestWrapper();
            reqWrap.appTypes='SalarySacrifice,Leave,Requests,WorkplaceSupportRequest,SupportOfficeBooking';
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
    }
}
