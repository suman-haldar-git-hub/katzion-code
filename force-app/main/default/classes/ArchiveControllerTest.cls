/**
 * @author      Abhishek Setia
 * @description Test class for ArchiveController.cls, ArchiveService.cls
 */
@isTest
private class ArchiveControllerTest {
    
    /**
     * author       Abhishek Setia
     * @description Custom settings/ Initial setup data
     */
    @TestSetup
    static void makeData(){    
        List<Campaign> campList = CampaignTestData.create(1);
        campList[0].CampaignCode__c = 'UTL NOTIF';
        insert campList;

        ActionCentreTestData.setupSettings(
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Query_Case').getRecordTypeId()
            );                
    }


    /**
     * author       Abhishek Setia
     * @description Test methods for class ArchiveController, ArchiveService
     */
    @isTest
    static void testGetArchiveRecords(){
        User usr=UserTestData.createUser('System Administrator');        
        System.runAs(usr){
            List<Account> accounts=ActionCentreTestData.getAccounts(1,true);
            List<Case> cases=ActionCentreTestData.myIncentiveCases(2,false);
            cases.addAll(ActionCentreTestData.salarySacrificeMobileCases(1,false));
            cases.addAll(ActionCentreTestData.salarySacrificeSmartwatchCases(1,false));
            cases.addAll(ActionCentreTestData.salarySacrificeTabletCases(1,false));
            List<Case> requestCases = ActionCentreTestData.requestCases(1,false);
            requestCases.addAll(ActionCentreTestData.requestCaseWithNoSubcat(1,false));
            requestCases.addAll(ActionCentreTestData.requestWPSCases(1,false));
            for(Case cs:cases){
                cs.ownerID=usr.Id;
                cs.CaseApproved__c='Approved';
                cs.AccountId=accounts[0].Id;                
            }
            for(Case cs:requestCases){
                cs.ownerID=usr.Id;
                cs.Status='Closed';
                cs.AccountId=accounts[0].Id;
            }
            List<Case> insertCases = new List<Case>();
            insertCases.addAll(cases);
            insertCases.addAll(requestCases);
            INSERT insertCases; 
            List<UniversalTaskList__c> tas=ActionCentreTestData.getApprovals(1,false);      
            for(UniversalTaskList__c ta:tas){
                ta.SubmittedForAccount__c=accounts[0].Id;
            }
            INSERT tas; 
            List<RTW_Reservation__c> reservationList = ActionCentreTestData.requestReservationRecords(1, System.today()-1);                      
            Test.startTest();
            ArchiveController.RequestWrapper reqWrap=new ArchiveController.RequestWrapper();
            reqWrap.types='Approval,Leave,SalarySacrifice,Task,Requests,WorkplaceSupportRequest,SupportOfficeBooking';
            reqWrap.keyword='';
            reqWrap.sortColumn='completionDate';
            reqWrap.sortDirection='desc';
            reqWrap.utlRowOffSet=0;
            reqWrap.caseRowOffSet=0;
            reqWrap.reservationRowOffSet=0;
            reqWrap.rowLimit=30;
            reqWrap.calculateTotalRecords=true;
            LightningResponse res=ArchiveController.getArchiveRecords(JSON.serialize(reqWrap));
            ArchiveController.ResponseWrapper resWrap=(ArchiveController.ResponseWrapper)
                            JSON.deserialize(res.payLoad, ArchiveController.ResponseWrapper.class);
                            System.assertEquals(resWrap.dataSize > 0, true);  
            Test.stopTest();
        }
    }

    /**
     * author       Akshansh Jain
     * @description Test methods for class ArchiveController, ArchiveService
     */
    @isTest
    static void testCaseImageName(){
        User usr=UserTestData.createUser('System Administrator');        
        System.runAs(usr){
            List<Account> accounts=ActionCentreTestData.getAccounts(1,true);
            List<Case> leaveCases = ActionCentreTestData.requestCasesForLeave(1,false);
            for(Case cs:leaveCases){
                cs.ownerID=usr.Id;
                cs.CaseApproved__c='Rejected';
                cs.AccountId=accounts[0].Id;       
            }
            INSERT leaveCases;
            leaveCases[0].Status='Closed';
            update leaveCases;
            List<UniversalTaskList__c> tas=ActionCentreTestData.getApprovals(1,false);      
            for(UniversalTaskList__c ta:tas){
                ta.SubmittedForAccount__c=accounts[0].Id;
            }
            INSERT tas;            
            Test.startTest();
            ArchiveController.RequestWrapper reqWrap=new ArchiveController.RequestWrapper();
            reqWrap.types='Approval,Leave,SalarySacrifice,Task,Requests';
            reqWrap.keyword='';
            reqWrap.sortColumn='completionDate';
            reqWrap.sortDirection='desc';
            reqWrap.utlRowOffSet=0;
            reqWrap.caseRowOffSet=0;
            reqWrap.rowLimit=10;
            reqWrap.calculateTotalRecords=true;
            LightningResponse res=ArchiveController.getArchiveRecords(JSON.serialize(reqWrap));
            ArchiveController.ResponseWrapper resWrap=(ArchiveController.ResponseWrapper)
                            JSON.deserialize(res.payLoad, ArchiveController.ResponseWrapper.class);
            Test.stopTest();
        }
    }
}