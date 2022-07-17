/**
 * @description       : This is controller class for Recaptchav2Page
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-14-2021   Prathamesh Lad   Initial Version
**/
public with sharing class Recaptchav2PageController {
    /**
    * @description This method is used to get Site key from URL
    * @author Prathamesh Lad | 07-14-2021 
    * @return String 
    **/
    public static String getSiteKey() {
        String sitekey=ApexPages.currentPage().getParameters().get('sitekey').escapeHtml4();
        return sitekey;
    }
}
