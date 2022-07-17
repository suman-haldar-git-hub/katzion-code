/**
* @author : Amit Sharma
* @company : SaaSFocus A Cognizant Company
* @description : Batch class for creating reminder Task for CATS
*/
global class SubmitterAndApproverReminderBatch implements Database.Batchable<SObject>,
                                                                    Schedulable,Database.Stateful 
{
    private static Map<String, String> labelToContentMap = 
                                    CommunityContentInfoService.getMappingFromMetadeta();
    DateTime dateValue = Date.Today();
    global String scheduleDay = dateValue.format('EEEE');
    global Set<Id> setOfOwnerId = new Set<Id> ();
    global List<UniversalTaskList__c> lstUniversalTask= new List<UniversalTaskList__c>();
    /**
    * @Author : Amit Sharma
    * @description : This method will query Account record based on IsTimeSheetSubmitter__c check.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(scheduleDay == labelToContentMap.get('BATCHSUBMITTERDAY')){ 
            return Database.getQueryLocator([Select Id,IsTimeSheetSubmitter__c,
                                             IsTimeSheetApprover__c
                                        FROM ACCOUNT 
                                     WHERE IsTimeSheetSubmitter__c =: true AND
                                     Active__c = 'Y' AND Employee_ID__c != null]);
                                     
        }
        else if(scheduleDay == labelToContentMap.get('BATCHAPPROVERDAY')){
            return Database.getQueryLocator([Select Id,IsTimeSheetSubmitter__c,
                                            IsTimeSheetApprover__c
                                        FROM ACCOUNT 
                                     WHERE IsTimeSheetApprover__c =: true AND
                                     Active__c = 'Y' AND Employee_ID__c != null]);
        }
        return null;
    }
    
    /**
    * @Author : Amit Sharma
    * @description : This method will process each batch of records and creates task
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        try{
            List<UniversalTaskList__c> lstUniversalTaskList= new List<UniversalTaskList__c>();
            
            Integer weekEndDays = 4;
            Date myDate = Date.today();

            Date weekStartDate = myDate.toStartofWeek().addDays(1);
            Date endDateOfDataDate = weekStartDate.addDays(weekEndDays);
            
            Time myTime = Time.newInstance(23, 59, 0, 0);
            DateTime dueDate = DateTime.newInstance(endDateOfDataDate, myTime);

            String strStart = weekStartDate.format();
            String strEnd = endDateOfDataDate.format();
            
            String titleSubMetadata = 
                    labelToContentMap.get('TITLESUBMITCATS').replace('submitStart',strStart);
            String titleSubmit = titleSubMetadata.replace('submitEnd',strEnd);
            
            String titleApprMetadata = 
                    labelToContentMap.get('TITLEAPPROVECATS').replace('approveStart',strStart);
            String titleApprove = titleApprMetadata.replace('approveEnd',strEnd); 
            
            String desSubmitterMetadata = 
                    labelToContentMap.get('DESSUBMITCATS').replaceAll('submitStart',strStart);
            String desSubmitter = desSubmitterMetadata.replaceAll('submitEnd',strEnd);
            
            String desApprovalMetadata = 
                    labelToContentMap.get('DESAPPROVECATS').replaceAll('approveStart',strStart);
            String desApprover = desApprovalMetadata.replaceAll('approveEnd',strEnd);
            
            for(Account objAcc : scope){
                
                UniversalTaskList__c objTask = new UniversalTaskList__c();
                objTask.Status__c            = labelToContentMap.get('UTLTASKSTATUS');
                objTask.DueDate__c           = dueDate;
                objTask.AssignedToAccount__c = objAcc.id;
                objTask.recordtypeId         = DescribeSObjectCall.getRecordTypeIdByDeveloperName(
                            'UniversalTaskList__c',labelToContentMap.get('UTLRECORDTYPETASK'));
                objTask.OriginatingSystem__c = labelToContentMap.get('DEFAULTTASKTYPE');
                objTask.SystemOfAction__c    = labelToContentMap.get('CATSYSTEM');
                objTask.ReceivedDate__c      = Datetime.now(); 
                objTask.Type__c              = labelToContentMap.get('DEFAULTTASKTYPE');
                objTask.DeepLink__c          = labelToContentMap.get('CATSDEEPLINKURL');
                if(scheduleDay == labelToContentMap.get('BATCHSUBMITTERDAY')){
                    objTask.Title__c         = titleSubmit;
                    objTask.Description__c   = desSubmitter;
                    
                }
                else if (scheduleDay == labelToContentMap.get('BATCHAPPROVERDAY')){
                    objTask.Title__c         = titleApprove;
                    objTask.Description__c   = desApprover;
                }

                lstUniversalTaskList.add(objTask);
            }
            if(!lstUniversalTaskList.isEmpty())
            {
                Database.insert(lstUniversalTaskList);
                Set<Id> setUtlId = new Set<Id>();
                for(UniversalTaskList__c objUtl : lstUniversalTaskList){
                    setUtlId.add(objUtl.id);
                }
                for(UniversalTaskList__c objTaskApproval : 
                                    UniversalTaskListDomain.getUTLRecorcdBySetOfId(setUtlId)){
                    setOfOwnerId.add(objTaskApproval.OwnerId);
                    lstUniversalTask.add(objTaskApproval);
                }
            }
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent
            ('SubmitterAndApproverReminderBatch.cls on execute',ex);
        }
    }
    
     /**
    * @Author : Amit Sharma
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global Void finish(Database.BatchableContext bc) {
        
        try{
            //Create child campain and campaign member record
            insertCampaingRecord(lstUniversalTask,setOfOwnerId);
        }
        catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent
            ('SubmitterAndApproverReminderBatch.cls on finish',ex);
        }
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to insert the campaign and campaign member record
    * @param lstUtlObj : list of utl object
    * @param setOwnerId : set of owner id
    */
    public void insertCampaingRecord(List<UniversalTaskList__c> lstUtlObj, Set<Id> setOwnerId){
        List<UniversalTaskList__c> lstUtlTask = new List<UniversalTaskList__c> ();
        Map<Id,User> mapOfUserIdAndUser = new Map<Id,User>();
        
        mapOfUserIdAndUser = UserDomain.getUserIdAndUserRecord(setOwnerId);
        for(UniversalTaskList__c objUtl : lstUtlObj){
            
            String systemAction =   objUtl.SystemOfAction__c;
            List<String> lstTaskNotification = new List<String>();
            Set<String> setReceivedTaskNotificationFor = new Set<String>();
            if(mapOfUserIdAndUser.containsKey(objUtl.OwnerId) && 
                    mapOfUserIdAndUser.get(objUtl.OwnerId).ReceiveTaskNotificationsFor__c != null){
                String userTaskNotificationFor = 
                            mapOfUserIdAndUser.get(objUtl.OwnerId).ReceiveTaskNotificationsFor__c;
                lstTaskNotification = userTaskNotificationFor.split(';');
                setReceivedTaskNotificationFor.addAll(lstTaskNotification); 

            }
            
            if(setReceivedTaskNotificationFor.contains(systemAction)){
                
                lstUtlTask.add(objUtl);
            }
        }
        if(!lstUtlTask.isEmpty()){
            createCampaignAndMember(lstUtlTask);
        }
    }
    
    /**
    * @author : Amit Sharma
    * @description : This method is used to insert the campaign and campaign member record
    * @param lstUtlObj : list of utl object record
    */
    private void createCampaignAndMember(List<UniversalTaskList__c> lstUtlObj){
        
        List<Campaign> lstChildCampaign = new List<Campaign>();
        List<CampaignMember> lstCampaignMember = new List<CampaignMember> ();
        List<Sobject> lstObjToInsert = new List<Sobject>();
        
        Campaign primaryCampaign = CampaignDomain.getCampaignRecordByCode(
                            labelToContentMap.get('CAMPAIGNCODEUTLNOTIF')); 
        integer count = 0;
        Integer listSize = Integer.valueOf(labelToContentMap.get('UTLRECORDSLIMIT'));
        //Integer listSize = 2;
        count = lstUtlObj.size() / listSize;
        count += math.mod(lstUtlObj.size(),listSize)>0?1:0; 

        for(Integer i=0;i<count;i++){
            Campaign childCampaign = new Campaign();
            String uniqueId = 
                        String.Valueof(primaryCampaign.Id)+String.ValueOf(lstUtlObj[i].Id)+'_'+i;
            childCampaign = CampaignDomain.createCampaignRecord(
                                primaryCampaign.Name,primaryCampaign.Id,uniqueId);
            lstChildCampaign.add(childCampaign);
        }
        for(Integer i = 0 ; i < lstChildCampaign.size(); i++){
            for(Integer j=(i*listSize);(j<(i*listSize)+listSize) && j<lstUtlObj.size() ; j++){
                CampaignMember campaignMember   = 
                            new CampaignMember(Campaign = new Campaign(
                                                UniqueId__c = lstChildCampaign[i].UniqueId__c),
                                   ContactId = lstUtlObj[j].AssignedToAccount__r.PersonContactId,
                                   UniversalTask__c = lstUtlObj[j].id
                                  );
                lstCampaignMember.add(campaignMember);
            }
        }
                    
        lstObjToInsert.addAll(lstChildCampaign);
        lstObjToInsert.addAll(lstCampaignMember);
        
        Database.insert(lstObjToInsert,false);  
    }
    
    /**
    * @Author : Amit Sharma
    * @description : This method will Schedule the above batch.
    * @param sc
    */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(
                new SubmitterAndApproverReminderBatch());
    }
}