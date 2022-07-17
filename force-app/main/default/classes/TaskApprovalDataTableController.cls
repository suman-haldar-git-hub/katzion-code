/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for lazy loading of article in home page
*/
public with sharing class TaskApprovalDataTableController {
    
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();

    /**
    * @author :Ankit Singh
    * @description : This method To return initial article records
    * @param requestParameters
    * @return TaskWrapper
    */
    @AuraEnabled
    public static TaskWrapper getTaskRecords(
        String requestParameters
    ) {        
        TaskWrapper taskWrapper= new TaskWrapper();
        try {            
            Set<String> setOfStatus = new Set<String>();
            RequestWrapper reqWrap = (RequestWrapper)JSON.deserialize(requestParameters, RequestWrapper.class);
            Map<String, String> paramsMap = new Map<String, String>();
            paramsMap.put('initialRows', String.valueOf(reqWrap.initialRows));
            paramsMap.put('filterType', reqWrap.filterType);
            paramsMap.put('columnSorting', reqWrap.columnSorting);
            paramsMap.put('approvalRecordType','true');
            paramsMap.put('taskRecordType','true');
            paramsMap.put('keyword', reqWrap.keyword);
            paramsMap.put('type', reqWrap.type);
            paramsMap.put('offset', String.valueOf(reqWrap.offset));             
            setOfStatus = getSetOfStatus(reqWrap.filterType);
            List<UniversalTaskList__c> lstutlrecords=UniversalTaskListFilterService.filterRecordsOnSearch(
                    paramsMap,
                    setOfStatus
                );
            taskWrapper.taskList = validateContract(lstutlrecords);
            paramsMap.put('countTotal', 'true');
            taskWrapper.totalRecords = UniversalTaskListFilterService.filterRecordsOnSearch(
                    paramsMap,
                    setOfStatus
                ).size();            
            taskWrapper.taskRecordCount = getTaskRecordCountByStatus(
                    taskWrapper.taskRecordCount,
                    UniversalTaskListDomain.getAllTaskForLoggedInUser()
                );            
            taskWrapper.message = '';
            taskWrapper.success = true;
            taskWrapper.labelAndContentWrapperMap = labelToContentMap;
            taskWrapper.loggedInUserId= (String) UserInfo.getUserId();            
        }
        catch(Exception ex) {
            taskWrapper.message = ex.getMessage();
            taskWrapper.success = false;
            PublishLogEventService.publishExceptionEvent(
                'TaskApprovalDataTableController.cls on load',
                ex
            );
        }
        return taskWrapper;
    }    

    /**
    * @author :Ankit Singh
    * @description : This method set of status for filter task query.
    * @param filterType
    * @return setOfStatus
    */
    public static Set<String> getSetOfStatus(
        String filterType
    ) {
        Set<String> setOfStatus = new Set<String>();
        String[] taskSatus;
        switch on filterType {
            when 'All', '' {
                taskSatus = labelToContentMap.get('STATUSALLTASK').split(',');
            }
            when 'My Task' {
                taskSatus = labelToContentMap.get('STATUSMYTASK').split(',');
            }
            when 'My Approval' {
                taskSatus = labelToContentMap.get('STATUSMYAPPROVAL').split(',');
            }
            when 'Archive' {
                taskSatus = labelToContentMap.get('STATUSARCHIVE').split(',');
            }
            when else {
                taskSatus = labelToContentMap.get('STATUSALLTASK').split(',');
            }
        }
        setOfStatus.addAll(taskSatus);
        return setOfStatus;
    }

    /**
    * @author :Ankit Singh
    * @description : This method get the all task count for each tab on Portal
    * @param taskRecordCount
    * @param taskList
    * @return taskRecordCount
    */
    public static String getTaskRecordCountByStatus(
        String taskRecordCount,
        List<UniversalTaskList__c> taskList
    ) {
        Integer allTab = 0;
        Integer myTaskTab = 0;
        Integer myApprovalTab = 0;
        Integer archiveTab = 0;
        Set<String> setOfAllStatus = new Set<String>();
        Set<String> setOfMyTaskStatus = new Set<String>();
        Set<String> setOfMyApprovalStatus = new Set<String>();
        Set<String> setOfArchiveStatus = new Set<String>();
        setOfAllStatus.addAll(labelToContentMap.get('STATUSALLTASK').split(','));
        setOfMyTaskStatus.addAll(labelToContentMap.get('STATUSMYTASK').split(','));
        setOfMyApprovalStatus.addAll(labelToContentMap.get('STATUSMYAPPROVAL').split(','));
        setOfArchiveStatus.addAll(labelToContentMap.get('STATUSARCHIVE').split(','));
        if(taskList != null && !taskList.isEmpty()) {
            for(UniversalTaskList__c eachtask : taskList) {
                if(setOfAllStatus.contains(eachtask.THStatus__c)) {
                    allTab++;
                }
                if(setOfMyTaskStatus.contains(eachtask.THStatus__c)) {
                    myTaskTab++;
                }
                if(setOfMyApprovalStatus.contains(eachtask.THStatus__c)) {
                    myApprovalTab++;
                }
                if(setOfArchiveStatus.contains(eachtask.THStatus__c)) {
                    archiveTab++;
                }
            }
        }
        return taskRecordCount = allTab +'-:-'+ myTaskTab +'-:-'+ myApprovalTab +'-:-'+ archiveTab;
    }

    /**
    * @author :Ankit Singh
    * @description : This method complete the task.
    * @param taskId
    * @return objResponse
    */
    @AuraEnabled
    public static LightningResponse completeTask(
        String taskId
    ) {
        LightningResponse objResponse = new LightningResponse();
        try{
            if(String.isNotBlank(taskId)) {
                UniversalTaskList__c utlObj = new UniversalTaskList__c(
                        id=taskId,
                        Status__c = labelToContentMap.get('UTLSTATUSCOMPLETED'),
                        CompletedDate__c = System.now()
                );
                Database.update(utlObj);
            }
            objResponse.isError = false;
            objResponse.errorOrSuccessMessage = '';
        } catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'TaskApprovalDataTableController.cls in completeTask',
                ex
            );
            objResponse.isError = true;
            objResponse.errorOrSuccessMessage = ex.getMessage();
        }
        return objResponse;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is to get UTL details required for Notification Landing page.
    * @param taskId
    * @return TaskAndApprovalController.ResponseWrapper
    */
    @AuraEnabled
    public static TaskAndApprovalController.ResponseWrapper getDetailsForUtlLanding(
        String taskId
    ) {
        TaskAndApprovalController.ResponseWrapper objResponse =
            new TaskAndApprovalController.ResponseWrapper();
        try{
            objResponse = TaskAndApprovalController.getTask();
            if(String.isNotBlank(taskId)) {
                objResponse.singleTask = UniversalTaskListDomain.getTaskBasedOnId(taskId);
            }
        } catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'TaskApprovalDataTableController.cls in getUTLRecordBasedOnId',
                ex
            );
        }
        return objResponse;
    }

    /**
    * @author :Ankit Singh
    * @description : wrapper class
    */
    public class TaskWrapper {
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
        @AuraEnabled
        public String taskRecordCount = '';
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
        @AuraEnabled
        public String loggedInUserId;
        @AuraEnabled
        public List<Case> caseList = new List<Case>();
    }

    /**
    * @author :Abhishek Setia
    * @description : Request parameter wrapper class
    */
    public class RequestWrapper{
        public Integer initialRows;
        public String filterType;
        public String columnSorting;
        public String keyword;
        public String type;
        public Integer offset=0;
    }

    /**
    * @author :Sunil
    * @description : This method To validate the category 'CONTRACT' and type 'UTL'
    * @param lstTask
    * @return List<UniversalTaskList__c>
    */
    @AuraEnabled
    public static List<UniversalTaskList__c> validateContract(List<UniversalTaskList__c> lstTask) {
        for(UniversalTaskList__c objTask : lstTask){
            if(objTask.Category__c == labelToContentMap.get('CATEGORYCONTRACT') && 
                objTask.Type__c == labelToContentMap.get('TYPEUTL')){
                objTask.SubmittedForAccount__r.Name = objTask.SubmittedByAccount__r.Name;
            }
        }
        return lstTask;
    }
}