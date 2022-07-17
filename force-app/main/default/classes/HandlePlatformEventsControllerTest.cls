/**
* @author : Ankit Singh
* @company : SaasFocus A Cognizant Company
* @description : This test class is used to cover positive and negative scenarios of
* HandlePlatformEventsController class.
*/
@isTest(SeeAllData=false)
public class HandlePlatformEventsControllerTest {
    /**
    @Author : Ankit Singh
    @Company : SaasFocus A Cognizant Company
    @description : Test all method
    */
    @isTest
    static void testHandlePlatformEventsController() {
        system.assertNotEquals(null, HandlePlatformEventsController.getSessionId());
    }
}