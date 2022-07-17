@isTest
public class NzwebformTestClass {
    
    static testMethod void UnitTest1() {
        string casetype ='WOW NZ ER Case';
        string Rectypedevname = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(casetype).getDeveloperName();
        id Rectypeid = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(casetype).getRecordTypeId();
        
    	Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;

        
        case tempcase = new case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'test@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        tempCase.RecordTypeID = Rectypeid;
        tempCase.Preferred_Contact_Method__c = 'Email';
        tempCase.Preferred_Phone__c = '0401010101';
        tempCase.New_People_Query_or_Process_Request__c = 'Yes';
		tempCase.Employee_Department_NZ__c ='Administration';
        tempCase.Employee_Division_NZ__c ='Supermarkets';
        
     	Nzwebform.getDependentOptionsImpl('case','Employee_Division_NZ__c','Employee_Department_NZ__c');
        Nzwebform.Savecase(tempcase,Rectypedevname);
        Nzwebform.getvalidattachtype();
        
        list<Case> caselist= New list<Case>();
        caselist = [Select Id from Case where WOW_Web_Email_Address__c = 'test@gmail.com' limit 1];
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        //string afterblob = EncodingUtil.urlDecode(paramvalue, 'UTF-8');
        string contenttype ='xls';
        string filename = 'test';
        
        //string fileId =  WPSLightningWebToCaseController.saveChunk(wr.id,filename, paramvalue, contenttype,'');
		ContentDocument cd = FileUploadController.saveChunk(caselist[0].id,filename, paramvalue, contenttype,'');
        
        string fileId =  cd.Id;    
        FileUploadController.saveChunk(caselist[0].id,filename, paramvalue, contenttype,fileId);
        FileUploadController.deleteAttachment(fileId,caselist[0].id);
        
    }
}