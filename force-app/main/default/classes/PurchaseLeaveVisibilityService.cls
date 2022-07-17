/**
* @Author : Ankit
* @Company : Cognizant
* @description : This Service Class is used to handle purchase Leave visibility
*/
public inherited sharing class PurchaseLeaveVisibilityService {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Ankit
    * @description :This method decide Purchase Or CashIn Leave Visibility
    * @return mapEligibilityToNoOfWeek
    * @param objAccount
    */
    public static Map<String, String> decidePurchaseLeaveVisibility(
        Account objAccount){
        //Map to store eligibility to number of weeks eligible for.
        Map<String, String> mapEligibilityToNoOfWeek = new Map<String, String>();
        mapEligibilityToNoOfWeek.put('Ineligible', '0 Week');
        Date todayDate = System.today();
        Datetime pastTwoMonthDate = System.now().addMonths(-2);
        String[] getDateComparedFromLabel = labelToContentMap.get('PURCHASELEAVEVISIBILITYDATECOMPAREDFROM').split('/');
        String[] getDateComparedToLabel = labelToContentMap.get('PURCHASELEAVEVISIBILITYDATECOMPAREDTO').split('/');
        List<String> leaveCategoryValues = new List<String>();
        if(labelToContentMap.get('ABSENCECATEGORYCODE') != null){
        	leaveCategoryValues = labelToContentMap.get('ABSENCECATEGORYCODE').split(',');
        }
        Date dateComparedFrom = Date.newInstance(
                todayDate.year(),
                Integer.valueOf(getDateComparedFromLabel[1]),
                Integer.valueOf(getDateComparedFromLabel[0])
        );
        Date dateComparedTo = Date.newInstance(
                todayDate.year(),
                Integer.valueOf(getDateComparedToLabel[1]),
                Integer.valueOf(getDateComparedToLabel[0])
        );
        Map<String, Date> dateComparedMap = new Map<String, Date>();
        dateComparedMap.put('todayDate', todayDate);
        dateComparedMap.put('dateComparedFrom', dateComparedFrom);
        dateComparedMap.put('dateComparedTo', dateComparedTo);
        Boolean isValidFirstLevel = false;
        Boolean isValidSecondLevel = true;
        Integer numberOfWeek = 0;
        // I have 0 LSL balance
        // I have <= 4 times the base hours of accrued Annual Leave as of today
        // I am a salaried employee (F or P)
        // I have not already resigned (Termination Date is null)
        // It is not between 26th of May to 30th June
        if(isValidPurchaseLeaveVisibility(dateComparedMap, objAccount)){
            isValidFirstLevel = true;
        }
        for (UniversalTaskList__c eachLeave : objAccount.SubmittedByAccount__r) {
            // I have no leave without pay in past 2 months
            if(leaveCategoryValues.contains(eachLeave.Category__c)){
                isValidSecondLevel =
                    !LeaveService.checkLWPInLastTwoMonth(eachLeave,pastTwoMonthDate);
            }
            //I have less than 2 weeks of purchased leave for this financial year
            if( eachLeave.Duration__c != null
                &&
                String.isNotBlank(eachLeave.Category__c)
                &&
                eachLeave.Category__c == labelToContentMap.get('PURCHASEDLEAVECODE')
                &&
                eachLeave.Status__c != labelToContentMap.get('REJECTEDSTATUS')
            ){
                numberOfWeek = numberOfWeek + (Integer)eachLeave.Duration__c;
            }
        }
        if(
                isValidFirstLevel
                &&
                isValidSecondLevel
                &&
                numberOfWeek < 2
        ) {
			String noOfWeeksEligibleFor = numberOfWeek == 0?'2 Weeks':'1 Week';
            mapEligibilityToNoOfWeek.put('Eligible', noOfWeeksEligibleFor);
        }
        return mapEligibilityToNoOfWeek;
    }
    /**
    * @Author : Praveen Tiwari
    * @description :This method checks if Annual Leave balance <= 4 times base hours
    * @return isValid
    * @param objAccount
    */
    public static Boolean isLessthanFourWeekOfAnnualLeave(
        Account objAccount
    ) {
        Boolean isValid = false;
        if(
                objAccount.BaseHours__c != null
                &&
                objAccount.AnnualLeaveBalance__c != null
                &&
                objAccount.AnnualLeaveBalance__c <= objAccount.BaseHours__c * 4
        ) {
            isValid = true;
        }
        return isValid;
    }

    /**
    * @Author : Ankit
    * @description :This method decide Purchase Or CashIn Leave Visibility
    * @return isValid
    * @param objAccount
    */
    public static Boolean isNotResignedSalariedEmployee(
        Account objAccount
    ) {
        Boolean isValid = false;
        if(
                String.isNotBlank(objAccount.Employee_Class__c)
                &&
                (
                    objAccount.Employee_Class__c == labelToContentMap.get('EMPLOYEEGROUPFULLTIME')
                    ||
                    objAccount.Employee_Class__c == labelToContentMap.get('EMPLOYEEGROUPPARTTIME')
                )
                &&
                objAccount.TerminationDate__c == null
        ) {
            isValid = true;
        }
        return isValid;
    }

    /**
    * @Author : Ankit
    * @description :This method decide Purchase Or CashIn Leave Visibility
    * @return isValid
    * @param objAccount
    */
    public static Boolean haveZeroLSLBalance(
        Account objAccount
    ) {
        Boolean isValid = false;
        if(
            objAccount.LongServiceLeaveBalance__c == null
            ||
            objAccount.LongServiceLeaveBalance__c == 0
        ) {
            isValid = true;
        }
        return isValid;
    }

    /**
    * @Author : Ankit
    * @description :This method decide Purchase Or CashIn Leave Visibility
    * @return isValid
    * @param todayDate
    * @param dateComparedFrom
    * @param dateComparedTo
    */
    public static Boolean excludeDateForPurchaseLeave(
        Date todayDate,
        Date dateComparedFrom,
        Date dateComparedTo
    ) {
        Boolean isValid = false;
        if(
                todayDate < dateComparedFrom
                ||
                todayDate > dateComparedTo
        ) {
            isValid = true;
        }
        return isValid;
    }

    /**
    * @Author : Ankit
    * @description :This method decide Purchase Or CashIn Leave Visibility
    * @return Boolean
    * @param dateComparedMap
    * @param objAccount
    */
    public static Boolean isValidPurchaseLeaveVisibility(
        Map<String, Date> dateComparedMap,
        Account objAccount
    ) {
        Boolean isValid = false;
        Date todayDate = dateComparedMap.get('todayDate');
        Date dateComparedFrom = dateComparedMap.get('dateComparedFrom');
        Date dateComparedTo = dateComparedMap.get('dateComparedTo');
        if(
                haveZeroLSLBalance(objAccount)
                &&
                excludeDateForPurchaseLeave(todayDate, dateComparedFrom, dateComparedTo)
            	&&
                isLessthanFourWeekOfAnnualLeave(objAccount)
                &&
                isNotResignedSalariedEmployee(objAccount)
        ) {
            isValid = true;
        }
        return isValid;
    }
}