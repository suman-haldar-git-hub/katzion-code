/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Service Class is used to handle the Nudge creation of Task
*/
public with sharing class NotificationService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Ankit Singh
    * @description :This method return Task with Nudges RecordType For CurrentWeek
    * @return setOfEmployeeIdHasNudgeForCurrentWeek
    * @param setOfTeamEmployeeId
    */
    public static Set<String> getNudgesTaskForCurrentWeek(Set<String> setOfTeamEmployeeId) {
        List<UniversalTaskList__c> lstTask = new List<UniversalTaskList__c>();
        Map<String, Id> employeeIdToUserId = new Map<String, Id>();
        Set<Id> setOfOwnerId = new Set<Id>();
        Set<String> setOfEmployeeIdHasNudgeForCurrentWeek = new Set<String>();
        employeeIdToUserId = UserService.getEmployeeIdToUserId(setOfTeamEmployeeId);
        if(
                employeeIdToUserId != null
                &&
                !employeeIdToUserId.isEmpty()
                &&
                !employeeIdToUserId.values().isEmpty())
        {
            setOfOwnerId.addAll(employeeIdToUserId.values());
        }
        if(setOfOwnerId != null && !setOfOwnerId.isEmpty()) {
            lstTask = UniversalTaskListDomain.getNudgesTaskForCurrentWeek(setOfOwnerId);
        }
        setOfEmployeeIdHasNudgeForCurrentWeek = getEmployeeIdHasNudgeForCurrentWeek(
                lstTask,
                setOfEmployeeIdHasNudgeForCurrentWeek
        );
        return setOfEmployeeIdHasNudgeForCurrentWeek;
    }

    /**
    * @Author : Ankit Singh
    * @description :This method set of EmployeeId having nudge for Current Week
    * @return setOfEmployeeIdHasNudgeForCurrentWeek
    * @param lstTask
    * @param setOfEmployeeIdHasNudgeForCurrentWeek
    */
    public static Set<String> getEmployeeIdHasNudgeForCurrentWeek(
        List<UniversalTaskList__c> lstTask,
        Set<String> setOfEmployeeIdHasNudgeForCurrentWeek
    ) {
        if(lstTask != null && !lstTask.isEmpty()) {
            for(UniversalTaskList__c eachTask : lstTask) {
                if(eachTask.Owner instanceof User) {
                    User userOwner = eachTask.Owner;
                    if(String.isNotBlank(userOwner.EmployeeID__c)) {
                        setOfEmployeeIdHasNudgeForCurrentWeek.add(userOwner.EmployeeID__c);
                    }
                }
            }
        }
        return setOfEmployeeIdHasNudgeForCurrentWeek;
    }

    /**
    * @author :Ankit Singh
    * @description : This method set user profile image url in wrapper
    * @param param
    * @param message
    * @return response
    */
    @AuraEnabled
    public static LightningResponse createNudge(
        String param,
        String message
    ) {
        LightningResponse response = new LightningResponse();
        try{
            Map<String, Id> nudgeDataToId = new Map<String, Id>();
            if(String.isNotBlank(param)){
                nudgeDataToId = LeaveService.getNudgeData(param);
            }
            String emplId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeId__c;
            Id recordTypeId = Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByName().get('Task').getRecordTypeId();
            UniversalTaskList__c nudgeDetail = new UniversalTaskList__c();
            nudgeDetail.Type__c = 'Nudge';
            nudgeDetail.RecordTypeId = recordTypeId;
            nudgeDetail.OriginatingSystem__c = 'TeamHub';
            nudgeDetail.SystemOfAction__c = 'SuccessFactors';
            nudgeDetail.DeepLink__c = labelToContentMap.get('APPLYLEAVESUCCESSFACTORS');
            nudgeDetail.Status__c = labelToContentMap.get('TASKSTATUSINPROGRESS');
            nudgeDetail.DueDate__c = Date.today().addDays(14);
            nudgeDetail.Title__c = labelToContentMap.get('NUDGETITLE');
            nudgeDetail.ReceivedDate__c = Date.today();
            if(
                    nudgeDataToId != null
                    &&
                    !nudgeDataToId.isEmpty()
                    &&
                    nudgeDataToId.containsKey('employeeId')
            ) {
                //nudgeDetail.SubmittedForAccount__c  = nudgeDataToId.get('accountId');
                nudgeDetail.SubmittedForAccount__r = new Account(Employee_Id__c = emplId);
                nudgeDetail.OwnerId = nudgeDataToId.get('employeeId');
                nudgeDetail.AssignedToAccount__c = nudgeDataToId.get('accountId');
            }
            nudgeDetail.SubmittedByUser__c = UserInfo.getUserId();
            nudgeDetail.Description__c = message;
            Database.insert(nudgeDetail);
            response.isError=false;
            response.errorOrSuccessMessage = '';
        }
        catch(Exception e) {
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = e.getMessage();
            PublishLogEventService.publishExceptionEvent(
                    'NotificationService.cls on createNudge method',
                     e
            );
        }
        return response;
    }
}