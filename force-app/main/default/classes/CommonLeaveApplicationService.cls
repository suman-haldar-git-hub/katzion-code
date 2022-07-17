/**
* @author : Praveen Tiwari
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of CommonLeaveApplicationFlowController
*/
public with sharing class CommonLeaveApplicationService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
	/**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for cashout leave Flow on load.
    * @return LightningResponse
    */
    public static LightningResponse getCashoutData(){
        LightningResponse objResp = new LightningResponse();
        CashoutWrapper cashoutWrap = new CashoutWrapper();
        Account objAccount = new Account();
        try{
            String emplId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeId__c;
            if(!String.isBlank(emplId)){
                objAccount = AccountDomain.queryAccountBasedOnEmpId(emplId);
            }
            if(objAccount.AnnualLeaveBalance__c != null
               &&
               objAccount.BaseHours__c != null)
            {
                cashoutWrap.baseHours = objAccount.BaseHours__c;
                cashoutWrap.cashoutLeaveHours =
                    (integer)(objAccount.AnnualLeaveBalance__c - (objAccount.BaseHours__c * 4));
            }
            Map<String, String> mapSelectedMetadata = new Map<String, String>();
            Set<String> setMetadataVals = new Set<String>{'ERRORMESSAGEFORPAYVALUE',
                                'PAYFREQUENCYERROR',
                                'SUCCESSFACTORCASHOUTLEAVE'
            };
            for(String metadataName: setMetadataVals)
            {
                mapSelectedMetadata.put(metadataName, labelToContentMap.get(metadataName));
            }
            cashoutWrap.communityContentMetadata = mapSelectedMetadata;
            if(!String.IsBlank(objAccount.PaymentFrequency__c)){
                cashoutWrap.payFrequency = objAccount.PaymentFrequency__c;
            }
            cashoutWrap.isEligible = LeaveRequestService.checksToDisplayCashIn(objAccount);
            objResp.payload = JSON.serialize(cashoutWrap);
        }
        catch(Exception ex){
            objResp.isError=true;
            objResp.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'CommonLeaveApplicationService.cls on getCashoutData',
                ex
            );
        }
        return objResp;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is used to fetch required data for purchase leave Flow on load.
    * @return LightningResponse
    */
    public static LightningResponse getPurchaseLeaveData(){
        LightningResponse objResp = new LightningResponse();
        PurchaseWrapper purchaseWrap = new PurchaseWrapper();
        Account objAccount = new Account();
        try{
            objAccount = LeaveService.getCurrentLeaves();
            Map<String, String> mapEligibilityToNoOfWeeks =
                            LeaveService.decidePurchaseLeaveVisibility(objAccount);
            if(mapEligibilityToNoOfWeeks.containsKey('Eligible')){
                purchaseWrap.isEligible = true;
                if(mapEligibilityToNoOfWeeks.get('Eligible') == '1 Week'){
                    purchaseWrap.hideTwoWeeksCard = true;
                }
            }
            purchaseWrap.requesterId = objAccount.id;
            purchaseWrap.approvalRecordTypeId =
                        RecordTypeDomain.getRecordTypeId('UniversalTaskList__c', 'Approval');
            if(!String.isBlank(objAccount.Line_Manager__c)){
                List<Account> lineManager = AccountDomain.getAccounts(objAccount.Line_Manager__c);
                if(lineManager.size() > 0){
                    purchaseWrap.lineManagerId = lineManager[0].Id;
                }
            }
            purchaseWrap.requestorName = objAccount.Name;
            Map<String, String> mapSelectedMetadata = new Map<String, String>();
            Set<String> setMetadataVals = new Set<String>{'TERMSANDCONDTIONERROR',
                                'ERRORMESSAGEFORPAYVALUE',
                                'PAYFREQUENCYERROR',
                                'LEAVEDURATIONERROR',
                                'PURCHASELEAVEDATECOMPARED',
                                'WEEKLY',
                                'FORTNIGHTLY',
                                'MONTHLY',
                                'PURCHASELEAVETANDCURL',
                                'SALARYSACRIFICEPOLICYURL',
                                'PURCHASELEAVETERMSANDCONDITIONS'
            };
            for(String metadataName: setMetadataVals)
            {
                mapSelectedMetadata.put(metadataName, labelToContentMap.get(metadataName));
            }
            purchaseWrap.communityContentMetadata = mapSelectedMetadata;
            objResp.payload = JSON.serialize(purchaseWrap);
        }
        catch(Exception ex){
            objResp.isError = true;
            objResp.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'CommonLeaveApplicationService.cls on getPurchaseLeaveData',
                ex
            );
        }
        return objResp;
    }
    /**
    * @author : Praveen Tiwari
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of Cashout Leave
    */
    public class CashoutWrapper{
        Decimal cashoutLeaveHours = 0;
        String payFrequency ='';
        Map<String, String> communityContentMetadata;
        Decimal baseHours = 0;
        Boolean isEligible = false;
    }
    /**
    * @author : Praveen Tiwari
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of Purchase Leave
    */
    public class PurchaseWrapper{
        Map<String, String> communityContentMetadata;
        Boolean isEligible = false;
        String approvalRecordTypeId ='';
        String lineManagerId ='';
        String requestorName ='';
        String requesterId ='';
        Boolean hideTwoWeeksCard = false;
    }
}