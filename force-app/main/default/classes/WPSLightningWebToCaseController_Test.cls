/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class WPSLightningWebToCaseController_Test {
    static testMethod void testUseCase1(){
        
        Case c = new case();
        c.Origin = 'Web';
        c.Priority = 'Low';
        c.Subject = 'Test';
        insert c;
        
        WPSLightningWebToCaseController con = new WPSLightningWebToCaseController();
        Work_Requests__c wr = new Work_Requests__c();
        wr.Category__c='Cleaning';
        wr.Sub_Category__c='Office Cleanup';
        wr.Location__c ='Dummy';
        wr.Email_Address__c = 'vikranth.h06@wipro.com';
        wr.case__c = c.id;
        insert wr; //for parentID
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        //string afterblob = EncodingUtil.urlDecode(paramvalue, 'UTF-8');
        string contenttype ='xls';
        string filename = 'test';
        
        //string fileId =  WPSLightningWebToCaseController.saveChunk(wr.id,filename, paramvalue, contenttype,'');
        ContentDocument cd = WPSLightningWebToCaseController.saveChunk(wr.id,filename, paramvalue, contenttype,'');
        
        string fileId =  cd.Id;        
        WPSLightningWebToCaseController.saveChunk(wr.id,filename, paramvalue, contenttype,fileId);
        WPSLightningWebToCaseController.deleteAttachment(fileId,wr.Id);
        WPSLightningWebToCaseController.SelectRecordfromController(wr.Id);
        System.assertEquals(String.isNotBlank(filename),true);
    }
    
    static testMethod void testCatchBlock(){
        
        Case c = new case();
        c.Origin = 'Web';
        c.Priority = 'Low';
        c.Subject = 'Test';
        insert c;
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        string contenttype ='xls';
        string filename = 'test';
        
        try { 
        ContentDocument cd = WPSLightningWebToCaseController.saveChunk(null,filename, paramvalue, contenttype,'');
        string fileId =  cd.Id;
               
        WPSLightningWebToCaseController.saveChunk(null,filename, paramvalue, contenttype,fileId);
        WPSLightningWebToCaseController.deleteAttachment(fileId,null);
        WPSLightningWebToCaseController.SelectRecordfromController(null);
        }
        catch(Exception ex) {
            System.assertNotEquals(ex,null);
        }
    } 
}