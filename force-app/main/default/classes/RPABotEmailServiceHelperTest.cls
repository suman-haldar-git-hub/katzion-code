/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * RPABotEmailServiceHelper class.
*/
@isTest(SeeAllData=false)
private class RPABotEmailServiceHelperTest {
	/**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used create setup data for testing.
    */
    @testSetup
    static void dataSetup(){
        General_Setting__c generalSetting = new General_Setting__c(
        	Name = ConstantsUtility.RPABOT_CUSTOMSETTING_NAME,
            Email_Size__c = 25
        );
        
        insert generalSetting;
        
    }
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * prepareEmailRequest method.
    */
    @isTest
    static void prepareEmailRequestTest() {
        String fromAddress = [SELECT Id, Address  FROM OrgWideEmailAddress Limit 1].Address;
		List<ContentVersion> contVersions = ContentVersionTestData.create(1);
        insert contVersions;
        ContentVersion contVersion = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contVersions[0].Id LIMIT 1];
		
        List<RPABotEmailService.EmailParameters> params = new List<RPABotEmailService.EmailParameters>();

        RPABotEmailService.EmailParameters emailparam = new RPABotEmailService.EmailParameters();
        emailparam.toAddress = 'testReciever@test.com';
        emailparam.fromAddress = fromAddress;
        emailparam.subject = 'Test Subject';
        emailparam.htmlText = false;
        emailparam.emailBody = 'Plain Text Body';
        emailparam.documentIds = contVersion.ContentDocumentId;
        params.add(emailparam);

        List<String> emailResponse = RPABotEmailServiceHelper.prepareEmailRequest(params);
        System.assertEquals(emailResponse.size(), 1);
    }
}