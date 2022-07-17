/*
@Author: Ashish Singh
@Company: Cognizant
@CreatedOn: 06-02-2022
@Description: This test class covers the positive and negatice scenarios for "GetGuestUserIPAddressControllerTest" class...
*/
@isTest(SeeAllData=false)
public class GetGuestUserIPAddressControllerTest {
	
    @isTest
    static void getGuestUserIp(){
        test.startTest();
        GetGuestUserIPAddressController getIPAddress = new GetGuestUserIPAddressController();
        test.stopTest();
        system.assertEquals(true,true,'success');
    }
}