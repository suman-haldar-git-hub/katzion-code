/**
 * @description       : This is test class for Recaptchav2PageController
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-15-2021   Prathamesh Lad   Initial Version
**/
@isTest
public class Recaptchav2PageControllerTest {
    
    private static testmethod void getSiteKey1(){
        Test.StartTest(); 
        PageReference pageRef = Page.recaptchav2Page; 
        pageRef.getParameters().put('sitekey', 'testValue');
        Test.setCurrentPage(pageRef);
        String siteKey=Recaptchav2PageController.getSiteKey(); 
        Test.StopTest();
        System.assertEquals('testValue',siteKey); 
    }  
}
