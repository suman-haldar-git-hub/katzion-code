/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 10-22-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@isTest
public class NoteToCaseCommentBatchTest {
    static testMethod void testMethod1(){
        Recordtype rt = [Select id from recordtype where DeveloperName='WPS'];
        Case caseRecord = new Case();
        caseRecord.Subject = 'Request to clean floor';
        caseRecord.Description = 'Test Description';
        caseRecord.Web_First_Name__c = 'Test';
        caseRecord.Web_Last_Name__c= 'Test';
        caseRecord.WOW_Web_Email_Address__c= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedEmail= 'testTeamMember@woolworths.com.au';
        caseRecord.SuppliedName= 'Test Test';
        caseRecord.Category__c= 'WPS';
        caseRecord.Sub_Category_New__c= 'WPS';
        caseRecord.Sub_Category_2__c= 'Parking';
        caseRecord.Sub_Category_3__c= 'Parking Issues';
        caseRecord.Priority= 'Low';
        caseRecord.Status= 'Open';
        caseRecord.Origin= 'Web';
        caseRecord.Select_Location__c= 'Mascot';
        caseRecord.Select_Floor__c= 'Level 1';
        caseRecord.Preferred_Email__c= 'testTeamMember@woolworths.com.au';
        caseRecord.Preferred_Phone__c= '999000999';
        caseRecord.New_or_Existing_Request__c='Existing';
        caseRecord.RecordTypeId = rt.Id;
        insert caseRecord;
        ContentVersion objCntNote = new ContentVersion();
        objCntNote.Title = 'Test Content Note';
        objCntNote.PathOnClient = objCntNote.Title + '.snote';
        objCntNote.VersionData = Blob.valueOf('Test Content Note');
        insert objCntNote;
        ContentVersion contentVersion = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id = :objCntNote.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = caseRecord.id;
        contentlink.contentdocumentid = contentVersion.contentdocumentId;
        contentlink.ShareType = 'V';
        insert contentlink;
        Test.startTest();
        NoteToCaseCommentBatch ba= new NoteToCaseCommentBatch();
        Id jobid= Database.executeBatch(ba,5);
        Test.stopTest();
        system.assertEquals(String.isNotBlank(jobid), true);
    }
}