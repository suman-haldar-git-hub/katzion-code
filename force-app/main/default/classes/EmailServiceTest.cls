/**
 * @author : Monika Bisht
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * EmailService class.
*/
@isTest(SeeAllData=false)
public class EmailServiceTest {
    
    /**
     * @author : Monika Bisht
     * @ccompany : Cognizant
     * @description : This method is used to setup test data
     * 
    */
    @testSetup
    static void dataSetup(){
  
    EmailTemplate emailTemp = new EmailTemplate();
    emailTemp.isActive = true;
    emailTemp.Name = 'name';
    emailTemp.DeveloperName = 'Test_Template_Unique';
    emailTemp.TemplateType = 'text';
    emailTemp.FolderId = UserInfo.getUserId();
    insert emailTemp;
    
    }

    /**
     * @author : Monika Bisht
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * sendEmail method.
    */
    @isTest
    static void testSendEmailWithTargetObjectId() {
     List<Account> accList = AccountTestData.createAccountRecords(1, '');
     insert accList;
    
    List<Contact> conList = ContactTestData.createContactRecords(1, accList[0].Id);
    conList[0].Email = 'email@test.com';
    insert conList;
        
    String templateId = [SELECT Id FROM EmailTemplate Limit 1].Id;
    
    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
    efa.setFileName('TestDoc.pdf');
    efa.setBody(blob.valueof('R0lGODlhOAAYAPeZAGixGXPIH3bPImCgFGy5G1yYEXucQLHahbLdhpjXW7TiiIq5U7jpiqrMgqbEf67VhKzRg6jIgLblicrfseHo0/X68MzZtfn69s3lsmuQKNLhv7THktjswuP00tfqwnTHHvb88Pv8+YakT/X78FmLCleBC26uJobPPcvisWerFfT472umJG2SK7PPkF2YEHDBHFJ/BmarFnvWI1mMCrXTke354lGACV+HF5XAYvX574jVP9v0xHnELFeICdDttEZqA7/Zoa/me7/pmGCeElSBB0tyBHXJH12GFFeMDVuPC1iKCVOABsfppU12Bk53BZPMWH/fJsnup6veeZu8b9bowWu3GVqNCuT301qSDnWYN4LIO3LFHd7qz7nblN7pz1uQC3WtM5HZTmisFUpwBGefIabjbOz34VWDB4WuT268G8far32tQYCfRtnuw4KhSXOWNFWECJDGVlSGClJ9BlqOC2+7GqK5eHbMIGmPJXa+Kury4Ex0BKC4derz4FaFCPb78FJ9BUVoA1eHCYvbQKnZd2iwF056B9ryxGOlFHnVI2/AHViQD2SoFkRnA0dtBE15CEpzBlSIDH/gJ1CBCnzbJYHkKFN+BYLmKf///////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAJkALAAAAAA4ABgAAAj/ADNdsMPCksGDCBMqXMiw4cEbbihkCpFFjIxLGDNq3Mixo8ePGaHUKWFhQwqQKFOq5Pghg4gPK2PK9EjCwJ1KOHPq3Mmzp8+fPr8YMCKpqNGjSJMqXcp0aRIDWyhJnUq1qtWrWLNipWPgRaKvYMMmYnAFU40og8ZiWrtWLaYyYBm0TcQWxI4gYsVaMZBGgN+/gIWwXRtGgITBmAyvBaHD7+HEAhBjOgS48gwDVQJo3sz5DyYfAU4o0KxgbYLTAUqv7UB6rea1TBJ0WCuFM+eahRTp3s17BCYzhLTsRrCWN3G2CBQd1702OQ/fbXjzVmIgBoHr2LMfGMwhD4Htg7+v/wX/BPz18dc5rM2evYcBRADiy58PIA6GCmsxAHiAeP9aAB5gUkEX/wGw1gPxBYgJffIJYsAQjEQo4YQmSIjCWoxAgKGEGmLCiAk5DBbhWhBE2AcmVEw4oR8GuDDAizDGOAENYKwwASZ6DNDAWgv0qONaL+Iw2ItrAbHAjZg0EGOMcBiARQFQRhnlGpJFUEAEiF25VpQtsAWlZFyQIaWUZxiAxCJopqkmGmqogIkGU6DpAGKLzImJml6sheZgGjig5p+LEGGAHJEUauihiCaq6KKMLrqEATZMIumklFZq6aWYZoopDAYY8sinoIYq6qiklmpqqXOI0AQkrLbq6quwxjwq66yyArKBE47kquuuvPbq66/A+loEHiG8sccPjSSr7LLMNuvss9AqG8gYJAnERwYOZavttgYdwYZEAQEAOw=='));
    
        List<EmailService.EmailWrapper > lst = new List<EmailService.EmailWrapper >();
        EmailService.EmailWrapper obj = new EmailService.EmailWrapper();
        obj.whatId = accList[0].Id;
        obj.targetObjectId = conList[0].Id;
        obj.emailTemplateId = templateId;
        obj.saveAsActivity = false;
        obj.attachments = new List<Messaging.Emailfileattachment>();
        obj.attachments.add(efa);
    lst.add(obj);

    Test.startTest();
        EmailService.sendEmail(lst);
    Test.stopTest();

        System.assertEquals(lst.size(), 1);
    }
  
  /**
     * @author : Monika Bisht 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * sendEmail method.
    */
    @isTest
    static void testSendEmailWithSubjectandBody() {
    List<string> toaddress = new List<string> ();
    Toaddress.add('test@testmail.com');
    
    List<string> ccAddress = new List<string> ();
    ccAddress.add('test@testmail.com');

    List<EmailService.EmailWrapper > lst = new List<EmailService.EmailWrapper >();
        EmailService.EmailWrapper obj = new EmailService.EmailWrapper();
        obj.subject = 'test subject';
        obj.htmlBody = 'test htmlBody';
        obj.plainTextBody = 'test plainTextBody';
        obj.toaddress = toaddress;
        obj.ccAddress = ccAddress;
        obj.saveAsActivity = false;
        lst.add(obj);

    Test.startTest();
        EmailService.sendEmail(lst);
    Test.stopTest();
        System.assertEquals(lst.size(), 1);
    }
}