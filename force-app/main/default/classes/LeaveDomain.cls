/**
* @Author : Sunil
* @Company : Cognizant
* @description : This Domain Class is used to query and insert data for Leave__c object
*/
public inherited sharing class LeaveDomain {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Sunil
    * @description :This method returns the Leave__c details for MyLeaveRequests
    * @return List<Leave__c>
    * @param accountId
    */
    public static List<Leave__c> getMyLeaveRequests(String accountId) {
        return [
            SELECT Id, LeaveFrom__c, LeaveTo__c, Status__c, LeaveDuration__c,
            UnitOfLeave__c, RecordType.Name, SubmittedBy__c
            FROM Leave__c
            WHERE SubmittedBy__c =: accountId
        ];
    }

    /**
    * @Author : Ankit Singh
    * @description :This method returns the Leave record with max value of Annual Leave balance for
    * Leave Balance Record Type
    * @return lstLeave
    * @param lineManager
    */
    public static List<Leave__c> getMaxAnnualLeaveBalanceRecord(String lineManager) {
        List<Leave__c> lstLeave = new List<Leave__c>();
        lstLeave = [
            SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c
            FROM Leave__c
            WHERE SubmittedBy__c != null
            AND SubmittedBy__r.Line_Manager__c =: lineManager
            AND RecordType.Name =: labelToContentMap.get('RECORDTYPELEAVEBALANCE')
            ORDER BY AnnualLeaveBal__c DESC
            Limit 1
        ];
        return lstLeave;
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used to query Leave object with Leave Balance Record type
    * based on passed Employee_ID__c.
    * @return : lstLeave
    * @param initialRows
    * @param lineManager
    */
    public static List<Leave__c> queryLeaveWithLineManager(
        Integer initialRows,
        String lineManager
    ) {
        List<Leave__c> lstLeave = new List<Leave__c>();
        lstLeave = [
                SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c,
                SubmittedBy__r.Name, SubmittedBy__r.Line_Manager__c, AboveNormalLeave__c,
                SubmittedBy__r.BaseHours__c, CreatedDate, SubmittedBy__r.Employee_ID__c,
                SubmittedBy__r.FirstName, SubmittedBy__r.LastName
                FROM Leave__c
                WHERE RecordType.Name =: labelToContentMap.get('RECORDTYPELEAVEBALANCE')
                AND SubmittedBy__c != null
                AND SubmittedBy__r.Employee_ID__c != null
                AND SubmittedBy__r.Line_Manager__c =:lineManager
                ORDER BY AboveNormalLeave__c DESC
                LIMIT :initialRows OFFSET 0
        ];
        return lstLeave;
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used to query Leave object with Leave Balance Record type
    * based on passed Employee_ID__c.
    * @return : lstLeave
    * @param rowLimit
    * @param rowOffset
    * @param lineManager
    */
    public static List<Leave__c> queryLeaveWithLineManagerUsingOffset(
        Integer rowLimit,
        Integer rowOffset,
        String lineManager
    ) {
        List<Leave__c> lstLeave = new List<Leave__c>();
        lstLeave = [
                SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c,
                SubmittedBy__r.Name, SubmittedBy__r.Line_Manager__c, AboveNormalLeave__c,
                SubmittedBy__r.BaseHours__c, CreatedDate, SubmittedBy__r.Employee_ID__c,
                SubmittedBy__r.FirstName, SubmittedBy__r.LastName
                FROM Leave__c
                WHERE RecordType.Name =: labelToContentMap.get('RECORDTYPELEAVEBALANCE')
                AND SubmittedBy__c != null
                AND SubmittedBy__r.Employee_ID__c != null
                AND SubmittedBy__r.Line_Manager__c =:lineManager
                ORDER BY AboveNormalLeave__c DESC
                LIMIT :rowLimit OFFSET :rowOffset
        ];
        return lstLeave;
    }

    /**
    * @author : Ankit Singh
    * @description :This method returns total record count of Leave with specific Line Manager.
    * @return : totalRecord
    * @param lineManager
    */
    public static Integer getTotalCountOfLeave(String lineManager) {
        Integer totalRecord = [
                SELECT COUNT()
                FROM Leave__c
                WHERE RecordType.Name =: labelToContentMap.get('RECORDTYPELEAVEBALANCE')
                AND SubmittedBy__c != null
                AND SubmittedBy__r.Employee_ID__c != null
                AND SubmittedBy__r.Line_Manager__c =:lineManager
        ];
        return totalRecord;
    }

     /**
    * @author : Sunil Kumar
    * @description : This method is used to query Leave object with Leave Without Pay Record type
    * based on passed Employee_ID__c.
    * @return : lstLeave
    * @param setOfTeamEmployeeId
    */
    public static List<Leave__c> queryLWPSubmittedBy(
        Set<String> setOfTeamEmployeeId
    ) {
        List<Leave__c> lstLeave = new List<Leave__c>();
        lstLeave = [
                SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c,
                SubmittedBy__r.Name, SubmittedBy__r.Line_Manager__c, AboveNormalLeave__c,
                SubmittedBy__r.BaseHours__c, CreatedDate, SubmittedBy__r.Employee_ID__c,
                SubmittedBy__r.FirstName, SubmittedBy__r.LastName
                FROM Leave__c
                WHERE RecordType.Name =: labelToContentMap.get('RECORDTYPELEAVEWITHOUTPAY')
                AND (LeaveFrom__c = THIS_MONTH OR LeaveFrom__c = LAST_N_MONTHS:2)
                AND SubmittedBy__c != null
                AND SubmittedBy__r.Employee_ID__c != null
                AND SubmittedBy__r.Employee_ID__c IN: setOfTeamEmployeeId
                AND Status__c =: labelToContentMap.get('APPROVED')
        ];
        return lstLeave;
    }
     /**
    * @author : Sunil Kumar
    * @description : This method is used to query Leave object with Leave Without Pay Record type
    * based on passed Employee_ID__c.
    * @return : lstLeave
    * @param objWrap
    */
    public static List<Leave__c> queryLeaveForRecTypeAndCreatedDate(
        LeaveRequestService.ExcessPurchaseWrapper objWrap
    ) {
        List<Leave__c> lstLeave = new List<Leave__c>();
        lstLeave = [
                SELECT Id, AnnualLeaveBal__c, RecordType.Name, SubmittedBy__c,
                SubmittedBy__r.Name, SubmittedBy__r.Line_Manager__c, AboveNormalLeave__c,
                SubmittedBy__r.BaseHours__c, CreatedDate, SubmittedBy__r.Employee_ID__c,
                SubmittedBy__r.FirstName, SubmittedBy__r.LastName,LeaveDuration__c
                FROM Leave__c
                WHERE RecordType.DeveloperName =:objWrap.recType
                AND CreatedDate >=: objWrap.startDate
                AND CreatedDate <=: objWrap.endDate
                AND SubmittedBy__c != null
                AND SubmittedBy__r.Employee_ID__c != null
                AND SubmittedBy__r.Employee_ID__c IN: objWrap.setOfTeamEmployeeId
                AND Status__c =: labelToContentMap.get('APPROVED')
                AND LeaveDuration__c != null
        ];
        return lstLeave;
    }
     /**
    * @author : Monika Bisht
    * @description : This method is used to query Leave object 
    * @return : allLeave
    * @param recordId
    */
    public static Leave__c queryForPurchaseNotification(string recordId) {
        Leave__c allLeave = new Leave__c();
        allLeave = [select id,ApproverUser__c,Status__c,Campaign__c,SubmittedBy__c,SubmittedByUser__c,Approver__c,
                    SubmittedByUser__r.LeaveNotification__c,SubmittedByUser__r.LeaveNotificationChannel__c,SubmittedBy__r.PersonContactId
                    from Leave__c where id =: recordId
                    AND RecordType.Name =: labelToContentMap.get('RECORDTYPEPURCHASELEAVEREQUEST') limit 1
                    ];
        return allLeave;
    }
}