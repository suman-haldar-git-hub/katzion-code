/**
@Author : Ankit Singh
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
TriggerSwitchDomain class.
*/
@isTest(SeeAllData=false)
public class TriggerSwitchDomainTest {
    /**
@Author : Daksh
@Company : Cognizant
@description : Test getTriggerSwitch method
*/
    @isTest
    static void getTriggerSwitchTest() {
        Test.startTest();
        System.assertEquals(false,TriggerSwitchDomain.getTriggerSwitch().isEmpty());
        Test.stopTest();
    }
}