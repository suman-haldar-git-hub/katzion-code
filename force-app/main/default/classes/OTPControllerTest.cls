/*
@Author: Ashish Singh
@Company: Cognizanr
@CreatedOn: 06-02-2022
@Description: This test class covers the positive and negatice scenarios for "OTPController" class...
*/
@isTest(SeeAllData=false)
public class OTPControllerTest {
	
    @testSetup
    static void makeData(){
        list<contact> conLst = new list<contact>();
        string emailAddress = 'TestToAdd@woolworths.com.au';
        Integer expiryTimeMinutes = 5;
        OTP_Master__c otpMasterRec = new OTP_Master__c();
        otpMasterRec.Email_Address__c = 'TestToAdd@woolworths.com.au';
        insert otpMasterRec;
                OTP_Details__c otpDetails = new OTP_Details__c();
                otpDetails.OTP_Master__c = otpMasterRec.id ;
                otpDetails.OTP_Code__c = 121212; 
                otpDetails.Issue_Time__c = System.now();
                otpDetails.Expiry_Time__c = System.now().addMinutes(expiryTimeMinutes);
                insert otpDetails;
    }
    
    @isTest
    static void requestOTPTest(){
        string email = 'TestToAdd@woolworths.com.au';
        string fromEmailAdd = 'noreply_peopleadvisory@woolworths.com.au';
        test.startTest();
        boolean req = OTPController.requestOTP(email,fromEmailAdd);
        test.stopTest();
        system.assertEquals(req,true,'success');
    }
    
    @isTest
    static void verifyOTPTest(){
        string email = 'TestToAdd@woolworths.com.au';
        string otp = '121212';
        test.startTest();
        boolean req = OTPController.verifyOTP(email,otp);
        test.stopTest();
        system.assertEquals(req, true,'success');
    }
    
    @isTest
    static void otpSwitchMdtTest(){
        string formName = 'PSForm';
        test.startTest();
        OTPComponentFor__mdt req = OTPController.otpSwitchMdt(formName);
        test.stopTest();
        system.assertEquals(true, (req!=null),'success');
    }
}