/**
 * @author : Amit Sharma
 * @company : SaasFocus
 * @description : This class handles the DML operations performed on the EmailMessage
 */
 
public with sharing class EmailMessageDomain{
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return Email message and attachment
    * @return  : List<EmailMessage>
    * @param  caseObjId - case Object id
    * @param objUser - user record
    */
    public static List<EmailMessage> getEmailAndAttachment (String caseObjId, 
                                                        User objUser){
        List<EmailMessage> lstEmailMessage = [Select TextBody,Status,CreatedDate,HtmlBody,
                                            Subject,ToAddress,FromAddress,CcAddress,
                                            (Select Id,Name from Attachments)
                            FROM EmailMessage 
                        Where ParentId =: caseObjId 
                        AND (ToAddress =: objUser.Email OR 
                        CcAddress =: objUser.Email OR FromAddress =: objUser.Email)
                        ];
        return lstEmailMessage;
    }
}