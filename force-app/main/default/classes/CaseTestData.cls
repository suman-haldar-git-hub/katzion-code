/**
@author : Saurabh Bisht
@company : SaasFocus
@description : This class creates the test data for Case record...
*/
@isTest(SeeAllData=false)
public class CaseTestData {
    /**
     * @author : Saurabh Bisht
     * @description : This method creates test data for Case...
     * @return : List<Case>
     * @param accountId
     * @param count
     * @param performDML
     */
    public static List<Case> getCaseData(
        String accountId,
        Integer count,
        Boolean performDML
    ){
        List<Case> returnData = new List<Case>();
        for(integer i=0; i<count; i++){
            Case obj = new Case();
            obj.AccountId = accountId;
            obj.Origin = 'Web';
            obj.Severity__c = 'Low';
            obj.Subject = 'test Subject';
            obj.Category__c = 'Supply Chain';
            obj.Status = 'Open';
            returnData.add(obj);
        }
        if(performDML){
            insert returnData;
        }
        return returnData;
    }
}