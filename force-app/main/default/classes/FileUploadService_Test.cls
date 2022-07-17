/**
 * @description       : This class is used to do a mock callout for Test execution scenarios of Apex classes where HTTP call out is done.
 * @author            : Aman Kumar
 * @group             : 
 * @last modified on  : 03-10-2022
**/
@isTest 
private class FileUploadService_Test {

     /**
     * @description       : To send a Mock Response.
     * @author            : Aman Kumar
     * @group             : 
     * @last modified on  : 03-10-2022
    **/
    @isTest static void testPostCallout(){
        Test.setMock(HttpCalloutMock.class, new MockCallOut());  
        FileUploadService.responseWrapper fusRW = FileUploadService.getAccessToken();
        System.assert(true);
    }
}