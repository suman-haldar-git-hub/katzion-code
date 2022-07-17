/** File Name: EmailRelatedListController
* Description This class is the controller for EmailRelatedListController Visualforce page
* @author : Divya
* Modification Log =============================================================== 
Ver     Date            Author         Modification --- ---- ------ -------------
1.0     30/12/2019   Divya Kapil        Original version
**/

public class EmailRelatedListController {     
public static List<EmailMessage> emails{get;set;}
public static Case cases {get;set;} 
public static Case cas {get;set;} 
//Constructor 

public EmailRelatedListController(ApexPages.StandardController controller) { 

    cas = (case)controller.getRecord();      

    cases = [SELECT id,Preferred_Email__c,contact.email FROM case WHERE id=: cas.id LIMIT 1]; 

    emails = [SELECT id,Subject,TextBody,status, Incoming,FromAddressText__c,FromAddress,ToAddress,MessageDate,IsOpened,IsBounced,HasAttachment FROM EmailMessage WHERE ParentId = :cases.id ORDER BY MessageDate desc];  
    for(EmailMessage  eEmail : emails ){
    integer i = eEmail.Subject.length();
    integer j = eEmail.TextBody.length();
    if(i>80)
     eEmail.Subject = eEmail.Subject.substring(0,77)+'...';
    if(j>80)
     eEmail.TextBody = eEmail.TextBody.substring(0,77)+'...';
    if (eEmail.status == '0')
     eEmail.Status = Label.New;
    if (eEmail.status =='1')
     eEmail.Status = Label.Read;
    if (eEmail.status=='2')
     eEmail.Status = Label.Replied;
    if (eEmail.status=='3')
     eEmail.Status = Label.Sent;
    if (eEmail.status=='4')
     eEmail.Status = Label.Forwarded;
    if (eEmail.status=='5')
     eEmail.Status = Label.Draft;      
   }        
} 
    /*
  ** Method Name : delEmail
  ** Description : This method is for deleting the email message record from email's list on case record;
  ** Return Type : Void
  */
  
     public string recid {get;set;}

   public void delEmail(){ 
    string passedParam1 = Apexpages.currentPage().getParameters().get('emailId');
    string passedParam2 = system.CurrentPageReference().getParameters().get('emailId');
    List<EmailMessage> delobj = new List<EmailMessage>();
    delobj  = [select id FROM EmailMessage where id =: recid];
    if(delobj.size()>0){
     delete delobj; 
      }
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
    emails = [SELECT id,Subject,TextBody,status, Incoming,FromAddressText__c,FromAddress,ToAddress,MessageDate,IsOpened,IsBounced,HasAttachment FROM EmailMessage WHERE ParentId = :cases.id ORDER BY MessageDate desc];  
    for(EmailMessage  eEmail : emails ){
    integer i = eEmail.Subject.length();
    integer j = eEmail.TextBody.length();
    if(i>80)
     eEmail.Subject = eEmail.Subject.substring(0,77)+'...';
    if(j>80)
     eEmail.TextBody = eEmail.TextBody.substring(0,77)+'...';
    if (eEmail.status == '0')
     eEmail.Status = Label.New;
    if (eEmail.status =='1')
     eEmail.Status = Label.Read;
    if (eEmail.status=='2')
     eEmail.Status = Label.Replied;
    if (eEmail.status=='3')
     eEmail.Status = Label.Sent;
    if (eEmail.status=='4')
     eEmail.Status = Label.Forwarded;
    if (eEmail.status=='5')
     eEmail.Status = Label.Draft;     
        }        
    }   
}