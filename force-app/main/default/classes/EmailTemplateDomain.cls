/**
 * @description       : This class is responsible for DML and SOQL for 
 *                      EmailTemplate object.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-10-2021   Prathamesh Lad   Initial Version
**/
public without sharing class EmailTemplateDomain {//We can not set sharing settings for Email Template object
    /**
   * @description This method is used to fetch EmailTemplate Object
   * @author Prathamesh Lad | 04-06-2021 
   * @param listEmailTempName 
   * @return List<EmailTemplate>
   **/
   public static List<EmailTemplate> getEmailTemplate(List<String> listEmailTempName) {
       return [Select id from EmailTemplate where 
               Name IN: listEmailTempName];
   }
}