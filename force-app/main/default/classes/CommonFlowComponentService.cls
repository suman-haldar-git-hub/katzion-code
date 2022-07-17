/**
* @author : Sunil
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of CommonFlowComponent
*/
public without sharing class CommonFlowComponentService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Sunil
    * @description : This method is used to fetch required data for Device Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getDeviceData() {
        LightningResponse objRep = new LightningResponse();
        List<Account> lstAcc = new List<Account>();
        deviceWrapper objWrap = new deviceWrapper();
        Map<String, String> mapcomContentMetadata = new Map<String, String>();
        try{
            Set<String> setMetadataVals = new Set<String>{
                'LAPTOPDEVICE',
                    'TABLETDEVICE',
                    'MOBILEPHONEDEVICE',
                    'SMARTWATCHDEVICE',
                    'SALARYSACRIFICETERMSANDCONDITIONS',
                    'SALARYSACRIFICETANDCURL',
                    'SALARYSACRIFICEPOLICYURL',
                    'PAYFREQUENCYERROR',
                    'INVOICEUPLOADERROR',
                    'TERMSANDCONDTIONERROR',
                    'PURCHASEDETAILSMANDATORYERROR',
                    'FUTUREPURCHASEDATEERROR',
                    'AMOUNTLESSTHANZEROERROR'
            };
            //Fetching Community Content Metadata to be passed in flow.
            for(String metadataName: setMetadataVals)
            {
                mapcomContentMetadata.put(metadataName, labelToContentMap.get(metadataName));
            }
            String emplId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeID__c;
            lstAcc = AccountDomain.queryAccountWithTransactionCase(emplId);
            for(Case eachCase: lstAcc[0].Cases){
                if(eachCase.TypeofDevice__c == labelToContentMap.get('LAPTOPDEVICE') ||
                    eachCase.TypeofDevice__c == labelToContentMap.get('TABLETDEVICE'))
                {
                        objWrap.isLaptopOrTabletApplied = true;
                        objWrap.appliedCaseId = eachCase.Id;
                }else if(eachCase.TypeofDevice__c == labelToContentMap.get('SMARTWATCHDEVICE') ||
                            eachCase.TypeofDevice__c == labelToContentMap.get('MOBILEPHONEDEVICE'))
                {
                    objWrap.isMobileOrWatchApplied = true;
                    objWrap.appliedCaseId = eachCase.Id;
                }
            }
            objWrap.communityContentMetadata = mapcomContentMetadata;
            objWrap.TransactionRecordTypeId =
                    RecordTypeDomain.getRecordTypeId('Case','Transaction');
            objWrap.TeamMemberId = lstAcc.size()>0?lstAcc[0].Id:null;
            List<Form__c> formLst = new List<Form__c>();
            Set<String> formTab = new Set<String>();
            formTab.add(labelToContentMap.get('FORMTABMYDEVICE'));
            formLst = FormDomain.getFormBasedOnFormTab(formTab);
            if(!formLst.isEmpty()){
                SalarySacrificeContainerService.checkForDeviceEligibility(lstAcc[0], formLst[0]);
                objWrap.isEligible = formLst[0].Active__c;
            }
            objWrap.PayrollServiceDeliveryQueueId =
                GroupDomain.getGroupId(
                FeatureControlDomain.getFeatureControlRecord('PAYROLLSERVICEDELIVERYQUEUE').Content__c);
            objRep.payload = JSON.Serialize(objWrap);
        }
        catch(Exception ex){
            //log exception
            objRep.isError=true;
            objRep.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'CommonFlowComponentService.cls on getDeviceData',
                ex
            );
        }
        return objRep;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for Incentive Flow on load.
    * @return LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getIncentiveData(){
        LightningResponse objRep = new LightningResponse();
        Set<String> setFeatureControl = new Set<String>{'CASECATEGORYPAYANDBASICS',
            'QUERYCASERECORDTYPENAME',
            'ADMINEMPLOYEEID',
            'PAYROLLOPERATIONQUEUEID',
            'MYINCENTIVECASEDESCRIPTION',
            'TEAMHUBORIGIN',
            'CASECATEGORYSUPERANNUATIONPROCESSING',
            'MYINCENTIVESUBJECT',
            'CASESTATUSOPEN'};
        Map<String,String> mapMetaData = new Map<String,String>();
        Map<String, String> mapcomContentMetadata = new Map<String, String>();
        List<Account> accList = new List<Account>();
        List<Account> indAccList = new List<Account>();
        List<Case> parentCase = new List<Case>();
        try{
            Set<String> setMetadataVals = new Set<String>{
                'MYINCENTIVETANDCURL',
                    'SALARYSACRIFICEPOLICYURL',
                    'PERCENTCONTRIEDITERROR',
                    'PERCENTCONTRINEWERROR',
                    'TERMSANDCONDTIONERROR',
                    'MYINCENTIVETERMSANDCONDITIONS'
            };
            //Fetching Community Content Metadata to be passed in flow.
            for(String metadataName: setMetadataVals)
            {
                mapcomContentMetadata.put(metadataName, labelToContentMap.get(metadataName));
            }
            //Fetching Feature Control Metadata.
            for(FeatureControl__mdt obj :FeatureControlDomain.getFeatureControlRecord(setFeatureControl)){
                mapMetaData.put(obj.MasterLabel, obj.Content__c);
            }
            String emplId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeID__c;
            accList = AccountDomain.getAccounts(mapMetaData.get('ADMINEMPLOYEEID'));
            IncentiveWrapper objWrap = new IncentiveWrapper();
            String queryCaseRecTypeId = RecordTypeDomain.getRecordTypeId(
                                            'Case',mapMetaData.get('QUERYCASERECORDTYPENAME'));
            objWrap.queryCaseRecordTypeId = queryCaseRecTypeId;
            String payrollQueueId = GroupDomain.getGroupId(mapMetaData.get('PAYROLLOPERATIONQUEUEID'));
            objWrap.payrollOperationQueueId = payrollQueueId;
            Date fromDate = Date.newInstance(System.Today().Year()-1,04,01);
            If(System.Today().Month()>=04){
                fromDate = Date.newInstance(System.Today().Year(),04,01);
            }
            If(accList.size() > 0){
                parentCase =
                CaseDomain.getMyIncentiveParentCase(accList[0].Id, fromDate, mapMetaData);
            }
            if(parentCase.size() > 0){
                objWrap.parentCaseId = parentCase[0].Id;
            }else{
                Case newCase = new Case();
                newCase.AccountId = accList[0].Id;
                newCase.Category__c = mapMetaData.get('CASECATEGORYPAYANDBASICS');
                newCase.Description = mapMetaData.get('MYINCENTIVECASEDESCRIPTION');
                newCase.Origin = mapMetaData.get('TEAMHUBORIGIN');
                newCase.OwnerId = payrollQueueId;
                newCase.RecordTypeId = queryCaseRecTypeId;
                newCase.Status = mapMetaData.get('CASESTATUSOPEN');
                newCase.Sub_Category__c = mapMetaData.get('CASECATEGORYSUPERANNUATIONPROCESSING');
                newCase.Subject = mapMetaData.get('MYINCENTIVESUBJECT');
                insert newCase;
                objWrap.parentCaseId = newCase.Id;
            }
            indAccList = AccountDomain.getIndAccountWithMyIncentiveCase(emplId, objWrap.parentCaseId,
                                                                            mapMetaData);
            objWrap.teamMemberId = indAccList.size() > 0 ? indAccList[0].Id : null;
            objWrap.communityContentMetadata = mapcomContentMetadata;
            objWrap.percentNomination = indAccList[0].Cases.size() > 0?
                indAccList[0].Cases[0].Nomination__c : null;
            if(indAccList[0].Cases.size() > 0){
                objWrap.percentNomination = indAccList[0].Cases[0].Nomination__c;
                objWrap.indCase = indAccList[0].Cases[0];
            }
            objWrap.isEligible = CommonFlowComponentServiceHelper.checkMyIncentiveApplicationWindow();
            objRep.payload = JSON.Serialize(objWrap);
        }
        catch(Exception ex){
            //log exception
            objRep.isError=true;
            objRep.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'CommonFlowComponentService.cls on getIncentiveData',
                ex
            );
        }
        return objRep;
    }
    /**
    * @author : Sunil
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of CommonFlowComponent
    */
    public class DeviceWrapper{
        String transactionRecordTypeId;
        String teamMemberId;
        String payrollServiceDeliveryQueueId;
        Boolean isMobileOrWatchApplied = false;
        Boolean isLaptopOrTabletApplied = false;
        String appliedCaseId = '';
        Map<String, String> communityContentMetadata;
        Boolean isEligible = false;
    }    
    /**
    * @author : Praveen Tiwari
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of Incentive Flow
    */
    public class IncentiveWrapper{
        String teamMemberId;
        String queryCaseRecordTypeId;
        String payrollOperationQueueId;
        String parentCaseId = '';
        Decimal percentNomination;
        Case indCase;
        Map<String, String> communityContentMetadata;
        Boolean isEligible = false;
    }
    /**
    * @author : Amit Sharma
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to return the Case details
    * @return  LightningResponse
    * @param caseId - case record id
    */
    public static LightningResponse getCaseRecordDetail(Id caseId) {
        LightningResponse objRep = new LightningResponse();
        IncentiveWrapper wrap = new IncentiveWrapper();
        List<Case> lstObjCaseRecord = new List<Case>();
        Set<Id> setCaseId = new Set<Id>();
        Map<String, String> mapSelectedMetadata = new Map<String, String>();
        Set<String> setMetadataVals = new Set<String>{
            'PLLEAVEFORMS',
                'PLLEAVES',
                'INVOICEDELETEMESSAGE',
                'PLPENDINGAPPMESSAGE',
                'PLAPPLICATIONPROCESSED',
                'SSPENDINGAPPROVAL',
                'PLAPPPROCESSEDMESSAGE',
                'PLAPPLICATIONREJECTED',
                'PLREJECTEDMESSAGE',
                'PLAPPLICATIONURL',
                'PLAPPLICATIONCLOSED',
                'PLAPPAUTOCLOSEDMESSAGE'
        };
        for(String metadataName: setMetadataVals)
        {
            mapSelectedMetadata.put(metadataName, labelToContentMap.get(metadataName));
        }
        setCaseId.add(caseId);
        if(caseId != null){
            lstObjCaseRecord = CaseDomain.getCaseRecordDetail(setCaseId);
        }
        if(lstObjCaseRecord[0].Sub_Category__c == labelToContentMap.get('PLLEAVEFORMS')
           ||
           lstObjCaseRecord[0].Sub_Category__c == labelToContentMap.get('PLLEAVES')
          )
        {
            wrap.isEligible = CommonFlowComponentServiceHelper.checkPurchaseLeaveWindow();
        }
        else{
            wrap.isEligible = CommonFlowComponentServiceHelper.checkMyIncentiveApplicationWindow();
        }
        wrap.indCase = lstObjCaseRecord[0];
        wrap.communityContentMetadata = mapSelectedMetadata;
        objRep.payload = JSON.serialize(wrap);
        return objRep;
    }
}