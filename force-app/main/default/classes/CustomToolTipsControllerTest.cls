/**     
    * @Name CustomToolTipsControllerTest
    * @description Test Class of CustomToolTipsController
    * @author Aman Kumar | 01-18-2022 
    **/
@isTest
public with sharing class CustomToolTipsControllerTest {
    
     /**
    * @description Getting values from custom Metadata
    * @author Aman Kumar | 01-18-2022 
    **/
    @isTest
    public static void customToolTipsMdtTest() { 
        
        Test.startTest();
        Configuration_Settings__mdt mdtObj = CustomToolTipsController.customToolTipsMdt('Payroll_Query_Form');
        system.assertEquals('Payroll_Query_Form', mdtObj.DeveloperName, 'Success');
        Test.stopTest();
    }
    
}