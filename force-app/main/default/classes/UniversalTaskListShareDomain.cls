/**
 * @author : Amit Sharma
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UniversalTaskListShareDomain {
    /**
    * @Author : Amit Sharma
    * @description :This method used to fire Universal Task List Platform Event
    * @param eachUtl
    * @param utlShareRecordList
    * @param labelToContentMap
    * @return utlShareRecordList
    */
    public static List<UniversalTaskList__Share> shareRecordWithSubmittedUser(
        UniversalTaskList__c eachUtl,
        List<UniversalTaskList__Share> utlShareRecordList,
        Map<String, String> labelToContentMap
    ) {
        try {
            if(eachUtl.SubmittedByUser__c != null) {
                UniversalTaskList__Share utlRecord = new UniversalTaskList__Share();
                utlRecord.ParentId = eachUtl.Id;
                utlRecord.UserOrGroupId = eachUtl.SubmittedByUser__c;
                utlRecord.AccessLevel = labelToContentMap.get('ACCESSLEVELREAD');
                utlRecord.RowCause =
                        Schema.UniversalTaskList__Share.RowCause.ApexBasedSharing__c;
                utlShareRecordList.add(utlRecord);
            }
            if(eachUtl.SubmittedForUser__c != null) {
                UniversalTaskList__Share utlRecordShare = new UniversalTaskList__Share();
                utlRecordShare.ParentId = eachUtl.Id;
                utlRecordShare.UserOrGroupId = eachUtl.SubmittedForUser__c;
                utlRecordShare.AccessLevel = labelToContentMap.get('ACCESSLEVELREAD');
                utlRecordShare.RowCause =
                        Schema.UniversalTaskList__Share.RowCause.ApexBasedSharing__c;
                utlShareRecordList.add(utlRecordShare);
            }
        } catch(Exception ex) {
            PublishLogEventService.publishExceptionEvent(
                'UniversalTaskListShareDomain class in shareRecordWithSubmittedUser method',
                ex
            );
        }
        return utlShareRecordList;
    }
}