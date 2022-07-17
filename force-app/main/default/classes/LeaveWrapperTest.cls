/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the test class of LeaveWrapper
*/
@isTest(SeeAllData=false)
public class LeaveWrapperTest {
	/**
* @author : Daksh
* @company : Cognizant
* @description : This is the test method
*/
    @isTest static void testMethod1(){
        LeaveWrapper leaveWrapObj = new LeaveWrapper();
        System.assertEquals(false,leaveWrapObj.showPurchaseLeave);
        System.assertNotEquals(1,leaveWrapObj.baseHours);
    }
}