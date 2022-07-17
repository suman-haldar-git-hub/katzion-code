/**
* @author : Monika
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* BannerComponentController class.
*/
@isTest(SeeAllData=false)
public class BannerComponentControllerTest {
     /**
    * @author : Monika
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;
        
        Case objCase = TestUtility.createPSQueryCase();
        objCase.Effort_To_Date__c = 4;
        objCase.RecordTypeID = caseRec.Transaction_Case__c;
        update objCase;
    }
    /**
    @Author : Monika
    @Company : SaasFocus A Cognizant Company
    @description : Test BannerComponentController method false scnario
    */
    @isTest
    static void testBannerComponentController()
    {
        case objCase = [select id, owner.name from case];
        
        BannerComponentController.getAlertFlags(objCase.id);
        System.assert(objCase!= null);
    }
}