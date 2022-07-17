/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * RPABotEmailService class.
*/
@isTest(SeeAllData=false)
private class RPABotEmailServiceTest {
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of getFiles method.
    */
    @isTest
    static void testsendEmail() {
        String fromAddress = [SELECT Id, Address  FROM OrgWideEmailAddress Limit 1].Address;

        List<RPABotEmailService.EmailParameters> params = new List<RPABotEmailService.EmailParameters>();

        RPABotEmailService.EmailParameters emailparam = new RPABotEmailService.EmailParameters();
        emailparam.toAddress = 'testReciever@test.com';
        emailparam.fromAddress = fromAddress;
        emailparam.subject = 'Test Subject';
        emailparam.htmlText = true;
        emailparam.emailBody = 'Plain Text Body';
        params.add(emailparam);

        List<String> emailResponse = RPABotEmailService.sendEmail(params);
        System.assertEquals(emailResponse.size(), 1);
    }
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to test exception scenarios of getFiles method.
    */
    @isTest
    static void testException() {
        String fromAddress = [SELECT Id, Address  FROM OrgWideEmailAddress Limit 1].Address;

        List<RPABotEmailService.EmailParameters> params = new List<RPABotEmailService.EmailParameters>();

        RPABotEmailService.EmailParameters emailparam = new RPABotEmailService.EmailParameters();
        emailparam.fromAddress = fromAddress;
        emailparam.subject = 'Test Subject';
        emailparam.htmlText = true;
        emailparam.emailBody = 'Plain Text Body';
        params.add(emailparam);
        
        exception exceptionResponse;
        try{
            List<String> emailResponse = RPABotEmailService.sendEmail(params);
        }
        catch(exception e){
            exceptionResponse = e;
        }
        
        System.assertEquals(exceptionResponse != null, true);
    }
}