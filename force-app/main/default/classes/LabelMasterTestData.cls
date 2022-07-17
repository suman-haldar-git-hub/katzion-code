/**
@author : Shubham Shukla
@company : SaasFocus
@description : This class creates the test data for label Master record...
*/
@isTest(SeeAllData=false)
public class LabelMasterTestData {
    /**
     * @author : Shubham Shukla
     * @description : This method creates test data for labelmaster...
     * @return returnData
     * @param count
     * @param performDML
     */
    public static List<Label_Master__c> getLabelMasterData(
        Integer count,
        Boolean performDML
    ){
        List<Label_Master__c> returnData = new List<Label_Master__c>();
        for(integer i=0; i<count; i++){
            Label_Master__c obj = new Label_Master__c();
            obj.Label_Name__c= 'Testing'+i;
            obj.Label_Color__c = '#ED0A3F';
            obj.Active__c = true;
            returnData.add(obj);
        }
        if(performDML){
            insert returnData;
        }
        return returnData;
    }
}