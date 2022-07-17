/**
* @author : Daksh
* @company : Cognizant
* @description : This test class will cover DistributionListRecordService class.
*/
@isTest(SeeAllData=false)
public class DistributionListRecordServiceTest {
    /**
* @author : Daksh
* @company : Cognizant
* @description : This is the setup method to create test data
*/
    @testSetup
    static void setupData(){
        User testUser = UserTestData.getUser('System Administrator', 'Test');
        testUser.EmployeeID__c = 'Test007';
        insert testUser;
        System.runAs(testUser) {
            //test data for getDistributionFormWrapperDataTest method.
            List<Object_Field__c> objectFieldList = new List<Object_Field__c>();
            List<Picklist_Field_Value__c> picklistFieldValueList = 
                new List<Picklist_Field_Value__c>();
            List<Related_Value__c> relatedValueList = new List<Related_Value__c>();
            String fieldApiStr = 'Company__c,Group__c,Brand__c,OpsSupport__c,Region__c,Area__c,'+
                ''+'EmployeeGroup__c,EmployeeSubgroup__c,CareerLevel__c,HasDOA__c,'+
                ''+'IsLineManager__c,Country__c,Location__c,TeamMemberIdentifier__c';
            //creating account recods
            List<Account> acctList = AccountTestData.createAccountRecords(1, '');
            acctList[0].Employee_ID__c = 'Test007';
            insert acctList;
            //creating Object_Field__c records.
            objectFieldList.addAll
                (ObjectFieldTestData.createObjectFieldRecds('DistributionList__c',fieldApiStr));
            insert objectFieldList;
            //creating Picklist_Field_Value__c records
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[0].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[1].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[2].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[3].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[4].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[5].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[6].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[7].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[8].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList(objectFieldList[9].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList
                 (objectFieldList[10].Id,2));
            picklistFieldValueList.addAll
                (PicklistFieldValueTestData.createPicklistFieldValueList
                 (objectFieldList[11].Id,2));
            insert picklistFieldValueList;
            //creating Related_Value__c records
            relatedValueList.addAll
                (RelatedValueTestData.createRelatedValuedList
                 (picklistFieldValueList[0].Id,picklistFieldValueList[2].Id,2));
            relatedValueList.addAll
                (RelatedValueTestData.createRelatedValuedList
                 (picklistFieldValueList[3].Id,picklistFieldValueList[5].Id,2));
            relatedValueList.addAll
                (RelatedValueTestData.createRelatedValuedList
                 (picklistFieldValueList[5].Id,picklistFieldValueList[7].Id,2));
            relatedValueList.addAll
                (RelatedValueTestData.createRelatedValuedList
                 (picklistFieldValueList[6].Id,picklistFieldValueList[8].Id,2));
            insert relatedValueList;
            //test data for editDLForBuAdminTest method.
            List<Campaign> campaignList = CampaignTestData.create(1);
            insert campaignList;
            List<Communication__c> commList = CommunicationTestData.create(1,campaignList[0].Id);
            insert commList;
            List<Contact> contList = ContactTestData.createContactRecords(1,acctList[0].Id);
            insert contList;
            List<DistributionList__c> dlList = DistributionListTestData.createDistributionListRecords(1);
            dlList[0].OwnerId = testUser.Id;
            insert dlList;
            List<Audience__c> audienceList = AudienceTestData.create(200,contList[0].Id,commList[0].Id);
            for(Integer i=0;i<200;i++){
                audienceList[i].DistributionList__c = dlList[0].Id;
            }
            insert audienceList;
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test catch block.
*/
    @isTest static void testCatchBlock(){
        List<Communication__c> commList = [
            Select Id,ScheduledDate__c
            From Communication__c
            Limit 1
        ];
        User userRecord = [Select Id,EmployeeID__c 
                           From User 
                           Where EmployeeID__c ='Test007'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            DistributionListRecordService.ReturnWrapper returnObj = 
                DistributionListRecordService.editDLForBuAdmin(commList[0].Id);
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test getDistributionFormWrapperData methods.
*/
    @isTest static void getDistributionFormWrapperDataTest(){
        List<Object_Field__c> objectFieldList = [
            Select Id,Name,Field_API__c
            From Object_Field__c
        ];
        List<Picklist_Field_Value__c> picklistFieldValueList = [
            Select Id,Name,Object_Field__c,Picklist_Field_Value__c,Web_Value__c,PrimaryUniqueKey__c
            From Picklist_Field_Value__c
        ];
        List<Related_Value__c> relatedValueList = [
            Select Id,Name,Top_Field_Value__c,Dependant_Field_Value__c,Sub_Category__c,
            Top_Field_Value__r.PrimaryUniqueKey__c,Dependant_Field_Value__r.PrimaryUniqueKey__c
            From Related_Value__c
        ];
        Account acctRecord = [Select Id,Name,Employee_ID__c
                              From Account 
                              Where Employee_ID__c ='Test007'];
        User userRecord = [Select Id,EmployeeID__c 
                           From User 
                           Where EmployeeID__c ='Test007'];             
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            LightningResponse response = 
                DistributionListRecordService.getDistributionFormWrapperData();
            DistributionListRecordService.DistributionFormWrapper dataWrapObj = 
                (DistributionListRecordService.DistributionFormWrapper)
                System.JSON.deserialize
                (response.payLoad, DistributionListRecordService.DistributionFormWrapper.class);
            Test.stopTest();
        }
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This will test editDLForBuAdmin method.
*/
    @isTest static void editDLForBuAdminTest(){
        List<DistributionList__c> dlList = [
            Select Id,ownerId,createdbyid
            From DistributionList__c
            Limit 1
        ];
        List<Audience__c> audienceList = [
            Select Id,Communication__c 
            from Audience__c
        ];
        List<Communication__c> commList = [
            Select Id,ScheduledDate__c
            From Communication__c
            Limit 1
        ];
        User userRecord = [Select Id,EmployeeID__c 
                           From User 
                           Where EmployeeID__c ='Test007'];
        System.assert(userRecord != null);
        System.runAs(userRecord) {
            Test.startTest();
            DistributionListRecordService.ReturnWrapper returnObj = DistributionListRecordService.editDLForBuAdmin(dlList[0].Id);
            Test.stopTest();
        }
    }
}