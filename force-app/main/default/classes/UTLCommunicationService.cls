/**
 * @author : Amit Sharma
 * @company : Cognizant
 * @description : Service class for Universal Task List object.
*/
public with sharing class UTLCommunicationService {
    /**
    * @author : Amit Sharma
    * @description : This method is used to create child campaign record and
    * add its team member
    * @param utlIdSet
    * @param setOfOwnerId
    * @param labelToContentMap
    */
    public static void createChildCampaigRecord(
        Set<Id> utlIdSet,
        Set<Id> setOfOwnerId,
        Map<String, String> labelToContentMap
    ) {
        Map<Id,User> mapOfUserIdAndUser = new Map<Id,User>();
        List<UniversalTaskList__c> utlObjList = new List<UniversalTaskList__c>();
        Map<ID,UniversalTaskList__c> mapIdAndUtl = new Map<ID,UniversalTaskList__c>();
        Map<String,Id> mapUniqueAndUtlId = new Map<String,Id> ();
        List<Campaign> lstChildCampaign = new List<Campaign>();

        List<CampaignMember> lstCampaignMember = new List<CampaignMember> ();
        if(!utlIdSet.isEmpty()){
            mapOfUserIdAndUser = UserDomain.getUserIdAndUserRecord(setOfOwnerId);
            utlObjList = UniversalTaskListDomain.getUTLRecorcdBySetOfId(utlIdSet);
        }
        if(!utlObjList.isEmpty()){

            Campaign primaryCampaign = CampaignDomain.getCampaignRecordByCode(
                                labelToContentMap.get('CAMPAIGNCODEUTLNOTIF'));

            for(UniversalTaskList__c objUtl : utlObjList){
                if(isValidForSendingEmail(objUtl,mapOfUserIdAndUser)){
                    String uniqueId = String.valueOf(primaryCampaign.id)+String.valueOf(objUtl.id);
                    Campaign childCampaign = CampaignDomain.createCampaignRecord(
                                            primaryCampaign.Name,primaryCampaign.Id,uniqueId);
                    lstChildCampaign.add(childCampaign);
                    mapIdAndUtl.put(objUtl.Id,objUtl);
                    mapUniqueAndUtlId.put(childCampaign.UniqueId__c,objUtl.id);
                }
            }
        }
        if(!lstChildCampaign.isEmpty()){
            CampaignDomain.dmlOnCampaignRecd(lstChildCampaign,'insert');
            lstCampaignMember = CampaignMemberDomain.getCampaignMemberList(lstChildCampaign,
                                                        mapIdAndUtl,mapUniqueAndUtlId);
        }
        if(!lstCampaignMember.isEmpty()){
            CampaignMemberDomain.dmlOnCampaignMemberRecd( lstCampaignMember,'insert');
        }
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to check the campaign creation criteria
    * @return Boolean - true/false
    * @param objUtl - utl object
    * @param labelToContentMap - utl object
    */
    public static Boolean isValidForCampaignCreation (
        UniversalTaskList__c objUtl,
        Map<String, String> labelToContentMap
    ){
        if((objUtl.Title__c==labelToContentMap.get('CATSTITLE') &&
            objUtl.SystemOfAction__c == labelToContentMap.get('DEFAULTTASKTYPE')) ||
            (objUtl.SystemOfAction__c != labelToContentMap.get('CATSYSTEM') &&
            objUtl.SystemOfAction__c != labelToContentMap.get('DEFAULTTASKTYPE'))
        ){
            return true;
        }
        return false;
    }

    /**
    * @author : Amit Sharma
    * @description : This method is used to check the valid for sending email
    * @return Boolean - true/false
    * @param objUtl - utl object
    * @param mapOfUserIdAndUser - map of userId and user
    */
    public static Boolean isValidForSendingEmail(UniversalTaskList__c objUtl,
                                                            Map<Id, User> mapOfUserIdAndUser){
        List<String> lstTaskNotification = new List<String>();
        Set<String> setReceivedTaskNotificationFor = new Set<String>();
        String systemAction =   objUtl.SystemOfAction__c;
        if(mapOfUserIdAndUser != null && mapOfUserIdAndUser.containsKey(objUtl.OwnerId) &&
            mapOfUserIdAndUser.get(objUtl.OwnerId).ReceiveTaskNotificationsFor__c != null){
            String userTaskNotificationFor =
                mapOfUserIdAndUser.get(objUtl.OwnerId).ReceiveTaskNotificationsFor__c;
            lstTaskNotification = userTaskNotificationFor.split(';');
            setReceivedTaskNotificationFor.addAll(lstTaskNotification);
        }
        if(setReceivedTaskNotificationFor.contains(systemAction)){
            return true;
        }
        return false;
    }
    /**
    * @Author : Harshad Dani
    * @description :This method used to update completed date
    * @param objUniversalTask
    * @param labelToContentMap
    * @param lstOfStatuses
    */
    public static void updateCompletedDate(UniversalTaskList__c objUniversalTask,
        Map<String, String> labelToContentMap,
        List<String> lstOfStatuses)
    {
        UniversalTaskServiceHelper.checkAssignmentType(objUniversalTask);
        if(
            objUniversalTask.Status__c == labelToContentMap.get('UNSUBMITTEDSTATUS')
            ||
            objUniversalTask.Status__c == labelToContentMap.get('SUBMITTEDSTATUS')
            ||
            (
                objUniversalTask.Status__c == labelToContentMap.get('REJECTEDSTATUS')
                &&
                objUniversalTask.THStatus__c != labelToContentMap.get('REJECTEDSTATUS')
            )
        ){
            objUniversalTask.CompletedDate__c = null;
        }
        else if(
            lstOfStatuses.contains(objUniversalTask.Status__c)
            &&
            objUniversalTask.CompletedDate__c == NULL
        ) {
            objUniversalTask.CompletedDate__c = System.Now();
        }
    }
    /**
    * @author : Sunil Kumar
    * @description : This method is used to return list of custom metadata
    * @return : List<FeatureControl__mdt>
    */
    public static Map<String,String> getContentFromMetadata(){
        Map<String,String> mapMetadata = new Map<String,String>();
        Set<String> setDeveloperName = new Set<String> {'UTLORIGINATINGSYSTEMSAPPY',
        'UTLTYPELEAVE','UTLRECORDTYPEAPPROVAL','LONGSERVICELEAVECATEGORY'};
        for(FeatureControl__mdt obj : 
            FeatureControlDomain.getFeatureControlRecord(setDeveloperName)){
            mapMetadata.put(obj.MasterLabel, obj.Content__c);
        }
        
        return mapMetadata;
    }
    /**
    * @author : Sunil Kumar
    * @description : This method is used to validate the input string and return blank if value is null
    * @return : String
    * @param inputStr
    */
    public static String validateString(String inputStr){
        String returnStr = '';
        returnStr = inputStr!=null?inputStr:returnStr;
        return returnStr;
    }
    /**
    * @author : Sunil Kumar
    * @description : This method is used to validate the input string Category
    * @return : String
    * @param setCat
    * @param objUtl
    */
    public static String validateCategory(set<String> setCat, UniversalTaskList__c objUtl){
        return setCat.contains(objUtl.Category__c)?
               validateString(String.valueOf(objUtl.DurationInDays__c)):
               validateString(String.valueOf(objUtl.Duration__c));
    }
    /**
    * @Author: Harshad Dani
    * @description :This method used to delete UTL records from Primary source
    * @param setOfExpense8Id
    */
    public static void deletePrimarySourceUTLRecords(
        Set<String> setOfExpense8Id
    ) {
        List<UniversalTaskList__c> listUtlRecord = new List<UniversalTaskList__c>();
        if(!setOfExpense8Id.isEmpty()) {
            listUtlRecord = UniversalTaskListDomain.getUTLRecordFromPrimarySourceId(
                    setOfExpense8Id
            );
        }
        if(!listUtlRecord.isEmpty()) {
            Database.delete(listUtlRecord);
        }
    }

    /**
    * @Author: Harshad Dani
    * @description :This method used get Set Of UTL Category
    * @param mapMetadata
    * @param setOfUTLCategory
    * @return setOfUTLCategory
    */
    public static Set<String> getSetOfUTLCategory(
        Map<String,String> mapMetadata,
        Set<String> setOfUTLCategory
    ) {
        if(
            mapMetadata.containsKey('LONGSERVICELEAVECATEGORY')
            &&
            mapMetadata.get('LONGSERVICELEAVECATEGORY') != null) {
            setOfUTLCategory.addAll(mapMetadata.get('LONGSERVICELEAVECATEGORY').split(';'));
        }
        return setOfUTLCategory;
    }
}
