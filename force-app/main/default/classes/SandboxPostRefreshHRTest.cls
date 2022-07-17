/** File Name: SandboxPostRefreshHRTest
* Description: This test class for SandboxRefreshMaskBatch
* @author : Ankur Garg
**/ 
@isTest
public class SandboxPostRefreshHRTest {

    
    private class WebServiceMockImpl implements WebServiceMock 
    {
/*
** Method Name : doInvoke
** Description : Invoke method for WebServiceMock interface
** Parameters : Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType
** Return Type :
*/        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) 
        {
            if(request instanceof MetadataService.retrieve_element)
                response.put('response_x', new MetadataService.retrieveResponse_element());
            else if(request instanceof MetadataService.checkDeployStatus_element)
                response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
            else if(request instanceof MetadataService.listMetadata_element){
                MetadataService.listMetadata_element listMetadata_element  = (MetadataService.listMetadata_element) request;
                // This allows you to generalize the mock response by type of metadata read
                MetadataService.listMetadataResponse_element mockRes   = new MetadataService.listMetadataResponse_element();

                if (listMetadata_element.queries[0].type_x == 'WorkflowAlert') { 
                    List<MetadataService.FileProperties> fileProperties = new List<MetadataService.FileProperties>();
                    MetadataService.FileProperties fileProperty = new MetadataService.FileProperties();
                    fileProperty.fullName='TEST_Active_Permission';
                    fileProperties.add(fileProperty);
                    mockRes.result = fileProperties;
                    response.put('response_x', mockRes);
                }          	    
            }
            else if(request instanceof MetadataService.readMetadata_element){
                MetadataService.readMetadata_element requestReadMetadata_element  = (MetadataService.readMetadata_element) request;
                // This allows you to generalize the mock response by type of metadata read
                if (requestReadMetadata_element.type_x == 'WorkflowAlert') { 
                    MetadataService.readWorkflowAlertResponse_element mockRes   = new MetadataService.readWorkflowAlertResponse_element();
                    mockRes.result = new MetaDataService.ReadWorkflowAlertResult();
                    //mockRes.result.records = createCustomObjects();
                    
                    /*MetadataService.Workflow workflow = new MetadataService.Workflow();
MetadataService.WorkflowActionReference workflowActionRef = new MetadataService.WorkflowActionReference();
MetadataService.WorkflowRule workflowRule = new MetadataService.WorkflowRule();*/
                    MetadataService.WorkflowAlert WorkflowAlert = new MetadataService.WorkflowAlert();
                    
                    // Workflow Alert
                    WorkflowAlert.fullName           = 'TEST_Active_Permission';
                    WorkflowAlert.description        = 'Activates a permission.';
                    WorkflowAlert.ccEmails           = new String[]{'agarg2@woolworths.com.au','agarg2@woolworths.com.au'};
                        WorkflowAlert.template           = 'TestTemplate';
                    WorkflowAlert.senderAddress      = 'agarg2@woolworths.com.au';
                    
                    MetadataService.WorkflowEmailRecipient WorkflowEmailRecipient = new MetadataService.WorkflowEmailRecipient();
                    WorkflowEmailRecipient.type_x='email';
                    WorkflowEmailRecipient.field='email';
                    WorkflowEmailRecipient.recipient='agarg2@woolworths.com.au';
                    
                    List<MetadataService.WorkflowEmailRecipient> WorkflowEmailRecipients = new List<MetadataService.WorkflowEmailRecipient>();
                    WorkflowEmailRecipients.add(WorkflowEmailRecipient);  
                    
                    WorkflowAlert.recipients      = WorkflowEmailRecipients;
                    
                    
                    // Workflow Action Reference
                    /*workflowActionRef.name   = 'TEST_Active_Permission';
workflowActionRef.type_x = 'Alert';


// Workflow Rule
workflowRule.fullName             = 'TEST_ManageActiveTemporaryPermission';
workflowRule.active               = true;
workflowRule.description          = 'Manages when a temporary permission has to be set as active.';
workflowRule.formula              = 'IF(RecordType.DeveloperName=\'Temporary\' && BeginDate__c > Today(),TRUE,FALSE)';
workflowRule.triggerType          = 'onCreateOrTriggeringUpdate';
workflowRule.actions              = new MetadataService.WorkflowActionReference[]{workflowActionRef};

workflow.fullName = 'Permission__c';
workflow.rules    = new MetadataService.WorkflowRule[]{workflowRule};*/
                    
                    List<MetadataService.WorkflowAlert> WorkflowAlerts = new List<MetadataService.WorkflowAlert>();
                    WorkflowAlerts.add(WorkflowAlert);
                    mockRes.result.records = WorkflowAlerts;
                    
                    
                    response.put('response_x', mockRes);
                }           	    
            }   
            else if(request instanceof MetadataService.updateMetadata_element){
                MetadataService.updateMetadata_element requestUpdateMetadata_element  = (MetadataService.updateMetadata_element) request;
                
                List<MetadataService.SaveResult> res = new List<MetadataService.SaveResult>();
                MetadataService.updateMetadataResponse_element mockRes   = new MetadataService.updateMetadataResponse_element();
                MetadataService.SaveResult sr = new MetadataService.SaveResult();
                sr.success=true;                
                res.add(sr);
                
                MetadataService.SaveResult sr1 = new MetadataService.SaveResult();
                sr1.success=false; 
                
                List<MetadataService.Error> errs = new List<MetadataService.Error>();
                
                MetadataService.Error err = new MetadataService.Error();
                err.message='Test Message';
                err.statusCode='404';
                //String[] flds = {'First','Second'};
                err.fields=new String[] { 'First','Second' };
                
                errs.add(err);
                sr1.errors = errs;
                res.add(sr1);

                MetadataService.SaveResult sr2 = new MetadataService.SaveResult();
                sr2.success=false;                
                res.add(sr2);
                
                mockRes.result = res;
                response.put('response_x', mockRes);          	    
            }             
            /*else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
            else if(request instanceof MetadataService.describeMetadata_element)
                response.put('response_x', new MetadataService.describeMetadataResponse_element());
            else if(request instanceof MetadataService.deploy_element)
                response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof  MetadataService.cancelDeploy_element)
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof  MetadataService.upsertMetadata_element)
                response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            else if(request instanceof  MetadataService.deployRecentValidation_element)
                response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
            else if(request instanceof MetadataService.describeValueType_element)
                response.put('response_x', new MetadataService.describeValueTypeResponse_element());
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());*/
            return;
        }
    }    
    
