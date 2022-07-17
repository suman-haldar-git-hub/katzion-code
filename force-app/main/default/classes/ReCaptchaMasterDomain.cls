/**
 * @description       : Tmain class is is Domain class for ReCaptchaMaster__mdt
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-15-2021   Prathamesh Lad   Initial Version
**/
public inherited sharing class ReCaptchaMasterDomain {
    
    /**
    * @description This method is used to get Recaptcha Masters records 
    * @author Prathamesh Lad | 07-15-2021 
    * @param webformName 
    * @return List<ReCaptchaMaster__mdt> 
    **/
    public static List<ReCaptchaMaster__mdt> getRecaptchaMasters(String webformName) {
        return [Select id,Secret_Key__c, Site_Key__c 
                from ReCaptchaMaster__mdt 
                where Webform__c=:webformName];
    }
}
