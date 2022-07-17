/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to handle LeaveManagement.cmp
*/
public with sharing class LeaveManagementController {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    
    /**
    * @author :Ankit Singh
    * @description : This method get Leave Wrapper Data for onload of LeaveManagement.cmp
    * @return LightningResponse
    * @param isDesktop
    * @param isMobile
    */
    @AuraEnabled
    public static LightningResponse getLeaveWrapperData(
        Boolean isDesktop, 
        Boolean isMobile
    ) {
        LightningResponse response = new LightningResponse();
        try{
            LeaveWrapper objWrap = new LeaveWrapper();
            objWrap.labelAndContentWrapperMap = labelToContentMap;
            // get logged in user Account on the basis of Employee Id
            // Queried Account return all the child Leave.
            Account objAccount = new Account();
            objAccount = LeaveService.getCurrentLeaves();
            if(objAccount != null){
                objWrap.accLeaveData = objAccount;
                objWrap.accLeaveData.AnnualLeaveBalance__c =
                    objAccount.AnnualLeaveBalance__c != null? objAccount.AnnualLeaveBalance__c.setScale(2) : null;
                objWrap.accLeaveData.PersonalLeaveBalance__c =
                    objAccount.PersonalLeaveBalance__c != null? objAccount.PersonalLeaveBalance__c.setScale(2) : null;
                objWrap.accLeaveData.PurchasedLeaveBalance__c =
                    objAccount.PurchasedLeaveBalance__c != null? objAccount.PurchasedLeaveBalance__c.setScale(2) : null;
                objWrap.accLeaveData.LongServiceLeaveBalance__c =
                    objAccount.LongServiceLeaveBalance__c != null? objAccount.LongServiceLeaveBalance__c.setScale(2) : null;
                objWrap = decidePurchaseOrCashInLeaveVisibility(objWrap, objAccount);
            }
            objWrap.myTeamWrapper = MyTeamLeaveService.getLeaveRecords(
                Integer.valueOf(labelToContentMap.get('MYTEAMINITIALROWLIMIT'))
            );
            objWrap.leaveCardData = getLeaveFormData(objWrap, isDesktop, isMobile);
            response.payLoad = JSON.serialize(objWrap);
            response.isError=false;
            response.errorOrSuccessMessage = '';
        }
        catch(Exception e) {
            //log exception
            system.debug('exception----'+e);
            response.isError=true;
            response.errorOrSuccessMessage = e.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'PurchaseOrCashInLeaveMasterController.cls on Load',
                e
            );
        }
        return response;
    }
    
    /**
    * @author :Ankit Singh
    * @description : This method decide whether Purchase Leave will be Visibile or OrCash In Leave
    * section will be visiblt in portal
    * @param objWrap
    * @param objAccount
    * @return LeaveWrapper
    */
    @AuraEnabled
    public static LeaveWrapper decidePurchaseOrCashInLeaveVisibility(
        LeaveWrapper objWrap,
        Account objAccount
    ) {
        String doughnutChartData;
        //Added by Praveen
        List<String> contractorEmp = (labelToContentMap.get('CONTRACTOREMPLOYEE')).split(',');
        List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
        Boolean isSalariedDirectReport =
                    BaseCommunityLayoutService.checkSalariedDirectReportToUser
                    (
                        objAccount.Employee_ID__c, salariedEmp
                    );
        if(salariedEmp.contains(objAccount.Employee_Class__c)){
            objWrap.showMyLeave = true;
            objWrap.showApplyLeave = true;
        }
        if(isSalariedDirectReport){
            objWrap.showMyTeam = true;
        }
        //End of Added by Praveen
        doughnutChartData = LeaveRequestService.createDoughnutChartData(objAccount);
        Map<String, String> mapEligibilityToNoOfWeeks =
                    LeaveService.decidePurchaseLeaveVisibility(objAccount);
        if(mapEligibilityToNoOfWeeks.containsKey('Eligible')){
            objWrap.showPurchaseLeave = true;
            objWrap.noOfPlEligibleFor = mapEligibilityToNoOfWeeks.get('Eligible');
        }
        objWrap.showCashInLeave = LeaveRequestService.checksToDisplayCashIn(objAccount);
        objWrap.donutChartData = doughnutChartData;
        return objWrap;
    }
    /**
    * @Author : Praveen Tiwari
    * @Company : Cognizant
    * @description : This method get form object records for Leave cards.
    * @return formData
    * @param objWrap
    * @param isDesktop
    * @param isMobile
    */
    public static List<Form__c> getLeaveFormData(
        LeaveWrapper objWrap, 
        Boolean isDesktop, 
        Boolean isMobile
    ){
        List<Form__c> formData = new List<Form__c>();
        Set<String> formTypes = new Set<String>();
        formTypes.add(labelToContentMap.get('LEAVELABEL'));
        for(Form__c objForm: FormDomain.getFormDataOnLoad(formTypes)){
            //Logic for Hiding tile on Desktop and Mobile
            if( 
                (isDesktop && objForm.DisplayOnDesktop__c == false) || 
                (isMobile && objForm.DisplayOnMobile__c == false)
            ) {
                continue;
            }
            if((objForm.FormTab__c == labelToContentMap.get('CASHOUTLEAVE')
                && !objWrap.showCashInLeave)
                ||
                (objForm.FormTab__c == labelToContentMap.get('PURCHASELEAVEHEADER')
                && !objWrap.showPurchaseLeave)
              ){
                  objForm.EligibilityHeaderCSS__c = objForm.ExhaustionofQuotaHeaderCSS__c;
                  objForm.ContentCSS__c = objForm.ExhaustionofQuotaCSS__c;
                  objForm.RedirectUrl__c = '';
                  objForm.FormEligibilityHeader__c = objForm.ExhaustionofQuotaText__c != null?
                                    objForm.ExhaustionofQuotaText__c:'Not Eligible';
                  objForm.FormIconName__c = objForm.FormDisabledIconName__c;
                  objForm.Active__c = False;
              }else if(objForm.FormTab__c == labelToContentMap.get('PURCHASELEAVEHEADER')){
                  objForm.FormEligibilityHeader__c = objForm.FormEligibilityHeader__c != null?
                      objForm.FormEligibilityHeader__c.replace('[XXXX]', objWrap.noOfPlEligibleFor):
                  	'Eligible';
              }
            formData.add(objForm);
        }
        return formData;
    }
}