/*
** Method Name : testSandboxPostCopyScript
** Description : Test method
** Parameters : 
** Return Type :
*/    
    @isTest
    static void testSandboxPostCopyScript() 
    {
        Group que = new Group();
        que.Name ='TestQueue1';
        que.Type = 'Queue'; 
        que.email= 'Test1@test.com';
        insert que;
        
        Contact con = new Contact();
        con.FirstName ='FirstUser';
        con.LastName = 'LastUser'; 
        con.email= 'Test2@test.com';
        insert con;  
        
        Account acc = new Account();
        acc.FirstName ='FirstUser';
        acc.LastName = 'LastUser'; 
        acc.Mass_Email_Address__c= 'Test3@test.com';
        insert acc; 

        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
        insert caseRec;

        // create transaction cases
        Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
        List<Case> cases = TestUtility.createTrxCases(1,transcationCaseId);    
        
        for(Case c : cases)
        {
            c.Preferred_Email__c = 'Test4@test.com';
            c.Account_Email_Address__c = 'Test4@test.com';
            c.On_Behalf_Of_Employee_Email__c = 'Test4@test.com';
            c.Respondent_Employee_Email__c = 'Test4@test.com';
            c.SuppliedEmail = 'Test4@test.com';
            c.WOW_Web_Email_Address__c = 'Test4@test.com';
        }

        insert cases;        
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());        
        
        Test.startTest();
        Test.testSandboxPostCopyScript(new SandboxPostRefreshHR(), UserInfo.getOrganizationId(),UserInfo.getOrganizationId(), UserInfo.getOrganizationName()); 
        Test.stopTest();
        
        List <Case> cs =[select id,Preferred_Email__c from case];
        system.assertEquals('test4@test.comxxx',cs[0].Preferred_Email__c);
        
        List <Account> ac =[select id,Mass_Email_Address__c from Account];
        system.assertEquals('test3@test.comxxx',ac[0].Mass_Email_Address__c);  
        
        List <Contact> cn =[select id,email from Contact];
        system.assertEquals('test2@test.comxxx',cn[0].email);   
        
        List <Group> gr =[select id,email from Group where name='TestQueue1'];
        system.assertEquals('test1@test.comxxx',gr[0].email); 
    }
}