/**
 * @description       : This class is responsible for DML and SOQL for 
 *                      OrgWideEmailAddress object.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-06-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-11-2021   Prathamesh Lad   Initial Version
**/
public without sharing class OrgWideAddressDomain {//We can not set sharing settings for OrgWideEmailAddress object
    /**
    * @description This method is used to fetch OrgWideEmailAddress Object
    * @author Prathamesh Lad | 04-06-2021 
    * @param address 
    * @return List<OrgWideEmailAddress> 
    **/
    public static List<OrgWideEmailAddress> getOrgWideAddress(String address) {
        return [select Id from OrgWideEmailAddress 
                where Address =:address];
    }
}