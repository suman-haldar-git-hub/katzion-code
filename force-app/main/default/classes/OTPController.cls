/**
* @Author : Ashish Singh
* @Company : Cognizant
* @description : This class serves as the apex controller for the OTP Aura component.
*/
public without sharing class OTPController {
    private static final Integer MAX_RETRY = 3;  		  // reflects the maximum attempt we can make to enter otp on component
    private static final Integer EXPIRY_TIME_MINUTES = 5; // reflects the time after which our otp will expire
    
    /**
* @description This method is used to request OTP From Component
* @author Ashish Singh | 25-01-2022 
* @param emailAddress
* @param fromEmail
* @return Boolean
**/
    @auraEnabled
    public static Boolean requestOTP(String emailAddress, String fromEmail){
        Savepoint sp = Database.setSavepoint();
        try{
            List<Contact> conLst = new List<Contact>();
            String ip;
            if(Test.isRunningTest()) { 
                ip = '192.168.1.1';
            } else {
                ip = (new PageReference('/apex/FetchGuestUserIPAddress')).getContent().toString().
                    substringBetween('<ipAddress>', '</ipAddress>');
            }
            OTP_Master__c master = getOTPMaster(!conLst.isEmpty() ? conLst[0].Id : null, emailAddress); 
            OTP_Details__c otpDetails = new OTP_Details__c();
            otpDetails.OTP_Master__c = master.Id;
            otpDetails.OTP_Code__c = Integer.valueOf(generateOTP());
            otpDetails.Guest_User_IP__c = ip;
            otpDetails.Issue_Time__c = System.now();
            otpDetails.Expiry_Time__c = System.now().addMinutes(EXPIRY_TIME_MINUTES);
            insert otpDetails;
            triggerOTPEmail(emailAddress,otpDetails.OTP_Code__c,fromEmail);
        }
        catch(Exception ex){
            Database.rollback(sp);
            system.debug('this is the error'+ex);
            throw new AuraHandledException('Something went wrong!!! Please contact your system administrator');            
        }
        return true;
    }
    
    /**
* @description This method is used to verify OTP on component level
* @author Ashish Singh | 15-02-2022  
* @param emailAddress
* @param otp 
* @return Boolean
**/
    @auraEnabled
    public static Boolean verifyOTP(String emailAddress, String otp){
        Boolean isSuccess = false;
        Boolean throwError = false;
        List<OTP_Details__c> otpDetails = [Select Id,Retry_Count__c,OTP_Code__c, Is_Expired__c from OTP_Details__c where OTP_Master__r.Email_Address__c = :emailAddress order by CreatedDate DESC LIMIT 1];
        if(!otpDetails.isEmpty()){
            otpDetails[0].Retry_Count__c = otpDetails[0].Retry_Count__c + 1;
            if(otpDetails[0].Retry_Count__c < MAX_RETRY) {
                if(Integer.valueOf(otp) == otpDetails[0].OTP_Code__c && !otpDetails[0].Is_Expired__c){
                    otpDetails[0].Expiry_Time__c = System.now();
                    isSuccess =  true;
                } else if(Integer.valueOf(otp) == otpDetails[0].OTP_Code__c && otpDetails[0].Is_Expired__c){
                    throw new AuraHandledException('Your OTP has Expired');
                }
                update otpDetails;     
            }
            else {
                throw new AuraHandledException('Maximum number of retries are exhausted. Please request new OTP.');
            }
        }
        return isSuccess;
    }
    
    /**
* @description This method is used to generate otp
* @author Ashish Singh | 15-02-2022 
* @return String
**/
    private static String generateOTP(){
        Integer len = 6;
        String randomNumber = String.valueof(Math.abs(Crypto.getRandomLong()));
        String otp = randomNumber.subString(0, len);
        return otp;
    }
    
    /**
* @description This method is used to get OTP Master value from the database
* @author Ashish Singh | 15-02-2022  
* @param contactId 
* @param emailAddress 
* @return OTP_Master__c
**/
    private static OTP_Master__c getOTPMaster(Id contactId, String emailAddress){
        List<OTP_Master__c> masterRec = [Select Id, SuccessFactors_Contact__c From OTP_Master__c where Email_Address__c = :emailAddress];
        OTP_Master__c master = new OTP_Master__c();
        if(masterRec.isEmpty() && String.isNotBlank(contactId)){
            master.SuccessFactors_Contact__c = contactId;
        } 
        master.Email_Address__c = emailAddress;
        insert master;
        masterRec.add(master);
        return masterRec[0];
    }
    
    /**
* @description This method is used to email for sending OTP to User
* @author Ashish Singh | 15-02-2022  
* @param emailAddress
* @param otp 
* @param fromEmailAdd
**/

    public static void triggerOTPEmail(String emailAddress, Decimal otp,String fromEmailAdd){   
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address =: fromEmailAdd LIMIT 1];
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { emailAddress };
            

            message.setOrgWideEmailAddressId(owea.Id);

        message.optOutPolicy = 'FILTER';
        message.subject = 'OTP';
        message.htmlBody = 'Your OTP is:</b>'+otp+'</b>';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            try{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }catch(Exception ex){
                System.debug('Error:'+ex.getMessage());
            }
    }
    
    /**
    * @author Ashish Singh
    * @description Get data from metadata
    * @param formName
    * @return OTPComponentFor__mdt
    */
    @AuraEnabled
    public static OTPComponentFor__mdt otpSwitchMdt(string formName){
        try {
            List<OTPComponentFor__mdt> mdtList = OTPComponentFor__mdt.getall().values();
            OTPComponentFor__mdt mdtObj = new OTPComponentFor__mdt();
            if( mdtList.size()> 0){
                for(OTPComponentFor__mdt mdt : mdtList){
                    if(mdt.DeveloperName == formName){
                        mdtObj = mdt;
                        break;
                    }
                }
                return mdtObj;
            }
            else{
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}