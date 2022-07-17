/**
* @Author : Sunil
* @Company : Cognizant
* @description : This Service Class is used to handle data for Leave__c object
*/
public inherited sharing class LeaveService{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Sunil
    * @description :This method returns the Account details with Leave for Current User
    * @return Account
    */
    public static Account getCurrentLeaves() {
        Account accWithLeaveReq = new Account();
        String emplId = UserDomain.queryUserBasedOnId(UserInfo.getUserId()).EmployeeId__c;
        List<String> leaveCategoryValues = new List<String>();
        if(labelToContentMap.get('ABSENCECATEGORYCODE') != null){
            leaveCategoryValues = labelToContentMap.get('ABSENCECATEGORYCODE').split(',');
        }        leaveCategoryValues.add(labelToContentMap.get('PURCHASEDLEAVECODE'));
        if(!String.isBlank(emplId)){
            //getting Account records along with Purchase Leave and LWP records for current
            //financial year based on passed Employee_ID__c
            accWithLeaveReq = AccountDomain.queryAccountWithLeaves(EmplId, leaveCategoryValues);
        }
        return accWithLeaveReq;
    }

    /**
    * @Author : Ankit Singh
    * @description :This method returns Picklist field values
    * @return fieldLabelToFieldApi
    * @param objectName
    * @param fieldName
    */
    public static Map<String, String> getPicklistValues(
        String objectName,
        String fieldName
    ) {
        Map<String, String> fieldLabelToFieldApi = new Map<String, String>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple) {
            fieldLabelToFieldApi.put(pickListVal.getLabel(), (String)pickListVal.getValue());
        }
        return fieldLabelToFieldApi;
    }

    /**
    * @Author : Ankit
    * @description :This method decide Purchase Leave Visibility
    * @return decidePurchaseLeaveVisibility
    * @param objAccount
    */
    public static Map<String, String> decidePurchaseLeaveVisibility(
        Account objAccount) {
        return PurchaseLeaveVisibilityService.decidePurchaseLeaveVisibility(objAccount);
    }

    /**
    * @Author : Ankit Singh
    * @description :This method map of nudge data to Id
    * @return nudgeDataToId
    * @param param
    */
    public static Map<String, Id> getNudgeData(
        String param
    ) {
        Map<String, Id> nudgeDataToId = new Map<String, Id>();
        String[] nudgeData;
        List<Account> lstAccount = new List<Account>();
        List<User> lstUser = new List<User>();
        if(String.isNotBlank(param)){
            nudgeData = param.split('-:-');
        }
        if(nudgeData != null && nudgeData.size() == 3) {
            lstUser = UserDomain.getUserRecords(new Set<String>{nudgeData[2]});
            nudgeDataToId.put('accountId', nudgeData[0]);
            nudgeDataToId.put(
                    'employeeId',
                    lstUser[0].Id
            );
        }
        return nudgeDataToId;
    }

    /**
    * @Author : Ankit
    * @description :This method checks if there is LWP in last 2 months
    * @return isValid
    * @param eachLeave
    * @param pastTwoMonthDate
    */
    public static Boolean checkLWPInLastTwoMonth(
        UniversalTaskList__c eachLeave,
        Datetime pastTwoMonthDate
    ) {
        Boolean isValid = false;
        Date pastDate = date.newinstance(pastTwoMonthDate.year(),
                                         pastTwoMonthDate.month(),
                                         pastTwoMonthDate.day()
                                        );
        if(
                eachLeave.ToDate__c != null
                &&
                pastDate <= date.newinstance(eachLeave.ToDate__c.year(),
                        eachLeave.ToDate__c.month(), eachLeave.ToDate__c.day()
                )
        ) {
            isValid = true;
        }
        return isValid;
    }
}