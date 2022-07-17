/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : 1. This batch class is used to Auto Complete EC Alert Category UTL.
*                2. Enhanced this batch as a part of TH-4076 to autocomplete task for
*                   Compensation Default Category
*/
global class AutoCompleteECAlertCategoryUTL implements Database.batchable<sobject>,
    Schedulable, Database.Stateful {
    private Boolean isUtlFeatureEnabled = false;
    private Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    private FeatureControl__mdt profileDetail = new FeatureControl__mdt();

    /**
    * @author : Ankit Singh
    * @description : This method get all the UniversalTaskList__c record which is of EC Alert Category
    * Type and Orginating System as SuccessFactor.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<FeatureControl__mdt> lstFeatureControl = new List<FeatureControl__mdt>();
        lstFeatureControl = FeatureControlDomain.getFeatureControlRecord(
                new Set<String> {'INTEGRATIONUSERID', labelToContentMap.get('FEATURECONTROLBATCHES')}
        );
        if(lstFeatureControl != null && !lstFeatureControl.isEmpty()) {
            for(FeatureControl__mdt eachFeatureControl : lstFeatureControl) {
                if(eachFeatureControl.MasterLabel == 'INTEGRATIONUSERID') {
                    profileDetail = eachFeatureControl;
                } else if (
                    eachFeatureControl.MasterLabel == labelToContentMap.get(
                            'FEATURECONTROLBATCHES')
                ) {
                    isUtlFeatureEnabled = eachFeatureControl.EnableUTLBatches__c;
                }
            }
        }
        String[] alertTypeSet = (labelToContentMap.get('ALERTTYPEUTL')).split(',');
        //As a part of TH-4076, adding one more category
        alertTypeSet.add(labelToContentMap.get('COMPENSATIONCATEGORY'));
        return Database.getQueryLocator(
            [
                SELECT Id, ExpiryDate__c, Status__c, OwnerId, Owner.ProfileId
                FROM UniversalTaskList__c
                WHERE OriginatingSystem__c =: labelToContentMap.get('ORIGINATINGSYSTEMSUCCESSFACTOR')
                AND Type__c =: alertTypeSet
                AND ExpiryDate__c <= TODAY
                AND Status__c !=: labelToContentMap.get('UTLSTATUSCOMPLETED')
            ]
        );
    }

    /**
    * @author : Ankit Singh
    * @description : This method update status as Complete of UniversalTaskList__c record.
    * @param info
    * @param scope
    */
    global void execute(Database.BatchableContext info, List<UniversalTaskList__c> scope) {
        try{
            List<UniversalTaskList__c> lstUtlToDelete = new List<UniversalTaskList__c>();
            List<UniversalTaskList__c> lstUtlToUpdate = new List<UniversalTaskList__c>();
            if(isUtlFeatureEnabled) {
                for(UniversalTaskList__c eachUtl : scope) {
                    if(profileDetail!=null
                    &&
                    ((profileDetail.ModuleName__c == 'USER_BASED'
                    &&
                    profileDetail.EligibleProfileForUTLCreation__c.split(';').contains(eachUtl.OwnerId)
                    )
                    ||
                    (profileDetail.ModuleName__c == 'PROFILE_BASED'
                    &&
                    profileDetail.EligibleProfileForUTLCreation__c.split(';').contains(eachUtl.Owner.ProfileId)
                    )
                    )){
                        lstUtlToDelete.add(eachUtl);
                    }
                    else{
                        eachUtl.Status__c = labelToContentMap.get('UTLSTATUSCOMPLETED');
                        eachUtl.CompletedDate__c = System.now();
                        lstUtlToUpdate.add(eachUtl);
                        }
                }
            }
            Database.update(lstUtlToUpdate);
            Database.delete(lstUtlToDelete);
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent
            ('AutoCompleteECAlertCategoryUTL.cls on execute',ex);}
    }

    /**
    * @author : Ankit Singh
    * @description : This method is user to perform any task post execution
    * @param info
    */
    global void finish(Database.BatchableContext info) {
        System.debug('*****' + info);
    }

    /**
    * @Author : Ankit Singh
    * @description : This method will Schedule the batch.
    * @param sc
    */
    global void execute(SchedulableContext sc){
        Database.executeBatch(new AutoCompleteECAlertCategoryUTL(),
            Integer.valueOf(labelToContentMap.get('AUTOCOMPLETEUTLBATCHSIZE'))
        );
    }
}