/*
    Author:             Venky
    Created Date:       Mar 03, 2017 
    Brief:              Email Function
 


   Description:     

This email function is triggered from the trigger AttachmentTypeTrigger and it sends email to the case users if the atatchments sent in the email was not in the accepted list.

Accepted list is configured in PicklistValues

Problem# PRB00001449
*/

public class EmailFunction {

    String atchName{get;set;}
      public void doSendEmail(List<String> emailParams,String caseId,String atchTypes) {
        String atchName=String.join(emailParams, ',');
       
         Case cas=[select id,suppliedemail,casenumber,subject,suppliedname,CaseThreadId__c,RecordTypeId  from case where id=:caseId];
        
      //  String CaseThreadid="[ ref:" & LEFT( org.Id , 4)  & IF (MID (org.Id, 5, 1) <> "0", RIGHT(org.Id, 11), IF(MID ( org.Id, 6, 1) <> "0", RIGHT(org.Id,10), IF (MID ( org.Id, 7, 1) <> "0",RIGHT(org.Id, 9), IF (MID ( org.Id, 8, 1) <>"0", RIGHT(org.Id, 8), IF (MID ( org.Id, 9, 1)<> "0", RIGHT(org.Id, 7), IF (MID ( org.Id,10, 1) <> "0", RIGHT(org.Id, 6), IF (MID (org.Id, 11, 1) <> "0", RIGHT(org.Id, 5), IF(MID ( org.Id, 12, 1) <> "0", RIGHT(org.Id,4), IF (MID ( org.Id, 13, 1) <> "0",RIGHT(org.Id, 3), IF (MID ( org.Id, 14, 1) <>"0", RIGHT(org.Id, 2), "") ) ) ) ) ) ) ) ) ) & "."  &LEFT( Id, 4) & IF (MID ( Id, 5, 1) <> "0", RIGHT(cas.Id, 11), IF(MID ( Id, 6, 1) <> "0", RIGHT(cas.Id, 10), IF (MID ( Id, 7, 1)<> "0", RIGHT(cas.Id, 9), IF (MID ( Id, 8, 1) <> "0", RIGHT(cas.Id,8), IF (MID ( Id, 9, 1) <> "0", RIGHT(cas.Id, 7), IF (MID ( Id, 10,1) <> "0", RIGHT(cas.Id, 6), IF (MID ( Id, 11, 1) <> "0",RIGHT(cas.Id, 5), IF (MID ( Id, 12, 1) <> "0", RIGHT(cas.Id, 4), IF (MID( Id, 13, 1) <> "0", RIGHT(cas.Id, 3), IF (MID ( Id, 14, 1) <>"0", RIGHT(cas.Id, 2), "") ) ) ) ) ) ) ) ) ) & ":ref ]";
        
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                           String[] toAddresses = new String[] {cas.suppliedemail};
          if(cas.RecordTypeId==Label.RecordTypeId_BigWCase){
            message.setSenderDisplayName('Big W Employee Services');
          }else{
			message.setSenderDisplayName('People Services');
          }                               
                         
       
     
         
       /*    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'hrpeopleadvisorytest@gmail.com'];
//Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
if ( owea.size() > 0 ) {
    message.setOrgWideEmailAddressId(owea.get(0).Id);
}
*/

        // message.('hrpeopleadvisorytest@gmail.com');
                        // message.setSubject('New case '+cas.casenumber +' has been created');
                     
      String emailBody='<table class="body" style="border-spacing: 0; border-collapse: collapse; padding: 0; vertical-align: top; text-align: left; height: 100%; width: 100%; color: #3e3e3e;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td class="center" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0; vertical-align: top; text-align: center; color: #3e3e3e;" align="center" valign="top"><center style="width: 100%; min-width: 580px;">'+
'<table class="row header" style="border-spacing: 0; border-collapse: collapse; padding: 0px; vertical-align: top; text-align: left; background: #3e3e3e; height: 45px; width: 100%; position: relative;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td class="center" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0; vertical-align: top; text-align: center; color: #3e3e3e;" align="center">&nbsp;</td>'+
'</tr>'+
'</tbody>'+
'</table>'+
'<table class="container" style="border-spacing: 0; border-collapse: collapse; padding: 0; vertical-align: top; text-align: inherit; width: 580px; margin: 0 auto; margin-top: 21px; margin-bottom: 21px;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0; vertical-align: top; text-align: left; color: #3e3e3e;">'+
'<table class="row" style="border-spacing: 0; border-collapse: collapse; padding: 0px; vertical-align: top; text-align: left; width: 100%; position: relative; display: block;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td class="wrapper" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 10px 20px 0px 0px; vertical-align: top; text-align: left; color: #3e3e3e;">'+
'<table class="three columns" style="border-spacing: 0; border-collapse: collapse; padding: 0; vertical-align: top; text-align: left; margin: 0 auto; width: 130px;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">';
          if(cas.RecordTypeId==Label.RecordTypeId_BigWCase){
            emailBody = emailBody + '<td class="center" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0px 0px 10px; vertical-align: top; text-align: center; color: #3e3e3e;"><img style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; width: auto; max-width: 100%; float: left; clear: both; display: block;" src="https://peopleservices--c.ap2.content.force.com/servlet/servlet.ImageServer?id=01528000002i9Ug&oid=00D28000000VWZJ&lastMod=1478766520000" alt="" /></td>' ;      
          }else{
			emailBody = emailBody + '<td class="center" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0px 0px 10px; vertical-align: top; text-align: center; color: #3e3e3e;"><img style="outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; width: auto; max-width: 100%; float: left; clear: both; display: block;" src="https://peopleservices--c.ap2.content.force.com/servlet/servlet.ImageServer?id=015280000005C7n&amp;oid=00D28000000VWZJ&amp;lastMod=1434499154000" alt="" /></td>' ;          
          }
		emailBody = emailBody +'</tr>'+
'</tbody>'+
'</table>'+
'</td>'+
'<td class="wrapper last" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 10px 20px 0px 0px; vertical-align: top; text-align: left; color: #3e3e3e;">'+
'<table class="nine columns" style="border-spacing: 0; border-collapse: collapse; padding: 0; vertical-align: top; text-align: left; margin: 0 auto; width: 430px;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0px 0px 10px; vertical-align: top; text-align: left; color: #3e3e3e;">'+
'<table>'+
'<tbody>'+
'<tr>'+
'<td class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;"><strong>Case Number:</strong></td>'+
'<td class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;"><strong>'+cas.casenumber+'</strong></td>'+
'</tr>'+
/*
 '<tr>'+
'<td class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;"><strong>Subject:</strong></td>'+
'<td class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;"><strong> Attachment Not Accepted </strong></td>'+
'</tr>'+
*/
'</tbody>'+
'</table>'+
'<br></br>'+
'<p style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">Dear '+cas.suppliedname+',</p>'+
'<p class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">Unfortunately, attachment named '+
'<strong>'+ atchName +'</strong>  has been removed from your previous correspondence because it is not part of the accepted file formats.</p>'+
          '<p class="lead" style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">You can reply to this email to re-submit your '+
'attachment in one of the following accepted file format ' +atchTypes+ '</p>'+
'<p style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">Thank you,</p>';
          if(cas.RecordTypeId==Label.RecordTypeId_BigWCase){
            emailBody = emailBody + '<p style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">Big W Employee Services</p>';    
          }else{
			emailBody = emailBody + '<p style="margin: 0; margin-bottom: 10px; color: #3e3e3e;font-family:verdana;">People Services</p>';          
          }          

          
	emailBody = emailBody +'<br />'+
'</td>'+
'<td class="expander" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0 !important; vertical-align: top; text-align: left; color: #3e3e3e;" hidden="">&nbsp;</td>'+
'</tr>'+
'</tbody>'+
'</table>'+
'</td>'+
'</tr>'+
 '<tr>'+cas.CaseThreadId__c+'</tr>'+
'</tbody>'+
'</table>'+
'<!-- container end below --></td>'+
'</tr>'+
'</tbody>'+
'</table>'+
'<table class="row footer" style="border-spacing: 0; border-collapse: collapse; padding: 0px; vertical-align: top; text-align: left; background: #b6b6b6; height: 45px; width: 100%; position: relative;">'+
'<tbody>'+
'<tr style="padding: 0; vertical-align: top; text-align: left;">'+
'<td class="center" style="word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; padding: 0; vertical-align: top; text-align: center; color: #3e3e3e;" align="center">&nbsp;</td>'+
'</tr>'+
'</tbody>'+
'</table>'+
'</center></td>'+
'</tr>'+
'</tbody>'+
'</table>';
    
    message.setSubject('Attachment Not Accepted');
        message.sethtmlBody(emailBody);
          if(cas.RecordTypeId==Label.RecordTypeId_BigWCase){
            message.setReplyTo('employeeservices@bigw.com');
          }else{
            message.setReplyTo('peopleadvisory@woolworths.com.au');
          }          
                            message.saveAsActivity=false;
                           message.setToAddresses(toAddresses);
                           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });

        
        /*    Contact con1=[Select Id,email,name from Contact where email=:cas.suppliedemail ] ;
          message.setTemplateid('00XO0000000RcCv');
      	 message.setTargetObjectId(con1.Id);
         message.setReplyTo('hrpeopleadvisorytest@gmail.com');
                message.setWhatId(cas.Id);
        message.setSaveAsActivity(false);
        message.setToAddresses(toAddresses);
                           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });*/

        
      
}
}