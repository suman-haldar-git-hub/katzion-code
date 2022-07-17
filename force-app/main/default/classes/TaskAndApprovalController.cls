/**
* @author : Monika Bisht
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to display Task on Home Page
*/
public with sharing class TaskAndApprovalController {
     private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author :Monika Bisht
    * @description : This method return task
    * @return ResponseWrapper
    */
    @AuraEnabled
    public static ResponseWrapper getTask() {
        ResponseWrapper objResponse = new ResponseWrapper();
        objResponse.showTaskTab = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLTASKTAB')
        ).Active__c;
        objResponse.showShareButton = FeatureControlDomain.getFeatureControlRecord(
                'EnableShareButton').Active__c;
        objResponse.showPrintButton = FeatureControlDomain.getFeatureControlRecord(
                'EnablePrintButton').Active__c;
        List<UniversalTaskList__c> taskList = new List<UniversalTaskList__c>();
            taskList = UniversalTaskListDomain.taskAndApproval();
            objResponse.labelAndContentWrapperMap = labelToContentMap;
            if(taskList.isEmpty()){
                objResponse.emptyTaskList = true;
            }
            integer count = 1;
            for(UniversalTaskList__c objUniversalTask : taskList){
                objResponse.taskCount = count;
                if( count <  Integer.valueOf(labelToContentMap.get('UTLTASKANDAPPROVALCOUNT'))){
                    RecordTypeWrapper objRecordWrapper = new RecordTypeWrapper();
                    objRecordWrapper.myTask = objUniversalTask;
                    if(objUniversalTask.RecordType.Name == 'Task'){
                        objRecordWrapper.taskOrApproval = true;
                    }
                    if(objUniversalTask.OriginatingSystem__c == labelToContentMap.get('UTLORIGINATINGSYSTEMTEAMHUB')){
                        objRecordWrapper.viewOrActionLabel = 'View';
                        objRecordWrapper.viewOrActionIcon = 'utility:expand_alt';
                        objRecordWrapper.actionURL = '/s/'+labelToContentMap.get('UTLLANDINGPAGENAME')+'/'+objUniversalTask.Id;
                    }else{
                        objRecordWrapper.actionURL = objUniversalTask.ActionUrl__c;
                    }
                    if(objUniversalTask.DueDate__c < System.today()){
                        objRecordWrapper.dueDateEarlierThenToday = true;
                    }
                    if(objUniversalTask.DueDate__c >= System.today() 
                    && objUniversalTask.DueDate__c <= objUniversalTask.NextTwoBusinessDaysF__c){
                        objRecordWrapper.dueDateTodayOrNextTwoBusDays = true;
                    }
                    objResponse.listTask.add(objRecordWrapper);
                }
                count++;
            }
        return objResponse;
    }
    /**
    * @author :Monika Bisht
    * @description : wrapper class
    */
    Public class ResponseWrapper{
        @AuraEnabled
        Public list<RecordTypeWrapper> listTask;
        @AuraEnabled
        Public integer taskCount;
        @AuraEnabled
        Public boolean emptyTaskList;
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
        @AuraEnabled
        Public UniversalTaskList__c singleTask;
        @AuraEnabled
        Public Boolean showTaskTab;
        @AuraEnabled
        Public Boolean showShareButton;
        @AuraEnabled
        Public Boolean showPrintButton;
        /**
        * @author :Monika Bisht
        * @description : wrapper class
        */
        Public ResponseWrapper(){
            listTask = new list<RecordTypeWrapper>();
            emptyTaskList = false;
            taskCount = 0;
            labelAndContentWrapperMap = new Map<string,string>();
            singleTask = new UniversalTaskList__c();
            showTaskTab = false;
        }
    }
    /**
    * @author :Monika Bisht
    * @description : wrapper class
    */
    Public class RecordTypeWrapper{
        @AuraEnabled
        Public UniversalTaskList__c myTask;
        @AuraEnabled
        Public boolean taskOrApproval;
        @AuraEnabled
        Public boolean dueDateEarlierThenToday;
        @AuraEnabled
        Public boolean dueDateTodayOrNextTwoBusDays;
        @AuraEnabled
        Public String viewOrActionLabel;
        @AuraEnabled
        Public String viewOrActionIcon;
        @AuraEnabled
        Public String actionURL;
        /**
        * @author :Monika Bisht
        * @description : wrapper class
        */
        Public RecordTypeWrapper(){
            myTask = new UniversalTaskList__c();
            taskOrApproval = false;
            dueDateEarlierThenToday = false;
            dueDateTodayOrNextTwoBusDays = false;
            viewOrActionLabel = 'Action';
            viewOrActionIcon = 'utility:new_window';
            actionURL='';
        }
    }
}