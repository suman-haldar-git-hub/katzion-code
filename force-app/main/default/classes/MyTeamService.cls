/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is act as Service class for MyTeamLeaveService.
*/
public inherited sharing class MyTeamService {
    /**
    * @Author : Ankit
    * @description : get Employee Id Having Nudge For Current Week
    * @return setOfEmployeeIdHasNudgeForCurrentWeek
    * @param lstNudgeLeave
    */
    public static Set<String> getEmployeeIdHavingNudgeForCurrentWeek(
        List<Leave__c> lstNudgeLeave
    ) {
        Set<String> setOfEmployeeIdHasNudgeForCurrentWeek = new Set<String>();
        if(
                lstNudgeLeave != null && !lstNudgeLeave.isEmpty()
        ) {
            for(Leave__c eachLeave : lstNudgeLeave) {
                setOfEmployeeIdHasNudgeForCurrentWeek.add(eachLeave.SubmittedBy__r.Employee_ID__c);
            }
        }
        return setOfEmployeeIdHasNudgeForCurrentWeek;
    }
}