/**
* @author : Sunil
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of SalarySacrificeContainer component
*/
public with sharing class SalarySacrificeContainerService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Sunil
    * @description : This method is used to fetch Form__c data on load.
    * @param isDesktop
    * @param isMobile
    * @return : LightningResponse
    */
    @AuraEnabled
    public static LightningResponse getFormData(Boolean isDesktop, Boolean isMobile) {
        LightningResponse response = new LightningResponse();
        List<Form__c> lstSalForm = new List<Form__c>();
        List<Form__c> lstDisableSalForm = new List<Form__c>();
        List<Form__c> lstActionForm = new List<Form__c>();
        List<Form__c> lstCaseForm = new List<Form__c>();
        Map<String,List<Form__c>> mapSalForms = new Map<String,List<Form__c>>();
        Map<String,List<Form__c>> mapActForms = new Map<String,List<Form__c>>();
        Map<String,List<Form__c>> mapCaseForms = new Map<String,List<Form__c>>();
        try{
            FormWrapper objWrap = new FormWrapper();
            List<String> contractorEmp = (labelToContentMap.get('CONTRACTOREMPLOYEE')).split(',');
            List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
            Integer noOfSalariedTM = 0;
            User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
            List<Account> acctList = new List<Account>();
            if(String.isNotBlank(userDetail.EmployeeID__c)){
                acctList = AccountDomain.queryAccountWithTransactionCase(userDetail.EmployeeID__c);//,
                //labelToContentMap.get('RECORDTYPELEAVEWITHOUTPAY'));
            }
            Boolean isEligibleForSalSac = false;
            if(!acctList.isEmpty()){
                isEligibleForSalSac = checkForSalarySacrificeEligibility(acctList[0], salariedEmp);
                noOfSalariedTM = AccountDomain.queryAcctListFromEmpId
                    (acctList[0].Employee_ID__c, salariedEmp).size();
            }
            Set<String> formTypes = new Set<String>();
            formTypes.add(labelToContentMap.get('FORMTYPEACTIONCENTRE'));
            formTypes.add(labelToContentMap.get('FORMTABSALARYSACRIFICE'));
            formTypes.add('Peopleservices');
            for(Form__c obj : FormDomain.getFormDataOnLoad(formTypes)){
                //Logic for Hiding tile on Desktop and Mobile
                if( 
                    (isDesktop && obj.DisplayOnDesktop__c == false) || 
                    (isMobile && obj.DisplayOnMobile__c == false)
                ) {
                    continue;
                }
                if(obj.FormType__c == labelToContentMap.get('FORMTYPEACTIONCENTRE')){
                    if(isEligibleForSalSac
                       ||
                       (
                           contractorEmp.contains(acctList[0].Employee_Class__c)
                           &&
                           noOfSalariedTM > 0
                           &&
                           obj.FormTab__c == 'Leave'
                       )
                       ||
                       obj.FormTab__c == 'PeopleServices'
                      ){
                          lstActionForm.add(obj);
                        }
                }
                else if(obj.FormType__c == 'SalarySacrifice'){
                    if(obj.FormTab__c == labelToContentMap.get('PURCHASELEAVEHEADER'))
                    {
                       obj = checkPurchaseLeaveVisibility(obj, acctList[0]); 
                    }
                    if(obj.FormTab__c == labelToContentMap.get('FORMTABMYDEVICE'))
                    {
                        obj = checkForDeviceEligibility(acctList[0],obj);
                    }
                    if(obj.StartDate__c != null && obj.EndDate__c != null)
                    {
                        obj = checkApplicationWindow(obj);
                    }
                    if(obj.ContentCSS__c == obj.ExhaustionofQuotaCSS__c){
                        lstDisableSalForm.add(obj);
                    }else{
                        lstSalForm.add(obj);
                    }
                }
                else if(obj.FormType__c == 'PeopleServices'){
                    lstCaseForm.add(obj);
                }
            }
            
            lstSalForm.addAll(lstDisableSalForm);
            FormWrapper objFormWrapper = new FormWrapper();
            createWrapper(createFormMap(lstSalForm), objFormWrapper.lstSalSac);
            createWrapper(createFormMap(lstActionForm), objFormWrapper.lstAct);
            createWrapper(createFormMap(lstCaseForm),objFormWrapper.lstCase); 
            response.isError = false;
            response.errorOrSuccessMessage = 'Success';
            response.payLoad = JSON.serialize(objFormWrapper);
        }
        catch (Exception ex) {
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'GenericMultiSelectLookupController.cls on fetchKnowledgeRecdTypes',
                ex
            );
        }
        return response;
    }
    
     /**
    * @author : Sunil
    * @description : This method check whether the Employee Group of Account is Salaried/Contractor.
    * @return : Boolean
    * @param objAcc
    * @param salariedEmp
    */
    public static Boolean checkForSalarySacrificeEligibility(Account objAcc,
                                                            List<String> salariedEmp)
    {
        Boolean isOnUnpaidLeave = false;
        for(UniversalTaskList__c utl: objAcc.SubmittedByAccount__r){
			if(labelToContentMap.get('ABSENCECATEGORYCODE').split(',').contains(utl.Category__c)){
                Date toLeaveDate = Date.newInstance(utl.ToDate__c.year(),
                                                    utl.ToDate__c.month(),
                                                    utl.ToDate__c.day()
                                                   );
                Date fromLeaveDate = Date.newInstance(utl.From__c.year(),
                                                    utl.From__c.month(),
                                                    utl.From__c.day()
                                                   );
                if(System.today() >= fromLeaveDate
                   &&
                   System.today() <= toLeaveDate
                   )
                {
                    isOnUnpaidLeave = true;
                }
            }
        }
        if(salariedEmp.contains(objAcc.Employee_Class__c)
           &&
           objAcc.TerminationDate__c == NULL
           &&
           !isOnUnpaidLeave
          ){
              return true;
          }
        return false;
    }
    /**
    * @author : Sunil
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of SalarySacrificeContainer component
    */
    public class FormWrapper{
        List<FormListWrapper> lstSalSac = new List<FormListWrapper>();
        List<FormListWrapper> lstAct = new List<FormListWrapper>();
        List<FormListWrapper> lstCase = new List<FormListWrapper>();
    }
    /**
    * @author : Sunil
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of SalarySacrificeContainer component
    */
    public class FormListWrapper{
        String category;
        Integer lstKey;
        List<Form__c> lstForm = new List<Form__c>();
    }
     /**
    * @author : Sunil
    * @description : This method check whether the Employee is Eligible for the device.
    * @return : Form__c
    * @param objAcc
    * @param objForm
    */
    public static Form__c checkForDeviceEligibility(Account objAcc, Form__c objForm){
        Integer maxDevices = Integer.valueOf(objForm.MaximumDeviceEligibility__c - objAcc.Cases.size());
        if(maxDevices > 0 && objForm.FormTab__c != labelToContentMap.get('PURCHASELEAVEHEADER')){
            String deviceLabel = (maxDevices == 1)? 'device' : 'devices';
            objForm.FormEligibilityHeader__c =
                objForm.FormEligibilityHeader__c.replace('[XX]',String.valueOf(maxDevices))
                +' '+deviceLabel;
        }
        else{
            Integer year = System.Today().Month()>=04?System.Today().Year()+1:System.Today().Year();
            objForm.FormEligibilityHeader__c = objForm.ExhaustionofQuotaText__c.replace('[XXXX]',String.valueOf(year));
            objForm.EligibilityHeaderCSS__c = objForm.ExhaustionofQuotaHeaderCSS__c;
            objForm.ContentCSS__c = objForm.ExhaustionofQuotaCSS__c;
            objForm.RedirectUrl__c = '';
            objForm.FormIconName__c = objForm.FormDisabledIconName__c;
            objForm.Active__c = False;
        }
        return objForm;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method checks if application falls within given window.
    * @return : Form__c
    * @param objForm
    */
    public static Form__c checkApplicationWindow(Form__c objForm){
        Datetime startDateTime = Datetime.newinstance(System.today().year(),
                                          objForm.StartDate__c.month(),
                                          objForm.StartDate__c.day()
                                         );
        Datetime endDateTime = Datetime.newinstance(System.today().year(),
                                          objForm.EndDate__c.month(),
                                          objForm.EndDate__c.day()
                                         );
        Datetime today = Datetime.newinstance(System.today().year(),
                                          System.today().month(),
                                          System.today().day()
                                         );
        String yearTwoDigit = today <= endDatetime? string.valueof(endDatetime.year()) :
                                                string.valueof(endDatetime.year() + 1);
        objForm.FormEligibilityHeader__c = 'Available in '+startDateTime.format('MMM')
                                            +'-'+endDateTime.format('MMM')+' '+yearTwoDigit;
        if(today < startDateTime || today > endDateTime){
            objForm.EligibilityHeaderCSS__c = objForm.ExhaustionofQuotaHeaderCSS__c;
            objForm.ContentCSS__c = objForm.ExhaustionofQuotaCSS__c;
            objForm.RedirectUrl__c = '';
            objForm.FormIconName__c = objForm.FormDisabledIconName__c;
            objForm.Active__c = False;
        }
        return objForm;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method checks if TM is eligible for Purchase Leave.
    * @return : Form__c
    * @param objForm
    * @param acc
    */
    public static Form__c checkPurchaseLeaveVisibility(Form__c objForm, Account acc){
        Map<String, String> mapEligibilityToNoOfWeeks =
        	PurchaseLeaveVisibilityService.decidePurchaseLeaveVisibility(acc);
        System.debug('==mapEligibilityToNoOfWeeks=='+mapEligibilityToNoOfWeeks);
        if(mapEligibilityToNoOfWeeks.containsKey('Eligible')){
            objForm.FormEligibilityHeader__c = objForm.FormEligibilityHeader__c != null?
                objForm.FormEligibilityHeader__c.replace
                ('[XXXX]',mapEligibilityToNoOfWeeks.get('Eligible')):'Eligible';
        }else{
            objForm.EligibilityHeaderCSS__c = objForm.ExhaustionofQuotaHeaderCSS__c;
            objForm.ContentCSS__c = objForm.ExhaustionofQuotaCSS__c;
            objForm.RedirectUrl__c = '';
            objForm.FormEligibilityHeader__c = objForm.ExhaustionofQuotaText__c != null?
                objForm.ExhaustionofQuotaText__c:'Not Eligibile';
            objForm.FormIconName__c = objForm.FormDisabledIconName__c;
            objForm.Active__c = False;
        }
        return objForm;
    }
     /**
    * @author : Sunil
    * @description : This method create the map of Form__c.
    * @return : Map<String,List<Form__c>>
    * @param lstForm
    */
    public static Map<String,List<Form__c>> createFormMap(List<Form__c> lstForm){
        Map<String,List<Form__c>> mapForm = new Map<String,List<Form__c>>();
        for(Form__c obj: lstForm){
                if(!mapForm.containsKey(obj.Category__c)){
                    mapForm.put(obj.Category__c, new List<Form__c>{obj});
                }
                else{
                    mapForm.get(obj.Category__c).add(obj);
                    
                }
                
            }
        return mapForm;
    }

     /**
    * @author : Sunil
    * @description : This method create the map of Form__c.
    * @param mapForm
    * @param formList
    */
    public static void createWrapper(Map<String,List<Form__c>> mapForm, 
                                List<SalarySacrificeContainerService.FormListWrapper> formList){
        Integer key = 0;
        for(String s:mapForm.keySet()){
                FormListWrapper obj = new FormListWrapper();
                obj.lstKey = key+1;
                obj.category = s;
                obj.lstForm = mapForm.get(s);
                formList.add(obj);
                key++;
            }
    }
}