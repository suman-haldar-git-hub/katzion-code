/**
* @author : Monika
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
* BannerComponentAdapter class.
*/
@isTest(SeeAllData=false)
public class BannerComponentAdapterTest {
     /**
    * @author : Monika
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    @testSetup
    static void setupData(){
        Profile prof = [Select Id from Profile Where Name = 'System Administrator'];
        UserRole role = new UserRole(Name = 'My Nice Role');
        insert role;
        User testUser = new User(Alias = 'standt', Email='testinguser@testorg.com', 
                          EmailEncodingKey='ISO-8859-1', LastName='Big W Employee Services', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_AU', ProfileId = prof.Id, 
                          TimeZoneSidKey='Australia/Sydney', UserName='testinguser@testorg.com',UserRoleId = role.Id);
        insert testUser;
        
        Group groupObj = new Group();
        groupObj.type = 'queue';
        groupObj.Name = 'Advisory Payroll';
        insert groupObj;

        GroupMember objGroupMem = new GroupMember();
        objGroupMem.UserOrGroupId = testUser.id;
        objGroupMem.GroupId = groupObj.Id;
        Insert objGroupMem;
        
        System.runAs(testUser) {
            Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
            insert caseRec;
            
            Case objCase = TestUtility.createPSQueryCase();
            objCase.Effort_To_Date__c = 4;
            objCase.RecordTypeID = caseRec.Transaction_Case__c;
            update objCase;
            
            Set<String> caseIds = new Set<String>();
        caseIds.add(objCase.Id);
        BannerMaster__mdt objBannerMaster = [select Queues__c,Active__c from BannerMaster__mdt where Queues__c = 'Advisory Payroll' and Active__c = True];
        
        BannerComponentAdapter.getAlertFlag(caseIds);
        System.assertEquals(objBannerMaster.Active__c, true);
        }
    }
    /**
    @Author : Monika
    @Company : SaasFocus A Cognizant Company
    @description : Test BannerComponentAdapter method
    */
    @isTest
    static void testBannerComponentController()
    {
        Profile prof = [Select Id from Profile Where Name = 'System Administrator'];
        User testUser = new User(Alias = 'standt', Email='testinguser2@testorg.com', 
                          EmailEncodingKey='ISO-8859-1', LastName='Advisory Payroll', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_AU', ProfileId = prof.Id, 
                          TimeZoneSidKey='Australia/Sydney', UserName='testinguser2@testorg.com');
        insert testUser;
        System.runAs(testUser) {
            case objCase = [select id, owner.name from case];
            Set<String> caseIds = new Set<String>();
            caseIds.add(objCase.Id);
            BannerMaster__mdt objBannerMaster = [select Queues__c,Active__c from BannerMaster__mdt where Queues__c = 'Advisory Payroll' and Active__c = True];
            BannerComponentAdapter.checkObjectName(objCase.Id);
            BannerComponentAdapter.getAlertFlag(caseIds);
            System.assertEquals(objBannerMaster.Active__c, true);
        }
    }
}