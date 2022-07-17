/**
 * @description       : 
 * @author            : Akhil Kumar
 * @group             : 
 * @last modified on  : 09-15-2021
 * @last modified by  : Akhil Kumar
**/
@isTest
public class RTW_ReservationDetailsControllerTest {
    
    @isTest
    public static void getReservationDetailsTest(){
        User usr = CommonTestDataFactory.buildTestUser();
        usr.EmployeeNumber = '12345';
        update usr;
        
        System.runAs(usr){
            Test.startTest();
            List<string> resToCancelIds = new List<string>();
            List<RTW_Reservation__c> resListUpdate = new List<RTW_Reservation__c>();
            
            List<RTW_Reservation__c> parentResList = CommonTestDataFactory.createParentReservation('testParent@woolworths.com',1);
            List<RTW_Reservation__c> resList = CommonTestDataFactory.createReservation('test@woolworths.com',2);
            
            for(RTW_Reservation__c res : resList){
                res.reservation__c = parentResList[0].id;
                resListUpdate.add(res);
                resToCancelIds.add(res.Id);
            }
            update resListUpdate;
            
            CommonTestDataFactory.createTeamMember('12345');
            RTW_ReservationDetailsController.getReservationDetails(resListUpdate[0].id);
            RTW_ReservationDetailsController.cancelBooking(resToCancelIds);
            System.assertEquals(2,resList.size());
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testReservationDetailsCatchBlock(){
        User usr = CommonTestDataFactory.buildTestUser();
        usr.EmployeeNumber = '12345';
        update usr;
        
        System.runAs(usr){
            Test.startTest();
            CommonTestDataFactory.createTeamMember('12345');
            RTW_ReservationDetailsController.getReservationDetails('1234');
            System.assertEquals(String.isNotBlank(usr.EmployeeNumber),true);
            Test.stopTest();
        }
    }
}