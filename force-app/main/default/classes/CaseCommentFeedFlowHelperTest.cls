/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * CaseCommentFeedFlowHelper class.
*/
@isTest(SeeAllData=false)
private class CaseCommentFeedFlowHelperTest {
	/**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive scenarios of htmlToPlainText method.
    */
    @isTest
    static void htmlToPlainText() {
        String htmlText = '<p>Test String</p>';
        String plainText = 'Test String';
        
        test.startTest();
        List<String> stringResp = CaseCommentFeedFlowHelper.htmlToPlainText(new String[]{htmlText});
        System.assertEquals(plainText, stringResp[0]);
        test.stopTest();
    }
    
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover exception scenarios of htmlToPlainText method.
    */
    @isTest
    static void htmlToPlainTextExcepion() {
        
        test.startTest();
        List<String> stringResp = CaseCommentFeedFlowHelper.htmlToPlainText(null);
        System.assertEquals(stringResp.size(), 0);
        test.stopTest();
    }
}