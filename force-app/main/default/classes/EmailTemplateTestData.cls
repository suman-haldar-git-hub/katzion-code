/**
 * @description       : This is test data builder class for EmailTemplate.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-08-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   04-08-2021   Prathamesh Lad   Initial Version
**/
@isTest
public class EmailTemplateTestData {
    /**
    * @description This method is used to create EmailTemplate records
    * @author Prathamesh Lad | 04-08-2021 
    * @param count 
    * @param folderName
    * @param templateName
    * @return List<EmailTemplate> 
    **/
    public static List<EmailTemplate> getEmailTemplateRecords
        (Integer count, String folderName, String templateName) {
        List<Folder> listFolders
            =[Select id from Folder where Name=:folderName];
        List<EmailTemplate> listEmailtemplates =new List<EmailTemplate>();
        for (Integer i = 1; i <= count; i++) {
            EmailTemplate emailTempObj= new EmailTemplate ();
            emailTempObj.developerName = templateName;
            emailTempObj.TemplateType= 'Text'; 
            emailTempObj.Name = templateName;
            emailTempObj.folderId=listFolders[0].Id;
            emailTempObj.Body='Test Data';
            listEmailtemplates.add(emailTempObj);        
        }
        return listEmailtemplates;
    }
}