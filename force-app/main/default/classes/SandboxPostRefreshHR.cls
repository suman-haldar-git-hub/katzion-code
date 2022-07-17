/** File Name: SandboxPostRefreshHR
* Description: This class is used for performing actions after Sandbox refresh
* @author : Ankur Garg
**/ 
global class SandboxPostRefreshHR implements SandboxPostCopy{

/*
** Method Name : runApexClass
** Description : Default method of SandboxPostCopy interface
** Parameters : SandboxContext
** Return Type :
*/    
    global void runApexClass(SandboxContext context) { 
        
        System.debug(context.organizationId()); 
        
        System.debug(context.sandboxId()); 
        
        System.debug(context.sandboxName()); 
        
        updateworkflows();        
        
        updatequeues();
        
        updatecontacts();
        
        updateaccounts();
        
        updatecases();
        
        updateusers();
    } 

/*
** Method Name : updatequeues
** Description : Update Email address in Queues
** Parameters : 
** Return Type :
*/     
    global static void updatequeues() { 
        
        //List of all Queue emails from the Group object  
        List<Group> queustoupdate = new List<Group>();
        List<Group> queueList = [SELECT Email,Id FROM Group WHERE Type = 'Queue' AND Email != null];
        for(Group grp : queueList)             
        {             
            //Group que = new Group();
            grp.Email = grp.Email+'xxx' ;        
            queustoupdate.add(grp);             
        } 
        
        system.debug('queueList::'+queueList.size());
        system.debug('queustoupdate::'+queustoupdate.size());
        
        if(queustoupdate.size() > 0)            
        {             
            Database.update(queustoupdate,false);             
        } 
    }
    
/*
** Method Name : updatecontacts
** Description : Update Email address in contact
** Parameters : 
** Return Type :
*/    
    global static void updatecontacts() { 
        
        //List of all emails from the Contact object          
        List<Contact> contactList = [Select Id, Email From Contact where email!=null]; 
        
        if(contactList.size() > 0)             
        { 
            String query = 'Select Id, Email From Contact where email!=null';
            SandboxRefreshMaskBatch batchObj=new SandboxRefreshMaskBatch(query,'Contact');
            Database.executeBatch(batchObj, 200);   
        }           
    }

/*
** Method Name : updateaccounts
** Description : Update Email address in account
** Parameters : 
** Return Type :
*/    
    global static void updateaccounts() { 
        
        //List of all emails from the Account object          
        List<Account> accountList = [Select id, Mass_Email_Address__c from Account where   Mass_Email_Address__c!=null]; 
        
        if(accountList.size() > 0)             
        { 
            String query = 'Select id, Mass_Email_Address__c from Account where   Mass_Email_Address__c!=null';
            SandboxRefreshMaskBatch batchObj=new SandboxRefreshMaskBatch(query,'Account');
            Database.executeBatch(batchObj, 200);   
        }           
    }  
    
/*
** Method Name : updatecases
** Description : Update Email address in case
** Parameters : 
** Return Type :
*/
    global static void updatecases() { 
        
        //List of all emails from the Case object          
        List<case> caseList = [Select id, Account_Email_Address__c,On_Behalf_Of_Employee_Email__c,Preferred_Email__c,Respondent_Employee_Email__c,SuppliedEmail,WOW_Web_Email_Address__c from Case]; 
        
        if(caseList.size() > 0)             
        { 
            String query = 'Select id, Account_Email_Address__c,On_Behalf_Of_Employee_Email__c,Preferred_Email__c,Respondent_Employee_Email__c,SuppliedEmail,WOW_Web_Email_Address__c from Case';
            SandboxRefreshMaskBatch batchObj=new SandboxRefreshMaskBatch(query,'Case');
            Database.executeBatch(batchObj, 200);   
        }           
    }      
    
/*
** Method Name : updateusers
** Description : Update email for users
** Parameters : 
** Return Type :
*/    
    global static void updateusers() { 
        String userIds = Label.Sandbox_refresh_exclude_Admin_User;
        
        List<String> filterLogicSplittedbySpace = userIds.split(',');
        
        List<Id> uIds = filterLogicSplittedbySpace;
        
        //Disable Specific Admin Users
        List<User> users = [select id, isactive from user where id in :uIds and isactive=true];        
        for(User us : users){
            us.isactive=false;
        }
        
        if(users.size()>0)
        	database.update(users,false);
        
        //Update Admin Users Email address
        Id profileId=userinfo.getProfileId();
        
        List<User> adminusers = [select id,email from user where profileid=:profileId and id not in :uIds and isactive=true];
        
        system.debug('users::'+users.size());
        system.debug('adminusers::'+adminusers.size());        
        
        for(User admusr : adminusers){
            admusr.email=admusr.email.substring(0, admusr.email.length() - 8);
        }
        
        if(adminusers.size()>0)
        	database.update(adminusers,false);         
    }      

/*
** Method Name : updateworkflows
** Description : Update Email address in workflow alerts
** Parameters : 
** Return Type :
*/    
    global static void updateworkflows() { 
        
        //Worflow Alerts
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId(); 
        
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery listView = new MetadataService.ListMetadataQuery();
        listView.type_x = 'WorkflowAlert';
        queries.add(listView);
        
        MetadataService.Metadata[] alerts = new MetadataService.Metadata[]{};
            
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 43);
        for(MetadataService.FileProperties fileProperty : fileProperties){
            System.debug(fileProperty.fullName);
            MetadataService.Metadata[] mdInfo = service.readMetadata('WorkflowAlert',new String[]{fileProperty.fullname}).getRecords();
            for(MetadataService.Metadata md:mdInfo){
                MetadataService.WorkflowAlert alert = (MetadataService.WorkflowAlert)md;
                //system.debug('description:::'+alert.description);
                //system.debug('From:::'+alert.senderAddress);
                system.debug('CCEmails:::'+alert.ccEmails);
                system.debug('Reciepients:::'+alert.recipients);
                
                List<String> newccemails = new List<String>();
                if(alert.ccEmails !=null){                    
                    for(String ccemail : alert.ccEmails){
                        newccemails.add(ccemail+'xxx');
                    }
                }
                alert.ccEmails = newccemails;
                
                List<MetadataService.WorkflowEmailRecipient> newrecipients = new List<MetadataService.WorkflowEmailRecipient>();
                if(alert.recipients !=null){                    
                    for(MetadataService.WorkflowEmailRecipient rec : alert.recipients){
                        rec.recipient = rec.recipient+'xxx';
                        newrecipients.add(rec);
                    }
                }
                alert.recipients = newrecipients;
                
                alerts.add(alert);
                
            }    
        }
        
        
        if(alerts.size()>0){
            system.debug('alerts::'+alerts.size());
            
            List<List<MetadataService.Metadata>> lstWrapper = new List<List<MetadataService.Metadata>>();
            for(Integer i = 0 ; i < (alerts.size() / 10)+1 ; i++){
                List<MetadataService.Metadata> lstTemp = new List<MetadataService.Metadata>();
                for(Integer j=(i*10);(j<(i*10)+10) && j<alerts.size() ; j++){
                    lstTemp.add(alerts.get(j));
                }
                lstWrapper.add(lstTemp);
            }            
            // Update
            system.debug('lstWrapper::'+lstWrapper.size());
            for(List<MetadataService.Metadata> lst : lstWrapper){
                List<MetadataService.SaveResult> results = service.updateMetadata(lst);
                handleSaveResults(results);                 
            }           
        }
                
        
    }
    
    public class MetadataServiceException extends Exception { }

/*
** Method Name : handleSaveResults
** Description : Handle errors during update of workflow alerts
** Parameters : List<MetadataService.SaveResult>
** Return Type :
*/    
    public static void handleSaveResults(List<MetadataService.SaveResult> saveResults)
    {
        for(MetadataService.SaveResult saveResult : saveResults){
            System.debug('saveResult:: '+saveResult);
            // Nothing to see?
            //if(saveResult==null || saveResult.success)
                //return;
            // Construct error message and throw an exception
            if(saveResult.errors!=null)
            {
                List<String> messages = new List<String>();
                messages.add((saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +'occured processing component ' + saveResult.fullName + '.');
                for(MetadataService.Error error : saveResult.errors)
                    messages.add(error.message + ' (' + error.statusCode + ').' +( error.fields!=null && error.fields.size()>0 ?' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
                if(messages.size()>0 && !Test.isRunningTest())
                    throw new MetadataServiceException(String.join(messages, ' '));
            }
            if(!saveResult.success && !Test.isRunningTest())
                throw new MetadataServiceException('Request failed with no specified error.');            
        }
        
    }    
}